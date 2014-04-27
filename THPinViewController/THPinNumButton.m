//
//  THPinNumButton.m
//  THPinViewController
//
//  Created by Thomas Heß on 14.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinNumButton.h"

@interface THPinNumButton ()

@property (nonatomic, readwrite, assign) NSUInteger number;
@property (nonatomic, readwrite, copy) NSString *letters;

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *lettersLabel;

@property (nonatomic, strong) UIColor *backgroundColorBackup;

@end

@implementation THPinNumButton

- (id)init {
    NSAssert(NO, @"use initWithNumber:letters:");
    return nil;
}

- (instancetype)initWithNumber:(NSUInteger)number letters:(NSString *)letters
{
    self = [super init];
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
        self.numberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)number];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.font = [UIFont systemFontOfSize:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 41.0f : 36.0f];
        [contentView addSubview:self.numberLabel];
        [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[numberLabel]|" options:0
                                                                            metrics:nil
                                                                              views:@{ @"numberLabel" : self.numberLabel }]];
        
        CGSize numberSize = [self.numberLabel.text sizeWithAttributes:@{ NSFontAttributeName : self.numberLabel.font }];
        CGFloat contentViewHeight = ceil(numberSize.height);
        
        if (letters)
        {
            self.lettersLabel = [[UILabel alloc] init];
            self.lettersLabel.translatesAutoresizingMaskIntoConstraints = NO;
            self.lettersLabel.text = letters;
            self.lettersLabel.textAlignment = NSTextAlignmentCenter;
            self.lettersLabel.font = [UIFont systemFontOfSize:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 11.0f : 9.0f];
            [contentView addSubview:self.lettersLabel];
            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lettersLabel]|" options:0
                                                                                metrics:nil
                                                                                  views:@{ @"lettersLabel" : self.lettersLabel }]];
            
            CGFloat numberLabelYCorrection = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 0.0f : -3.5f;
            CGFloat lettersLabelYCorrection = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? -6.5f : -4.0f;
            
            CGSize lettersSize = [self.lettersLabel.text sizeWithAttributes:@{ NSFontAttributeName : self.lettersLabel.font }];
            contentViewHeight += ceil(lettersSize.height) + numberLabelYCorrection;
            
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
        } else {
            
            // pin number label to top
            [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.numberLabel attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:contentView attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f constant:0.0f]];
        }

        // set contentView height
        [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual toItem:nil attribute:0
                                                        multiplier:0.0f constant:contentViewHeight]];
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
    self.backgroundColorBackup = self.backgroundColor;
    self.backgroundColor = self.tintColor;
    self.numberLabel.textColor = self.backgroundColorBackup;
    self.lettersLabel.textColor = self.backgroundColorBackup;
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
                         self.backgroundColor = self.backgroundColorBackup;
                     } completion:^(BOOL finished) {
                         self.numberLabel.textColor = self.tintColor;
                         self.lettersLabel.textColor = self.tintColor;
                     }];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake([self.class diameter], [self.class diameter]);
}

+ (CGFloat)diameter
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 82.0f : 75.0f;
}

@end
