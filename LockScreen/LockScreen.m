//
//  GuestureUnLock.m
//  NavigationBarTest
//
//  Created by lawrence on 2/4/15.
//  Copyright (c) 2015 lawrence. All rights reserved.
//

#import "LockScreen.h"
#import "GuestureView.h"

@interface LockScreen()<GuestureDelegate>
@property (nonatomic,strong)UIView * codeLockView;
@property (nonatomic,strong)GuestureView * guestureView;
@property (nonatomic,strong)UITextField * passwordField;
@property (nonatomic,strong)UIButton * doneButton;
@property (nonatomic,strong)UISegmentedControl * segment;

@end
@implementation LockScreen

+(id)shareInstance
{
    static dispatch_once_t  once;
    static LockScreen * unlockWindow = nil;
    dispatch_once(&once, ^{
        unlockWindow = [[LockScreen alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return unlockWindow;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelAlert;
        [self setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self configLockScreen];
        
    }
    return self;
}

-(void)configLockScreen
{
    self.codeLockView.hidden = YES;
    [self addSubview:self.codeLockView];
    
    self.guestureView = [[GuestureView alloc] initWithFrame:self.bounds];
    self.guestureView.hidden = YES;
    self.guestureView.delegate = self;
    [self.guestureView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.guestureView];
    
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"code lock",@"guesture lock"]];
    [self.segment setFrame:CGRectMake(self.center.x - self.segment.frame.size.width/2,0, self.segment.frame.size.width, self.segment.frame.size.height)];
    [self.segment addTarget:self action:@selector(chooseLockScreenType:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.segment];
}
-(void)show
{
    [self makeKeyWindow];
    [self configConstrain];
    self.hidden = NO;
}

#pragma mark - code lock view
-(UIView *)codeLockView
{
    if (!_codeLockView) {
        _codeLockView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _codeLockView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_codeLockView addSubview:self.passwordField];
        [_codeLockView addSubview:self.doneButton];
    }
    return _codeLockView;
}
-(UITextField *)passwordField
{
    if (!_passwordField) {
        _passwordField = [[UITextField alloc]init];
        _passwordField.secureTextEntry = YES;
        _passwordField.placeholder = @"请输入密码";
        _passwordField.backgroundColor = [UIColor whiteColor];
    }
    return _passwordField;
}

-(UIButton *)doneButton
{
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_doneButton addTarget:self
                        action:@selector(tapButton:)
              forControlEvents:UIControlEventTouchUpInside];
        [_doneButton setTitle:@"确定" forState:UIControlStateNormal];
        [_doneButton setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _doneButton;
}


#pragma mark - button status
-(IBAction)tapButton:(id)sender
{
    if ([self.passwordField.text isEqualToString:@"abc123"]) {
        
        [self resignKeyWindow];
        self.hidden = YES;
    }
    else
    {
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"password error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alter show];
    }
}
-(void)chooseLockScreenType:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0)
    {
        self.codeLockView.hidden = NO;
        self.guestureView.hidden = YES;
    }
    else
    {
        self.codeLockView.hidden = YES;
        self.guestureView.hidden = NO;
    }
}

#pragma mark - text field delegate
-(void)configConstrain
{
    UITextField * passwordTextField = self.passwordField;
    UIButton * doneButton = self.doneButton;
    passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    doneButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[passwordTextField]-50-|"
                                                                options:0
                                                                metrics:nil
                                                                  views:NSDictionaryOfVariableBindings(passwordTextField)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[doneButton]-100-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(doneButton)]];
    CGFloat middleHeight = [UIScreen mainScreen].bounds.size.height/2;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[passwordTextField(50)]-30-[doneButton(50)]-middleHeight-|" options:0 metrics:@{@"middleHeight":@(middleHeight)} views:NSDictionaryOfVariableBindings(passwordTextField,doneButton)]];
    
}

#pragma mark - delegate
-(void)unlockFromGuesture:(BOOL)unlock
{
    if (unlock) {
        [self resignKeyWindow];
        self.hidden = YES;
    }
    else
    {
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"password error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alter show];
    }
 
}
@end
