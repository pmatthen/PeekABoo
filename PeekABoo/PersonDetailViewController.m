//
//  PersonDetailViewController.m
//  PeekABoo
//
//  Created by Apple on 31/01/14.
//  Copyright (c) 2014 Tablified Solutions. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "AddPersonDetailsViewController.h"
#import "MapViewController.h"


@interface PersonDetailViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIScrollView *myScrollView;
    NSMutableArray *personPhotos;
    float stagnantY;
    float startingX;
    BOOL isOverlayOn;
    UIView *detailOverlay;
}

@end

@implementation PersonDetailViewController

-(void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [detailOverlay removeFromSuperview];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhoto)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.enabled = YES;
    tapGestureRecognizer.cancelsTouchesInView = NO;
    tapGestureRecognizer.delegate = self;
    [myScrollView addGestureRecognizer:tapGestureRecognizer];
    isOverlayOn = NO;

    
    personPhotos = [NSMutableArray new];

    CGFloat width = 0.0;
    
    myScrollView.contentSize = CGSizeMake(width, myScrollView.frame.size.height);

    
    for (int i = 0; i < [self.fetchedResultsController.sections[0] numberOfObjects]; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        Person *tempPerson = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSData *data = [NSData dataWithContentsOfFile:tempPerson.photourl];
        UIImage *image = [UIImage imageWithData:data];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [personPhotos addObject:imageView];
    }
    
    for (int n = 0; n < personPhotos.count; n++) {
        UIImageView * anImageView = personPhotos[n];
        [myScrollView addSubview:anImageView];
        anImageView.frame = CGRectMake(width, 0, self.view.frame.size.width, self.view.frame.size.height);
        anImageView.contentMode = UIViewContentModeScaleAspectFit;
        if (self.indexPathRow == n) {
            startingX = width;
        }
        width += anImageView.frame.size.width;
    }

    myScrollView.contentSize = CGSizeMake(width, myScrollView.frame.size.height);
    [myScrollView setContentOffset:CGPointMake(startingX, self.view.frame.size.height/2)];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [aScrollView setContentOffset:CGPointMake(aScrollView.contentOffset.x, stagnantY)];
}

-(void)tapPhoto
{
    isOverlayOn = !(isOverlayOn);
    if (isOverlayOn) {
        [detailOverlay removeFromSuperview];
    } else {
        detailOverlay = [[UIView alloc]initWithFrame:CGRectMake(0, 0, myScrollView.contentSize.width, myScrollView.contentSize.height)];
        [detailOverlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0.4 alpha:0.3]];
        [self tappedMode];
        [myScrollView addSubview:detailOverlay];
    }
}

-(void)tappedMode
{
    for (int i = 0; i < [self.fetchedResultsController.sections[0] numberOfObjects]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        UILabel *personLabel = [[UILabel alloc] initWithFrame:CGRectMake((i * self.view.frame.size.width) + 20, 83, 280, 24)];
        personLabel.textColor = [UIColor whiteColor];
        personLabel.text = person.name;
        personLabel.font = [UIFont boldSystemFontOfSize:20];
        
        [detailOverlay addSubview:personLabel];
        
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake((i * self.view.frame.size.width) + 20, 115, 280, 21)];
        phoneLabel.textColor = [UIColor whiteColor];
        phoneLabel.text = person.phone;
        
        [detailOverlay addSubview:phoneLabel];
        
        UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake((i * self.view.frame.size.width) + 20, 144, 280, 21)];
        emailLabel.textColor = [UIColor whiteColor];
        emailLabel.text = person.email;
        
        [detailOverlay addSubview:emailLabel];
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake((i * self.view.frame.size.width) + 20, 173, 280, 21)];
        addressLabel.textColor = [UIColor whiteColor];
        addressLabel.text = person.address;

        [detailOverlay addSubview:addressLabel];
        
        UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mapButton setImage:[UIImage imageNamed:@"compass"] forState:UIControlStateNormal];
        mapButton.frame = CGRectMake((i * self.view.frame.size.width) + 212, 508, 40, 40);
        [mapButton addTarget:self action:@selector(goToMapView) forControlEvents:UIControlEventTouchDown];
        
        [detailOverlay addSubview:mapButton];

        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [editButton setImage:[UIImage imageNamed:@"user-card"] forState:UIControlStateNormal];
        editButton.frame = CGRectMake((i * self.view.frame.size.width) + 260, 508, 40, 40);
        [editButton addTarget:self action:@selector(goToEditView) forControlEvents:UIControlEventTouchDown];
        
        [detailOverlay addSubview:editButton];
    }
}

-(void)goToMapView
{
    NSLog(@"mapButton tapped");
    [self performSegueWithIdentifier:@"MapSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditSegue"]) {
        [[segue destinationViewController] setManagedObjectContext:_managedObjectContext];
        int page = (myScrollView.contentOffset.x + (0.5f * myScrollView.frame.size.width))/myScrollView.frame.size.width;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:page inSection:0];
        AddPersonDetailsViewController *destinationViewController;
        destinationViewController = segue.destinationViewController;
        destinationViewController.indexPath = indexPath;
        destinationViewController.fetchedResultsController = _fetchedResultsController;
    } else {
        MapViewController *destinationViewController;
        destinationViewController = segue.destinationViewController;
        int page = (myScrollView.contentOffset.x + (0.5f * myScrollView.frame.size.width))/myScrollView.frame.size.width;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:page inSection:0];
        Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
        destinationViewController.addressString = person.address;
    }
}

-(void)goToEditView
{
    NSLog(@"editButton tapped");
    [self performSegueWithIdentifier:@"EditSegue" sender:self];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // test if our control subview is on-screen
    if ([touch.view isKindOfClass:[UIButton class]]) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    return YES; // handle the touch
}

@end
