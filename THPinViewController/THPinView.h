//
//  THPinView.h
//  THPinViewControllerExample
//
//  Created by Thomas Heß on 21.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

@import UIKit;
#import "THPinViewControllerMacros.h"

@class THPinView;

typedef NS_ENUM(NSInteger, THPinViewControllerType) {
    THPinViewControllerTypeStandard,
    THPinViewControllerTypeCreatePin
};

@protocol THPinViewDelegate <NSObject>

@required
- (NSUInteger)pinLengthForPinView:(THPinView *)pinView;
- (BOOL)pinView:(THPinView *)pinView isPinValid:(NSString *)pin;
- (void)pin:(NSString *)pin wasCreatedInPinView:(THPinView *)pinView;
- (void)cancelButtonTappedInPinView:(THPinView *)pinView;
- (void)correctPinWasEnteredInPinView:(THPinView *)pinView;
- (void)incorrectPinWasEnteredInPinView:(THPinView *)pinView;

@end

@interface THPinView : UIView

@property (nonatomic, weak) id<THPinViewDelegate> delegate;
@property (nonatomic, copy) NSString *promptTitle;
@property (nonatomic, copy) NSString *promptChooseTitle;
@property (nonatomic, copy) NSString *promptVerifyTitle;
@property (nonatomic, strong) UIColor *promptColor;
@property (nonatomic, assign) BOOL hideLetters;
@property (nonatomic, assign) BOOL disableCancel;
@property (nonatomic, assign) THPinViewControllerType viewControllerType;

- (instancetype)initWithDelegate:(id<THPinViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

@end
