//
//  ViewController.m
//  CoreMotion
//
//  Created by Zakk Hoyt on 6/10/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "ViewController.h"

@import CoreMotion;


typedef void (^VWWBoolBlock)(BOOL success);
typedef void (^VWWNumberBlock)(NSNumber *number);
typedef void (^VWWCMMotionActivityBlock)(CMMotionActivity *activity);
typedef void (^VWWCMPedometerDataBlock)(CMPedometerData *pedometer);
@interface ViewController ()
@property (nonatomic, strong) CMMotionActivityManager *motionActivity;
@property (nonatomic, strong) CMPedometer *pedometer;
@property (nonatomic, strong) NSNumber *stepCounts;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *unknownLabel;
@property (weak, nonatomic) IBOutlet UILabel *stationaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *walkingLabel;
@property (weak, nonatomic) IBOutlet UILabel *runningLabel;
@property (weak, nonatomic) IBOutlet UILabel *automotiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepsLabel;
@property (weak, nonatomic) IBOutlet UILabel *confidenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorsAscendedLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorsDescendedLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (nonatomic, strong) NSDate *lastDate;
@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMotionActivity];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.lastDate = [self readDate];
//    self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0, 0, 0);
    
    [self checkAuthorizationWithCompletionBlock:^(BOOL success) {
        if(success){
            [self restartMonitors];
//            [self queryHistoricalDataFrom:self.lastDate toDate:[NSDate date]];
        } else {
            NSLog(@"ERROR: %d:%s No Permissions", __LINE__, __PRETTY_FUNCTION__);
        }
    }];

}


-(NSDate*)readDate{
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastDate"];
    if(date == nil){
        NSDate *now = [NSDate date];
        date = [NSDate dateWithTimeInterval:-60 * 60 * 24 * 7 sinceDate:now];
    }
    return date;
}

-(void)writeDate{
    [[NSUserDefaults standardUserDefaults] setObject:self.lastDate forKey:@"lastDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clearButtonTouchUpInside:(id)sender {
    
    self.lastDate = [NSDate date];
    [self writeDate];
    self.startDateLabel.text = self.lastDate.description;
    
    [self restartMonitors];
}


-(void)restartMonitors{
    [self stopMotionUpdates];
    [self startMotionUpdatesWithCompletionBlock:^(CMMotionActivity *activity) {
        self.unknownLabel.text = activity.unknown ? @"YES" : @"NO";
        self.stationaryLabel.text = activity.stationary ? @"YES" : @"NO";
        self.walkingLabel.text = activity.walking? @"YES" : @"NO";
        self.runningLabel.text = activity.running ? @"YES" : @"NO";
        self.automotiveLabel.text = activity.automotive ? @"YES" : @"NO";
        if(activity.confidence == CMMotionActivityConfidenceLow){
            self.confidenceLabel.text = @"low";
        } else if(activity.confidence == CMMotionActivityConfidenceMedium){
            self.confidenceLabel.text =  @"medium";
        } else if(activity.confidence == CMMotionActivityConfidenceHigh){
            self.confidenceLabel.text =  @"high";
        }
    }];
    
    
    
    [self stopStepUpdates];
    [self startStepUpdatesFromDate:self.lastDate updateBlock:^(CMPedometerData *pedometer) {
        self.stepsLabel.text = pedometer.numberOfSteps.stringValue;
        self.distanceLabel.text = [NSString stringWithFormat:@"%ldm", pedometer.distance.integerValue];
        self.floorsAscendedLabel.text = pedometer.floorsAscended.stringValue;
        self.floorsDescendedLabel.text = pedometer.floorsDescended.stringValue;
        
    }];
    
    self.startDateLabel.text = self.lastDate.description;
}


-(void)handleError:(NSError*)error{
    
    NSLog(@"ERROR: %d:%s %@", __LINE__, __PRETTY_FUNCTION__, error.description);
}

-(void)setupMotionActivity{
    self.motionActivity = [[CMMotionActivityManager alloc]init];
    self.pedometer = [[CMPedometer alloc]init];
}

-(void)checkAuthorizationWithCompletionBlock:(VWWBoolBlock)completionBlock{
    NSDate *now = [NSDate date];
    [self.pedometer queryPedometerDataFromDate:now toDate:now withHandler:^(CMPedometerData *pedometerData, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(!error || error.code != CMErrorMotionActivityNotAuthorized);
        });
    }];
}

-(void)queryHistoricalDataFrom:(NSDate*)startDate toDate:(NSDate*)endDate{
    [_motionActivity queryActivityStartingFromDate:startDate
                                            toDate:endDate
                                           toQueue:[NSOperationQueue mainQueue]
                                       withHandler:^(NSArray *activities, NSError *error) {
                                           if(error){
                                               [self handleError:error];
                                           } else {
                                               NSLog(@"TODO: %d:%s process data", __LINE__, __PRETTY_FUNCTION__);
//                                               [self additionalProcessingOn:activities];
                                               [_pedometer queryPedometerDataFromDate:startDate
                                                                               toDate:endDate
                                                                          withHandler:^(CMPedometerData *pedometerData, NSError *error) {
                                                                              if(error){
                                                                                  [self handleError:error];
                                                                              } else {
                                                                                  _stepCounts = pedometerData.numberOfSteps;
                                                                              }
                                                                              
                                                                              dispatch_async(dispatch_get_main_queue(), ^{
//                                                                                  _query
                                                                              });
                                                                          }];
                                           }
                                       }];
}


-(void)startStepUpdatesFromDate:(NSDate*)date updateBlock:(VWWCMPedometerDataBlock)updateBlock{
    
    if([CMPedometer isStepCountingAvailable] == NO){
        self.stepsLabel.text = @"n/a";
    } else {
        self.stepsLabel.text = @"...";
    }
    
    if([CMPedometer isDistanceAvailable] == NO){
        self.distanceLabel.text = @"n/a";
    } else {
        self.distanceLabel.text = @"...";
    }
    

    [self.pedometer startPedometerUpdatesFromDate:date withHandler:^(CMPedometerData *pedometerData, NSError *error) {
        if(error){
            [self handleError:error];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                updateBlock(pedometerData);
            });
        }
    }];
}

-(void)stopStepUpdates{
    [self.pedometer stopPedometerUpdates];
}

-(void)startMotionUpdatesWithCompletionBlock:(VWWCMMotionActivityBlock)completionBlock{
    [self.motionActivity startActivityUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMotionActivity *activity) {
        completionBlock(activity);
    }];
}

-(void)stopMotionUpdates{
    [self.motionActivity stopActivityUpdates];
}



@end
