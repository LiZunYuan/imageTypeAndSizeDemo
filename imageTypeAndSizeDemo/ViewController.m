//
//  ViewController.m
//  imageTypeAndSizeDemo
//
//  Created by 李遵源 on 16/9/13.
//  Copyright © 2016年 李遵源. All rights reserved.
//

#import "ViewController.h"
#import "YImageSizeUtility.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //jpg
    NSURL *jpgFileURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"jpg"];
    CGSize imageSize = [YImageSizeUtility sizeWithImageFilePath:jpgFileURL.relativePath];
    NSLog(@"jpg size:%@",NSStringFromCGSize(imageSize));
    
    //png
    NSURL *pngFileURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"png"];
    imageSize = [YImageSizeUtility sizeWithImageFilePath:pngFileURL.relativePath];
    NSLog(@"png size:%@",NSStringFromCGSize(imageSize));
    
    
    //gif
    NSURL *gifFileURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"gif"];
    imageSize = [YImageSizeUtility sizeWithImageFilePath:gifFileURL.relativePath];
    NSLog(@"gif size:%@",NSStringFromCGSize(imageSize));
    
    //bmp
    NSURL *bmpFileURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"bmp"];
    imageSize = [YImageSizeUtility sizeWithImageFilePath:bmpFileURL.relativePath];
    NSLog(@"bmp size:%@",NSStringFromCGSize(imageSize));
    
    //other  webp  读取失败的会返回 CGSizeNull
    NSURL *otherFileURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"webp"];
    imageSize = [YImageSizeUtility sizeWithImageFilePath:otherFileURL.relativePath];
    NSLog(@"webp size:%@",NSStringFromCGSize(imageSize));
}

@end
