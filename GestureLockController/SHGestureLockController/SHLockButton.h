//
//  SHLockButton.h
//  GestureLockController
//
//  Created by lalala on 2017/5/2.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SHLockButtonState){
    SHLockButtonStateNormal,
    SHLockButtonStateSelected,
    SHLockButtonStateError
};
//每一个解锁的按钮
@interface SHLockButton : UIImageView
//按钮的状态 根据不同的状态显示不同的图片，或者绘制不同的内容
@property(assign,nonatomic) SHLockButtonState lockBtnState;

-(void)setBtnImage:(UIImage *)image forState:(SHLockButtonState)state;

@end
