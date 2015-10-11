//
//  rRahmen.m
//  Lesestudio_ML
//
//  Created by Ruedi Heimlicher on 11.10.2015.
//  Copyright © 2015 Ruedi Heimlicher. All rights reserved.
//

#import "rRahmen.h"

@implementation rRahmen

- (id)initWithFrame:(NSRect)frame
{
   self = [super initWithFrame:frame];
   if (self)
   {
      // setup the initial properties of the
      // draggable item
      [self setItemPropertiesToDefault:self];
   }
   return self;
}
- (NSPoint)location {
   return location;
}

- (void)setItemPropertiesToDefault:sender
{
   [self setLocation:NSMakePoint(0.0,0.0)];
   [self setItemColor:[NSColor greenColor]];
   [self setBackgroundColor:[NSColor grayColor]];
}
- (void)setItemColor:(NSColor *)aColor
{
   if (![itemColor isEqual:aColor]) {
      itemColor = aColor;
      
      // if the colors are not equal, mark the
      // draggable rect as needing display
      [self setNeedsDisplay:YES];
   }
}
- (NSColor *)itemColor
{
   return itemColor ;
}

- (void)setBackgroundColor:(NSColor *)aColor
{
  // if (![backgroundColor isEqual:aColor])
   {
      backgroundColor = aColor;
      
      // if the colors are not equal, mark the
      // draggable rect as needing display
      [self setNeedsDisplay:YES];
   }
}


- (NSColor *)backgroundColor
{
   return backgroundColor;
}

- (void)setLocation:(NSPoint)point
{
   // test to see if the point actually changed
   if (!NSEqualPoints(point,location)) {
      // tell the display to redraw the old rect
      [self setNeedsDisplay:YES];
      
      // reassign the rect
      location=point;
      
      // display the new rect
      //[self setNeedsDisplayInRect:[self calculatedItemBounds]];
      [self setNeedsDisplay:YES];
      
      // invalidate the cursor rects
      [[self window] invalidateCursorRectsForView:self];
   }
}

- (NSRect)calculatedItemBounds
{
   NSRect calculatedRect;
   
   // calculate the bounds of the draggable item
   // relative to the location
   calculatedRect.origin=location;
   
   // the example assumes that the width and height
   // are fixed values
   calculatedRect.size.width=60.0;
   calculatedRect.size.height=20.0;
   
   return calculatedRect;
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
   // erase the background by drawing white
   [[NSColor whiteColor] set];
   [NSBezierPath fillRect:dirtyRect];
   
   // set the current color for the draggable item
   [[self itemColor] set];
   
   // draw the draggable item
   //[NSBezierPath fillRect:[self calculatedItemBounds]];
   [NSBezierPath strokeRect:dirtyRect];
}

@end
