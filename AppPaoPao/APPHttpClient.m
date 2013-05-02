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
#define HTTP_HOST @"http://localhost:3000"
//#define HTTP_HOST @"http://www.apppaopao.com"

@implementation APPHttpClient

-(void) sync
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/sync.json", HTTP_HOST]]];
    NSDictionary *syncDict = [[NSDictionary alloc] init];
    
    [request setHTTPMethod:@"POST"];
    [self prepareHttpBody:request dict:syncDict];
    [self prepareHttpHeaders:request];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:nil];
    [connection start];
}

-(void) sendRate:(Boolean)like
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/rates.json", HTTP_HOST]]];
    NSString *rateValue = like ? @"true" : @"false";
    NSDictionary *rateDict = [[NSDictionary alloc] initWithObjects:@[rateValue] forKeys:@[@"rate"]];
    
    [request setHTTPMethod:@"POST"];
    [self prepareHttpBody:request dict:rateDict];
    [self prepareHttpHeaders:request];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:nil];
    [connection start];
}

-(void) sendFeedback:(NSString *)title content:(NSString *)content userEmail:(NSString *)email userPhone:(NSString *)phone
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/feedbacks.json", HTTP_HOST]]];
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
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleDisplayname = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *bundleIdentifier = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    NSString *bundleVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *authorization = [NSString stringWithFormat:@"APP key=\"%@\", timestamp=\"%@\", uuid=\"%@\", macaddress=\"%@\", carriername=\"%@\", platform=\"%@\", systemversion=\"%@\", displayname=\"%@\", bundleidentifier=\"%@\", bundleversion=\"%@\", signature=\"%@\"", key, timestamp, uuid, macaddress, carrierName, platform, systemVersion,bundleDisplayname, bundleIdentifier, bundleVersion, signature];
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

#pragma mark NSURLConnectionDelegete
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSInteger statusCode = [(NSHTTPURLResponse*) response statusCode];
    if (statusCode == 200 || statusCode == 201) {
        [self popupHUD:@"AppPaoPaoResources.bundle/check-mark.png" label:@"发送成功！"];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self popupHUD:@"" label:@"发送失败！"];
}

- (void)popupHUD:(NSString *)imagePath label:(NSString *)label {
    UIViewController *topController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    HUD = [[MBProgressHUD alloc] initWithView:topController.view];
	[topController.view addSubview:HUD];
	
    if (![imagePath isEqualToString:@""]) {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagePath]];
    }
	
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
	
	HUD.delegate = self;
	HUD.labelText = label;
	
	[HUD show:YES];
	[HUD hide:YES afterDelay:2];
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}
@end