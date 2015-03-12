//
//  CanadaTableViewController.m
//  AboutCanada
//
//  Created by Asfanur Arafin on 12/03/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import "CanadaTableViewController.h"
#import "NetworkModelDownloader.h"
#import "ImageDownloader.h"
@interface CanadaTableViewController()
@property (nonatomic,retain) NSMutableArray *records;

@end

@implementation CanadaTableViewController

-(NSMutableArray *)records {
    if (!_records) {
        [self downLoadRecord];
        
    }
    return _records;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self records];
}






-(void)downLoadRecord {
    [NetworkModelDownloader fetchCountryInfoWithCompletionBlock:^(NSDictionary *model, NSError *error) {
        if (error) {
            
        } else {
            self.title = [model objectForKey:kTitle];
            NSMutableArray *records = [NSMutableArray array];
            
            for (NSDictionary *row in model[kRows]) {
                RowData *rowData = [[[RowData alloc] initWithTitle:row[kRowTitle] withDescription:row[kRowDescription] andImageHref:row[kRowImageHref]] autorelease];
                [records addObject:rowData];
                }
            self.records = records;
            
            [self.tableView reloadData];
            
        }
        
    }];
}

- (void)dealloc
{
    [_records release];
     _records = nil;
    
    [super dealloc];
}

@end
