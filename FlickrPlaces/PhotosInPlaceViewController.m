//
//  PhotosInPlaceViewController.m
//  FlickrPlaces
//
//  Created by Evgenii Neumerzhitckii on 28/04/13.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//

#import "PhotosInPlaceViewController.h"
#import "FlickrFetcher.h"

@interface PhotosInPlaceViewController ()

@end

@implementation PhotosInPlaceViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.selectedPlacePhoto[FLICKR_WOE_NAME];
    [self loadTopPhotos];
}

- (void) loadTopPhotos {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr top places downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *photos = [FlickrFetcher photosInPlace:self.selectedPlacePhoto maxResults:50];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = nil;
        });
    });
}


@end
