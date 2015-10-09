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
@property (weak, nonatomic) IBOutlet UIView *billView;
@property (weak, nonatomic) IBOutlet UIView *tipView;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tip Calculator";
    [self setTipControl];
    [self updateValues];
    self.tipView.alpha = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastUpdate = [defaults objectForKey:@"lastUpdatedTime"];
    NSDate *now = [NSDate date];
    NSTimeInterval seconds = [now timeIntervalSinceDate:lastUpdate];
    if (seconds <= 10 * 60) {
        self.billTextField.text = [defaults stringForKey:@"lastUpdatedBill"];
        self.tipView.alpha = 1;
    }
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
    NSArray *locales = @[@"en_US", @"en_UK", @"en_CA", @"es_ES", @"fr_FR", @"de_DE", @"zh_CN", @"ja_JP", @"it_IT"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    long localeIndex = [defaults integerForKey:@"localeIndex"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:locales[localeIndex]];
    [formatter setLocale:locale];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setMaximumFractionDigits:2];
    
    float billAmount = [self.billTextField.text floatValue];
    
    NSArray *tipValues = @[@(0.10), @(0.15), @(0.20)];
    float tipAmount = [tipValues[self.tipControl.selectedSegmentIndex] floatValue] * billAmount;
    float total = tipAmount + billAmount;
    
    NSString *formattedTipAmount = [formatter stringFromNumber:[NSNumber numberWithFloat:tipAmount]];
    self.tipAmountLabel.text = formattedTipAmount;
    NSString *formattedTotalAmount = [formatter stringFromNumber:[NSNumber numberWithFloat:total]];
    self.totalLabel.text = formattedTotalAmount;
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
    [UIView animateWithDuration:0.5 animations:^{
        // This causes first view to fade in and second view to fade out
        self.tipView.alpha = 1;
    } completion:^(BOOL finished) {
        // Do something here when the animation finishes.
    }];
    [self updateValues];
    if (self.billTextField.text && self.billTextField.text.length > 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:self.billTextField.text forKey:@"lastUpdatedBill"];
        NSDate *now = [NSDate date];
        [defaults setObject:now forKey:@"lastUpdatedTime"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastUpdatedBill"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastUpdatedTime"];
    }
}

@end
