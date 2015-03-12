//
//  ImageDownloader.h
//  
//
//  Created by Asfanur Arafin on 12/03/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
// NSOperation class responsible for downloading image 

#import <Foundation/Foundation.h>
#import "RowData.h"

@interface ImageDownloader : NSOperation
//Completion handler when the operation is done
@property (nonatomic, copy) void (^completionHandler)(void);

//designated initializer
- (instancetype)initWithRowData:(RowData *)rowData;


@end
