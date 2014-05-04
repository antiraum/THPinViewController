//
//  THPinNumPadView.h
//  THPinViewControllerExample
//
//  Created by Thomas Heß on 20.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

@import UIKit;

@class THPinNumPadView;

@protocol THPinNumPadViewDelegate <NSObject>

@required
- (void)pinNumPadView:(THPinNumPadView *)pinNumPadView numberTapped:(NSUInteger)number;

@end

@interface THPinNumPadView : UIView

@property (nonatomic, weak) id<THPinNumPadViewDelegate> delegate;
@property (nonatomic, assign) BOOL hideLetters;

- (instancetype)initWithDelegate:(id<THPinNumPadViewDelegate>)delegate;

@end
