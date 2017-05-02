//
//  SHLockViewController.h
//  GestureLockController
//
//  Created by lalala on 2017/5/2.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHLockView.h"
@class SHLockViewController;
typedef NS_ENUM(NSInteger,SHLockOperationType){
    SHLockOperationTypeCreate,//创建密码
    SHLockOperationTypeValidate,//验证密码
    SHLockOperationTypeReset,//重置密码
    SHLockOperationTypeDelete//删除密码
};
@protocol SHLockViewControllerDelegate <NSObject>
@optional
/**
 *  创建密码成功
 *
 *  @param lockViewController controller
 *  @param password   password
 */
- (void)lockViewController:(SHLockViewController *)lockViewController didSuccessFullyCreatePassword:(NSString *)password;
/**
 *  验证密码
 *
 *  @param lockViewController   controller description
 *  @param password     password description
 *  @param isSuccessful 是否验证成功
 */
- (void)lockViewController:(SHLockViewController *)lockViewController validatePassword:(NSString *)password isSuccessful:(BOOL)isSuccessful;
/**
 *  修改密码
 *
 *  @param lockViewController   controller description
 *  @param password     修改后的密码
 *  @param isSuccessful 是否修改成功
 */
- (void)lockViewController:(SHLockViewController *)lockViewController modifyPassword:(NSString *)password isSuccessful:(BOOL)isSuccessful;
/**
 *  删除密码
 *
 *  @param lockViewController   controller description
 *  @param password 要删除的密码
 *  @param isSuccessful 是否删除成功
 */
- (void)lockViewController:(SHLockViewController *)lockViewController removePassword:(NSString *)password isSuccessful:(BOOL)isSuccessful;

@end

@interface SHLockViewController : UIViewController
//密码输入的View
@property(nonatomic,strong,readonly) SHLockView * lockView;
//提示文字的lable 可以设置它的属性
@property(nonatomic,strong,readonly) UILabel * statusLabel;
//最少要连接的密码的位数 默认为3
@property(nonatomic,assign) NSInteger  mininumCount;
//密码view的边长 默认是屏幕的2/3
@property(nonatomic,assign) CGFloat lockViewSlideLength;
//是否设置过密码
+(BOOL)isAllreadySetPassword;
//获取本地的密码
+(NSString *)getCurrentPassword;
//保存密码到本地
+(void)setCurrentPassword:(NSString *)password;

//初始化方法
-(instancetype)initWithOperationType:(SHLockOperationType)type delegate:(id<SHLockViewControllerDelegate>)delegate;
@end
