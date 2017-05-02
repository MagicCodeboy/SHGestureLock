//
//  SHLockViewController.m
//  GestureLockController
//
//  Created by lalala on 2017/5/2.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "SHLockViewController.h"
typedef NS_ENUM(NSInteger, SHLockViewControllerState) {
    SHLockViewControllerStateCreate,       // 创建操作
    SHLockViewControllerStateCreateEnsure, // 确认创建操作
    SHLockViewControllerStateValidate      // 验证操作
};

static NSString *const kCurrentPasswordKey = @"kCurrentPasswordKey";

@interface SHLockViewController ()<SHLockViewDelegate>
// 密码输入view
@property (strong, nonatomic) SHLockView *lockView;
// 提示文字label
@property (strong, nonatomic) UILabel *statusLabel;
// 当前操作的状态
@property (assign, nonatomic) SHLockViewControllerState state;
// 是否发生错误
@property (assign, nonatomic) BOOL isMeetingError;
// 当前密码
@property (copy, nonatomic) NSString *currentPassword;
// 需要操作的类型
@property (assign, nonatomic) SHLockOperationType operationType;
// 代理
@property (weak, nonatomic) id<SHLockViewControllerDelegate> delegate;
@end

@implementation SHLockViewController

+(BOOL)isAllreadySetPassword{
    return [SHLockViewController getCurrentPassword] != nil;
}
+(NSString *)getCurrentPassword{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kCurrentPasswordKey];
}
//保存密码到本地
+(void)setCurrentPassword:(NSString *)password{
    [[NSUserDefaults standardUserDefaults] setValue:password forKey:kCurrentPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(instancetype)initWithOperationType:(SHLockOperationType)type delegate:(id<SHLockViewControllerDelegate>)delegate{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _delegate = delegate;
        //重写set方法
        self.operationType = type;
        //获取本地的密码
        _currentPassword = [SHLockViewController getCurrentPassword];
        _mininumCount = 3;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.lockView];
    [self.view addSubview:self.statusLabel];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (_lockViewSlideLength == 0) {
        _lockViewSlideLength = MIN(self.view.bounds.size.width, self.view.bounds.size.height * 2/3);
    }
    CGRect lockViewFrame = CGRectMake(0.f, 0.f, _lockViewSlideLength, _lockViewSlideLength);
    _lockView.frame = lockViewFrame;
    _lockView.center = self.view.center;
    //自动计算文字的宽高
    [self.statusLabel sizeToFit];
    CGFloat margin = 20.f;
    CGFloat labelX = margin;
    CGFloat labelY = _lockView.frame.origin.y - self.statusLabel.bounds.size.height - 100.f;
    CGFloat labelWidth = self.view.bounds.size.width - 2*margin;
    self.statusLabel.frame = CGRectMake(labelX, labelY, labelWidth, self.statusLabel.bounds.size.height);
}

#pragma mark --SHLockViewDelegate
-(void)lockView:(SHLockView *)lockView didFinishCreatingPassword:(NSString *)password{
    if (self.operationType == SHLockOperationTypeCreate) {
        [self createPassword:password withLockView:lockView];
    } else if (self.operationType == SHLockOperationTypeReset){
        [self modifyPassword:password withLockView:lockView];
    } else if (self.operationType == SHLockOperationTypeValidate) {
        [self validatePassword:password withLockView:lockView];
    } else {
        [self removePassword:password withLockView:lockView];
    }
}
#pragma mark -- helper
- (void)createPassword:(NSString *)password withLockView:(SHLockView *)lockView{
    if (self.state == SHLockViewControllerStateCreate) {
        if (password.length < self.mininumCount) {
             self.statusLabel.text = [NSString stringWithFormat:@"连接的密码数少于%ld个",self.mininumCount];
            self.isMeetingError = YES;
            __weak typeof(self) weakSelf = self;
            [_lockView showErrorPassword:password withTime:1.0f finishHandler:^(SHLockView * lockView) {
                weakSelf.statusLabel.text = @"请绘制密码";
                weakSelf.isMeetingError = NO;
            }];
        } else {
            //暂时的密码--未写入本地
            _currentPassword = password;
            //清除绘制的密码的图案
            [lockView resetDrawing];
            //更改操作步骤为确认密码
            self.statusLabel.text = @"请再次绘制密码";
            self.state = SHLockViewControllerStateCreateEnsure;
        }
    } else if (self.state == SHLockViewControllerStateCreateEnsure){
        if ([password isEqualToString:_currentPassword]) {//正确
            [lockView resetDrawing];
            //设置成功-- 保存密码
            [SHLockViewController setCurrentPassword:password];
            if (self.operationType == SHLockOperationTypeCreate) {
                 self.statusLabel.text = @"密码创建成功";
                if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:didSuccessFullyCreatePassword:)]) {
                    [_delegate lockViewController:self didSuccessFullyCreatePassword:_currentPassword];
                }
            } else if (self.operationType == SHLockOperationTypeReset) {
                self.statusLabel.text = @"密码修改成功";
                if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:modifyPassword:isSuccessful:)]) {
                    [_delegate lockViewController:self modifyPassword:password isSuccessful:YES];
                }
            }
        } else {//错误
            self.statusLabel.text = @"两次绘制的密码不匹配，创建失败";
            self.isMeetingError = YES;
            __weak typeof(self) weakSelf = self;
            [lockView showErrorPassword:password withTime:1.0f finishHandler:^(SHLockView *lockView) {
                if (weakSelf.operationType == SHLockOperationTypeReset) {
                     weakSelf.statusLabel.text = @"请重新绘制新的密码";
                }
                if (weakSelf.operationType == SHLockOperationTypeCreate) {
                     weakSelf.statusLabel.text = @"请重新绘制密码";
                }
                weakSelf.isMeetingError = NO;
            }];
            self.state = SHLockViewControllerStateCreate;
        }
    }
}
-(void)removePassword:(NSString *)password withLockView:(SHLockView *)lockView{
    if (self.state == SHLockViewControllerStateValidate) {
        [self validatePassword:password withLockView:lockView];
    }
}
- (void)validatePassword:(NSString *)password withLockView:(SHLockView *)lockView{
    self.statusLabel.text = @"请绘制旧密码";
    if ([password isEqualToString:_currentPassword]) {// 正确
        [lockView resetDrawing];
        if (self.operationType == SHLockOperationTypeReset) {
            self.state = SHLockViewControllerStateCreate;
            self.statusLabel.text = @"请绘制新密码";
            
        }
        else if (self.operationType == SHLockOperationTypeValidate) {
            self.statusLabel.text = @"密码验证成功";
            if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:validatePassword:isSuccessful:)]) {
                [_delegate lockViewController:self validatePassword:password isSuccessful:YES];
            }
        }
        else if (self.operationType == SHLockOperationTypeDelete) {
            if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:removePassword:isSuccessful:)]) {
                [_delegate lockViewController:self removePassword:password isSuccessful:YES];
                [SHLockViewController setCurrentPassword:nil];
            }
            
        }
        
    }
    else {//错误
        
        if (self.operationType == SHLockOperationTypeReset) {
            if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:modifyPassword:isSuccessful:)]) {
                [_delegate lockViewController:self modifyPassword:password isSuccessful:NO];
            }
            
        }
        else if (self.operationType == SHLockOperationTypeValidate) {
            if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:validatePassword:isSuccessful:)]) {
                [_delegate lockViewController:self validatePassword:password isSuccessful:NO];
            }
        }
        else if (self.operationType == SHLockOperationTypeDelete) {
            if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:removePassword:isSuccessful:)]) {
                [_delegate lockViewController:self removePassword:password isSuccessful:NO];
            }
            
        }
        self.statusLabel.text = @"绘制的密码错误";
        self.isMeetingError = YES;
        __weak typeof(self) weakSelf = self;
        [lockView showErrorPassword:password withTime:1.0f finishHandler:^(SHLockView *lockView) {
            weakSelf.statusLabel.text = @"请绘制密码";
            weakSelf.isMeetingError = NO;
        }];
    }
}
- (void)modifyPassword:(NSString *)password withLockView:(SHLockView *)lockView {
    if (self.state == SHLockViewControllerStateValidate) {
        //验证旧的密码
        [self validatePassword:password withLockView:lockView];
    } else {
        //创建新的密码
        [self createPassword:password withLockView:lockView];
    }
}
- (void)dealloc {
    _lockView = nil;
    //    NSLog(@"ZJLockViewController---销毁");
}

