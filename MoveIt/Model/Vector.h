//
// Created by Atanas Balevsky on 8/1/16.
// Copyright (c) 2016 Less Is More. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface Vector : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString *dir;
@property (nonatomic, strong) PFGeoPoint *loc;

@end