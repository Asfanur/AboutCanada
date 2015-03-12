//
//  NetworkModelDownloader.h
//  AboutCanada
//
//  Created by Asfanur Arafin on 12/03/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkModelDownloader : NSObject
typedef void (^ModelCompletionBlock) (NSDictionary *model, NSError * error);
+(void)fetchCountryInfoWithCompletionBlock:(ModelCompletionBlock)completionBlock;
@end