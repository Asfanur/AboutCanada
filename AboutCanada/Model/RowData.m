//
//  RowData.m
//  PecTest
//
//  Created by Asfanur Arafin on 12/03/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import "RowData.h"
@interface RowData()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *rowDescription;
@property (nonatomic, copy) NSString *imageHref;

@end

@implementation RowData


// -------------------------------------------------------------------------------
//	Init Methods
//
// -------------------------------------------------------------------------------

-(instancetype)initWithTitle:(NSString *)title withDescription:(NSString *)rowDescription andImageHref:(NSString *)imageHref{
    self = [super init];
    if (self) {
        _title = [title copy];
        _rowDescription = [rowDescription copy];
        _imageHref = [imageHref copy];
        
    }
    return self;
}

-(instancetype) init {
    return [self initWithTitle:nil withDescription:nil andImageHref:nil];
}
// -------------------------------------------------------------------------------

- (BOOL)hasImage {
    return _image != nil;
}

// -------------------------------------------------------------------------------

- (BOOL)isFailed {
    return _failed;
}

// -------------------------------------------------------------------------------

- (void)dealloc
{
    [_imageHref release];
    [_rowDescription release];
    [_title release];
    [_image release];
    
    
    _image=nil;
    _rowDescription = nil;
    _title = nil;
    _image = nil;
    [super dealloc];
}





@end
