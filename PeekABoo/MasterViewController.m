//
//  ViewController.m
//  PeekABoo
//
//  Created by Apple on 30/01/14.
//  Copyright (c) 2014 Tablified Solutions. All rights reserved.
//

#import "MasterViewController.h"
#import "PersonButton.h"

#define BLOCKHEIGHT 100
#define BLOCKWIDTH 100
#define BLOCKGAP 30
#define NUMBEROFCOLUMNS 4

@interface MasterViewController () <UIScrollViewDelegate, NSFetchedResultsControllerDelegate>
{
    __weak IBOutlet UIScrollView *myScrollView;
}

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    request.sortDescriptors = @[];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"CacheMoney"];
    [self.fetchedResultsController performFetch:nil];
    NSLog(@"%i", [self.fetchedResultsController.sections[0] numberOfObjects]);
    self.fetchedResultsController.delegate = self;

    int numberOfObjects = [self.fetchedResultsController.sections[0] numberOfObjects];
    int rows = 1 + (numberOfObjects/NUMBEROFCOLUMNS);
    int columns = NUMBEROFCOLUMNS;
    
    float scrollViewHeight = (BLOCKGAP * 2) + (rows * BLOCKHEIGHT) + ((rows - 1) * BLOCKGAP);
    float scrollViewWidth = (BLOCKGAP * 2) + (columns * BLOCKWIDTH) + ((columns - 1) * BLOCKGAP);
    
    myScrollView.contentSize = CGSizeMake(scrollViewWidth, scrollViewHeight);
    [self generateColumnsAndRows];
}

-(void)generateColumnsAndRows
{
    int numberOfObjects = [self.fetchedResultsController.sections[0] numberOfObjects];
    int indexPathRow = 0;
    int rows = 1 + (numberOfObjects/NUMBEROFCOLUMNS);
    int columns = NUMBEROFCOLUMNS;
    
    for (int r = 0; r < rows; r++) {
        if (numberOfObjects < columns) {
            columns = numberOfObjects;
        }
        for (int c = 0; c < columns; c++) {
            numberOfObjects--;
            
            PersonButton *personButton = [PersonButton buttonWithType:UIButtonTypeRoundedRect];
            [personButton addTarget:self action:@selector(onPersonButtonPressed:) forControlEvents:UIControlEventTouchDown];
            float buttonOriginX = (BLOCKGAP + (c * BLOCKWIDTH) + (c * BLOCKGAP));
            float buttonOriginY = ((BLOCKGAP) + (r * BLOCKHEIGHT) + (r * BLOCKGAP));
            personButton.frame = CGRectMake(buttonOriginX, buttonOriginY, BLOCKWIDTH, BLOCKHEIGHT);
            personButton.clipsToBounds = YES;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexPathRow inSection:0];
            personButton.person = [self.fetchedResultsController objectAtIndexPath:indexPath];
            personButton.indexPathRow = indexPathRow;
            NSLog(@"%@", personButton.person.photourl);
            
            NSData *data = [NSData dataWithContentsOfFile:personButton.person.photourl];
            
            [personButton setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
            [myScrollView addSubview:personButton];
            indexPathRow++;
        }
    }
}
                                            
-(IBAction)onPersonButtonPressed:(PersonButton *)sender
{
    NSLog(@"tapped");
    [self performSegueWithIdentifier:@"PersonDetailSegue" sender:sender];
}

            

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(PersonButton *)sender
{
    if ([[segue identifier] isEqualToString:@"AddUserSegue"]) {
        [[segue destinationViewController] setManagedObjectContext:_managedObjectContext];
    }
    if ([[segue identifier] isEqualToString:@"PersonDetailSegue"]) {
        [[segue destinationViewController] setManagedObjectContext:_managedObjectContext];
        [[segue destinationViewController] setFetchedResultsController:_fetchedResultsController];
        [[segue destinationViewController] setPerson:sender.person];
        [[segue destinationViewController] setIndexPathRow:sender.indexPathRow];
    }
}

@end
