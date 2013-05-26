//
//  RecentPhotosStorage.m
//  FlickrPlaces
//
//  Created by Evgenii Neumerzhitckii on 26/05/13.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//

#import "RecentPhotosStorage.h"

#define RECENT_KEY @"recent photos"
#define MAX_RECENT_ITEMS 20

@implementation RecentPhotosStorage

+ (void) savePhotoToRecent: (NSDictionary*) photoData {
    NSMutableArray *recent = [RecentPhotosStorage getRecentPhotos];
    NSUInteger existingIndex = [recent indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([((NSDictionary *)obj)[@"id"] isEqualToString:photoData[@"id"]]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    if (existingIndex != NSNotFound) [recent removeObjectAtIndex:existingIndex];
    [recent insertObject:photoData atIndex:0];
    
    if (recent.count > MAX_RECENT_ITEMS) {
        NSRange theRange;
        theRange.location = 0;
        theRange.length = MAX_RECENT_ITEMS;
        recent = [[recent subarrayWithRange:theRange] mutableCopy];
    }
    
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
