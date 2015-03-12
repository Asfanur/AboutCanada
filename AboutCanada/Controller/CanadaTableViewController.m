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
#import "DynamicCell.h"

@interface CanadaTableViewController()

@property (nonatomic,retain) NSMutableArray *records;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) NSOperationQueue *queue;

@end

@implementation CanadaTableViewController
static NSString *kCellIdentifier = @"Cell";

-(NSMutableArray *)records {
    if (!_records) {
        [self downLoadRecord];
        
    }
    return _records;
}

-(NSMutableDictionary *)imageDownloadsInProgress {
    if (!_imageDownloadsInProgress) {
        self.imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    }
    return _imageDownloadsInProgress;
}
-(NSOperationQueue *)queue {
    if (!_queue) {
        self.queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self records];
    [self initializeRefreshController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}




// -------------------------------------------------------------------------------
//	initializeRefreshController
//  Add Refresh Controller to the tablevirew
// -------------------------------------------------------------------------------

-(void)initializeRefreshController{
    
    self.refreshControl = [[[UIRefreshControl alloc] init] autorelease];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
    
}
-(void)refresh {
    [self downLoadRecord];
    [self.refreshControl endRefreshing];
    
}
// -------------------------------------------------------------------------------
//	downLoadRecord
//  Download json and save it to the records property
// -------------------------------------------------------------------------------

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

#pragma mark - Table view data source
// -------------------------------------------------------------------------------
//	tableView:numberOfRowsInSection:
//  get number of rows
// -------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}
// -------------------------------------------------------------------------------
// tableView:cellForRowAtIndexPath:indexPath
//
// -------------------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    UIActivityIndicatorView *activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    cell.accessoryView = activityIndicatorView;
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

// -------------------------------------------------------------------------------
//	configureCell:atIndexPath:indexPath
//  configure title and detail of the tableview row
// -------------------------------------------------------------------------------

-(void)configureCell:(DynamicCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if (self.records.count>0) {
        RowData *rowData = [self.records objectAtIndex:indexPath.row];
        //check if title is null
        if([rowData.title isKindOfClass:[NSNull class]]){
            cell.rowtitle.text = @"No Title";
            
        }else {
            cell.rowtitle.text = rowData.title;
            
        }
        cell.rowtitle.font =[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        
        //check if rowDescription is null
        if([rowData.rowDescription isKindOfClass:[NSNull class]]){
            cell.rowDescription.text = @"No Title";
            
        }else {
            cell.rowDescription.text = rowData.rowDescription;
            
        }
        cell.rowDescription.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [self configureImageView:rowData ofCell:cell atIndexPath:indexPath];
        
        
        
    }
    
    
}

// -------------------------------------------------------------------------------
//	configureImageView:ofCell:atIndexPath
//  When image is downloaded add them to the imageview
// -------------------------------------------------------------------------------

-(void)configureImageView:(RowData *)rowData ofCell:(DynamicCell *)cell  atIndexPath:(NSIndexPath *)indexPath{
    
    if (rowData.hasImage) {
        [((UIActivityIndicatorView *)cell.accessoryView) stopAnimating];
        cell.cellImageView.image = rowData.image;
        
    }
    // If downloading the image has failed, display an error to display the failure, and stop the activity indicator.
    else if (rowData.isFailed) {
        [((UIActivityIndicatorView *)cell.accessoryView) stopAnimating];
        cell.cellImageView.image = [UIImage imageNamed:@"error"];
        
    } // If image href is null the set the imageview to nil and stop activity indicator.
    
    else if ([rowData.imageHref isKindOfClass:[NSNull class]]) {
        [((UIActivityIndicatorView *)cell.accessoryView) stopAnimating];
        cell.cellImageView.image = nil;
        
    }
    
    // the image has not been downloaded yet.Start the activity indicator.
    else {
        
        [((UIActivityIndicatorView *)cell.accessoryView) startAnimating];
        cell.cellImageView.image = [UIImage imageNamed:@"placeHolder"];
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
        {
            [self startImageDownload:rowData forIndexPath:indexPath];
        }
    }
    
    
}

// -------------------------------------------------------------------------------
//	startImageDownload:forIndexPath
//  Download image for a perticuler row
// -------------------------------------------------------------------------------

- (void)startImageDownload:(RowData *)rowData forIndexPath:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (imageDownloader == nil)
    {
        imageDownloader = [[[ImageDownloader alloc] initWithRowData:rowData] autorelease];
        [imageDownloader setCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                DynamicCell *cell = (DynamicCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                // Display the newly loaded image
                [self configureImageView:rowData ofCell:cell atIndexPath:indexPath];
                [self.imageDownloadsInProgress removeObjectForKey:indexPath];
                
            });
            
        }];
        
        if(![rowData.imageHref isKindOfClass:[NSNull class]]){
            (self.imageDownloadsInProgress)[indexPath] = imageDownloader;
            [self.queue addOperation:imageDownloader];
            
        }
    }
}

// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows:
//  Load images for all onscreen rows
// -------------------------------------------------------------------------------

- (void)loadImagesForOnscreenRows
{
    if (self.records.count > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            RowData *rowData = (self.records)[indexPath.row];
            
            if (!rowData.image)
                // Avoid the app icon download if the app already has an icon
            {
                [self startImageDownload:rowData forIndexPath:indexPath];
            }
        }
    }
}

// -------------------------------------------------------------------------------
//	didChangePreferredContentSize:
//  Get called when preferred content size changes
// -------------------------------------------------------------------------------


- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self.tableView reloadData];
}




#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:scrollView
//  When scrolling stops, proceed to load the app icons that are on screen.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
    
    [_records release];
    [_imageDownloadsInProgress release];
    [_queue release];
    
    _records = nil;
    _imageDownloadsInProgress = nil;
    _queue = nil;
    
    [super dealloc];
}

@end
