//
//  THPinViewController.m
//  THPinViewController
//
//  Created by Thomas Heß on 11.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinViewController.h"
#import "THPinInputCirclesView.h"
#import "THPinNumPadView.h"

@interface THPinViewController () <THPinNumPadViewDelegate>

@property(nonatomic, strong) UILabel *promptLabel;
@property(nonatomic, strong) THPinInputCirclesView *inputCirclesView;
@property(nonatomic, strong) UIButton *bottomButton;

@property(nonatomic, strong) NSMutableString *inputPin;

@end

@implementation THPinViewController

- (instancetype)initWithDelegate:(id<THPinViewControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.promptTitle = NSLocalizedStringFromTable(@"prompt_title", @"THPinViewController", nil);
        self.inputPin = [NSMutableString string];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.promptLabel = [[UILabel alloc] init];
    self.promptLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    self.promptLabel.textColor = self.promptColor;
    self.promptLabel.text = self.promptTitle;
    self.promptLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.promptLabel sizeToFit];
    [self.view addSubview:self.promptLabel];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[promptLabel]|" options:0 metrics:nil
                                                                        views:@{ @"promptLabel" : self.promptLabel }]];
    
    self.inputCirclesView = [[THPinInputCirclesView alloc] initWithPinLength:[self.delegate pinLengthForPinViewController:self]];
    self.inputCirclesView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.inputCirclesView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.inputCirclesView attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f constant:0.0f]];

    THPinNumPadView *numPadView = [[THPinNumPadView alloc] initWithDelegate:self];
    numPadView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:numPadView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:numPadView attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f constant:0.0f]];
    
    self.bottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.bottomButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self updateBottomButton];
    [self.view addSubview:self.bottomButton];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomButton attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeRight
                                                         multiplier:1.0f constant:-15.0f]];
    
    NSDictionary *views = @{ @"promptLabel" : self.promptLabel,
                             @"inputCirclesView" : self.inputCirclesView,
                             @"numPadView" : numPadView,
                             @"bottomButton" : self.bottomButton };
    BOOL isFourInchScreen = (fabs(CGRectGetHeight([[UIScreen mainScreen] bounds]) - 568.0f) < DBL_EPSILON);
    if (isFourInchScreen) {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-55-[promptLabel]-16-[inputCirclesView]-33-[numPadView]-19.5-[bottomButton]-|"
                                                                          options:0 metrics:nil views:views]];
    } else {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[promptLabel]-9-[inputCirclesView]-21-[numPadView]-(-6.5)-[bottomButton]-|"
                                                                          options:0 metrics:nil views:views]];
    }
}

#pragma mark - Properties

- (void)setPromptTitle:(NSString *)promptTitle
{
    if ([self.promptTitle isEqualToString:promptTitle]) {
        return;
    }
    _promptTitle = [promptTitle copy];
    self.promptLabel.text = self.promptTitle;
}

- (void)setPromptColor:(UIColor *)promptColor
{
    if ([self.promptColor isEqual:promptColor]) {
        return;
    }
    _promptColor = promptColor;
    self.promptLabel.textColor = self.promptColor;
}

#pragma mark - User Interaction

- (void)cancel:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pinViewControllerWillDismissAfterPinEntryWasCancelled:)]) {
        [self.delegate pinViewControllerWillDismissAfterPinEntryWasCancelled:self];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(pinViewControllerDidDismissAfterPinEntryWasCancelled:)]) {
            [self.delegate pinViewControllerDidDismissAfterPinEntryWasCancelled:self];
        }
    }];
}

- (void)delete:(id)sender
{
    if ([self.inputPin length] < 2) {
        [self resetInput];
    } else {
        [self.inputPin deleteCharactersInRange:NSMakeRange([self.inputPin length] - 1, 1)];
        [self.inputCirclesView unfillCircleAtPosition:[self.inputPin length]];
    }
}

#pragma mark - THPinNumPadViewDelegate

- (void)pinNumPadView:(THPinNumPadView *)pinNumPadView numberTapped:(NSUInteger)number
{
    NSUInteger pinLength = [self.delegate pinLengthForPinViewController:self];
    
    if ([self.inputPin length] >= pinLength) {
        return;
    }
    
    [self.inputPin appendString:[NSString stringWithFormat:@"%d", number]];
    [self.inputCirclesView fillCircleAtPosition:[self.inputPin length] - 1];
    
    [self updateBottomButton];
    
    if ([self.inputPin length] < pinLength) {
        return;
    }
    
    if ([self.delegate pinViewController:self isPinValid:self.inputPin])
    {
        double delayInSeconds = 0.3f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if ([self.delegate respondsToSelector:@selector(pinViewControllerWillDismissAfterPinEntryWasSuccessful:)]) {
                [self.delegate pinViewControllerWillDismissAfterPinEntryWasSuccessful:self];
            }
            [self dismissViewControllerAnimated:YES completion:^{
                if ([self.delegate respondsToSelector:@selector(pinViewControllerDidDismissAfterPinEntryWasSuccessful:)]) {
                    [self.delegate pinViewControllerDidDismissAfterPinEntryWasSuccessful:self];
                }
            }];
        });
        
    } else {
        
        [self.inputCirclesView shakeWithCompletion:^{
            [self resetInput];
        }];
        
        if ([self.delegate userCanRetryInPinViewController:self]) {
            if ([self.delegate respondsToSelector:@selector(pinViewControllerWrongPinEntered:)]) {
                [self.delegate pinViewControllerWrongPinEntered:self];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(pinViewControllerWillDismissAfterPinEntryWasUnsuccessful:)]) {
                [self.delegate pinViewControllerWillDismissAfterPinEntryWasUnsuccessful:self];
            }
            [self dismissViewControllerAnimated:YES completion:^{
                if ([self.delegate respondsToSelector:@selector(pinViewControllerDidDismissAfterPinEntryWasUnsuccessful:)]) {
                    [self.delegate pinViewControllerDidDismissAfterPinEntryWasUnsuccessful:self];
                }
            }];
        }
    }
    
}

#pragma mark - Util

- (void)updateBottomButton
{
    if ([self.inputPin length] == 0) {
        [self.bottomButton setTitle:NSLocalizedStringFromTable(@"cancel_button_title", @"THPinViewController", nil)
                           forState:UIControlStateNormal];
        [self.bottomButton removeTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.bottomButton setTitle:NSLocalizedStringFromTable(@"delete_button_title", @"THPinViewController", nil)
                           forState:UIControlStateNormal];
        [self.bottomButton removeTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.bottomButton sizeToFit];
}

- (void)resetInput
{
    self.inputPin = [NSMutableString string];
    [self.inputCirclesView unfillAllCircles];
    [self updateBottomButton];
}

@end
