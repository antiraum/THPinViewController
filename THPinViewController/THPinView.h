//
//  THPinView.h
//  THPinViewControllerExample
//
//  Created by Thomas Heß on 21.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@class THPinView;

@protocol THPinViewDelegate <NSObject>

@required
- (NSUInteger)pinLengthForPinView:(THPinView *)pinView;
- (BOOL)pinView:(THPinView *)pinView isPinValid:(NSString *)pin;
- (void)cancelButtonTappedInPinView:(THPinView *)pinView;
- (void)correctPinWasEnteredInPinView:(THPinView *)pinView;
- (void)incorrectPinWasEnteredInPinView:(THPinView *)pinView;

@end

@interface THPinView : UIView

@property (nonatomic, weak, nullable) id<THPinViewDelegate> delegate;
@property (nonatomic, copy, nullable) NSString *promptTitle;
@property (nonatomic, strong, nullable) UIColor *promptColor;
@property (nonatomic, assign) BOOL hideLetters;
@property (nonatomic, assign) BOOL disableCancel;

- (instancetype)initWithDelegate:(nullable id<THPinViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
