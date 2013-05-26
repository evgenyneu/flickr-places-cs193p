//
//  RecentPhotosTableViewController.m
//  FlickrPlaces
//
//  Created by Evgenii Neumerzhitckii on 26/05/13.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//

#import "RecentPhotosTableViewController.h"
#import "RecentPhotosStorage.h"
#import "FlickrFetcher.h"
#import "nsstring_extend.m"

#define RECENT_PHOTO_CELL_IDENTIFIER @"Recent Photo"

@implementation RecentPhotosTableViewController

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [RecentPhotosStorage getRecentPhotos].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RECENT_PHOTO_CELL_IDENTIFIER forIndexPath:indexPath];
    
    
    NSDictionary *photo = [RecentPhotosStorage getRecentPhotos][indexPath.row];
    
    NSString *description = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    NSString *title = photo[FLICKR_PHOTO_TITLE];
    
    if ([title isEmpty]){
        title = description;
        description = @"";
        if ([title isEmpty]){ title = @"Unknown"; }
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = description;
    
    return cell;
}

@end