#pragma mark -- getter ---setter
-(void)setIsMeetingError:(BOOL)isMeetingError{
    _isMeetingError = isMeetingError;
    if (isMeetingError) {
        self.statusLabel.textColor = [UIColor redColor];
    } else {
        self.statusLabel.textColor = [UIColor blackColor];
    }
}
-(void)setOperationType:(SHLockOperationType)operationType{
    _operationType = operationType;
    if (operationType == SHLockOperationTypeReset) {
        self.statusLabel.text = @"输入旧密码";
        self.state = SHLockViewControllerStateValidate;
    } else if (operationType == SHLockOperationTypeValidate){
        self.statusLabel.text = @"输入密码";
        self.state = SHLockViewControllerStateValidate;
    } else if (operationType == SHLockOperationTypeDelete){
        self.statusLabel.text = @"输入旧密码";
        self.state = SHLockViewControllerStateValidate;
    } else {
        self.statusLabel.text = @"输入初始密码";
        self.state = SHLockViewControllerStateCreate;
    }
}

-(UILabel *)statusLabel{
    if (!_statusLabel) {
        UILabel * statusLabel = [UILabel new];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.text = @"请输入密码";
        statusLabel.textColor = [UIColor blackColor];
        _statusLabel = statusLabel;
    }
    return _statusLabel;
}
-(SHLockView *)lockView{
    if (!_lockView) {
        _lockView = [[SHLockView alloc]initWithDelegate:self];
        _lockView.backgroundColor = [UIColor purpleColor];
    }
    return _lockView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
