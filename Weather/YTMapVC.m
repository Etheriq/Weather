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
#import "YTRequestManager.h"
#import "YTLocationManager.h"
#import "YTDateHelper.h"
@import GoogleMaps;

@interface YTMapVC()

@end

@implementation YTMapVC {
    GMSMapView *mapView_;
    GMSPlacesClient *placeClient_;
    NSString *infoPlace;
    YTCurrentWeatherModel *currentWeatherInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage imageNamed:@"menu-icon"]
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(showMenuAction)
                                              ];
    [self initMap];
//    placeClient_ = [GMSPlacesClient sharedClient];
}

-(void) initMap {
    CLLocation *location = [[YTLocationManager sharedManager] updateLocation];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                                            longitude:location.coordinate.longitude
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    mapView_.accessibilityElementsHidden = NO;
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    self.view = mapView_;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
//    marker.title = @"Sydney";
//    marker.snippet = @"Australia";
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
    
//    [placeClient_ currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error) {
//        if (error != nil) {
//            NSLog(@"Pick Place error %@", [error localizedDescription]);
//            return;
//        }
//        
//        if (placeLikelihoodList != nil) {
//            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
//            if (place != nil) {
////                NSLog(@"Place = %@", place);
////                NSLog(@"name: %@, addr: %@", place.name, [[place.formattedAddress componentsSeparatedByString:@", "] componentsJoinedByString:@"\n"]);
//            }
//        }
//    }];
    
    NSLog(@"tapped at: lat: %f, lng: %f", coordinate.latitude, coordinate.longitude);
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    YTCustomInfoWindow *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] objectAtIndex:0];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:marker.position.latitude longitude:marker.position.longitude];
    
    if (currentWeatherInfo == nil) {
        [[YTRequestManager sharedManager] getCurrentWeatherDataByCoordinates:location onSuccess:^(YTCurrentWeatherModel *model) {
            currentWeatherInfo = model;
            [mapView_ setSelectedMarker:marker];
        } onFailure:nil];
    } else {
        infoWindow.placeNameLabel.text = currentWeatherInfo.name;
        infoWindow.tempLabel.text = [NSString stringWithFormat:@"%.0f °C", currentWeatherInfo.temp];
        infoWindow.humidityLabel.text = [NSString stringWithFormat:@"Humidity: %i %%", currentWeatherInfo.humidity];
        infoWindow.pressureLabel.text = [NSString stringWithFormat:@"Pressure: %.1f hPa", currentWeatherInfo.pressure];
        infoWindow.windSpeedLabel.text = [NSString stringWithFormat:@"Wind speed: %i m/s", currentWeatherInfo.speed];
        infoWindow.sunriseLabel.text = [NSString stringWithFormat:@"Sunrise: %@", [[YTDateHelper sharedHelper] getFormattedDateStringFromDate:currentWeatherInfo.sunrise withFormat:@"kk:mm"]];
        infoWindow.sunsetLabel.text = [NSString stringWithFormat:@"Sunset: %@", [[YTDateHelper sharedHelper] getFormattedDateStringFromDate:currentWeatherInfo.sunset withFormat:@"kk:mm"]];
    }
    if (infoPlace == nil) {
        [[YTGoogleGeocodeManager sharedManager] getGeocodeInformationByCoordinates:location onSuccess:^(NSString *geoInfo) {
            infoPlace = geoInfo;
        } onFailure:nil];
    } else {
        infoWindow.placeNameLabel.text = infoPlace;
        NSLog(@"xxx --> %@", infoPlace);
    }
    
    return infoWindow;
}

- (void)mapView:(GMSMapView *)mapView didCloseInfoWindowOfMarker:(GMSMarker *)marker {
    infoPlace = nil;
    currentWeatherInfo = nil;
}

@end
