//
//  AboutCanadaTests.m
//  AboutCanadaTests
//
//  Created by Asfanur Arafin on 12/03/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NetworkModelDownloader.h"
#import "ImageDownloader.h"

@interface AboutCanadaTests : XCTestCase

@end

@implementation AboutCanadaTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    [super tearDown];
}

// -------------------------------------------------------------------------------
// testNetworkModelDownloader
// Download LowData test
// -------------------------------------------------------------------------------

-(void)testNetworkModelDownloader {
    
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Network Model Downloader"];
    [NetworkModelDownloader fetchCountryInfoWithCompletionBlock:^(NSDictionary *model, NSError *error) {
        
        XCTAssertNotNil(model, @"data should not be nil");
        XCTAssertNil(error, @"error should be nil");
        
        [completionExpectation fulfill];
        
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    
    
}

// -------------------------------------------------------------------------------
// testImageDownloader
// Download Image test
// -------------------------------------------------------------------------------


-(void)testImageDownloader {
    
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Image Downloader"];
    NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    RowData *rowData = [[[RowData alloc] initWithTitle:@"Beavers" withDescription:@"Beavers are second only to humans" andImageHref:@"http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"] autorelease];
    
    ImageDownloader *imageDownloader = [[[ImageDownloader alloc] initWithRowData:rowData] autorelease];
    [imageDownloader setCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            XCTAssertNotNil(rowData.image, @"data should not be nil");
            [completionExpectation fulfill];
        });
        
    }];
    
    [queue addOperation:imageDownloader];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];


}



@end
