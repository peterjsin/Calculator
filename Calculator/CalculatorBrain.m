//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Peter Siniawski on 6/21/2012.
//  Copyright (c) 2012 peterjsin@gmail.com. All rights reserved.
//

#import "CalculatorBrain.h"
#import "CalculatorBrainUtility.h"

@interface CalculatorBrain ()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

-(id)program
{
    return [self.programStack copy];
}

- (NSMutableArray *)programStack
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (void)clear
{
    [self.programStack removeAllObjects];
}

- (NSString *)description
{
    return [self.programStack description];
}    

+ (BOOL)isVariable:(NSString *)testString
{
    BOOL result = YES;
    NSSet *variables = [[NSSet alloc] initWithObjects:@"+", @"−", @"×", @"÷", @"sin", @"cos", @"π", nil];
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

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
    NSString *result;
    
    // current thing
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    // Is a number?
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [NSString stringWithFormat:@"%@", [topOfStack stringValue]];
    
    // A string
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        if ([CalculatorBrainUtility isSingleOperator:topOfStack]) {
            if ([stack lastObject]) {
                NSString *operand = [CalculatorBrain descriptionOfTopOfStack:stack];
                if ([operand hasPrefix:@"("]) {
                    result = [NSString stringWithFormat:@"%@%@", topOfStack, operand];
                } else {
                    result = [NSString stringWithFormat:@"%@(%@)", topOfStack, operand];
                }
            } else {
                result = [NSString stringWithFormat:@"%@()", topOfStack];
            }
        } else if ([CalculatorBrainUtility isDoubleOperator:topOfStack]) {
            NSString *secondOperand = [CalculatorBrainUtility ifNullReplaceWithQuestionMark:[CalculatorBrain descriptionOfTopOfStack:stack]];
            NSString *firstOperand = [CalculatorBrainUtility ifNullReplaceWithQuestionMark:[CalculatorBrain descriptionOfTopOfStack:stack]];
            if ([secondOperand hasPrefix:@"("]) {
                result = [NSString stringWithFormat:@"%@ %@ %@", firstOperand, topOfStack, secondOperand];
            } else if ([topOfStack isEqual:@"×"] || [topOfStack isEqual:@"÷"]) {
                result = [NSString stringWithFormat:@"%@ %@ %@", firstOperand, topOfStack, secondOperand];
            } else {
                result = [NSString stringWithFormat:@"(%@ %@ %@)", firstOperand, topOfStack, secondOperand]; // ((3 + 5) + 9)
            }
        } else if ([CalculatorBrainUtility isNoOperator:topOfStack]) {
            result = topOfStack;
        } else if ([CalculatorBrain isVariable:topOfStack]) {
            result = topOfStack;
        }
    }
    return result;
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSString *result;
    
    if ([program isKindOfClass:[NSArray class]]) {
        NSMutableArray *stack = [program mutableCopy];
        result = [CalculatorBrain descriptionOfTopOfStack:stack];
        if ([CalculatorBrainUtility beginsAndEndsWithParens:result]) {
            result = [CalculatorBrainUtility removeFirstAndLastCharacter:result];
        }
        if ([stack count]) {
            result = [NSString stringWithFormat:@"%@, %@", result, [CalculatorBrain descriptionOfProgram:stack]];
        }
    }
    return result;
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
        } else if ([operation isEqualToString:@"×"]) {
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"−"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"÷"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor != 0) {
                result = [self popOperandOffProgramStack:stack] / divisor;
            }
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"√"]){
            double radicand = [self popOperandOffProgramStack:stack];
            if (radicand >= 0) {
                result = sqrt(radicand);
            }
        } else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        }
    }
    return result;
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSMutableSet *variables = [[NSMutableSet alloc] init];
    if ([program isKindOfClass:[NSArray class]]) {
        for (id obj in program) {
            if ([obj isKindOfClass:[NSString class]]) {
                if ([self isVariable:obj]) {
                    [variables addObject:obj];
                }
            }
        }
    }
    if ([variables count]) {
        return variables;
    } else {
        return nil;
    }
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    if ([program isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [program count]; i++) {
            if ([[program objectAtIndex:i] isKindOfClass:[NSString class]]) {
                if ([self isVariable:[program objectAtIndex:i]]) {
                    if ([variableValues objectForKey:[program objectAtIndex:i]]) {
                        [stack addObject:[variableValues objectForKey:[program objectAtIndex:i]]];
                    } else {
                        [stack addObject:[NSNumber numberWithDouble:0]];
                    }
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

- (void)undo
{
    if ([self.program isKindOfClass:[NSArray class]]) {
        if ([self.programStack lastObject]) {
            [self.programStack removeLastObject];
        }
    }
}

@end