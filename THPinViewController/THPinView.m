//
//  THPinView.m
//  THPinViewControllerExample
//
//  Created by Thomas Heß on 21.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinView.h"
#import "THPinInputCirclesView.h"
#import "THPinNumPadView.h"

@interface THPinView () <THPinNumPadViewDelegate>

@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) THPinInputCirclesView *inputCirclesView;
@property (nonatomic, strong) THPinNumPadView *numPadView;
@property (nonatomic, strong) UIButton *bottomButton;

@property (nonatomic, strong) NSMutableString *input;

@end

@implementation THPinView

- (instancetype)initWithDelegate:(id<THPinViewDelegate>)delegate;
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
        self.promptTitle = NSLocalizedStringFromTable(@"prompt_title", @"THPinViewController", nil);
        self.input = [NSMutableString string];
        
        self.promptLabel = [[UILabel alloc] init];
        self.promptLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.promptLabel.textAlignment = NSTextAlignmentCenter;
        self.promptLabel.textColor = self.promptColor;
        self.promptLabel.text = self.promptTitle;
        self.promptLabel.font = [UIFont systemFontOfSize:18.0f];
        [self.promptLabel sizeToFit];
        //    [self.promptLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        //    [self.promptLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self addSubview:self.promptLabel];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[promptLabel]|" options:0 metrics:nil
                                                                            views:@{ @"promptLabel" : self.promptLabel }]];
        
        self.inputCirclesView = [[THPinInputCirclesView alloc] initWithPinLength:[self.delegate pinLengthForPinView:self]];
        self.inputCirclesView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.inputCirclesView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.inputCirclesView attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0f constant:0.0f]];
        
        self.numPadView = [[THPinNumPadView alloc] initWithDelegate:self];
        self.numPadView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.numPadView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.numPadView attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0f constant:0.0f]];
        
        self.bottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.bottomButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self updateBottomButton];
        [self addSubview:self.bottomButton];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomButton attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self attribute:NSLayoutAttributeRight
                                                             multiplier:1.0f constant:-15.0f]];
        
        NSString *vFormat = nil;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            vFormat = @"V:|[promptLabel]-16-[inputCirclesView]-33-[numPadView]-(-20)-[bottomButton]|";
        } else {
            BOOL isFourInchScreen = (fabs(CGRectGetHeight([[UIScreen mainScreen] bounds]) - 568.0f) < DBL_EPSILON);
            if (isFourInchScreen) {
                vFormat = @"V:|[promptLabel]-16-[inputCirclesView]-33-[numPadView]-19.5-[bottomButton]|";
            } else {
                vFormat = @"V:|[promptLabel]-9-[inputCirclesView]-21-[numPadView]-(-6.5)-[bottomButton]|";
            }
        }
        NSDictionary *views = @{ @"promptLabel" : self.promptLabel,
                                 @"inputCirclesView" : self.inputCirclesView,
                                 @"numPadView" : self.numPadView,
                                 @"bottomButton" : self.bottomButton };
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vFormat options:0 metrics:nil views:views]];
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    CGFloat height = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        height = self.promptLabel.intrinsicContentSize.height + 16 + self.inputCirclesView.intrinsicContentSize.height + 33 + self.numPadView.intrinsicContentSize.height + (-20) + self.bottomButton.intrinsicContentSize.height;
    } else {
        BOOL isFourInchScreen = (fabs(CGRectGetHeight([[UIScreen mainScreen] bounds]) - 568.0f) < DBL_EPSILON);
        if (isFourInchScreen) {
            height = self.promptLabel.intrinsicContentSize.height + 16 + self.inputCirclesView.intrinsicContentSize.height + 33 + self.numPadView.intrinsicContentSize.height + 19.5 + self.bottomButton.intrinsicContentSize.height;
        } else {
            height = self.promptLabel.intrinsicContentSize.height + 9 + self.inputCirclesView.intrinsicContentSize.height + 21 + self.numPadView.intrinsicContentSize.height + (-6.5) + self.bottomButton.intrinsicContentSize.height;
        }
    }
    return CGSizeMake(self.numPadView.intrinsicContentSize.width, height);
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

#pragma mark - Public

- (void)updateBottomButton
{
    if ([self.input length] == 0) {
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

#pragma mark - User Interaction

- (void)cancel:(id)sender
{
    [self.delegate cancelButtonTappedInPinView:self];
}

- (void)delete:(id)sender
{
    if ([self.input length] < 2) {
        [self resetInput];
    } else {
        [self.input deleteCharactersInRange:NSMakeRange([self.input length] - 1, 1)];
        [self.inputCirclesView unfillCircleAtPosition:[self.input length]];
    }
}

#pragma mark - THPinNumPadViewDelegate

- (void)pinNumPadView:(THPinNumPadView *)pinNumPadView numberTapped:(NSUInteger)number
{
    NSUInteger pinLength = [self.delegate pinLengthForPinView:self];
    
    if ([self.input length] >= pinLength) {
        return;
    }
    
    [self.input appendString:[NSString stringWithFormat:@"%d", number]];
    [self.inputCirclesView fillCircleAtPosition:[self.input length] - 1];
    
    [self updateBottomButton];
    
    if ([self.input length] < pinLength) {
        return;
    }
    
    if ([self.delegate pinView:self isPinValid:self.input])
    {
        double delayInSeconds = 0.3f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.delegate correctPinWasEnteredInPinView:self];
        });
        
    } else {
        
        [self.inputCirclesView shakeWithCompletion:^{
            [self resetInput];
            [self.delegate incorrectPinWasEnteredInPinView:self];
        }];
    }
    
}

#pragma mark - Util

- (void)resetInput
{
    self.input = [NSMutableString string];
    [self.inputCirclesView unfillAllCircles];
    [self updateBottomButton];
}

@end
