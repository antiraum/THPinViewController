//
//  THPinCircleButton.m
//  THPinViewController
//
//  Created by Thomas Heß on 14.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinCircleButton.h"

@interface THPinCircleButton ()

@property (nonatomic, readwrite, assign) NSUInteger number;
@property (nonatomic, readwrite, copy) NSString *letters;

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *lettersLabel;

@end

@implementation THPinCircleButton

- (instancetype)initWithFrame:(CGRect)frame number:(NSUInteger)number letters:(NSString *)letters
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.number = number;
        self.letters = letters;
        
        self.layer.cornerRadius = [self.class diameter] / 2.0f;
        self.layer.borderWidth = 1.0f;
        
        UIView *contentView = [[UIView alloc] init];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        contentView.userInteractionEnabled = NO;
        [self addSubview:contentView];
        
        self.numberLabel = [[UILabel alloc] init];
        self.numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.numberLabel.text = [NSString stringWithFormat:@"%d", number];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.font = [UIFont systemFontOfSize:36.0f];
        [self.numberLabel sizeToFit];
        [contentView addSubview:self.numberLabel];
        [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[numberLabel]|" options:0
                                                                            metrics:nil
                                                                              views:@{ @"numberLabel" : self.numberLabel }]];
        
        CGFloat contentViewHeight = CGRectGetHeight(self.numberLabel.frame);
        
        if (letters)
        {
            self.lettersLabel = [[UILabel alloc] init];
            self.lettersLabel.translatesAutoresizingMaskIntoConstraints = NO;
            self.lettersLabel.text = letters;
            self.lettersLabel.textAlignment = NSTextAlignmentCenter;
            self.lettersLabel.font = [UIFont systemFontOfSize:10.0f];
            [self.lettersLabel sizeToFit];
            [contentView addSubview:self.lettersLabel];
            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lettersLabel]|" options:0
                                                                                metrics:nil
                                                                                  views:@{ @"lettersLabel" : self.lettersLabel }]];
            
            CGFloat numberLabelYCorrection = -3.0f;
            CGFloat lettersLabelYCorrection = -5.0f;
            
            contentViewHeight += CGRectGetHeight(self.lettersLabel.frame) + numberLabelYCorrection;
            
            // pin number label to top
            [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.numberLabel attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:contentView attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f constant:numberLabelYCorrection]];
            // pin letter label to bottom
            [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lettersLabel attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:contentView attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f constant:lettersLabelYCorrection]];
        }

        // set contentView height
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentView(==contentViewHeight)]" options:0
                                                                     metrics:@{ @"contentViewHeight" : @(contentViewHeight) }
                                                                       views:@{ @"contentView" : contentView }]];
        // center contentView horizontally
        [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0f constant:0.0f]];
        // center contentView vertically
        [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f constant:0.0f]];
        [self tintColorDidChange];
    }
    return self;
}

- (void)tintColorDidChange
{
    self.layer.borderColor = [self.tintColor CGColor];
    self.numberLabel.textColor = self.tintColor;
    self.lettersLabel.textColor = self.tintColor;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.backgroundColor = self.tintColor;
    self.numberLabel.textColor = [UIColor whiteColor];
    self.lettersLabel.textColor = [UIColor whiteColor];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self resetHighlight];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self resetHighlight];
}

- (void)resetHighlight
{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.backgroundColor = [UIColor whiteColor];
                     } completion:^(BOOL finished) {
                         self.numberLabel.textColor = self.tintColor;
                         self.lettersLabel.textColor = self.tintColor;
                     }];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(75.0f, 75.0f);
}

+ (CGFloat)diameter
{
    return 75.0f;
}

@end
