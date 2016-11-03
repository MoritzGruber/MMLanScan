//
//  PingOperation.m
//  WhiteLabel-Test
//
//  Created by Michael Mavris on 03/11/2016.
//  Copyright © 2016 DW Dynamicworks Ltd. All rights reserved.
//

#import "MACOperation.h"
#import "Device.h"
#import "LANProperties.h"
#import "MacFinder.h"

@interface MACOperation ()
@property (nonatomic,strong) NSString *ipStr;
@property (nonatomic, copy) void (^result)(NSError  * _Nullable error, NSString  * _Nonnull ip,Device * _Nonnull device);
@property(nonnull,strong)Device *device;
@end

@implementation MACOperation {

    NSError *errorMessage;
}

-(instancetype)initWithIPToPing:(NSString*)ip andCompletionHandler:(nullable void (^)(NSError  * _Nullable error, NSString  * _Nonnull ip,Device * _Nonnull device))result;{

    self = [super init];
    
    if (self) {
        self.device = [[Device alloc]init];
        self.name = ip;
        self.ipStr= ip;
        self.result = result;
    }
    
    return self;
};

-(void)start {

    [super start];
    // RUN LOOP MAGIC
    [self getMACDetails];
}
-(void)finishMAC {
   
    if (self.result) {
        self.result(errorMessage,self.name,self.device);

    [self finish];
}
}
-(void)cancel{
    [super cancel];
    [self finish];
}
    
#pragma mark - Ping Result callback
-(void)getMACDetails{
    
    self.device.ipAddress=self.ipStr;
    self.device.macAddress =[[MacFinder ip2mac:self.device.ipAddress] uppercaseString];
    self.device.hostname = [LANProperties getHostFromIPAddress:self.ipStr];
    
    if (self.device.macAddress) {
        
        if (self.device.macAddress) {
            
            //self.device.brand = [self.brandDictionary objectForKey:[[curDevice.macAddress substringWithRange:NSMakeRange(0, 8)] stringByReplacingOccurrencesOfString:@":" withString:@"-"]];
        }
        
    }
    else {
        errorMessage = [NSError errorWithDomain:@"MAC Address Not Exist" code:10 userInfo:nil];
    }
    //NSLog(@"Finished");
  //  [self finishedPing];
    [self finishMAC];
}

@end
