//
//  AppDelegate.m
//  Lesestudio_ML
//
//  Created by Ruedi Heimlicher on 09.10.2015.
//  Copyright © 2015 Ruedi Heimlicher. All rights reserved.
//

#import "AppDelegate.h"
#import "rRecorder.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
   // Insert code here to initialize your application
   NSLog(@"applicationDidFinishLaunching");
}


- (BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) theApplication
{
   NSLog(@"applicationShouldTerminateAfterLastWindowClosed");
   NSMutableDictionary* BeendenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [BeendenDic setObject:[NSNumber numberWithInt:1] forKey:@"beenden"];
   NSNotificationCenter* beendennc=[NSNotificationCenter defaultCenter];
   [beendennc postNotificationName:@"externbeenden" object:self userInfo:BeendenDic];
   
   return NO;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
   NSLog(@"applicationShouldTerminate");
   return NSTerminateNow;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
   // Insert code here to tear down your application
   NSLog(@"applicationWillTerminate note: %@",aNotification);
}

@end
