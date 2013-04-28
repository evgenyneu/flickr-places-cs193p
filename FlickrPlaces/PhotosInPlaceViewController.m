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
    }
@end
