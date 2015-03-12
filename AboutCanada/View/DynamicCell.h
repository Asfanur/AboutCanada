//
//  DynamicCell.h
//  AboutCanada
//
//  Created by Asfanur Arafin on 12/03/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//This class is the Custom tableview cell for CanadaTableViewController

#import <UIKit/UIKit.h>

@interface DynamicCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *rowtitle;
@property (retain, nonatomic) IBOutlet UILabel *rowDescription;
@property (retain, nonatomic) IBOutlet UIImageView *cellImageView;


@end
