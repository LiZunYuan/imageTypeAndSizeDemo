//
//  YImageSizeUtility.m
//  imageTypeAndSizeDemo
//
//  Created by 李遵源 on 16/9/13.
//  Copyright © 2016年 李遵源. All rights reserved.
//

#import "YImageSizeUtility.h"

@implementation YImageSizeUtility
+ (CGSize)sizeWithImageFilePath:(NSString *)imageFilePath
{
    //判断文件是否存在
    if (!imageFilePath || ![[NSFileManager defaultManager] fileExistsAtPath:imageFilePath]) {
        return CGSizeNull;
    }
    
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForReadingAtPath:imageFilePath];
    //获取文件前1个字节
    NSData *firstByteByimageData = [fileHandler readDataOfLength:1];
    
    CGSize imageSize = CGSizeNull;
    NSString *imageType = [YImageSizeUtility imageTypeWithimageData:firstByteByimageData];
    if ([imageType isEqualToString:@"image/jpeg"]) {
        [fileHandler seekToFileOffset:0];
        NSData *imageData = [fileHandler readDataOfLength:210];
        imageSize = [YImageSizeUtility jpgImageSizeWithHeaderData:imageData];
        if (CGSizeEqualToSize(CGSizeNull,imageSize)) {
            imageSize = [YImageSizeUtility sizeWithJpgFilePath:imageFilePath];
        }
    } else  if([imageType isEqualToString:@"image/png"]) {
        [fileHandler seekToFileOffset:16];
        NSData *imageData = [fileHandler readDataOfLength:8];
        imageSize = [YImageSizeUtility sizeWithPngData:imageData];
    } else if([imageType isEqualToString:@"image/gif"]) {
        [fileHandler seekToFileOffset:6];
        NSData *imageData = [fileHandler readDataOfLength:4];
        imageSize = [YImageSizeUtility sizeWithGifData:imageData];
    } else if([imageType isEqualToString:@"image/bmp"]) {
        [fileHandler seekToFileOffset:18];
        NSData *imageData = [fileHandler readDataOfLeadsngth:8];
        imageSize = [YImageSizeUtility sizeWithBmpData:imageData];
    }
    [fileHandler closeFile];
    return imageSize;
}

+ (NSString *)imageTypeWithimageData:(NSData *)imageData
{
    //判断数据是否存在
    if (!imageData) {
        return nil;
    }
    
    //第一个字节进行判断
    uint8_t c;
    [imageData getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x42:
            return @"image/bmp";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x52:
            // R as RIFF for WEBP
            if ([imageData length] < 12) {
                return nil;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[imageData subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"image/webp";
            }
            
            return nil;
    }
    return nil;
}


+ (CGSize)sizeWithGifData:(NSData *)imageData
{
    if (!imageData || imageData.length < 4) {
        return CGSizeZero;
    }
    unsigned char w1 = 0, w2 = 0;
    [imageData getBytes:&w1 range:NSMakeRange(0, 1)];
    [imageData getBytes:&w2 range:NSMakeRange(1, 1)];
    short w = w1 + (w2 << 8);
    unsigned char h1 = 0, h2 = 0;
    [imageData getBytes:&h1 range:NSMakeRange(2, 1)];
    [imageData getBytes:&h2 range:NSMakeRange(3, 1)];
    short h = h1 + (h2 << 8);
    return CGSizeMake(w, h);
}

// 第一种方式 最快速
+ (CGSize)sizeWithJpgData:(NSData *)data
{
    if ([data length] <= 0x58) {
        return CGSizeNull;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeNull;
        }
    }
}

//第二种方式 遍历文件，至少比new出UIImage还是效率高的
+ (CGSize)sizeWithJpgFilePath:(NSString *)filePath
{
    if (!filePath.length) {
        return CGSizeNull;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return  CGSizeNull;
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSUInteger offset = 2;
    NSUInteger length = 0;
    while (1) {
        [fileHandle seekToFileOffset:offset];
        length = 4;
        NSData *data = [fileHandle readDataOfLength:length];
        if (data.length != length) {
            break;
        }
        offset += length;
        int marker,code;
        NSUInteger newLength;
        unsigned char value1,value2,value3,value4;
        [data getBytes:&value1 range:NSMakeRange(0, 1)];
        [data getBytes:&value2 range:NSMakeRange(1, 1)];
        [data getBytes:&value3 range:NSMakeRange(2, 1)];
        [data getBytes:&value4 range:NSMakeRange(3, 1)];
        marker = value1;
        code = value2;
        newLength = (value3 << 8) + value4;
        if (marker != 0xff) {
            [fileHandle closeFile];
            return CGSizeNull;
        }
        
        if (code >= 0xc0 && code <= 0xc3) {
            length = 5;
            [fileHandle seekToFileOffset:offset];
            NSData *data =[fileHandle readDataOfLength:length];
            if (data.length != length) {
                break;
            }
            Byte *bytesArray = (Byte*)[data bytes];
            NSUInteger height = ((unsigned char)bytesArray[1] << 8) + (unsigned char)bytesArray[2];
            NSUInteger width =  ((unsigned char)bytesArray[3] << 8) + (unsigned char)bytesArray[4];
            [fileHandle closeFile];
            return CGSizeMake(width, height);
        }
        else {
            offset += newLength;
            offset -=2;
        }
    }
    [fileHandle closeFile];
    return CGSizeNull;
    
}




+ (CGSize)sizeWithPngData:(NSData *)imageData
{
    if (!imageData || imageData.length < 8) {
        return CGSizeZero;
    }
    unsigned char w1 = 0, w2 = 0, w3 = 0, w4 = 0;
    [imageData getBytes:&w1 range:NSMakeRange(0, 1)];
    [imageData getBytes:&w2 range:NSMakeRange(1, 1)];
    [imageData getBytes:&w3 range:NSMakeRange(2, 1)];
    [imageData getBytes:&w4 range:NSMakeRange(3, 1)];
    int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
    
    unsigned char h1 = 0, h2 = 0, h3 = 0, h4 = 0;
    [imageData getBytes:&h1 range:NSMakeRange(4, 1)];
    [imageData getBytes:&h2 range:NSMakeRange(5, 1)];
    [imageData getBytes:&h3 range:NSMakeRange(6, 1)];
    [imageData getBytes:&h4 range:NSMakeRange(7, 1)];
    int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
    return CGSizeMake(w, h);
}


+ (CGSize)sizeWithBmpData:(NSData *)imageData {
    if (!imageData || imageData.length < 8) {
        return CGSizeZero;
    }
    unsigned char w1 = 0, w2 = 0, w3 = 0, w4 = 0;
    [imageData getBytes:&w1 range:NSMakeRange(0, 1)];
    [imageData getBytes:&w2 range:NSMakeRange(1, 1)];
    [imageData getBytes:&w3 range:NSMakeRange(2, 1)];
    [imageData getBytes:&w4 range:NSMakeRange(3, 1)];
    int w = w1 + (w2 << 8) + (w3 << 16) + (w4 << 24);
    unsigned char h1 = 0, h2 = 0, h3 = 0, h4 = 0;
    [imageData getBytes:&h1 range:NSMakeRange(4, 1)];
    [imageData getBytes:&h2 range:NSMakeRange(5, 1)];
    [imageData getBytes:&h3 range:NSMakeRange(6, 1)];
    [imageData getBytes:&h4 range:NSMakeRange(7, 1)];
    int h = h1 + (h2 << 8) + (h3 << 16) + (h4 << 24);
    return CGSizeMake(w, h);
}


@end
