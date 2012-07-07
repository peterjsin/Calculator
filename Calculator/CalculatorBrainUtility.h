//
//  CalculatorBrainUtility.h
//  Calculator
//
//  Created by Peter Siniawski on 7/7/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrainUtility : NSObject

+ (BOOL)isNoOperator:(NSString *)string;
+ (BOOL)isSingleOperator:(NSString *)string;
+ (BOOL)isDoubleOperator:(NSString *)string;
+ (NSString *)ifNullReplaceWithQuestionMark:(NSString *)string;
+ (NSString *)removeFirstAndLastCharacter:(NSString *)string;
+ (BOOL)beginsAndEndsWithParens:(NSString *)string;


@end
