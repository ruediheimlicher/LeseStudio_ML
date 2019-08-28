/* rEinstellungen */

#import <Cocoa/Cocoa.h>

@interface rEinstellungen : NSWindowController <NSTabViewDelegate, NSWindowDelegate, NSMenuDelegate>
{
    IBOutlet id BewertungZeigen;
    IBOutlet id NoteZeigen;
	IBOutlet id mitUserPasswort;
	IBOutlet id TimeoutCombo;
   IBOutlet id TitelString;

}

@property (nonatomic, strong) IBOutlet NSTextField*				AnzeigeFeld; 

- (IBAction)reportClose:(id)sender;
- (IBAction)reportHelp:(id)sender;
- (IBAction)reportCancel:(id)sender;
- (void)setMitPasswort:(BOOL)mitPW;

- (void)setBewertung:(BOOL)mitBewertung;
- (void)setNote:(BOOL)mitNote;
- (void)setTimeoutDelay:(NSTimeInterval)derDelay;
- (void)setzeAnzeigeFeld:(NSString *)anzeige;
@end
