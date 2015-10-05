//
//  ViewController.m
//  tipCalculator
//
//  Created by Xin Suo on 10/4/15.
//  Copyright © 2015 Groupon. All rights reserved.
//

#import "TipViewController.h"

@interface TipViewController ()
@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tip Calculator";
    [self setTipControl];
    [self updateValues];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)onValueChanged:(UISegmentedControl *)sender {
    [self updateValues];
}

- (void)updateValues {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    
    float billAmount = [self.billTextField.text floatValue];
    
    NSArray *tipValues = @[@(0.10), @(0.15), @(0.20)];
    float tipAmount = [tipValues[self.tipControl.selectedSegmentIndex] floatValue] * billAmount;
    float total = tipAmount + billAmount;
    
    NSString *formattedTipAmount = [formatter stringFromNumber:[NSNumber numberWithFloat:tipAmount]];
    self.tipAmountLabel.text = [@"$" stringByAppendingString:formattedTipAmount];
    NSString *formattedTotalAmount = [formatter stringFromNumber:[NSNumber numberWithFloat:total]];
    self.totalLabel.text = [@"$" stringByAppendingString:formattedTotalAmount];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setTipControl];
    [self updateValues];
    [self.billTextField becomeFirstResponder];
}

- (void) setTipControl {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    long tipIndex = [defaults integerForKey:@"default_index"];
    [self.tipControl setSelectedSegmentIndex:tipIndex];
}

- (IBAction)onBillChanged:(UITextField *)sender {
    [self updateValues];
}

@end
