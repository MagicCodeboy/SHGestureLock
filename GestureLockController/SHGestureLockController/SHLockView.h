//
//  SHLockView.h
//  GestureLockController
//
//  Created by lalala on 2017/5/2.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHLockButton.h"

@class SHLockView;
@protocol SHLockViewDelegate <NSObject>

-(void)lockView:(SHLockView *)lockView didFinishCreatingPassword:(NSString *)password;

@end
@interface SHLockView : UIView
/** x和y 的两边间隙 默认为20 */
@property (assign, nonatomic) CGFloat margin;
/** 密码块的边长 默认为 44.0f */
@property (assign, nonatomic) CGFloat pwdBtnSlideLength;
/** 连接线的宽度 默认2.0f */
@property (assign, nonatomic) CGFloat lineWidth;
/** 连接线的颜色 默认红色 */
@property (strong, nonatomic) UIColor *lineColor;
/** 绘制的密码, 只读 */
@property (strong, nonatomic, readonly) NSString *password;
@property(weak,nonatomic)id<SHLockViewDelegate> delegate;
//初始化方法
-(instancetype)initWithDelegate:(id<SHLockViewDelegate>)delegate;
//重置状态
-(void)resetDrawing;
//显示错误的密码 errorPassword errorpassword   time 显示时间  handler 显示完毕的处理的block
-(void)showErrorPassword:(NSString *)errorPassword withTime:(CGFloat)time finishHandler:(void(^)(SHLockView *))handler;
//展示密码 password 字符串密码（0~8）最多九位并且无重复 status 展示的状态  handler 展示完毕的处理的block
-(void)showPassword:(NSString *)password withButtonStatus:(SHLockButtonState)status finishHandler:(void(^)(SHLockView *lockView))handler;
//设置不同状态的图片 image 图片  state 状态
-(void)setBtnImage:(UIImage *)image forState:(SHLockButtonState)state;
@end
