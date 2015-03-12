//
//  ImageDownloader.m
//
//
//  Created by Asfanur Arafin on 12/03/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import "ImageDownloader.h"
@interface ImageDownloader()
@property (nonatomic,retain) RowData *rowData;
@end

@implementation ImageDownloader

// -------------------------------------------------------------------------------
//	InitwithData
// Initialize the class with the data to work on
// -------------------------------------------------------------------------------

- (instancetype)initWithRowData:(RowData *)rowData{
    self = [super init];
    if (self != nil)
    {
        _rowData = rowData;
    }
    return self;
}

// -------------------------------------------------------------------------------
// main
// method to download an image in a queue
// -------------------------------------------------------------------------------
- (void)main {
    
     @autoreleasepool {
        //Check if th operation is canceled
        if (self.isCancelled)
            return;
        
        NSData *imageData = [[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.rowData.imageHref] ] autorelease];
        
        if (self.isCancelled) {
            imageData = nil;
            return;
        }
        
        if (imageData) {
            UIImage *downloadedImage = [UIImage imageWithData:imageData];
            self.rowData.image = downloadedImage;
        }
        else {
            self.rowData.failed = YES;
        }
        
        imageData = nil;
        
        if (self.isCancelled)
            return;
         
        //Return to the caller 
        if (self.completionHandler)
        {
            self.completionHandler();
        }
    }
}

- (void)dealloc
{
    [_rowData release];
    _rowData = nil;
    [super dealloc];
}


@end
