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

/**
 The pinViewController is automatically dismissed unless the delegate implements this method returning \c NO.
 One reason to prevent dismissing would be to use this view controller to let the user set up the PIN by entering the number, then confirming it.
   1. After the user has entered the first number, return \c NO to keep the controller visible,
   2. change the prompt in /c -pinViewControllerWillReset:,
   3. finally return \c YES after the user has successfully entered the new PIN a second time.
 */
- (BOOL)pinViewControllerShouldDismissAfterPinEntryWasSuccessful:(THPinViewController *)pinViewController;
- (void)pinViewControllerDidDismissAfterPinEntryWasSuccessful:(THPinViewController *)pinViewController;

- (void)pinViewControllerWillDismissAfterPinEntryWasUnsuccessful:(THPinViewController *)pinViewController;
- (void)pinViewControllerDidDismissAfterPinEntryWasUnsuccessful:(THPinViewController *)pinViewController;

- (void)pinViewControllerWillDismissAfterPinEntryWasCancelled:(THPinViewController *)pinViewController;
- (void)pinViewControllerDidDismissAfterPinEntryWasCancelled:(THPinViewController *)pinViewController;

/**
 Called when the delegate returned \c NO for \c pinViewControllerShouldDismissAfterPinEntryWasSuccessful:
 This gives the delegate a chance to update the promptTitle and/or any colors while the pin view is refreshed.
 */
- (void)pinViewControllerWillReset:(THPinViewController *)pinViewController;

@end

@interface THPinViewController : UIViewController

@property (nonatomic, weak) id<THPinViewControllerDelegate> delegate;

/**
 The background color is also used as the blur tint if translucentBackground == YES.
 If the alpha value is ~1.0, the blur tint will be applied with a
 default alpha value; otherwise the alpha of the background color will be used as-is.
 */
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) BOOL translucentBackground;
@property (nonatomic, copy) NSString *promptTitle;
@property (nonatomic, strong) UIColor *promptColor;
@property (nonatomic, assign) BOOL hideLetters; // hides the letters on the number buttons
@property (nonatomic, assign) BOOL disableCancel; // hides the cancel button

- (instancetype)initWithDelegate:(id<THPinViewControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

@end
