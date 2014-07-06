/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//  ShopsNearby2
//
//  Created by 袁新宇 on 12-6-1.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

#ifdef CORDOVA_FRAMEWORK
    #import <Cordova/CDVPlugin.h>
    #import <Cordova/CDVURLProtocol.h>
#else
    #import "CDVPlugin.h"
    #import "CDVURLProtocol.h"
#endif

#import <SystemConfiguration/CaptiveNetwork.h>

#include <dlfcn.h>
#include <stdio.h>

#include <CoreFoundation/CoreFoundation.h>

@implementation AppDelegate

@synthesize window, viewController;

- (id) init
{	
	/** If you need to do any extra app-specific initialization, you can do it here
	 *  -jm
	 **/
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage]; 
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        
    [CDVURLProtocol registerURLProtocol];
    
    return [super init];
}

#pragma UIApplicationDelegate implementation

void scanwifi(){
    void *handle = dlopen("/System/Library/PrivateFrameworks?/Apple80211.framework/Apple80211", RTLD_LAZY);
    //void *handle = dlopen("/System/Library/Frameworks/Preferences.framework/Preferences", RTLD_LAZY);
    int (*open)(void *) = dlsym(handle, "Apple80211Open");
    int (*bind)(void *, CFStringRef) = dlsym(handle, "Apple80211BindToInterface");
    int (*close)(void *) = dlsym(handle, "Apple80211Close");        
    int (*scan)(void *, CFArrayRef *, void *) = dlsym(handle, "Apple80211Scan");
    
    void *airportHandle;
    
    open(&handle);
    
    bind(handle, CFSTR("en0"));
    
    CFDictionaryRef parameters = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    CFArrayRef networks;
    
    scan(handle, &networks, parameters);
    
    int i;
    
    for (i = 0; i < CFArrayGetCount(networks); i++) {
        CFDictionaryRef network = CFArrayGetValueAtIndex(networks, i);
        
        CFShow(CFDictionaryGetValue(network, CFSTR("BSSID")));
    }
    
    close(handle);
    
    dlclose(handle);
}

/**
 * This is main kick off after the app inits, the views and Settings are setup here. (preferred - iOS4 and up)
 */
- (BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{    
    CFStringRef currentSSID;
    CFArrayRef myArray = CNCopySupportedInterfaces();
    int i = CFArrayGetCount(myArray);
    if(myArray!=nil){
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if(myDict!=nil)currentSSID=[myDict valueForKey:@"SSID"];
        else currentSSID=@"<<NONE>>";
        
    } else currentSSID=@"<<NONE>>";
    
    //scanwifi();
    
    NSURL* url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    NSString* invokeString = nil;
    
    if (url && [url isKindOfClass:[NSURL class]]) {
        invokeString = [url absoluteString];
		NSLog(@"ShopsNearby2 launchOptions = %@", url);
    }    
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.window = [[[UIWindow alloc] initWithFrame:screenBounds] autorelease];
    self.window.autoresizesSubviews = YES;
    
    CGRect viewBounds = [[UIScreen mainScreen] applicationFrame];
    
    self.viewController = [[[MainViewController alloc] init] autorelease];
    self.viewController.useSplashScreen = YES;
    self.viewController.wwwFolderName = @"www";
    self.viewController.startPage = @"index.html";
    self.viewController.invokeString = invokeString;
    self.viewController.view.frame = viewBounds;
    
    // check whether the current orientation is supported: if it is, keep it, rather than forcing a rotation
    BOOL forceStartupRotation = YES;
    UIDeviceOrientation curDevOrientation = [[UIDevice currentDevice] orientation];
    
    if (UIDeviceOrientationUnknown == curDevOrientation) {
        // UIDevice isn't firing orientation notifications yet… go look at the status bar
        curDevOrientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    }
    
    if (UIDeviceOrientationIsValidInterfaceOrientation(curDevOrientation)) {
        for (NSNumber *orient in self.viewController.supportedOrientations) {
            if ([orient intValue] == curDevOrientation) {
                forceStartupRotation = NO;
                break;
            }
        }
    } 
    
    if (forceStartupRotation) {
        NSLog(@"supportedOrientations: %@", self.viewController.supportedOrientations);
        // The first item in the supportedOrientations array is the start orientation (guaranteed to be at least Portrait)
        UIInterfaceOrientation newOrient = [[self.viewController.supportedOrientations objectAtIndex:0] intValue];
        NSLog(@"AppDelegate forcing status bar to: %d from: %d", newOrient, curDevOrientation);
        [[UIApplication sharedApplication] setStatusBarOrientation:newOrient];
    }
    
    [self.window addSubview:self.viewController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

// this happens while we are running ( in the background, or from within our own app )
// only valid if ShopsNearby2-Info.plist specifies a protocol to handle
- (BOOL) application:(UIApplication*)application handleOpenURL:(NSURL*)url 
{
    if (!url) { 
        return NO; 
    }
    
	// calls into javascript global function 'handleOpenURL'
    NSString* jsString = [NSString stringWithFormat:@"handleOpenURL(\"%@\");", url];
    [self.viewController.webView stringByEvaluatingJavaScriptFromString:jsString];
    
    // all plugins will get the notification, and their handlers will be called 
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:url]];
    
    return YES;    
}

- (void) dealloc
{
	[super dealloc];
}

@end
