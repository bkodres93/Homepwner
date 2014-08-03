//
//  BNRItem.h
//  RandomItems
//
//  Created by Benjamin Kodres-O'Brien on 6/3/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, strong) NSDate *dateCreated;

+ (instancetype)randomItem;

// The designated initializer (initializes anything writeable)
- (instancetype) initWithItemName:(NSString *)name
                   valueInDollars:(int)value
                     serialNumber:(NSString *)sNumber;

- (instancetype) initWithItemName:(NSString *)name;

- (instancetype)initWithItemName:(NSString *)name
                    serialNumber:(NSString *)sNumber;

@end
