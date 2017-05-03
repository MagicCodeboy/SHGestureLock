//
//  ViewController.m
//  GestureLockController
//
//  Created by lalala on 2017/5/2.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "ViewController.h"
#import "SHLockViewController.h"
#import "SHGestureLockController/SHLockView.h"
#import "SHPasswordView.h"
@interface ViewController ()<SHLockViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)lockViewController:(SHLockViewController *)lockViewController didSuccessFullyCreatePassword:(NSString *)password {
    NSLog(@"创建密码成功:  %@", password);
    [lockViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)lockViewController:(SHLockViewController *)lockViewController validatePassword:(NSString *)password isSuccessful:(BOOL)isSuccessful {
    NSString *result = isSuccessful ? @"验证成功" : @"验证失败";
    NSLog(@"验证结果为: %@", result);
    if (isSuccessful) {
        [lockViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)lockViewController:(SHLockViewController *)lockViewController modifyPassword:(NSString *)password isSuccessful:(BOOL)isSuccessful {
    NSString *result = isSuccessful ? @"修改成功" : @"修改失败";
    NSLog(@"修改结果为: %@", result);
    if (isSuccessful) {
        [lockViewController dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

- (void)lockViewController:(SHLockViewController *)lockViewController removePassword:(NSString *)password isSuccessful:(BOOL)isSuccessful {
    NSString *result = isSuccessful ? @"删除成功" : @"删除失败";
    NSLog(@"删除结果为: %@", result);
    if (isSuccessful) {
        [lockViewController dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

#pragma mark -- 按钮的点击事件
- (IBAction)createBtnOnClick:(id)sender {
    SHLockViewController * lock = [[SHLockViewController alloc]initWithOperationType:SHLockOperationTypeCreate delegate:self];
    lock.lockView.pwdBtnSlideLength = 64;
    lock.lockView.lineWidth = 8;
    [lock.lockView setBtnImage:[UIImage imageNamed:@"normal"] forState:SHLockButtonStateNormal];
    [lock.lockView setBtnImage:[UIImage imageNamed:@"selected"] forState:SHLockButtonStateSelected];
    [lock.lockView setBtnImage:[UIImage imageNamed:@"error"] forState:SHLockButtonStateError];
    [self presentViewController:lock animated:YES completion:nil];
}
- (IBAction)validateOnClick:(id)sender {
    if (![SHLockViewController isAllreadySetPassword]) {
        NSLog(@"未曾设置过密码或者密码已经被删除");
        return;
    }
    SHLockViewController * lock = [[SHLockViewController alloc]initWithOperationType:SHLockOperationTypeValidate delegate:self];
    lock.lockView.pwdBtnSlideLength = 64;
    lock.lockView.lineWidth = 8;
    [lock.lockView setBtnImage:[UIImage imageNamed:@"normal"] forState:SHLockButtonStateNormal];
    [lock.lockView setBtnImage:[UIImage imageNamed:@"selected"] forState:SHLockButtonStateSelected];
    [lock.lockView setBtnImage:[UIImage imageNamed:@"error"] forState:SHLockButtonStateError];
    [self presentViewController:lock animated:YES completion:nil];
}
- (IBAction)resetBtnOnClick:(id)sender {
    if (![SHLockViewController isAllreadySetPassword]) {
        NSLog(@"未曾设置过密码或者密码已经被删除");
        return;
    }
    SHLockViewController * lock = [[SHLockViewController alloc]initWithOperationType:SHLockOperationTypeReset delegate:self];
    lock.lockView.pwdBtnSlideLength = 64;
    lock.lockView.lineWidth = 8;
    [lock.lockView setBtnImage:[UIImage imageNamed:@"normal"] forState:SHLockButtonStateNormal];
    [lock.lockView setBtnImage:[UIImage imageNamed:@"selected"] forState:SHLockButtonStateSelected];
    [lock.lockView setBtnImage:[UIImage imageNamed:@"error"] forState:SHLockButtonStateError];
    [self presentViewController:lock animated:YES completion:nil];
}
- (IBAction)delegateBtnOnClick:(id)sender {
    if (![SHLockViewController isAllreadySetPassword]) {
        NSLog(@"未曾设置过密码或者密码已经被删除");
        return;
    }
    SHLockViewController * lock = [[SHLockViewController alloc]initWithOperationType:SHLockOperationTypeDelete delegate:self];
    lock.lockView.pwdBtnSlideLength = 64;
    lock.lockView.lineWidth = 8;
    [lock.lockView setBtnImage:[UIImage imageNamed:@"normal"] forState:SHLockButtonStateNormal];
    [lock.lockView setBtnImage:[UIImage imageNamed:@"selected"] forState:SHLockButtonStateSelected];
    [lock.lockView setBtnImage:[UIImage imageNamed:@"error"] forState:SHLockButtonStateError];
    [self presentViewController:lock animated:YES completion:nil];
}

- (IBAction)inputPaywordOnClick:(id)sender {
    SHPasswordView * passwordView = [[SHPasswordView alloc]initWithNormalImage:nil selectedImage:[UIImage imageNamed:@"circle"] lineColor:[UIColor lightGrayColor] passwordLength:6 finishHandler:^(SHPasswordView *passwordView, NSString *password) {
        NSLog(@"输入的密码是---%@",password);
        [passwordView hide];
    }];
    [passwordView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
