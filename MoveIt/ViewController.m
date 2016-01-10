//
//  ViewController.m
//  MoveIt
//
//  Created by Atanas Balevsky on 13/11/15.
//  Copyright © 2015 Less Is More. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

#import "ViewController.h"
#import "Vector.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *shaker;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwiper;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwiper;
@property (assign) float angle;
@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.angle = 0;
}

- (IBAction)right:(id)sender {
    if (self.angle < 0) {
        NSLog(@"swiped right, but already on the right");
        return;
    }
    self.angle = -1;
    [self rotate:-(M_PI/8)];
    [self locate:@"right"];
   
}
- (IBAction)left:(id)sender {
    if (self.angle > 0) {
        NSLog(@"swiped left, but already on the left");
        return;
    }
    self.angle = 1;
    [self rotate:(M_PI/8)];
    [self locate:@"left"];
}

-(void)rotate:(float)angle {
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:0
                     animations:^{
                         [UIView setAnimationBeginsFromCurrentState:YES];
                         self.shaker.transform = CGAffineTransformMakeRotation(angle);
                     } completion:^(BOOL finished) {
                        [self share];
                     }];
}

-(void)locate:(NSString*)direction {
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"Location Services Enabled");
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Info"
                                        message:@"We will be saving the location of your mandalo movings."
                                        preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* close = [UIAlertAction
                                 actionWithTitle:@"Close"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
            [alert addAction:close];
            [self presentViewController:alert animated:YES completion:nil];
        }
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            // must be only once?
            UIAlertController *alert = [UIAlertController
                                          alertControllerWithTitle:@"Info"
                                          message:@"We need your location to build the mandalo's map. Please go to Settings and turn on Location Service for this app."
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* close = [UIAlertAction
                                    actionWithTitle:@"Close"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                    }];
            [alert addAction:close];
            [self presentViewController:alert animated:YES completion:nil];
        }
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
            if (!error) {
                Vector* vector = [Vector object];
                vector.dir = direction;
                vector.loc = geoPoint;
                [vector saveInBackground];
            }
        }];
        
    } else {
        // we can't save you on the map if you don't have location services enabled
    }
    
}
-(void)share {
    NSString *txt = self.angle > 0 ? @"I moved it to the left" : @"I moved it to the right";
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[txt] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
    [self presentViewController:activityVC animated:YES completion:nil];
}
@end
