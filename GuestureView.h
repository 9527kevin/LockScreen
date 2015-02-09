//
//  GuestureView.h
//  LockScreen
//
//  Created by lawrence on 2/9/15.
//  Copyright (c) 2015 lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GuestureDelegate
-(void)unlockFromGuesture:(BOOL)unlock;
@end

@interface GuestureView : UIView
@property (nonatomic,weak) id<GuestureDelegate> delegate;
@end
