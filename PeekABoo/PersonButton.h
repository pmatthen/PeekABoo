//
//  PersonButton.h
//  PeekABoo
//
//  Created by Fletcher Rhoads on 1/31/14.
//  Copyright (c) 2014 Tablified Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface PersonButton : UIButton
@property Person *person;
@property int indexPathRow;

@end
