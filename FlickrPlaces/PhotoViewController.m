//
//  PhotoViewController.m
//  FlickrPlaces
//
//  Created by Evgenii Neumerzhitckii on 18/05/13.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@implementation PhotoViewController

- (void) setPhotoData:(NSDictionary *)photoData {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr get photo url", NULL);
    dispatch_async(downloadQueue, ^{
        NSURL *urlForPhoto = [FlickrFetcher urlForPhoto:photoData format:FlickrPhotoFormatLarge];
        NSData *imageData = [NSData dataWithContentsOfURL:urlForPhoto];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image.image = image;
            self.navigationItem.rightBarButtonItem = nil;
        });
    });
}

@end
