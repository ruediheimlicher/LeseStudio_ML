//
//  NSString+StringExtensions.m
//  Lesestudio_15
//
//  Created by Ruedi Heimlicher on 04.10.2015.
//  Copyright © 2015 Ruedi Heimlicher. All rights reserved.
//

#import "NSString+StringExtensions.h"

@implementation NSString (StringExtensions)

- (NSString*)pfadOhneExtension
{
   NSSet* extensionSet = [NSSet setWithObjects:@"m4a",@"mp3",@"txt",@"doc",nil];
   if ([extensionSet containsObject:[self pathExtension]]) // korrekte extension. Punkt im titel nicht als Extension behandlen
   {
      return [self stringByDeletingPathExtension];
   }
   return self;
}

- (NSString*)extensionVonPfad
{
   NSSet* extensionSet = [NSSet setWithObjects:@"m4a",@"mp3",@"txt",@"doc",nil];
   
   // eventuell Punkte im String, Extension nicht richtig erkannt
   NSString* extension;
   
   //NSRange firstPunkt = [self rangeOfString:@"."]; // erster Punkt im String

   NSRange lastPunkt = [self rangeOfString:@"." options:NSBackwardsSearch];
  // //NSLog(@"firstPunkt: %ld lastPunkt: %ld",firstPunkt.location, lastPunkt.location);
   
   if(lastPunkt.location != NSNotFound) // Punkt vorhanden
   {
       extension = [self substringFromIndex:lastPunkt.location+1];
        if ([extensionSet containsObject:extension]) // korrekte Extension
        {
           return extension;
        }
   }
   // keine Extension
   return [NSString string];
}

@end
