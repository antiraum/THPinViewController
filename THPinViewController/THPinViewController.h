//
//  THPinViewController.h
//  THPinViewController
//
//  Created by Thomas Heß on 11.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

@import UIKit;

@class THPinViewController;

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
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, copy) NSString *promptTitle;
@property (nonatomic, strong) UIColor *promptColor;
@property (nonatomic, assign) BOOL hideLetters;

- (instancetype)initWithDelegate:(id<THPinViewControllerDelegate>)delegate;

@end
