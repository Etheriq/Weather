//
//  YTMapVC.m
//  Weather
//
//  Created by Yuriy T on 23.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTMapVC.h"
#import "YTCustomInfoWindow.h"
#import "YTGoogleGeocodeManager.h"
@import GoogleMaps;

@interface YTMapVC()

@end

@implementation YTMapVC {
    GMSMapView *mapView_;
    GMSPlacesClient *placeClient_;
    NSString *infoPlace;
    NSString *infoCoords;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage imageNamed:@"menu-icon"]
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(showMenuAction)
                                              ];
    placeClient_ = [GMSPlacesClient sharedClient];
}

-(void) loadView {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    mapView_.accessibilityElementsHidden = NO;
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    self.view = mapView_;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView_;
}

# pragma mark - Actions

- (void) showMenuAction {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    [mapView_ clear];
    CLLocationCoordinate2D markerPosition = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:markerPosition];
    marker.title = @"fds";
    marker.map = mapView_;
    
    [mapView_ animateToLocation:coordinate];
    
    [placeClient_ currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            if (place != nil) {
//                NSLog(@"Place = %@", place);
//                NSLog(@"name: %@, addr: %@", place.name, [[place.formattedAddress componentsSeparatedByString:@", "] componentsJoinedByString:@"\n"]);
            }
        }
    }];
    
    NSLog(@"tapped at: lat: %f, lng: %f", coordinate.latitude, coordinate.longitude);
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    YTCustomInfoWindow *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] objectAtIndex:0];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:marker.position.latitude longitude:marker.position.longitude];
    
    if (infoPlace == nil) {
        [[YTGoogleGeocodeManager sharedManager] getGeocodeInformationByCoordinates:location onSuccess:^(NSString *info) {
            infoCoords = [NSString stringWithFormat:@"lat: %.8f lng: %.8f", location.coordinate.latitude, location.coordinate.longitude];
            infoPlace = info;
//            infoWindow.coordinateLabel.text = [NSString stringWithFormat:@"lat: %.8f lng: %.8f", location.coordinate.latitude, location.coordinate.longitude];
//            infoWindow.placeNameLabel.text = info;
            [mapView_ setSelectedMarker:marker];
            
        } onFailure:nil];
    } else {
        infoWindow.placeNameLabel.text = infoPlace;
        infoWindow.coordinateLabel.text = infoCoords;
    }    
    
    return infoWindow;
}

- (void)mapView:(GMSMapView *)mapView didCloseInfoWindowOfMarker:(GMSMarker *)marker {
    infoPlace = nil;
    infoCoords = nil;
}

@end
