//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Peter Siniawski on 6/21/2012.
//  Copyright (c) 2012 peterjsin@gmail.com. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, readonly) NSDictionary *variableValues;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize historyDisplay = _historyDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *) brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (NSDictionary *) variableValues {
    NSArray *values = [NSArray arrayWithObjects:[NSNumber numberWithDouble:2],
                                                [NSNumber numberWithDouble:3],
                                                [NSNumber numberWithDouble:5], nil];
    NSArray *variables = [NSArray arrayWithObjects:@"x", @"y", @"z", nil];
    return [NSDictionary dictionaryWithObjects:values forKeys:variables];
}

- (void)updateHistoryDisplay:(NSString *)stringSentToBrain
{
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingFormat:@" %@", stringSentToBrain];
}

/*  Appends or places a digit on the display */
- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else if (![self.display.text isEqualToString:@"0"] || ![digit isEqualToString:@"0"]) {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

/*  Trims the last character off of the display unless there is only one. If only one, puts a zero */
- (IBAction)deletePressed
{
    int length = self.display.text.length;
    if (length > 1) {
        length--;
        self.display.text = [self.display.text substringToIndex:length];
    } else {
        self.display.text = @"0";
    }
}

/*  Pushes the display onto the stack */
- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self updateHistoryDisplay:self.display.text];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

/*  Sends performOperation. Updates both display and historyDisplay */
- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.historyDisplay.text = [self.historyDisplay.text stringByReplacingOccurrencesOfString:@"=" withString:@""];
    [self updateHistoryDisplay:[operation stringByAppendingString:@" ="]];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

/*  Puts one and only one decimal onto the display */
- (IBAction)decimalPressed
{ 
    if ( ([self.display.text rangeOfString:@"."]).location == NSNotFound ) {
        self.display.text = [self.display.text stringByAppendingFormat:@"."];
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

/* Push M_PI onto the stack. Put M_PI onto the display */
- (IBAction)piPressed
{   
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    [self.brain pushOperand:M_PI];
    [self updateHistoryDisplay:@"π"];
    self.display.text = [NSString stringWithFormat:@"%g", M_PI];
}

/* First time: Clears memory and display. A second press also clears historyDisplay */
- (IBAction)clearPressed {
    if ([self.historyDisplay.text hasSuffix:@"C"]) {
        self.historyDisplay.text = @"";
    } else {
        [self updateHistoryDisplay:@"C"];
    }        
    [self.brain clear];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.display.text = @"0";
}  

/* Multiplies the display by -1 and puts it onto the display */
- (IBAction)negatePressed
{
    if (![self.display.text isEqualToString:@"0"]) {
        self.display.text = [NSString stringWithFormat:@"%g", [self.display.text doubleValue] * -1];
        if (!self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    }
}

- (IBAction)variablePressed:(UIButton *)sender
{
    NSString *variable = [sender currentTitle];
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    [self.brain pushVariable:variable];
    [self updateHistoryDisplay:variable];
    self.display.text = variable;
}

- (IBAction)testPressed
{
    self.display.text = [NSString stringWithFormat:@"%g", [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.variableValues]];
    
}


@end