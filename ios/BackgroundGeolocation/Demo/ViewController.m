//
//  ViewController.m
//  Demo
//
//  Created by Christopher Scott on 2018-03-02.
//  Copyright © 2018 Christopher Scott. All rights reserved.
//

#import "ViewController.h"
@import TSLocationManager;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _locations = [NSMutableArray new];
    
    _mapView.delegate = self;
    
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    TSConfig *config = [TSConfig sharedInstance];
    [config updateWithBlock:^(TSConfigBuilder *builder) {
        builder.debug = YES;
        builder.logLevel = 5;
        builder.stopOnTerminate = NO;
        builder.startOnBoot = YES;
        builder.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        builder.distanceFilter = 10;
    }];
    TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
    
    [bgGeo onGeofencesChange:^(TSGeofencesChangeEvent *event) {
        NSArray *geofencesOn    = event.on;
        NSArray *geofencesOff   = event.off;
        
        NSLog(@"- geofences that STARTED monitoring: %@", geofencesOn);
        NSLog(@"- geofences that STOPPED monitoring: %@", geofencesOff);
    }];
    
    [bgGeo ready];
    
    if (!config.schedulerEnabled) {
        [bgGeo startSchedule];
    }
    
    [bgGeo onMotionChange:^(TSLocation *tsLocation) {
        [self setCenterAndZoom:tsLocation.location];
    }];
    
    [bgGeo onLocation:^(TSLocation *tsLocation) {
        if (!tsLocation.isSample) {
            [self renderLocation:tsLocation.location];
        }
        [self setCenter:tsLocation.location];
    } failure:^(NSError *error) {
        NSLog(@"[location] FAILURE: %@", @(error.code));
    }];
    [bgGeo ready];
}

- (IBAction)onEnabledChange:(UISwitch*)sender {
    NSLog(@"- onEnabledChange");
    TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
    TSConfig *config = [TSConfig sharedInstance];
    if (sender.isOn) {
        [bgGeo start];
    } else {
        [bgGeo stop];
        [_mapView removeAnnotations:_mapView.annotations];
        [_mapView removeOverlays:_mapView.overlays];
        [_locations removeAllObjects];
        _polyline = nil;
    }
    [_btnChangePace setEnabled:config.enabled];
}

- (IBAction)onClickChangePace:(UIBarButtonItem*)sender {
    TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
    TSConfig *config = [TSConfig sharedInstance];
    if (!config.enabled) { return; }
    [bgGeo changePace:!config.isMoving];
    [sender setTitle:(config.isMoving) ? @"||" : @">"];
}

- (IBAction)onClickGetCurrentPosition:(UIBarButtonItem*)sender {
    TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
    
    TSCurrentPositionRequest *request = [[TSCurrentPositionRequest alloc] initWithSuccess:^(TSLocation *location) {
        NSLog(@"- getCurrentPosition success");
    } failure:^(NSError *error) {
        NSLog(@"- getCurrentPosition failure");
    }];
    request.persist = NO;
    request.samples = 1;
    [bgGeo getCurrentPosition:request];
}

- (void) setCenterAndZoom:(CLLocation*)location {
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = _mapView.region;
    if (region.span.latitudeDelta < span.latitudeDelta) { return; }
    region = MKCoordinateRegionMake(location.coordinate, span);
    [_mapView setRegion:region animated:YES];
    
}

- (void) setCenter:(CLLocation*)location {
    MKCoordinateRegion region = _mapView.region;
    region = MKCoordinateRegionMake(location.coordinate, region.span);
    [_mapView setRegion:region animated:YES];
}
- (void) renderLocation:(CLLocation*) location {
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = location.coordinate;
    //[_mapView addAnnotation:annotation];
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:location.coordinate radius:15];
    [_mapView addOverlay:circle];
    
    [_locations addObject:location];
    
    [self renderPolyline];
}

- (void) renderPolyline {
    NSUInteger count = [_locations count];
    if (count) {
        CLLocationCoordinate2D coordinates[count];
        for (NSInteger i=0; i < count; i++) {
            coordinates[i] = [(CLLocation*)_locations[i] coordinate];
        }
        if (_polyline) {
            [_mapView removeOverlay:_polyline];
        }
        _polyline = [MKPolyline polylineWithCoordinates:coordinates count:count];
        [_mapView insertOverlay:_polyline atIndex:0];
    }
}


-(MKOverlayRenderer*) mapView:(MKMapView*)mapView rendererForOverlay:(nonnull id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline *)overlay];
        renderer.lineWidth = 8.0f;
        renderer.strokeColor = [UIColor blueColor];
        renderer.alpha = 0.5;
        
        return renderer;
    } else if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circleView.strokeColor = [UIColor blackColor];
        circleView.fillColor = [self.class colorFromHexString:@"00B3FD"];
        circleView.lineWidth = 1;
        return circleView;
    } else {
        return nil;
    }
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
