//
//  ViewController.h
//  Demo
//
//  Created by Christopher Scott on 2018-03-02.
//  Copyright © 2018 Christopher Scott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnChangePace;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCurrentPosition;
@property (weak, nonatomic) IBOutlet UISwitch *enableSwitch;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UISwitch *enableSwitch2;

@property (strong, nonatomic) MKPolyline *polyline;
@property (strong, nonatomic) NSMutableArray *locations;

@end

