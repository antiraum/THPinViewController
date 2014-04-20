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
@property(nonatomic, assign) CGFloat bottomButtonYPos;

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
    
    CGFloat y = 20.0f;
    
    BOOL isFourInchScreen = (fabs(CGRectGetHeight([[UIScreen mainScreen] bounds]) - 568.0f) < DBL_EPSILON);
    
    y += (isFourInchScreen) ? 55.0f : 25.0f;
    self.promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, y, CGRectGetWidth(self.view.bounds), 22.0f)];
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    self.promptLabel.textColor = self.promptColor;
    self.promptLabel.text = self.promptTitle;
    self.promptLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.view addSubview:self.promptLabel];
    
    y += (isFourInchScreen) ? 38.0f : 31.0f;
    self.inputCirclesView = [[THPinInputCirclesView alloc] initWithPinLength:[self.delegate pinLengthForPinViewController:self]];
    self.inputCirclesView.frame = CGRectMake((CGRectGetWidth(self.view.bounds) - self.inputCirclesView.intrinsicContentSize.width) / 2.0f, y,
                                             self.inputCirclesView.intrinsicContentSize.width, self.inputCirclesView.intrinsicContentSize.height);
    [self.view addSubview:self.inputCirclesView];
    
    y += (isFourInchScreen) ? 45.0f : 33.0f;
    THPinNumPadView *numPadView = [[THPinNumPadView alloc] initWithDelegate:self];
    numPadView.frame = CGRectMake((CGRectGetWidth(self.view.bounds) - numPadView.intrinsicContentSize.width) / 2.0f, y,
                                  numPadView.intrinsicContentSize.width, numPadView.intrinsicContentSize.height);
    [self.view addSubview:numPadView];
    
    self.bottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.bottomButton];
    y += (isFourInchScreen) ? 357.0f : 331.0f;
    self.bottomButtonYPos = y;
    [self updateBottomButton];
    
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
    self.bottomButton.frame = (CGRect) {
        .origin.x = CGRectGetWidth(self.view.bounds) - CGRectGetWidth(self.bottomButton.frame) - 15.0f,
        .origin.y = self.bottomButtonYPos,
        .size = self.bottomButton.frame.size
    };
}

- (void)resetInput
{
    self.inputPin = [NSMutableString string];
    [self.inputCirclesView unfillAllCircles];
    [self updateBottomButton];
}

@end
