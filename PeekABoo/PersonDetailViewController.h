//
//  PersonDetailViewController.h
//  PeekABoo
//
//  Created by Apple on 31/01/14.
//  Copyright (c) 2014 Tablified Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface PersonDetailViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) Person *person;
@property int indexPathRow;

@end
