//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Peter Siniawski on 6/21/2012.
//  Copyright (c) 2012 peterjsin@gmail.com. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain ()
@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

-(id)program
{
    return [self.programStack copy];
}

- (void)clear
{
    [self.programStack removeAllObjects];
}

- (NSString *)description {
    return [self.programStack description];
}
    
+ (NSString *)descriptionOfProgram:(id)program
{
    //TODO
    return @"implement me";
}

+ (BOOL)isVariable:(NSString *)testString
{
    BOOL result = YES;
    NSSet *variables = [[NSSet alloc] initWithObjects:@"+", @"-", @"*", @"/", @"sin", @"cos", @"π", nil];
    if ([variables containsObject:testString]) {
        result =  NO;
    }
    return result;
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation 
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

- (void)pushVariable:(NSString *)variable
{
    if ([[self class] isVariable:variable]) {
        [self.programStack addObject:variable]; 
    }
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    }
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation        isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor != 0) {
                result = [self popOperandOffProgramStack:stack] / divisor;
            }
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]){
            double radicand = [self popOperandOffProgramStack:stack];
            if (radicand >= 0) {
                result = sqrt(radicand);
            }
        }
    }
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

/*
 */
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    if ([program isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [program count]; i++) {
           
            if ([[program objectAtIndex:i] isKindOfClass:[NSString class]]) {
                if ([self isVariable:[program objectAtIndex:i]]) {
                    [stack addObject:[variableValues objectForKey:[program objectAtIndex:i]]];
                } else {
                    [stack addObject:[program objectAtIndex:i]];
                }
            } else {
                [stack addObject:[program objectAtIndex:i]];
            }
        }
    }
    return [self runProgram:stack];
}

@end
