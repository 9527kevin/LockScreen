//
//  GuestureView.m
//  LockScreen
//
//  Created by lawrence on 2/9/15.
//  Copyright (c) 2015 lawrence. All rights reserved.
//

#import "GuestureView.h"
@interface GuestureView()
@property (nonatomic,strong) NSMutableArray * buttonsArray;
@property (nonatomic,assign) CGPoint currentPoi;

@end
@implementation GuestureView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configButtons];
    }
    return self;
}

-(void)configButtons
{
    
    self.buttonsArray = [NSMutableArray array];
    for (int i = 0 ; i < 9 ; ++i) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.userInteractionEnabled = NO;
        [self addSubview:btn];
        [btn setBackgroundImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateSelected];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    for(int i = 0 ; i < [self.subviews count] ; ++i) {
        UIButton *btn=self.subviews[i];
        CGFloat row = i/3;
        CGFloat loc   = i%3;
        CGFloat btnW=74;
        CGFloat btnH=74;
        CGFloat padding=(self.frame.size.width-3*btnW)/4;
        CGFloat btnX=padding+(btnW+padding)*loc;
        CGFloat btnY=padding+(btnW+padding)*row;
        btn.frame=CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    UILabel * passwordLabel = [[UILabel alloc] init];
    passwordLabel.text = @"密码是：L";
    passwordLabel.textColor = [UIColor grayColor];
    [passwordLabel sizeToFit];
    [self addSubview:passwordLabel];
    passwordLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-400-[passwordLabel]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(passwordLabel)]];
    
    
}
#pragma mark - touch event
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint startPoint = [self getCurrentPoint:touches];
    UIButton * btn = [self getButtonWithCurrentPoint:startPoint];
    if (btn && btn.selected != YES) {
        btn.selected = YES;
        [self.buttonsArray addObject:btn];
    }
    self.currentPoi = startPoint;
    [self setNeedsDisplay];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [self getCurrentPoint:touches];
    UIButton * btn = [self getButtonWithCurrentPoint:point];
    if (btn && btn.selected != YES) {
        btn.selected = YES;
        [self.buttonsArray addObject:btn];
    }
    [self setNeedsDisplay];
    self.currentPoi = point;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableString * passWordString = [[NSMutableString alloc] init];
    for (UIButton * btn in self.buttonsArray) {
        [passWordString appendFormat:@"%ld", (long)btn.tag];
    }
    NSLog(@"password is %@",passWordString);
    
    [self.buttonsArray makeObjectsPerformSelector:@selector(setSelected:) withObject:@NO];
    [self.buttonsArray removeAllObjects];
    [self setNeedsDisplay];
    self.currentPoi = CGPointZero;
    
    if ([passWordString isEqualToString:@"03678"])
    {
        [self.delegate unlockFromGuesture:YES];
    }
    else
    {
        [self.delegate unlockFromGuesture:NO];
    }
}

#pragma mark - point event
-(CGPoint)getCurrentPoint:(NSSet *)touches
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    return point;
}

-(UIButton *)getButtonWithCurrentPoint:(CGPoint)point
{
    for (UIButton * btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    for (int i = 0; i < self.buttonsArray.count; ++i) {
        UIButton * btn = self.buttonsArray[i];
        if (0 == i)
        {
            CGContextMoveToPoint(context, btn.center.x, btn.center.y);
        }
        else
        {
            CGContextAddLineToPoint(context, btn.center.x,btn.center.y);
        }
    }
    
    if (self.buttonsArray.count > 0) {
        CGContextAddLineToPoint(context, self.currentPoi.x, self.currentPoi.y);
    }
    
    CGContextSetLineWidth(context, 10);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetRGBStrokeColor(context, 20/255.0, 107/255.0, 153/255.0, 1);
    CGContextStrokePath(context);
}


@end
