//
// Created by Atanas Balevsky on 8/1/16.
// Copyright (c) 2016 Less Is More. All rights reserved.
//

#import "Vector.h"
#import <Parse/PFObject+Subclass.h>


@implementation Vector

@dynamic dir, loc;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Vector";
}
@end