//
//  SHPasswordInputView.h
//  GestureLockController
//
//  Created by lalala on 2017/5/3.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHPasswordInputView : UIView
/**
 *  初始化方法
 *
 *  @param normalImage    未输入密码的图片
 *  @param selectedImage  输入密码的图片
 *  @param lineColor      分割线的颜色
 *  @param passwordLength 密码的位数
 *
 *  @return ZJPasswordInputView
 */
- (instancetype)initWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage lineColor:(UIColor *)lineColor passwordLength:(int)passwordLength;
/**
 *  设置输入的密码的状态
 *
 *  @param currentPasswordLength 已经输入的密码位数
 */
- (void)setupBtnWithCurrentPasswordLength:(NSInteger)currentPasswordLength;
@end
