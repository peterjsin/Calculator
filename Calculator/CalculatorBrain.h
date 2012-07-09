//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Peter Siniawski on 6/21/2012.
//  Copyright (c) 2012 peterjsin@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (BOOL)isVariable:(NSString *)testString;
+ (NSSet *)variablesUsedInProgram:(id)program;

- (void)pushOperand:(double)operand;
- (void)pushVariable:(NSString *)variable;
- (double)performOperation:(NSString *)operation;
- (void)clear;
- (void)undo;

@end
