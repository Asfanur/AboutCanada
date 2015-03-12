//
//  RowData.h
//  
//
//  Created by Asfanur Arafin on 12/03/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RowData : NSObject

//Readonly properties to read the Row data
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *rowDescription;
@property (nonatomic, readonly) NSString *imageHref;

@property (nonatomic, retain) UIImage *image; // To store the actual image
@property (nonatomic, readonly) BOOL hasImage; // Return YES if image is downloaded.
@property (nonatomic, getter = isFailed) BOOL failed; // Return Yes if image failed to be downloaded

//designated initializer
-(instancetype)initWithTitle:(NSString *)title withDescription:(NSString *)rowDescription andImageHref:(NSString *)imageHref;

@end
