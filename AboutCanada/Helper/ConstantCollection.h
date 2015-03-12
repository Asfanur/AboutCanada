//
//  ConstantCollection.h
//  AboutCanada
//
//  Created by Asfanur Arafin on 12/03/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//This Class holds the requred constants

#import <Foundation/Foundation.h>

@interface ConstantCollection : NSObject

//URL and JSON constants 
#define kFeedURL @"https://dl.dropboxusercontent.com/u/746330/facts.json"
#define kTitle @"title"
#define kRows @"rows"
#define kRowTitle @"title"
#define kRowDescription @"description"
#define kRowImageHref @"imageHref"


//The following error domain is predefined.
extern NSString * const AsfanurArafinErrorDomain;


@end
