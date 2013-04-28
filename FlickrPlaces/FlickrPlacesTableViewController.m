//
//  FlickrPlacesTableViewController.m
//  FlickrPlaces
//
//  Created by Evgenii Neumerzhitckii on 25/04/13.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//

#import "FlickrPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotosInPlaceViewController.h"

#define CELL_IDENTIFIER @"Flickr Photo"

@implementation FlickrPlacesTableViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self refresh:self.navigationItem.rightBarButtonItem];
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
    [topCountries sortUsingSelector:@selector(caseInsensitiveCompare:)];
    self.topCountries = [topCountries copy];
    self.topPhotos = [topPhotos copy];
    [self.tableView reloadData];
}

- (NSArray*)topCountryPhotos: (NSInteger)index {
    NSString *country = self.topCountries[index];
    return self.topPhotos[country];
}

- (NSDictionary*)photoFromIndexPath: (NSIndexPath*)indexPath {
    NSArray *countryPhotos = [self topCountryPhotos:indexPath.section];
    return countryPhotos[indexPath.row];
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
            self.navigationItem.rightBarButtonItem = sender;
        });
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSDictionary *photo = [self photoFromIndexPath:indexPath];
    [segue.destinationViewController setSelectedPlacePhoto:photo];
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
    
    NSDictionary *photo = [self photoFromIndexPath: indexPath];
    cell.textLabel.text = photo[FLICKR_WOE_NAME];
    
    NSString *place = photo[@"_content"];
    NSArray *placeComponents = [place componentsSeparatedByString: @", "];
    if (placeComponents.count == 3) {
        cell.detailTextLabel.text = placeComponents[1];
    }
    
    return cell;
}

@end
