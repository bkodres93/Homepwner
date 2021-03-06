//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by Benjamin Kodres-O'Brien on 8/1/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface BNRDetailViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);


- (IBAction)changeDate:(id)sender;
- (instancetype)initForNewItem:(BOOL)isNew;

@end
