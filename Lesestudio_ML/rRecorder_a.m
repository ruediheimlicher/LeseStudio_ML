//
//  rRecorder.m
//  Lesestudio_ML
//
//  Created by Ruedi Heimlicher on 09.10.2015.
//  Copyright © 2015 Ruedi Heimlicher. All rights reserved.
//

#import "rRecorder.h"

@interface rRecorder ()

@end

@implementation rRecorder
@synthesize Knopf;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
   titelrahmen = [[rRahmen alloc]init];
   [titelrahmen setBackgroundColor:[NSColor redColor]];
   [titelrahmen setItemPropertiesToDefault:nil];
   [titelrahmen setItemColor:[NSColor greenColor]];
   
}

- (void)awakeFromNib
{
   NSLog(@"awakeFromNib");
   [titelrahmen setItemColor:[NSColor greenColor]];

  // [titelrahmen setNeedsDisplay:YES];
}



- (IBAction)setText:(id)sender
{
   NSLog(@"setText");
   [titelrahmen setItemColor:[NSColor greenColor]];

   [titelrahmen setBackgroundColor:[NSColor redColor]];
   [titelrahmen setNeedsDisplay:YES];
   [self.Feld setIntValue:1];
}
@end
