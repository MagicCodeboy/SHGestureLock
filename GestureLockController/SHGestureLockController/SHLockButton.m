//
//  SHLockButton.m
//  GestureLockController
//
//  Created by lalala on 2017/5/2.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "SHLockButton.h"

@interface SHLockButton ()
@property(nonatomic,strong) UIImage * normalStateImage;
@property(nonatomic,strong) UIImage * selectedStateImage;
@property(nonatomic,strong) UIImage * errorStateImage;
@end

@implementation SHLockButton
-(void)setBtnImage:(UIImage *)image forState:(SHLockButtonState)state{
    switch (state) {
        case SHLockButtonStateNormal:
            self.normalStateImage = image;
            break;
        case SHLockButtonStateSelected:
            self.selectedStateImage = image;
            break;
        case SHLockButtonStateError:
            self.errorStateImage = image;
            break;
        default:
            break;
    }
    //设置图片以后 设置为默认的状态
    self.lockBtnState = SHLockButtonStateNormal;
}
-(void)setLockBtnState:(SHLockButtonState)lockBtnState {
    _lockBtnState = lockBtnState;
    switch (lockBtnState) {
        case SHLockButtonStateNormal:
            self.image = self.normalStateImage;
            break;
        case SHLockButtonStateSelected:
            self.image = self.selectedStateImage;
            break;
        case SHLockButtonStateError:
            self.image = self.errorStateImage;
            break;
        default:
            break;
    }
}
@end
