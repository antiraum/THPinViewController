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
        
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, (letters) ? 16.0f : 21.0f, CGRectGetWidth(frame), 30.0f)];
        self.numberLabel.text = [NSString stringWithFormat:@"%d", number];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:36.0f];
        self.numberLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.numberLabel];
        
        if (letters && [letters length] > 0)
        {
            self.lettersLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 46.0f, CGRectGetWidth(frame), 15.0f)];
            self.lettersLabel.text = letters;
            self.lettersLabel.textAlignment = NSTextAlignmentCenter;
            self.lettersLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10.0f];
            self.lettersLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:self.lettersLabel];
        }
        
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

+ (CGFloat)diameter
{
    return 75.0f;
}

@end
