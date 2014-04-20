//
//  THPinNumPadView.h
//  THPinViewControllerExample
//
//  Created by Thomas Heß on 20.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THPinNumPadView;

@protocol THPinNumPadViewDelegate <NSObject>

- (void)pinNumPadView:(THPinNumPadView *)pinNumPadView numberTapped:(NSUInteger)number;

@end

@interface THPinNumPadView : UIView

@property (nonatomic, weak) id<THPinNumPadViewDelegate> delegate;

- (instancetype)initWithDelegate:(id<THPinNumPadViewDelegate>)delegate;

@end
