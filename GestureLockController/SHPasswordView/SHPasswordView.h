//
//  SHPasswordView.h
//  GestureLockController
//
//  Created by lalala on 2017/5/3.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHPasswordView : UIView
//输入完成的block
typedef void(^InputFinishHandler)(SHPasswordView * passwordView, NSString * password);
/**
 *  初始化方法
 *
 *  @param normalImage    未输入密码的图片
 *  @param selectedImage  输入密码的图片
 *  @param lineColor      分割线的颜色
 *  @param passwordLength 密码的位数
 *  @param handler        结束输入的处理block
 *
 *  @return ZJPasswordView
 */
-(instancetype)initWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage lineColor:(UIColor *)lineColor passwordLength:(int)passwordLength finishHandler:(InputFinishHandler)handler;
//展示
-(void)show;
//移除
-(void)hide;

@end
