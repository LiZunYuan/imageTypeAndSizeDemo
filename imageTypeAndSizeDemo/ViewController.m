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
@property (weak, nonatomic) IBOutlet UILabel *jpgSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jpg2SizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pngSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gifSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmpSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherSizeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //jpg
    NSURL *jpgFileURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"jpg"];
    CGSize imageSize = [YImageSizeUtility sizeWithImageFilePath:jpgFileURL.relativePath];
    self.jpgSizeLabel.text = NSStringFromCGSize(imageSize);
    NSLog(@"jpg size:%@",NSStringFromCGSize(imageSize));
    
    //jpg2
    NSURL *jpg2FileURL = [[NSBundle mainBundle] URLForResource:@"test2" withExtension:@"jpg"];
    imageSize = [YImageSizeUtility sizeWithImageFilePath:jpg2FileURL.relativePath];
    self.jpg2SizeLabel.text = NSStringFromCGSize(imageSize);
    NSLog(@"jpg2 size:%@",NSStringFromCGSize(imageSize));
    
    //png
    NSURL *pngFileURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"png"];
    imageSize = [YImageSizeUtility sizeWithImageFilePath:pngFileURL.relativePath];
    self.pngSizeLabel.text = NSStringFromCGSize(imageSize);
    NSLog(@"png size:%@",NSStringFromCGSize(imageSize));
    
    
    //gif
    NSURL *gifFileURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"gif"];
    imageSize = [YImageSizeUtility sizeWithImageFilePath:gifFileURL.relativePath];
    self.gifSizeLabel.text = NSStringFromCGSize(imageSize);
    NSLog(@"gif size:%@",NSStringFromCGSize(imageSize));
    
    //bmp
    NSURL *bmpFileURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"bmp"];
    imageSize = [YImageSizeUtility sizeWithImageFilePath:bmpFileURL.relativePath];
    self.bmpSizeLabel.text = NSStringFromCGSize(imageSize);
    NSLog(@"bmp size:%@",NSStringFromCGSize(imageSize));
    
    //other  webp  读取失败的会返回 CGSizeNull
    NSURL *otherFileURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"webp"];
    imageSize = [YImageSizeUtility sizeWithImageFilePath:otherFileURL.relativePath];
    self.otherSizeLabel.text = NSStringFromCGSize(imageSize);
    NSLog(@"webp size:%@",NSStringFromCGSize(imageSize));
}

@end
