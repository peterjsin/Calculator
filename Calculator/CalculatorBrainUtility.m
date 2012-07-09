//
//  CalculatorBrainUtility.m
//  Calculator
//
//  Created by Peter Siniawski on 7/7/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrainUtility.h"

@implementation CalculatorBrainUtility

+ (BOOL)isNoOperator:(NSString *)string
{
    return [string isEqualToString:@"π"];
}

+ (BOOL)isSingleOperator:(NSString *)string
{
    NSSet *operators = [NSSet setWithObjects:@"sin",@"cos",@"√", nil];
    return [operators containsObject:string];
}

+ (BOOL)isDoubleOperator:(NSString *)string
{
    NSSet *operators = [NSSet setWithObjects:@"+",@"−",@"×",@"÷", nil];
    return [operators containsObject:string];
}
+ (NSString *)ifNullReplaceWithQuestionMark:(NSString *)string
{
    if (!string) string = @"?";
    return string;
}

+ (NSString *)removeFirstAndLastCharacter:(NSString *)string
{
    NSRange range = {1, [string length] - 2};
    string = [string substringWithRange:range];
    return string;
}

+ (BOOL)beginsAndEndsWithParens:(NSString *)string
{
    return ([string hasPrefix:@"("] && [string hasSuffix:@")"]);
}



@end
