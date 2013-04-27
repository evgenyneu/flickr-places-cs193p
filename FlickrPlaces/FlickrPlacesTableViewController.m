//
//  FlickrPlacesTableViewController.m
//  FlickrPlaces
//
//  Created by Evgenii Neumerzhitckii on 25/04/13.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//

#import "FlickrPlacesTableViewController.h"
#import "FlickrFetcher.h"

#define CELL_IDENTIFIER @"Flickr Photo"

@interface FlickrPlacesTableViewController ()

@end

@implementation FlickrPlacesTableViewController

- (void) viewDidLoad {
    [self refresh:self.navigationItem.rightBarButtonItem];
}

- (void) setPhotos:(NSArray *)photos {
    if (_photos != photos) {
        _photos = photos;
        [self.tableView reloadData];
    }
}

- (void)setPhotoData:(NSArray*)photos {
    NSMutableArray *topCountries = [@[] mutableCopy];
    NSMutableDictionary *topPhotos = [@{} mutableCopy];
    
    for (NSDictionary *photo in photos) {
        NSString *place = photo[@"_content"];
        NSArray *placeComponents = [place componentsSeparatedByString: @", "];
        NSString *country = [placeComponents lastObject];
        if (![topCountries containsObject: country]) { [topCountries addObject:country]; }
        if (!topPhotos[country]) { topPhotos[country] = [@[] mutableCopy]; }
        [topPhotos[country] addObject:photo];
    }
    self.topCountries = [topCountries copy];
    self.topPhotos = [topPhotos copy];
}

- (NSArray*)topCountryPhotos: (NSInteger)index {
    NSString *country = self.topCountries[index];
    return self.topPhotos[country];
}

- (void) setTopPhotos:(NSDictionary *)topPhotos {
    if (_topPhotos != topPhotos) {
        _topPhotos = topPhotos;
        [self.tableView reloadData];
    }
}

- (IBAction)refresh:(UIBarButtonItem *)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *photos = [FlickrFetcher topPlaces];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setPhotoData: photos];
            self.photos = photos;
            self.navigationItem.rightBarButtonItem = sender;
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.topCountries.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self topCountryPhotos:section].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.topCountries[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    NSArray *countryPhotos = [self topCountryPhotos:indexPath.section];
    
    NSDictionary *photo = countryPhotos[indexPath.row];
    cell.textLabel.text = photo[FLICKR_WOE_NAME];
    
    NSString *place = photo[@"_content"];
    NSArray *placeComponents = [place componentsSeparatedByString: @", "];
    if (placeComponents.count == 3) {
        cell.detailTextLabel.text = placeComponents[1];
    }
    
    return cell;
}

@end
