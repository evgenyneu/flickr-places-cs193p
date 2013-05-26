//
//  PhotoViewController.m
//  FlickrPlaces
//
//  Created by Evgenii Neumerzhitckii on 18/05/13.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@interface PhotoViewController()  <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scrollView.delegate = self;
    [self initImageView];
}

- (void) initImageView {
    [self.scrollView removeConstraints: self.scrollView.constraints];
    
    [self addConstraintsForImageEdges];
    
    [self addConstraintsToCenterImage];
}

/*
 Three things to note here:
 1) Constraints are added to self.view and not to self.scrollView. Otherwise the picture will jump when zooming.
 2) Notice that top and left edges have priority 750, and right and bottom have 250.
 3) Using '>=' instead of equality to allow centering in addConstraintsToCenterImage.*/
- (void) addConstraintsForImageEdges {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(>=0@750)-[_imageView]-(>=0@250)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0@750)-[_imageView]-(>=0@250)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
}

- (void) addConstraintsToCenterImage {
    NSLayoutConstraint *constraintMiddleY =
    [NSLayoutConstraint constraintWithItem:self.imageView
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.scrollView
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0.0];
    constraintMiddleY.priority = 100;
    [self.view addConstraint:constraintMiddleY];
    
    NSLayoutConstraint *constraintMiddleX =
    [NSLayoutConstraint constraintWithItem:self.imageView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.scrollView
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0];
    constraintMiddleX.priority = 100;
    [self.view addConstraint:constraintMiddleX];
}

// Zoom to show as much image as possible
- (void) initZoom {
    if (!self.imageView.image) return;
    float minZoom = MIN(self.view.bounds.size.width / self.imageView.image.size.width,
                        self.view.bounds.size.height / self.imageView.image.size.height);
    if (minZoom > 1) return;
    
    self.scrollView.minimumZoomScale = minZoom;
    
    self.scrollView.zoomScale = minZoom;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self initZoom];
}

- (void) setPhotoData:(NSDictionary *)photoData {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    self.title = photoData[@"title"];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr get photo url", NULL);
    dispatch_async(downloadQueue, ^{
        NSURL *urlForPhoto = [FlickrFetcher urlForPhoto:photoData format:FlickrPhotoFormatMedium640];
        NSData *imageData = [NSData dataWithContentsOfURL:urlForPhoto];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            [self initZoom];
            self.navigationItem.rightBarButtonItem = nil;
        });
    });
}

@end
