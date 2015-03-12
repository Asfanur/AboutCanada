//
//  DynamicCell.m
//  AboutCanada
//
//  Created by Asfanur Arafin on 12/03/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import "DynamicCell.h"

@implementation DynamicCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.rowDescription.preferredMaxLayoutWidth = CGRectGetWidth(self.rowDescription.frame);
     
}



- (void)dealloc {
    [_rowtitle release];
    [_rowDescription release];
    [_cellImageView release];
    _rowtitle=nil;
    _rowDescription=nil;
    _cellImageView=nil;
    [super dealloc];
}


@end
