//
//  YImageSizeUtility.h
//  imageTypeAndSizeDemo
//
//  Created by 李遵源 on 16/9/13.
//  Copyright © 2016年 李遵源. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define CGSizeNull CGSizeMake(-1, -1)

@interface YImageSizeUtility : NSObject

/**
 *  根据文件路径获取图片尺寸(分辨率) 如果获取失败会返回 CGSizeNull
 *
 *  @param imageFilePath 文件路径
 *
 *  @return 图片尺寸
 */
+ (CGSize)sizeWithImageFilePath:(NSString *)imageFilePath;

@end
