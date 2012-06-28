//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Peter Siniawski on 6/21/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
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

- (void)updateHistoryDisplay:(NSString *)stringSentToBrain
{
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingFormat:@"%@ ", stringSentToBrain];
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)deletePressed {
    int length = self.display.text.length;
    if (length > 1) {
        length--;
        self.display.text = [self.display.text substringToIndex:length];
    } else {
        self.display.text = @"0";
    }
}


- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self updateHistoryDisplay:self.display.text];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

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

- (IBAction)decimalPressed
{ 
    if ( ([self.display.text rangeOfString:@"."]).location == NSNotFound ) {
        self.display.text = [self.display.text stringByAppendingFormat:@"."];
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)piPressed
{   
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    [self.brain performOperation:@"π"];
    self.display.text = [NSString stringWithFormat:@"%g", M_PI];
}

- (IBAction)clearPressed {
    [self.brain clear];
    [self updateHistoryDisplay:@"C"];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.display.text = @"0";
}  

- (IBAction)negatePressed {
    self.display.text = [NSString stringWithFormat:@"%g", [self.display.text doubleValue] * -1];
    if (!self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
}

@end
