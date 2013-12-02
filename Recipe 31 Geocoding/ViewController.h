//
//  ViewController.h
//  Recipe 31 Geocoding
//
//  Created by joseph hoffman on 11/26/13.
//  Copyright (c) 2013 NSCookbook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *outputLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputText;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;

- (IBAction)findAddress:(id)sender;
- (IBAction)findLocation:(id)sender;

@end
