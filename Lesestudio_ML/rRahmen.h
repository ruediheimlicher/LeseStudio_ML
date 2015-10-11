//
//  rRahmen.h
//  Lesestudio_ML
//
//  Created by Ruedi Heimlicher on 11.10.2015.
//  Copyright © 2015 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface rRahmen : NSView
{
NSPoint location;
NSColor *itemColor;
NSColor *backgroundColor;


// private variables that track state
BOOL dragging;
NSPoint lastDragLocation;
}

- (void)setLocation:(NSPoint)point;
- (NSPoint)location;
- (NSRect)calculatedItemBounds;
- (void)setBackgroundColor:(NSColor *)aColor;
- (void)setItemColor:(NSColor *)aColor;
- (void)setItemPropertiesToDefault:sender;
@end
