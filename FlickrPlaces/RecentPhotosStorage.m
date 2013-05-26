//
//  RecentPhotosStorage.m
//  FlickrPlaces
//
//  Created by Evgenii Neumerzhitckii on 26/05/13.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//

#import "RecentPhotosStorage.h"

#define RECENT_KEY @"recent_photos"
#define MAX_RECENT_ITEMS 5

@implementation RecentPhotosStorage

+ (void) savePhotoToRecent: (NSDictionary*) photoData {
    NSMutableArray *recent = [RecentPhotosStorage getRecentPhotos];
    [recent removeObjectIdenticalTo:photoData];
    [recent insertObject:photoData atIndex:0];
    [RecentPhotosStorage saveRecent:recent];
}

+ (NSMutableArray*) getRecentPhotos {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recent = [defaults mutableArrayValueForKey:RECENT_KEY];
    if (!recent) recent = [[NSMutableArray alloc] init];
    return recent;
}

+ (void) saveRecent: (NSMutableArray*) recent {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:recent forKey:RECENT_KEY];
    [defaults synchronize];
}

@end
