#import "rEinstellungen.h"

@implementation rEinstellungen
- (id) init
{
	self=[super  initWithWindowNibName:@"RPEinstellungen"];
	return self;
}


- (void)awakeFromNib
{
   //NSLog(@"Einstellungenfenster  awake");
   NSFont* Titelfont;
   Titelfont=[NSFont fontWithName:@"Helvetica" size: 24];
   NSColor * TitelFarbe=[NSColor grayColor];
   [TitelString setFont: Titelfont];
   [TitelString setTextColor: TitelFarbe];
   [self.AnzeigeFeld setStringValue:@"start"];

	NSFont* Tablefont;
	Tablefont=[NSFont fontWithName:@"Helvetica" size: 14];
   
//[TimeoutCombo synchronizeTitleAndSelectedItem];
   [self.window display];
}


- (IBAction)mitBewertung:(id)sender
{
	//NSLog(@"mitBewertung");
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	NSNumber* CheckboxStatus=[NSNumber numberWithInt:[sender state]];
	NSMutableDictionary* BewertungDic=[NSMutableDictionary dictionaryWithObject:CheckboxStatus forKey:@"Status"];
	[nc postNotificationName:@"mitBewertung" object:self userInfo:BewertungDic];
}

- (IBAction)mitNote:(id)sender
{
	//NSLog(@"mitNote");
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	NSNumber* CheckboxStatus=[NSNumber numberWithInt:[sender state]];
	NSMutableDictionary* NotenDic=[NSMutableDictionary dictionaryWithObject:CheckboxStatus forKey:@"Status"];
	[nc postNotificationName:@"mitNote" object:self userInfo:NotenDic];
	
}


- (void)setBewertung:(BOOL)mitBewertung
{
	//int s=[BewertungZeigen state];
	[BewertungZeigen setState:mitBewertung];
}

- (void)setTimeoutDelay:(NSTimeInterval)derDelay
{
NSLog(@"setTimeoutDelay: derDelay: %f",derDelay);
	[TimeoutCombo setIntValue:derDelay];
}



- (void)setNote:(BOOL)mitNote
{
	//int s=[BewertungZeigen state];
	[NoteZeigen setState:mitNote];
}

- (IBAction)reportClose:(id)sender
{
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	NSNumber* mitPWNumber=[NSNumber numberWithInt:[mitUserPasswort state]];
	NSMutableDictionary* StatusDic=[NSMutableDictionary dictionaryWithObject:mitPWNumber forKey:@"mituserpasswort"];
	NSNumber* NoteStatus=[NSNumber numberWithInt:[NoteZeigen state]];
	[StatusDic setObject:NoteStatus forKey:@"notenstatus"];
	NSNumber* BewertungStatus=[NSNumber numberWithInt:[BewertungZeigen state]];
	[StatusDic setObject:BewertungStatus forKey:@"bewertungstatus"];
	int TimeoutDelay=[TimeoutCombo  intValue];
	//NSLog(@"TimeoutDelay: %d  ",TimeoutDelay  );
	[StatusDic setObject:[NSNumber numberWithInt:TimeoutDelay] forKey:@"timeoutdelay"];
	NSLog(@"reportClose: StatusDic: %@",[StatusDic description]);
	[nc postNotificationName:@"StartStatus" object:self userInfo:StatusDic];
   [NSApp stopModalWithCode:1];
	[self.window orderOut:NULL];

}
- (IBAction)reportCancel:(id)sender
{
    [NSApp stopModalWithCode:0];
	[self.window orderOut:NULL];
}
- (void)setMitPasswort:(BOOL)mitPW
{
   [mitUserPasswort setState:mitPW];
}

- (void)setzeAnzeigeFeld:(NSString *)anzeige
{
   //NSLog(@"Einstellungenfenster setzeAnzeigeFeld anzeige: %@ startfeld: %@",anzeige);
   self.AnzeigeFeld.stringValue = anzeige;
   //[self.AnzeigeFeld setStringValue:@"soso"];
}

- (IBAction)reportHelp:(id)sender
{
   NSString* name =[@"info"stringByAppendingString:[sender alternateTitle]];
   
   if (![[name pathExtension]length])
   {
      name = [name stringByAppendingPathExtension:@"txt"];
   }
   //NSLog(@"ident: %@",[sender alternateTitle]);
   NSString* helpPfad =[[[[NSBundle mainBundle] bundlePath]stringByAppendingPathComponent:@"Contents/Resources"]stringByAppendingPathComponent:name];
   //NSLog(@"Utils helpPfad: %@",helpPfad);
   if ([[NSFileManager defaultManager]fileExistsAtPath:helpPfad] )
   {
      NSString* helpString = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:helpPfad] encoding:NSUTF8StringEncoding error:nil];
      //NSLog(@"helpString: %@",helpString);
      if ([helpString length])
      {
         NSArray* helpArray;
         if ([helpString rangeOfString:@"\n"].location < NSNotFound)
         {
            helpArray= [helpString componentsSeparatedByString:@"\n"];
         }
         
         else if ([helpString rangeOfString:@"\r"].location < NSNotFound)
         {
            helpArray= [helpString componentsSeparatedByString:@"\r"];
         }
         else
         {
            return;
         }
         // //NSLog(@"helpArray: %@",helpArray);
         NSAlert *Warnung = [[NSAlert alloc] init];
         [Warnung setMessageText:[helpArray objectAtIndex:0]];
         NSRect cellFeld = NSMakeRect(0, 0, 400, 100);
         
         NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:
                                     cellFeld];
         [scrollView setHasVerticalScroller:YES];
         [scrollView setHasHorizontalScroller:NO];
         
         
         NSTextView* helpView = [[NSTextView alloc] initWithFrame:cellFeld];
         NSRange inforange =NSMakeRange(1, [helpArray count]-1);
         //NSLog(@"inforange loc: %ld len: %ld",inforange.location, inforange.length);
         NSString* infoString = [[helpArray subarrayWithRange:NSMakeRange(1, [helpArray count]-1)]componentsJoinedByString:@"\r"];
         //NSLog(@"infoString: %@",infoString); // korrectes encoding!!!
         
         [helpView insertText:[[helpArray subarrayWithRange:NSMakeRange(1, [helpArray count]-1)]componentsJoinedByString:@"\r"]];
         [helpView setEditable:NO];
         [scrollView setDocumentView:helpView];
         
         Warnung.accessoryView = scrollView;
         //Warnung.accessoryView = helpView;
         Warnung.alertStyle = NSInformationalAlertStyle;
         
         [Warnung addButtonWithTitle:@"OK"];
         
         [Warnung runModal];
         
         
      }
      
   }
}
@end
