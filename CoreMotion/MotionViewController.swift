//
//  MotionViewController.swift
//  CoreMotion
//
//  Created by Zakk Hoyt on 6/10/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

import UIKit

class MotionViewController: UIViewController {
    var lastDate: NSDate
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        [self setupMotionActivity];
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
//    @IBAction func resetButtonAction(sender : AnyObject) {
//        lastDate = NSDate.date()
//        writeDate()
//        
//    }
//
//    func readDate() -> NSDate{
//        var date = NSUserDefaults.standardUserDefaults().objectForKey("lastDate") as NSDate
//        if date == nil{
//            date = NSDate.date().dateByAddingTimeInterval(60 * 60 * 24 * 7)
//        return date
//    }
//        func writeDate(){
//            NSUserDefaults.standardUserDefaults().setObject(self.lastDate, forKey: "lastDate")
//            NSUserDefaults.standardUserDefaults().synchronize()
//        }
    

        
//
//    - (IBAction)clearButtonTouchUpInside:(id)sender {
//    
//    self.lastDate = [NSDate date];
//    [self writeDate];
//    self.startDateLabel.text = self.lastDate.description;
//    
//    [self restartMonitors];
//    }
//    
//    
//    -(void)restartMonitors{
//    [self stopMotionUpdates];
//    [self startMotionUpdatesWithCompletionBlock:^(CMMotionActivity *activity) {
//    self.unknownLabel.text = activity.unknown ? @"YES" : @"NO";
//    self.stationaryLabel.text = activity.stationary ? @"YES" : @"NO";
//    self.walkingLabel.text = activity.walking? @"YES" : @"NO";
//    self.runningLabel.text = activity.running ? @"YES" : @"NO";
//    self.automotiveLabel.text = activity.automotive ? @"YES" : @"NO";
//    if(activity.confidence == CMMotionActivityConfidenceLow){
//    self.confidenceLabel.text = @"low";
//    } else if(activity.confidence == CMMotionActivityConfidenceMedium){
//    self.confidenceLabel.text =  @"medium";
//    } else if(activity.confidence == CMMotionActivityConfidenceHigh){
//    self.confidenceLabel.text =  @"high";
//    }
//    }];
//    
//    
//    
//    [self stopStepUpdates];
//    [self startStepUpdatesFromDate:self.lastDate updateBlock:^(CMPedometerData *pedometer) {
//    self.stepsLabel.text = pedometer.numberOfSteps.stringValue;
//    self.distanceLabel.text = [NSString stringWithFormat:@"%ldm", pedometer.distance.integerValue];
//    self.floorsAscendedLabel.text = pedometer.floorsAscended.stringValue;
//    self.floorsDescendedLabel.text = pedometer.floorsDescended.stringValue;
//    
//    }];
//    
//    self.startDateLabel.text = self.lastDate.description;
//    }
//    
//    
//    -(void)handleError:(NSError*)error{
//    
//    NSLog(@"ERROR: %d:%s %@", __LINE__, __PRETTY_FUNCTION__, error.description);
//    }
//    
//    -(void)setupMotionActivity{
//    self.motionActivity = [[CMMotionActivityManager alloc]init];
//    self.pedometer = [[CMPedometer alloc]init];
//    }
//    
//    -(void)checkAuthorizationWithCompletionBlock:(VWWBoolBlock)completionBlock{
//    NSDate *now = [NSDate date];
//    [self.pedometer queryPedometerDataFromDate:now toDate:now withHandler:^(CMPedometerData *pedometerData, NSError *error) {
//    dispatch_async(dispatch_get_main_queue(), ^{
//    completionBlock(!error || error.code != CMErrorMotionActivityNotAuthorized);
//    });
//    }];
//    }
//    
//    -(void)queryHistoricalDataFrom:(NSDate*)startDate toDate:(NSDate*)endDate{
//    [_motionActivity queryActivityStartingFromDate:startDate
//    toDate:endDate
//    toQueue:[NSOperationQueue mainQueue]
//    withHandler:^(NSArray *activities, NSError *error) {
//    if(error){
//    [self handleError:error];
//    } else {
//    NSLog(@"TODO: %d:%s process data", __LINE__, __PRETTY_FUNCTION__);
//    //                                               [self additionalProcessingOn:activities];
//    [_pedometer queryPedometerDataFromDate:startDate
//    toDate:endDate
//    withHandler:^(CMPedometerData *pedometerData, NSError *error) {
//    if(error){
//    [self handleError:error];
//    } else {
//    _stepCounts = pedometerData.numberOfSteps;
//    }
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//    //                                                                                  _query
//    });
//    }];
//    }
//    }];
//    }
//    
//    
//    -(void)startStepUpdatesFromDate:(NSDate*)date updateBlock:(VWWCMPedometerDataBlock)updateBlock{
//    
//    if([CMPedometer isStepCountingAvailable] == NO){
//    self.stepsLabel.text = @"n/a";
//    } else {
//    self.stepsLabel.text = @"...";
//    }
//    
//    if([CMPedometer isDistanceAvailable] == NO){
//    self.distanceLabel.text = @"n/a";
//    } else {
//    self.distanceLabel.text = @"...";
//    }
//    
//    
//    [self.pedometer startPedometerUpdatesFromDate:date withHandler:^(CMPedometerData *pedometerData, NSError *error) {
//    if(error){
//    [self handleError:error];
//    } else {
//    dispatch_async(dispatch_get_main_queue(), ^{
//    updateBlock(pedometerData);
//    });
//    }
//    }];
//    }
//    
//    -(void)stopStepUpdates{
//    [self.pedometer stopPedometerUpdates];
//    }
//    
//    -(void)startMotionUpdatesWithCompletionBlock:(VWWCMMotionActivityBlock)completionBlock{
//    [self.motionActivity startActivityUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMotionActivity *activity) {
//    completionBlock(activity);
//    }];
//    }
//    
//    -(void)stopMotionUpdates{
//    [self.motionActivity stopActivityUpdates];
//    }
//    
//    
//
//    
//    

}
