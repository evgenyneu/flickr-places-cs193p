//
//  RecentPhotosStorage.h
//  FlickrPlaces
//
//  Created by Evgenii Neumerzhitckii on 26/05/13.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentPhotosStorage : NSObject

+ (void) savePhotoToRecent: (NSDictionary*) photoData;

@end
