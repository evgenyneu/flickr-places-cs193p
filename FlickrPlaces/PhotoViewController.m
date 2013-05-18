//
//  PhotoViewController.m
//  FlickrPlaces
//
//  Created by Evgenii Neumerzhitckii on 18/05/13.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@interface PhotoViewController()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;

@end

@implementation PhotoViewController

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.image setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

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
            self.imageViewWidthConstraint.constant = image.size.width;
            self.imageViewHeightConstraint.constant = image.size.height;
            [self.image setNeedsUpdateConstraints];
            [self.image setNeedsLayout];
            self.navigationItem.rightBarButtonItem = nil;
        });
    });
}

@end
