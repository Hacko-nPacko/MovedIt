//
//  ViewController.m
//  MoveIt
//
//  Created by Atanas Balevsky on 13/11/15.
//  Copyright © 2015 Less Is More. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

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
    float toValue = -(M_PI/8);
    self.angle = -1;
    [self rotate:toValue];
   
}
- (IBAction)left:(id)sender {
    if (self.angle > 0) {
        NSLog(@"swiped left, but already on the left");
        return;
    }
    float toValue = (M_PI/8);
    self.angle = 1;
    [self rotate:toValue];
}

-(void)rotate:(float)angle {
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:nil
                     animations:^{
                         [UIView setAnimationBeginsFromCurrentState:YES];
                         self.shaker.transform = CGAffineTransformMakeRotation(angle);
                     } completion:^(BOOL finished) {
                        [self share];
                     }];
}

-(void)share {
    NSString *txt = self.angle > 0 ? @"I moved it to the left" : @"I moved it to the right";
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[txt] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
    [self presentViewController:activityVC animated:YES completion:nil];
}
@end
