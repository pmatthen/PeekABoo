//
//  Person.h
//  PeekABoo
//
//  Created by Fletcher Rhoads on 1/31/14.
//  Copyright (c) 2014 Tablified Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * photourl;

@end
