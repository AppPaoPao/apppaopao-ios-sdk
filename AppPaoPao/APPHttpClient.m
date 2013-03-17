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

#define UUID_USER_DEFAULTS_KEY @"APPPaoPao_UUID"

@implementation APPHttpClient

+(void)sendFeedback
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:9292/feedbacks.json"]];
    NSDictionary *feedbackDict = [[NSDictionary alloc] initWithObjects:@[@"feedback title", @"feedback content"] forKeys:@[@"title", @"content"]];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:feedbackDict
                                                          options:NSJSONWritingPrettyPrinted
                                                            error:nil];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [request setHTTPBody:requestData];
    [self prepareHttpHeaders:request];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

+(void)prepareHttpHeaders:(NSMutableURLRequest *)request
{
    [request setValue:[[AppPaoPao sharedConnection] apiKey] forHTTPHeaderField:@"APP_KEY"];
    [request setValue:[self getUUID] forHTTPHeaderField:@"APP_UUID"];
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[[NSDate alloc] init] timeIntervalSince1970]];
    [request setValue:timestamp forHTTPHeaderField:@"APP_TIMESTAMP"];
    [request setValue:[self getSignature:request timestamp:timestamp] forHTTPHeaderField:@"APP_SIGNATURE"];
}

+(NSString *)getSignature:(NSMutableURLRequest *)request timestamp:(NSString *)timestamp
{
    NSString *httpMethod = request.HTTPMethod;
    NSString *httpUrl = [request.URL absoluteString];
    NSString *httpBody = [[NSString alloc] initWithData:request.HTTPBody encoding:NSNonLossyASCIIStringEncoding];
    NSString *rawText = [[[httpMethod stringByAppendingString:httpUrl] stringByAppendingString:httpBody] stringByAppendingString:timestamp];
    
    return [self encodeWithHmacsha1:[[AppPaoPao sharedConnection] apiSecret] rawText:rawText];
}

+(NSString *)encodeWithHmacsha1:(NSString *)key rawText:(NSString*)text
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [text cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    return [NSString  stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", cHMAC[0], cHMAC[1], cHMAC[2], cHMAC[3], cHMAC[4], cHMAC[5], cHMAC[6], cHMAC[7], cHMAC[8], cHMAC[9], cHMAC[10], cHMAC[11], cHMAC[12], cHMAC[13], cHMAC[14], cHMAC[15], cHMAC[16], cHMAC[17], cHMAC[18], cHMAC[19]];
}

+(NSString *)getUUID
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
@end
