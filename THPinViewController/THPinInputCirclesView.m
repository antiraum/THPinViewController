//
//  THPinInputCirclesView.m
//  THPinViewControllerExample
//
//  Created by Thomas Heß on 20.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinInputCirclesView.h"
#import "THPinInputCircleView.h"

@interface THPinInputCirclesView ()

@property (nonatomic, strong) NSMutableArray *circleViews;
@property (nonatomic, readonly, assign) CGFloat circlePadding;

@property (nonatomic, assign) NSUInteger numShakes;
@property (nonatomic, assign) NSInteger shakeDirection;
@property (nonatomic, assign) CGFloat shakeAmplitude;
@property (nonatomic, strong) THPinInputCirclesViewShakeCompletionBlock shakeCompletionBlock;

@end

@implementation THPinInputCirclesView

- (nonnull instancetype)initWithPinLength:(NSUInteger)pinLength
{
    NSParameterAssert(pinLength > 0);

    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        _pinLength = pinLength;
        
        _circleViews = [NSMutableArray array];
        NSMutableString *format = [NSMutableString stringWithString:@"H:|"];
        NSMutableDictionary *views = [NSMutableDictionary dictionary];
        
        for (NSUInteger i = 0; i < _pinLength; i++)
        {
            THPinInputCircleView* circleView = [[THPinInputCircleView alloc] init];
            circleView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:circleView];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:circleView attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeTop
                                                            multiplier:1.0f constant:0.0f]];
            [_circleViews addObject:circleView];
            NSString *name = [NSString stringWithFormat:@"circle%lu", (unsigned long)i];
            if (i > 0) {
                [format appendString:@"-(padding)-"];
            }
            [format appendFormat:@"[%@]", name];
            views[name] = circleView;
        }
        
        [format appendString:@"|"];
        NSDictionary *metrics = @{ @"padding" : @(self.circlePadding) };
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views]];
    }
    return self;
}

- (nonnull instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithPinLength:0];
}

- (nonnull instancetype)initWithCoder:(nonnull NSCoder *)aDecoder
{
    return [self initWithPinLength:0];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(self.pinLength * [THPinInputCircleView diameter] + (self.pinLength - 1) * self.circlePadding,
                      [THPinInputCircleView diameter]);
}

- (CGFloat)circlePadding
{
    return 2.0f * [THPinInputCircleView diameter];
}

- (void)fillCircleAtPosition:(NSUInteger)position
{
    NSParameterAssert(position < [self.circleViews count]);
    [self.circleViews[position] setFilled:YES];
}

- (void)unfillCircleAtPosition:(NSUInteger)position
{
    NSParameterAssert(position < [self.circleViews count]);
    [self.circleViews[position] setFilled:NO];
}

- (void)unfillAllCircles
{
    for (THPinInputCircleView *view in self.circleViews) {
        view.filled = NO;
    }
}

static const NSUInteger THTotalNumberOfShakes = 6;
static const CGFloat THInitialShakeAmplitude = 40.0f;

- (void)shakeWithCompletion:(THPinInputCirclesViewShakeCompletionBlock)completion
{
    self.numShakes = 0;
    self.shakeDirection = -1;
    self.shakeAmplitude = THInitialShakeAmplitude;
    self.shakeCompletionBlock = completion;
    [self performShake];
}

- (void)performShake
{
    [UIView animateWithDuration:0.03f animations:^ {
        self.transform = CGAffineTransformMakeTranslation(self.shakeDirection * self.shakeAmplitude, 0.0f);
    } completion:^(BOOL finished) {
        if (self.numShakes < THTotalNumberOfShakes)
        {
            self.numShakes++;
            self.shakeDirection = -1 * self.shakeDirection;
            self.shakeAmplitude = (THTotalNumberOfShakes - self.numShakes) * (THInitialShakeAmplitude / THTotalNumberOfShakes);
            [self performShake];
        } else {
            self.transform = CGAffineTransformIdentity;
            if (self.shakeCompletionBlock) {
                self.shakeCompletionBlock();
                self.shakeCompletionBlock = nil;
            }
        }
    }];
}

@end
