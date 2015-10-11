/* rProjektExport */

#import <Cocoa/Cocoa.h>

@interface rProjektExport : NSWindowController
{
    IBOutlet NSMatrix* ExportVariante;
    IBOutlet id NamenString;
	IBOutlet NSTextField* TitelString;
	IBOutlet id TextString;
   IBOutlet NSPopUpButton* anzPop;
}
- (void)setNamenString:(NSString*)derName;
- (IBAction)reportExportVariante:(id)sender;
- (IBAction)reportAbbrechen:(id)sender;
- (IBAction)reportHelp:(id)sender;
@end
