//
//  rRecorder.h
//  Lesestudio_ML
//
//  Created by Ruedi Heimlicher on 09.10.2015.
//  Copyright © 2015 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "rRahmen.h"

@interface rRecorder : NSViewController
{
   IBOutlet rRahmen* titelrahmen;
}
@property IBOutlet NSButton*      Knopf;
@property IBOutlet  NSTextField*   Feld;


- (IBAction)setText:(id)sender;
@end
