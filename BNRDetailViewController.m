//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by Benjamin Kodres-O'Brien on 8/1/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRDateViewController.h"
#import "BNRItem.h"

@interface BNRDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation BNRDetailViewController

// VIEW METHODS

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    BNRItem *item = self.item;
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    // You need an NSDateFormatter that will turn a date into a simple date string
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    // Use filtered NSDate object to set dateLabel contents
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    // Clear first responder
    [self.view endEditing:YES];
    
    // "Save" changes to item
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialNumberField.text;
    self.item.valueInDollars = [self.valueField.text intValue];
}

// UITextFieldDelegateMethods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nameField resignFirstResponder];
    [self.serialNumberField resignFirstResponder];
    [self.valueField resignFirstResponder];
    
    return YES;
}


// OTHER METHODS

- (void)setItem:(BNRItem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)changeDate:(id)sender
{
    BNRDateViewController *dateViewController = [[BNRDateViewController alloc] init];
    
    dateViewController.item = self.item;
    
    // Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:dateViewController animated:YES];
}

@end
