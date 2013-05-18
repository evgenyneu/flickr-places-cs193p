//
//  PhotosInPlaceViewController.m
//  FlickrPlaces
//
//  Created by Evgenii Neumerzhitckii on 28/04/13.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//

#import "PhotosInPlaceViewController.h"
#import "FlickrFetcher.h"
#import "nsstring_extend.m"
#import "PhotoViewController.h"

#define PHOTOS_IN_PLACE_CELL_IDENTIFIER @"Flickr Photo In Place"

@implementation PhotosInPlaceViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.selectedPlacePhoto[FLICKR_WOE_NAME];
    [self loadTopPhotos];
}

- (void) setPhotosInPlace:(NSArray *)photosInPlace  {
    if (_photosInPlace != photosInPlace) {
        _photosInPlace = photosInPlace;
        [self.tableView reloadData];
    }
}

- (void) loadTopPhotos {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr top places downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *photos = [FlickrFetcher photosInPlace:self.selectedPlacePhoto maxResults:50];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photosInPlace = photos;
            self.navigationItem.rightBarButtonItem = nil;
        });
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSDictionary *photo = self.photosInPlace[indexPath.row];
    [segue.destinationViewController setPhoto:photo];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photosInPlace.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PHOTOS_IN_PLACE_CELL_IDENTIFIER forIndexPath:indexPath];
    
    NSDictionary *photo = self.photosInPlace[indexPath.row];
    
    NSString *description = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    NSString *title = photo[FLICKR_PHOTO_TITLE];
    
    if ([title isEmpty]){
        title = description;
        description = @"";
        if ([title isEmpty]){ title = @"Unknown"; }
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = description;

    return cell;
}

@end
