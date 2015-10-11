/* rMarkierung */

#import <Cocoa/Cocoa.h>

@interface rMarkierung : NSWindowController
{
    IBOutlet id MarkierungVariante;
    IBOutlet id NamenString;
	IBOutlet NSTextField* TitelString;
	IBOutlet id TextString;
}
- (void)setNamenString:(NSString*)derName;
- (IBAction)reportMarkierungVariante:(id)sender;
- (IBAction)reportAbbrechen:(id)sender;
- (IBAction)reportHelp:(id)sender;
@end
