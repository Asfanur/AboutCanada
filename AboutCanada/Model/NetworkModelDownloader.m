//
//  NetworkModelDownloader.m
//  AboutCanada
//
//  Created by Asfanur Arafin on 12/03/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import "NetworkModelDownloader.h"

@interface NetworkModelDownloader()
typedef void (^DownloadCompletionBlock) (NSData *data, NSURLResponse *response, NSError *error);
@end


@implementation NetworkModelDownloader

// -------------------------------------------------------------------------------
//	fetchCountryInfoWithCompletionBlock:completionBlock
//  Convenience method to get the json data about canada
// -------------------------------------------------------------------------------

+(void)fetchCountryInfoWithCompletionBlock:(ModelCompletionBlock)completionBlock{
    
    [self fetchQuery:kFeedURL withCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completionBlock(nil,error);
        }
        //Parse the json data and return the callback 
        else {
            NSString *string = [[[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding] autorelease]  ;
            NSData *metOfficeData = [string dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *countryData = [NSJSONSerialization JSONObjectWithData:metOfficeData
                                                                        options:kNilOptions
                                                                          error:&error];
            completionBlock(countryData,error);
            
        }
        
        
        
    }];
    
    
}

// -------------------------------------------------------------------------------
//	fetchQuery:withCompletionBlock:completionBlock
//  Common gateway to get the json data
// -------------------------------------------------------------------------------
+(void)fetchQuery:(NSString *)query withCompletionBlock:(DownloadCompletionBlock)completionBlock {
    
    NSString *queryString = [[query copy] autorelease];
    NSURLSession *session = [NSURLSession sharedSession];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[session dataTaskWithURL:[NSURL URLWithString:[queryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                if (!error) {
                    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                    NSIndexSet *acceptableStatusCodes =  [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
                    //If no error and the response is in range between 200 and 100 then callback with good data
                    if ( [acceptableStatusCodes containsIndex:(NSUInteger)httpResp.statusCode] && data) {
                       
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(data,response,error);
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            
                        });
                        
                    }
                    //If response if not in the range then create custom error
                    else {
                        NSDictionary *userInfo = @{
                                                   NSLocalizedDescriptionKey: NSLocalizedString([NSHTTPURLResponse localizedStringForStatusCode:httpResp.statusCode] , nil),
                                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The data might be incorrect", nil),
                                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please check your data and try again", nil)
                                                   };
                        NSError *customError = [NSError errorWithDomain:AsfanurArafinErrorDomain
                                                                   code:-55
                                                               userInfo:userInfo];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(data,response,customError);
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            
                        });
                        
                    }
                }
                //If error exists then send the callback with error
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(data,response,error);
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        
                    });
                    
                    
                    
                }
            }] resume];
    
    
    
}



@end
