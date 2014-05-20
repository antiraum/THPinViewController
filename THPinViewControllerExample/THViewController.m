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

@property (nonatomic, strong) UIButton *contentButton;
@property (nonatomic, copy) NSString *correctPin;
@property (nonatomic, assign) NSUInteger remainingPinEntries;
@property (nonatomic, assign) BOOL locked;

@end

@implementation THViewController

static const NSUInteger THNumberOfPinEntries = 6;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.correctPin = @"1234";

    self.contentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.contentButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentButton setTitle:@"Enter PIN" forState:UIControlStateNormal];
    [self.view addSubview:self.contentButton];
    
    NSDictionary *views = @{ @"contentButton" : self.contentButton };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentButton]|" options:0
                                                                      metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentButton]|" options:0
                                                                      metrics:nil views:views]];
    self.locked = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    if (! self.locked) {
        [self logout:self];
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
        [self.contentButton removeTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.contentButton removeTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - UI

- (void)showPinViewAnimated:(BOOL)animated
{
    THPinViewController *pinViewController = [[THPinViewController alloc] initWithDelegate:self];
    pinViewController.backgroundColor = [UIColor lightGrayColor];
    pinViewController.promptTitle = @"Enter PIN";
    pinViewController.promptColor = [UIColor whiteColor];
    pinViewController.view.tintColor = [UIColor whiteColor];
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
    [self.contentButton setTitle:@"Enter PIN" forState:UIControlStateNormal];
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
    [self.contentButton setTitle:@"This is the secret content / Logout" forState:UIControlStateNormal];
}

- (void)pinViewControllerWillDismissAfterPinEntryWasUnsuccessful:(THPinViewController *)pinViewController
{
    self.locked = YES;
    [self.contentButton setTitle:@"Access Denied / Enter PIN" forState:UIControlStateNormal];
}

@end
