//
//  PhotoViewController.h
//  FlickrPlaces
//
//  Created by Evgenii Neumerzhitckii on 18/05/13.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController

@property (nonatomic, strong) NSDictionary *photoData;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
