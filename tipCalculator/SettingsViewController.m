//
//  SettingsViewController.m
//  tipCalculator
//
//  Created by Xin Suo on 10/4/15.
//  Copyright © 2015 Groupon. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController () {
    NSArray *regions;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (weak, nonatomic) IBOutlet UIPickerView *localePicker;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    regions = @[@"English(U.S.)", @"English(U.K.)", @"English(C.A.)", @"Spanish", @"French", @"German", @"Chinese", @"Japanese", @"Italian"];
    self.localePicker.dataSource = self;
    self.localePicker.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onTap:(UISegmentedControl *)sender {
    long defaultIndex = [self.tipControl selectedSegmentIndex];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:defaultIndex forKey:@"default_index"];
    [defaults synchronize];
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    long tipIndex = [defaults integerForKey:@"default_index"];
    [self.tipControl setSelectedSegmentIndex:tipIndex];
    long localeIndex = [defaults integerForKey:@"localeIndex"];
    [self.localePicker selectRow:localeIndex inComponent:0 animated:YES];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return regions.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return regions[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:row forKey:@"localeIndex"];
}

@end
