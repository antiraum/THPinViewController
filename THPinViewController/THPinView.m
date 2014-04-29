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
#import "THPinNumButton.h"

@interface THPinView () <THPinNumPadViewDelegate>

@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) THPinInputCirclesView *inputCirclesView;
@property (nonatomic, strong) THPinNumPadView *numPadView;
@property (nonatomic, strong) UIButton *bottomButton;

@property (nonatomic, assign) CGFloat paddingBetweenPromptLabelAndInputCircles;
@property (nonatomic, assign) CGFloat paddingBetweenInputCirclesAndNumPad;
@property (nonatomic, assign) CGFloat paddingBetweenNumPadAndBottomButton;

@property (nonatomic, strong) NSMutableString *input;

@end

@implementation THPinView

- (id)init {
    NSAssert(NO, @"use initWithDelegate:");
    return nil;
}

- (instancetype)initWithDelegate:(id<THPinViewDelegate>)delegate;
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
        self.input = [NSMutableString string];
        
        self.promptLabel = [[UILabel alloc] init];
        self.promptLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.promptLabel.textAlignment = NSTextAlignmentCenter;
        self.promptLabel.textColor = self.promptColor;
        self.promptLabel.text = self.promptTitle;
        self.promptLabel.font = [UIFont systemFontOfSize:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 22.0f : 18.0f];
        [self.promptLabel setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
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
        self.numPadView.backgroundColor = self.backgroundColor;
        self.numPadView.hideLetters = self.hideLetters;
        [self addSubview:self.numPadView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.numPadView attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0f constant:0.0f]];
        
        self.bottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.bottomButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.bottomButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        self.bottomButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.bottomButton setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        [self updateBottomButton];
        [self addSubview:self.bottomButton];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // place button right of zero number button
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomButton attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeRight
                                                            multiplier:1.0f constant:-[THPinNumButton diameter] / 2.0f]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomButton attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0f constant:-[THPinNumButton diameter] / 2.0f]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomButton attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:0
                                                            multiplier:0.0f constant:[THPinNumButton diameter]]];
        } else {
            // place button beneath the num pad on the right
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomButton attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeRight
                                                            multiplier:1.0f constant:0.0f]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomButton attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationLessThanOrEqual
                                                                toItem:self attribute:NSLayoutAttributeWidth
                                                            multiplier:0.4f constant:0.0f]];
        }
        
        NSMutableString *vFormat = [NSMutableString stringWithString:@"V:|[promptLabel]-(paddingBetweenPromptLabelAndInputCircles)-[inputCirclesView]-(paddingBetweenInputCirclesAndNumPad)-[numPadView]"];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.paddingBetweenPromptLabelAndInputCircles = 22.0f;
            self.paddingBetweenInputCirclesAndNumPad = 52.0f;
        } else {
            [vFormat appendString:@"-(paddingBetweenNumPadAndBottomButton)-[bottomButton]"];
            BOOL isFourInchScreen = (fabs(CGRectGetHeight([[UIScreen mainScreen] bounds]) - 568.0f) < DBL_EPSILON);
            if (isFourInchScreen) {
                self.paddingBetweenPromptLabelAndInputCircles = 22.5f;
                self.paddingBetweenInputCirclesAndNumPad = 41.5f;
                self.paddingBetweenNumPadAndBottomButton = 19.0f;
            } else {
                self.paddingBetweenPromptLabelAndInputCircles = 15.5f;
                self.paddingBetweenInputCirclesAndNumPad = 14.0f;
                self.paddingBetweenNumPadAndBottomButton = -7.5f;
            }
        }
        [vFormat appendString:@"|"];
        
        NSDictionary *metrics = @{ @"paddingBetweenPromptLabelAndInputCircles" : @(self.paddingBetweenPromptLabelAndInputCircles),
                                   @"paddingBetweenInputCirclesAndNumPad" : @(self.paddingBetweenInputCirclesAndNumPad),
                                   @"paddingBetweenNumPadAndBottomButton" : @(self.paddingBetweenNumPadAndBottomButton) };
        NSDictionary *views = @{ @"promptLabel" : self.promptLabel,
                                 @"inputCirclesView" : self.inputCirclesView,
                                 @"numPadView" : self.numPadView,
                                 @"bottomButton" : self.bottomButton };
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vFormat options:0 metrics:metrics views:views]];
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    CGFloat height = (self.promptLabel.intrinsicContentSize.height + self.paddingBetweenPromptLabelAndInputCircles +
                      self.inputCirclesView.intrinsicContentSize.height + self.paddingBetweenInputCirclesAndNumPad +
                      self.numPadView.intrinsicContentSize.height);
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        height += self.paddingBetweenNumPadAndBottomButton + self.bottomButton.intrinsicContentSize.height;
    }
    return CGSizeMake(self.numPadView.intrinsicContentSize.width, height);
}

#pragma mark - Properties

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.numPadView.backgroundColor = self.backgroundColor;
}

- (NSString *)promptTitle
{
    return self.promptLabel.text;
}

- (void)setPromptTitle:(NSString *)promptTitle
{
    self.promptLabel.text = promptTitle;
}

- (UIColor *)promptColor
{
    return self.promptLabel.textColor;
}

- (void)setPromptColor:(UIColor *)promptColor
{
    self.promptLabel.textColor = promptColor;
}

- (BOOL)hideLetters
{
    return self.numPadView.hideLetters;
}

- (void)setHideLetters:(BOOL)hideLetters
{
    self.numPadView.hideLetters = hideLetters;
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
    
    [self.input appendString:[NSString stringWithFormat:@"%lu", (unsigned long)number]];
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
