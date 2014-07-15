//
//  THPinViewController.h
//  THPinViewController
//
//  Created by Thomas Heß on 11.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

@import UIKit;
#import "THPinViewControllerMacros.h"

@class THPinViewController;

// when using translucentBackground assign this tag to the view that should be blurred
static const NSInteger THPinViewControllerContentViewTag = 14742;

@protocol THPinViewControllerDelegate <NSObject>

@required
- (NSUInteger)pinLengthForPinViewController:(THPinViewController *)pinViewController;
- (BOOL)pinViewController:(THPinViewController *)pinViewController isPinValid:(NSString *)pin;
- (BOOL)userCanRetryInPinViewController:(THPinViewController *)pinViewController;

@optional
- (void)incorrectPinEnteredInPinViewController:(THPinViewController *)pinViewController;
- (void)pinViewControllerWillDismissAfterPinEntryWasSuccessful:(THPinViewController *)pinViewController;
- (void)pinViewControllerDidDismissAfterPinEntryWasSuccessful:(THPinViewController *)pinViewController;
- (void)pinViewControllerWillDismissAfterPinEntryWasUnsuccessful:(THPinViewController *)pinViewController;
- (void)pinViewControllerDidDismissAfterPinEntryWasUnsuccessful:(THPinViewController *)pinViewController;
- (void)pinViewControllerWillDismissAfterPinEntryWasCancelled:(THPinViewController *)pinViewController;
- (void)pinViewControllerDidDismissAfterPinEntryWasCancelled:(THPinViewController *)pinViewController;

@end

@interface THPinViewController : UIViewController

@property (nonatomic, weak) id<THPinViewControllerDelegate> delegate;
@property (nonatomic, strong) UIColor *backgroundColor; // is only used if translucentBackground == NO
@property (nonatomic, assign) BOOL translucentBackground;
@property (nonatomic, copy) NSString *promptTitle;
@property (nonatomic, strong) UIColor *promptColor;
@property (nonatomic, assign) BOOL hideLetters; // hides the letters on the number buttons
@property (nonatomic, assign) BOOL disableCancel; // hides the cancel button

- (instancetype)initWithDelegate:(id<THPinViewControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

@end
