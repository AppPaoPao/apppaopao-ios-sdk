//
//  Authorization.m
//  AppPaoPao
//
//  Created by Richard Huang on 3/16/13.
//  Copyright (c) 2013 AppPaoPao. All rights reserved.
//

#import "APPHttpClient.h"
#import "AppPaoPao.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "UIDevice-Hardware.h"

#define UUID_USER_DEFAULTS_KEY @"APPPaoPao_UUID"

@implementation APPHttpClient

-(void) sendRate:(Boolean)like
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apppaopao.com/rates.json"]];
    NSString *rateValue = like ? @"true" : @"false";
    NSDictionary *rateDict = [[NSDictionary alloc] initWithObjects:@[rateValue] forKeys:@[@"rate"]];
    
    [request setHTTPMethod:@"POST"];
    [self prepareHttpBody:request dict:rateDict];
    [self prepareHttpHeaders:request];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

-(void) sendFeedback:(NSString *)title content:(NSString *)content userEmail:(NSString *)email userPhone:(NSString *)phone
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apppaopao.com/feedbacks.json"]];
    NSDictionary *feedbackDict = [[NSDictionary alloc] initWithObjects:@[title, content, email, phone] forKeys:@[@"title", @"content", @"email", @"phone"]];
    
    [request setHTTPMethod:@"POST"];
    [self prepareHttpBody:request dict:feedbackDict];
    [self prepareHttpHeaders:request];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

-(void)prepareHttpHeaders:(NSMutableURLRequest *)request
{
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    
    NSString *key = [[AppPaoPao sharedConnection] apiKey];
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[[NSDate alloc] init] timeIntervalSince1970]];
    NSString *uuid = [self getUUID];
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *carrierName = [self getCarrierName];
    NSString *platform =[[UIDevice currentDevice] platformString];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *signature = [self getSignature:request timestamp:timestamp];
    NSString *authorization = [NSString stringWithFormat:@"APP key=\"%@\", timestamp=\"%@\", uuid=\"%@\", macaddress=\"%@\", carriername=\"%@\", platform=\"%@\", systemversion=\"%@\", signature=\"%@\"", key, timestamp, uuid, macaddress, carrierName, platform, systemVersion, signature];
    [request setValue:authorization forHTTPHeaderField:@"AUTHORIZATION"];
}

-(void) prepareHttpBody:(NSMutableURLRequest *)request dict:(NSDictionary *)requestDict
{
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDict
                                                          options:NSJSONWritingPrettyPrinted
                                                            error:nil];
    [request setHTTPBody:requestData];
}

-(NSString *)getSignature:(NSMutableURLRequest *)request timestamp:(NSString *)timestamp
{
    NSString *httpMethod = request.HTTPMethod;
    NSString *httpUrl = [request.URL absoluteString];
    NSString *httpBody = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    NSString *rawText = [[[httpMethod stringByAppendingString:httpUrl] stringByAppendingString:httpBody] stringByAppendingString:timestamp];
    
    return [self encodeWithHmacsha1:[[AppPaoPao sharedConnection] apiSecret] rawText:rawText];
}

-(NSString *)encodeWithHmacsha1:(NSString *)key rawText:(NSString*)text
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    return [NSString  stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", cHMAC[0], cHMAC[1], cHMAC[2], cHMAC[3], cHMAC[4], cHMAC[5], cHMAC[6], cHMAC[7], cHMAC[8], cHMAC[9], cHMAC[10], cHMAC[11], cHMAC[12], cHMAC[13], cHMAC[14], cHMAC[15], cHMAC[16], cHMAC[17], cHMAC[18], cHMAC[19]];
}

-(NSString *)getUUID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uuidString = [defaults objectForKey:UUID_USER_DEFAULTS_KEY];
    if (uuidString == nil) {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
        CFRelease(uuid);
        
        [defaults setValue:uuidString forKey:UUID_USER_DEFAULTS_KEY];
        [defaults synchronize];
    }
    
    return uuidString;
}

-(NSString *)getCarrierName
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];

    return [carrier carrierName];
}
@end