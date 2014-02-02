//
//  FlipSegue.m
//  PeekABoo
//
//  Created by Apple on 01/02/14.
//  Copyright (c) 2014 Tablified Solutions. All rights reserved.
//

#import "FlipSegue.h"

@implementation FlipSegue

- (void) perform {
    
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    [UIView transitionWithView:src.navigationController.view duration:.8
     
                       options:UIViewAnimationOptionTransitionFlipFromLeft
     
                    animations:^{
                        
                        [src.navigationController pushViewController:dst animated:NO];
                        
                    }
     
                    completion:NULL];
    
}

@end
