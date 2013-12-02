//
//  ViewController.m
//  Recipe 31 Geocoding
//
//  Created by joseph hoffman on 11/26/13.
//  Copyright (c) 2013 NSCookbook. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)findAddress:(id)sender
{
    
    if([CLLocationManager locationServicesEnabled])
    {
        if(self.locationManager == nil)
        {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.distanceFilter = 300;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.delegate = self;
            
        }
        
        [self.locationManager startUpdatingLocation];
        self.outputLabel.text= @"Getting your address";
    }
    else
    {
        
        self.outputLabel.text = @"Location Services Not Available";
        
    }
}

- (IBAction)findLocation:(id)sender
{
    if(self.geocoder == nil)
    {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    NSString *address = self.inputText.text;
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(placemarks.count > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            self.outputLabel.text = placemark.location.description;
        }
        else if (error.domain == kCLErrorDomain)
        {
            switch (error.code)
            {
                case kCLErrorDenied:
                    self.outputLabel.text
                    = @"Location Services Denied by User";
                    break;
                case kCLErrorNetwork:
                    self.outputLabel.text = @"No Network";
                    break;
                case kCLErrorGeocodeFoundNoResult:
                    self.outputLabel.text = @"No Result Found";
                    break;
                default:
                    self.outputLabel.text = error.localizedDescription;
                    break;
            }
        }
        else
        {
            self.outputLabel.text = error.localizedDescription;
            
        }
    
        
    }];
    
    
}

#pragma mark - delegate methods

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(error.code == kCLErrorDenied)
    {
        self.outputLabel.text = @"Location information denied";
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // Make sure this is a recent location event
    CLLocation *newLocation = [locations lastObject];
    NSTimeInterval eventInterval = [newLocation.timestamp timeIntervalSinceNow];
    if(abs(eventInterval) < 30.0)
    {
        // Make sure the event is valid
        if (newLocation.horizontalAccuracy < 0)
        {
            return;
        }

        
        // Instantiate _geoCoder if it has not been already
        if (self.geocoder == nil)
        {
            self.geocoder = [[CLGeocoder alloc] init];
        }

        
        //Only one geocoding instance per action
        //so stop any previous geocoding actions before starting this one
        if([self.geocoder isGeocoding])
        {
            [self.geocoder cancelGeocode];
        }

        
        [self.geocoder reverseGeocodeLocation: newLocation
                        completionHandler: ^(NSArray* placemarks, NSError* error)
         {
             if([placemarks count] > 0)
             {
                 CLPlacemark *foundPlacemark = [placemarks objectAtIndex:0];
                 self.outputLabel.text =
                 [NSString stringWithFormat:@"You are in: %@",
                  foundPlacemark.description];
             }
             else if (error.code == kCLErrorGeocodeCanceled)
             {
                 NSLog(@"Geocoding cancelled");
             }
             else if (error.code == kCLErrorGeocodeFoundNoResult)
             {
                 self.outputLabel.text=@"No geocode result found";
             }
             else if (error.code == kCLErrorGeocodeFoundPartialResult)
             {
                 self.outputLabel.text=@"Partial geocode result";
             }
             else
             {
                 self.outputLabel.text =
                 [NSString stringWithFormat:@"Unknown error: %@",
                  error.description];
             }
         }
         ];
        
        //Stop updating location until they click the button again
        [manager stopUpdatingLocation];
    }
}

@end
