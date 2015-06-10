//
//  THPinNumPadView.h
//  THPinViewControllerExample
//
//  Created by Thomas Heß on 20.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@class THPinNumPadView;

@protocol THPinNumPadViewDelegate <NSObject>

@required
- (void)pinNumPadView:(THPinNumPadView *)pinNumPadView numberTapped:(NSUInteger)number;

@end

@interface THPinNumPadView : UIView

@property (nonatomic, weak, nullable) id<THPinNumPadViewDelegate> delegate;
@property (nonatomic, assign) BOOL hideLetters;

- (instancetype)initWithDelegate:(nullable id<THPinNumPadViewDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
