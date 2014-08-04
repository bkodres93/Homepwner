//
//  BNRDateViewController.m
//  Homepwner
//
//  Created by Benjamin Kodres-O'Brien on 8/3/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRDateViewController.h"

@interface BNRDateViewController ()

@end

@implementation BNRDateViewController

- (IBAction)datePicked:(UIDatePicker *)sender
{
    self.item.dateCreated = sender.date;
}

@end
