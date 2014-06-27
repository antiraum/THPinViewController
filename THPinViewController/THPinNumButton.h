//
//  THPinNumButton.h
//  THPinViewController
//
//  Created by Thomas Heß on 14.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

@import UIKit;
#import "THPinViewControllerMacros.h"

@interface THPinNumButton : UIButton

@property (nonatomic, readonly, assign) NSUInteger number;
@property (nonatomic, readonly, copy) NSString *letters;

- (instancetype)initWithNumber:(NSUInteger)number letters:(NSString *)letters NS_DESIGNATED_INITIALIZER;

+ (CGFloat)diameter;

@end
