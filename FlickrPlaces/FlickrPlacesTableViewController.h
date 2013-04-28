//
//  FlickrPlacesTableViewController.h
//  FlickrPlaces
//
//  Created by Evgenii Neumerzhitckii on 25/04/13.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPlacesTableViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *topPhotos; // key: country name, value: NSArray of photos discriptions (NSDictionary)
@property (nonatomic, strong) NSArray *topCountries; // Used to store the order of country name keys from topPhotos

@end
