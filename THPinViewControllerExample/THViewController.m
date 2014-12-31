//
//  THViewController.m
//  THPinViewControllerExample
//
//  Created by Thomas Heß on 19.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THViewController.h"
#import "THPinViewController.h"

@interface THViewController () <THPinViewControllerDelegate>

@property (nonatomic, strong) UIImageView *secretContentView;
@property (nonatomic, strong) UIButton *loginLogoutButton;
@property (nonatomic, copy) NSString *correctPin;
@property (nonatomic, assign) NSUInteger remainingPinEntries;
@property (nonatomic, assign) BOOL locked;

@end

@implementation THViewController

static const NSUInteger THNumberOfPinEntries = 6;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.361f green:0.404f blue:0.671f alpha:1.0f];
    
    self.correctPin = @"1234";
    
    self.secretContentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confidential"]];
    self.secretContentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.secretContentView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.secretContentView];

    self.loginLogoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginLogoutButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.loginLogoutButton setTitle:@"Enter PIN" forState:UIControlStateNormal];
    self.loginLogoutButton.tintColor = [UIColor whiteColor];
    [self.view addSubview:self.loginLogoutButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginLogoutButton attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginLogoutButton attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f constant:60.0f]];
    NSDictionary *views = @{ @"secretContentView" : self.secretContentView };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[secretContentView]-(20)-|"
                                                                      options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(120)-[secretContentView]-(20)-|"
                                                                      options:0 metrics:nil views:views]];
    self.locked = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    if (! self.locked) {
        [self showPinViewAnimated:NO];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

#pragma mark - Properties

- (void)setLocked:(BOOL)locked
{
    _locked = locked;
    
    if (self.locked) {
        self.remainingPinEntries = THNumberOfPinEntries;
        [self.loginLogoutButton removeTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        [self.loginLogoutButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        self.secretContentView.hidden = YES;
    } else {
        [self.loginLogoutButton removeTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        [self.loginLogoutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        self.secretContentView.hidden = NO;
    }
}

#pragma mark - UI

- (void)showPinViewAnimated:(BOOL)animated
{
    THPinViewController *pinViewController = [[THPinViewController alloc] initWithDelegate:self];
    pinViewController.promptTitle = @"Enter PIN";
    UIColor *darkBlueColor = [UIColor colorWithRed:0.012f green:0.071f blue:0.365f alpha:1.0f];
    pinViewController.promptColor = darkBlueColor;
    pinViewController.view.tintColor = darkBlueColor;
    
    // for a solid background color, use this:
    pinViewController.backgroundColor = [UIColor whiteColor];
    
    // for a translucent background, use this:
    self.view.tag = THPinViewControllerContentViewTag;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    pinViewController.translucentBackground = YES;
    
    [self presentViewController:pinViewController animated:animated completion:nil];
}

#pragma mark - User Interaction

- (void)login:(id)sender
{
    [self showPinViewAnimated:YES];
}

- (void)logout:(id)sender
{
    self.locked = YES;
    [self.loginLogoutButton setTitle:@"Enter PIN" forState:UIControlStateNormal];
}

#pragma mark - THPinViewControllerDelegate

- (NSUInteger)pinLengthForPinViewController:(THPinViewController *)pinViewController
{
    return 4;
}

- (BOOL)pinViewController:(THPinViewController *)pinViewController isPinValid:(NSString *)pin
{
    if ([pin isEqualToString:self.correctPin]) {
        return YES;
    } else {
        self.remainingPinEntries--;
        return NO;
    }
}

- (BOOL)userCanRetryInPinViewController:(THPinViewController *)pinViewController
{
    return (self.remainingPinEntries > 0);
}

- (void)incorrectPinEnteredInPinViewController:(THPinViewController *)pinViewController
{
    if (self.remainingPinEntries > THNumberOfPinEntries / 2) {
        return;
    }
    
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"Incorrect PIN"
                               message:(self.remainingPinEntries == 1 ?
                                        @"You can try again once." :
                                        [NSString stringWithFormat:@"You can try again %lu times.",
                                         (unsigned long)self.remainingPinEntries])
                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

}

- (void)pinViewControllerWillDismissAfterPinEntryWasSuccessful:(THPinViewController *)pinViewController
{
    self.locked = NO;
    [self.loginLogoutButton setTitle:@"Logout" forState:UIControlStateNormal];
}

- (void)pinViewControllerWillDismissAfterPinEntryWasUnsuccessful:(THPinViewController *)pinViewController
{
    self.locked = YES;
    [self.loginLogoutButton setTitle:@"Access Denied / Enter PIN" forState:UIControlStateNormal];
}

- (void)pinViewControllerWillDismissAfterPinEntryWasCancelled:(THPinViewController *)pinViewController
{
    if (! self.locked) {
        [self logout:self];
    }
}

@end
