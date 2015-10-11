//
//  rExportKontroller.m
//  RecPlayC
//
//  Created by sysadmin on 22.05.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "rAdminPlayer.h"

//Soundfile-Types
	//kQTFileTypeAIFF             = FOUR_CHAR_CODE('AIFF'),
	//kQTFileTypeAIFC             = FOUR_CHAR_CODE('AIFC'),
	//kQTFileTypeWave             = FOUR_CHAR_CODE('WAVE'),
	//kQTFileTypeMuLaw            = FOUR_CHAR_CODE('ULAW'),
	//kQTFileTypeAVI              = FOUR_CHAR_CODE('VfW '),
	//kQTFileTypeAudioCDTrack     = FOUR_CHAR_CODE('trak'),
	
NSString* AIFF=@"AIFF";
NSString* AIFC=@"AIFC";
NSString* WAVE=@"WAVE";
NSString* AVI=@"AVI";
NSString* uLAW=@"uLAW";
NSString* AudioCDTrack=@"AudioCDTrack";
NSString* MP3=@"mp3";
NSString* MOV=@"mov";



extern NSString* alle;
extern NSString* name;
extern NSString* titel;
extern NSString* anzahl;
extern NSString* auswahl;
extern NSString* leser;
extern NSString* anzleser;

enum
{
	NamenViewTag=1111,
	TitelViewTag=2222
};

//extern NSString*	RPExportdatenKey;
NSString*	RPExportformatKey;

// current export settings
//static QTAtomContainer gExportSettings = 0;


@implementation rAdminPlayer(rExportKontroller)


 - (long)ExportPrefsLesen
 {
 	RPExportdaten=[[NSUserDefaults standardUserDefaults]objectForKey:@"RPExportdaten"];
	ExportFormatString=[[NSUserDefaults standardUserDefaults]objectForKey:@"RPExportformatKey"];
 return[RPExportdaten length];
 }
 
 - (long)ExportPrefsSchreiben
 {
 	short l=[RPExportdaten length];
	if(l>0)
	{
	[[NSUserDefaults standardUserDefaults]setObject:RPExportdaten forKey:@"RPExportdaten"];
	}
	[[NSUserDefaults standardUserDefaults]setObject:ExportFormatString forKey:RPExportformatKey];
	[[NSUserDefaults standardUserDefaults]synchronize];
	//NSLog(@"ExportFormatString; %@",ExportFormatString);

 return 0;
 }



- (void)ExportNotificationAktion:(NSNotification*)note
{
	//Aufgerufen nach Ã„nderungen in den Pops des Cleanfensters
	NSString* export=@"export";
	NSString* selektiertenamenzeile=@"selektiertenamenzeile";
	
	//NSLog(@"ExportNotificationAktion note: %@",[note object]);
	NSDictionary* OptionDic=[note userInfo];
	
	//Namen
	NSMutableArray* exportNamenArray=[OptionDic objectForKey:@"exportnamen"];
	if (exportNamenArray)
	{
		//NSLog(@"ExportNotificationAktion*** exportNamenArray: %@",[exportNamenArray description]);
	}

	NSMutableArray* exportTitelArray=[OptionDic objectForKey:@"exporttitel"];
	if (exportTitelArray)
	{
		//NSLog(@"ExportNotificationAktion*** exportTitelArray: %@",[exportTitelArray description]);
	}
	
	NSNumber*  exportVariantenNumber=[OptionDic objectForKey:@"exportvariante"];//markierteAufnahmen oder nach Anzahl
	if (exportVariantenNumber)
	{
		//NSLog(@"ExportNotificationAktion exportVariante: %d",[exportVariantenNumber intValue]);
	}
	
	NSNumber*  exportAnzahlNumber=[OptionDic objectForKey:@"exportanzahl"];//Anzahl zu exportierende A.
	if (exportAnzahlNumber)
	{
		//NSLog(@"ExportNotificationAktion*** exportAnzahl: %d",[exportAnzahlNumber intValue]);
	}
	
	NSString*  exportFormat=[OptionDic objectForKey:@"exportformat"];//Format aus Pop
		if (exportFormat)
		{
			//NSLog(@"ExportNotificationAktion*** exportFormat: %@",[exportFormat description]);
		}
		
	//NSLog(@"ExportNotificationAktion OptionDic: %@",[OptionDic description]);
	
	[self Export:OptionDic];
	NSNumber* AnzahlNamenNummer=[OptionDic objectForKey:@"AnzahlNamen"];
	
}

- (void)ExportFormatDialogAktion:(NSNotification*)note 
{
	//Aufgerufen nach Wahl von Optionen 
	//NSString* alle=@"alle";

	//NSLog(@"ExportFormatDialogAktion note: %@",[note object]);
	NSDictionary* OptionDic=[note userInfo];
	
	//Pop AnzahlNamen
	NSNumber* DialogRequest=[OptionDic objectForKey:@"dialog"];
	}
	
- (OSErr)getExportEinstellungenvonAufnahme:(NSString*)derAufnahmePfad 
{
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	OSErr err=0;
	//NSLog(@"getExportEinstellungenvonAufnahme");

	if ([Filemanager fileExistsAtPath:derAufnahmePfad])
	{
		NSError* loadErr;
      /*
		NSURL *movieURL = [NSURL fileURLWithPath:derAufnahmePfad];
		QTMovie* tempMovie= [[QTMovie alloc]initWithURL:movieURL error:&loadErr];
		if (loadErr)
		{
			NSAlert *theAlert = [NSAlert alertWithError:loadErr];
			[theAlert runModal]; // Ignore return value.
		}
		if (!tempMovie)
			//NSLog(@"Kein Movie da");
		// retrieve the QuickTime-style movie (type "Movie" from QuickTime/Movies.h) 
		
		Movie tempExportMovie =[tempMovie quickTimeMovie];
		
		if (!tempMovie)
		{
			//NSLog(@"Kein Movie da");
			NSString* FehlerString=[NSString stringWithString:NSLocalizedString(@"No movie present.",@"Es ist kein Movie da.")];
			NSAlert *Warnung = [[NSAlert alloc] init];
			[Warnung addButtonWithTitle:@"OK"];
			[Warnung setMessageText:NSLocalizedString(@"Error in export settings",@"Fehler beim Setzen der ExportEinstellungen:")];
			[Warnung setInformativeText:FehlerString];
			[Warnung setAlertStyle:NSWarningAlertStyle];
			[Warnung beginSheetModalForWindow:[self window] 
									  modalDelegate:nil
									 didEndSelector:nil
										 contextInfo:nil];
			return -1;
		}
       */
		/* retrieve the QuickTime-style movie (type "Movie" from QuickTime/Movies.h) */
		
	//	Movie tempExportMovie =(Movie) [tempMovie QTMovie];
		
      /*
		if ([tempMovie rate])
		{
			[tempMovie stop];
		}
		*/
      /*
		Component c = 0;
		ComponentInstance derExporter = 0;
		
      
		OSType ExportFormatType=kQTFileTypeAIFF;
		
		
		if ([ExportFormatString isEqualToString:AIFF])
		{
			ExportFormatType=kQTFileTypeAIFF;
		}
		else if ([ExportFormatString isEqualToString:AIFC])
		{
			ExportFormatType=kQTFileTypeAIFC;
		}
		else if ([ExportFormatString isEqualToString:WAVE])
		{
			ExportFormatType=kQTFileTypeWave;
		}
		else if ([ExportFormatString isEqualToString:AVI])
		{
			ExportFormatType=kQTFileTypeAVI;
		}
		else if ([ExportFormatString isEqualToString:uLAW])
		{
			ExportFormatType=kQTFileTypeMuLaw;
		}
		else if ([ExportFormatString isEqualToString:AudioCDTrack])
		{
			ExportFormatType=kQTFileTypeAudioCDTrack;
		}
		
		
		else if ([ExportFormatString isEqualToString:MOV])
		{
			ExportFormatType=kQTFileTypeMovie;
		}
		
		
		
		ComponentDescription cd = { MovieExportType,
			ExportFormatType,
			StandardCompressionSubTypeSound,
			hasMovieExportUserInterface,
			hasMovieExportUserInterface };
		*/
		/*
		 ComponentDescription cd;
		 cd.componentType=MovieExportType;
		 cd.componentSubType=ExportFormatType;
		 cd.componentManufacturer='appl';
		 */
		Boolean ignore;
		
      /*
		c = FindNextComponent(0, &cd);
		
		if (!c)
		{
			//NSLog(@"getExportEinstellungenVonAufnahme: Keine NextComponent");
		}
		//err = OpenAComponent(c, &theExporter);
		derExporter = OpenComponent(c);
		err=GetMoviesError();
		//NSLog(@"OpenAComponent err: %d",GetMoviesError());
		//NSAssert(err,@"OpenAComponent misslungen: ");
		if (err||derExporter==0)
		{
			//NSLog(@"OpenAComponent misslungen: %d",err);
			
			if (derExporter)
			{
				CloseComponent(derExporter);
			}
			NSString* FehlerString=[NSString stringWithString:NSLocalizedString(@"No component could be opened.",@"Es konnte keine Komponente gešffnet werden.")];
			NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
			[Warnung addButtonWithTitle:@"OK"];
			//[Warnung addButtonWithTitle:@"Cancel"];
			[Warnung setMessageText:NSLocalizedString(@"Error While Opening Export Components",@"Fehler beim …ffnen der Exportkomponenten.")];
			[Warnung setInformativeText:FehlerString];
			[Warnung setAlertStyle:NSWarningAlertStyle];
			[Warnung beginSheetModalForWindow:[self window] 
									  modalDelegate:nil
									 didEndSelector:nil
										 contextInfo:nil];
			return err;
			
		}
		
		Track inTrack=NULL;
		err = MovieExportDoUserDialog(derExporter, tempExportMovie,
												inTrack, 0,
												GetTrackDuration(inTrack), &ignore);
		
		//NSAssert(err,@"MovieExportDoUserDialog misslungen");					  
		if (err)
		{	
			//NSLog(@"MovieExportDoUserDialog misslungen: %d  ignore: %d",err,ignore);
			if (derExporter)
			{
				CloseComponent(derExporter);
			}
			
			NSString* FehlerString=[NSString stringWithString:NSLocalizedString(@"The export settings dialog could not be opened",@"Das Einstellungenfenster konnten nicht gešffnet werden.")];
			NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
			[Warnung addButtonWithTitle:@"OK"];
			//[Warnung addButtonWithTitle:@"Cancel"];
			[Warnung setMessageText:NSLocalizedString(@"Error With Export Settings",@"Fehler beim Setzen der Exporteinstellungen.")];
			[Warnung setInformativeText:FehlerString];
			[Warnung setAlertStyle:NSWarningAlertStyle];
			[Warnung beginSheetModalForWindow:[self window] 
									  modalDelegate:nil
									 didEndSelector:nil
										 contextInfo:nil];
			return err;
		}
		//NSLog(@"getExporteinstellungen vor: RPExportdaten: %\n%@",[RPExportdaten description]);
		
		//QTAtomContainer tempExportSettings;
		err=QTNewAtomContainer(&gExportSettings);
		//QTAtomContainer *ExportSettings;	
		if (err)
		{	
			//NSLog(@"QTNewAtomContainer misslungen: %d",err);
		}			
		
		err = MovieExportGetSettingsAsAtomContainer(derExporter,
																  &gExportSettings);
		//NSAssert(err,@"MovieExportGetSettingsAsAtomContainer misslungen");	
		if (err)
		{	
			//NSLog(@"MovieExportGetSettingsAsAtomContainer misslungen: %d",err);
			if (derExporter)
			{
				CloseComponent(derExporter);
			}
			NSString* s=NSLocalizedString(@"The Settings couldn't be read.\nError: %d",@"Die Einstellungen konnten nicht gelesen werden.\nFehler: %d:");
			NSString* FehlerString=[NSString stringWithFormat:s,err];
			NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
			[Warnung addButtonWithTitle:@"OK"];
			//[Warnung addButtonWithTitle:@"Cancel"];
			[Warnung setMessageText:@"Fehler beim Lesen der Exporteinstellungen:"];
			[Warnung setInformativeText:FehlerString];
			[Warnung setAlertStyle:NSWarningAlertStyle];
			[Warnung beginSheetModalForWindow:[self window] 
									  modalDelegate:nil
									 didEndSelector:nil
										 contextInfo:nil];
			return err;
			
		}//err
		
		//UserData Exportdaten;
		HLock((Handle)gExportSettings);
		long Exportdatenlaenge=GetHandleSize(gExportSettings);
		RPExportdaten=[NSData dataWithBytes:(UInt8*)*gExportSettings length: Exportdatenlaenge];
		//NSLog(@"getExporteinstellungen nach: RPExportdaten: %\n%@",[RPExportdaten description]);
		HUnlock((Handle)gExportSettings);
		//DisposeHandle(tempExportSettings);
		//QTDisposeAtomContainer(gExportSettings);
		short l=[RPExportdaten length];
		if(l>0)
		{
			[[NSUserDefaults standardUserDefaults]setObject:RPExportdaten forKey: @"RPExportdaten"];
		}
		[[NSUserDefaults standardUserDefaults]setObject:ExportFormatString forKey:RPExportformatKey];
		
		[[NSUserDefaults standardUserDefaults]synchronize];
		if (derExporter)
		{
			CloseComponent(derExporter);
			
		}
		*/
	}		
	
	return err;
}

- (OSErr)getExportEinstellungen
{
	//NSFileManager *Filemanager=[NSFileManager defaultManager];
	OSErr err=0;
	//NSLog(@"getExportEinstellungen");

	return err;
}


- (IBAction)AufnahmeExportieren:(id)sender
{

	OSErr erfolg=0;
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	
   NSString* ExportAufnahmeName=[AdminPlayPfad lastPathComponent];
   //NSLog(@"AdminPlayPfad : %@ ExportAufnahmeName: %@",AdminPlayPfad,ExportAufnahmeName);
   
   if ([Filemanager fileExistsAtPath:AdminPlayPfad])
      {
         NSSavePanel * AdminExportDialog=[NSSavePanel savePanel];
         AdminExportDialog.allowedFileTypes = [NSArray arrayWithObject:@"m4a"];
         AdminExportDialog.prompt = @"Aufnahme exportieren";
         [AdminExportDialog setNameFieldStringValue:[AdminPlayPfad lastPathComponent]];
         [AdminExportDialog setDirectoryURL:[NSURL fileURLWithPath:[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]]];
         [AdminExportDialog setCanCreateDirectories:YES];
         AdminExportDialog.nameFieldLabel = @"Aufnahme sichern als:";
         AdminExportDialog.title = @"Aufnahme exportieren";

         [AdminExportDialog setMessage:@"Wo soll diese Aufnahme gespeichert werden?"];
         [AdminExportDialog setCanSelectHiddenExtension:NO];
         
         NSString* tempExportPfad;
         long AdminExportHit=0;
         {
            AdminExportHit=[AdminExportDialog runModal];
         }
         if (AdminExportHit==NSModalResponseOK)
         {
            tempExportPfad=[[AdminExportDialog URL] path]; //"home"
            //NSLog(@"tempExportPfad: %@",tempExportPfad);
            
            if ([Filemanager fileExistsAtPath:tempExportPfad])
            {
               erfolg=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:tempExportPfad] error:nil];
               //NSLog(@"Export: removeFileAtPath: erfolg: %d",erfolg);
               
            }
            int exporterfolg =[Filemanager copyItemAtPath:AdminPlayPfad toPath:tempExportPfad error:nil];
            
         }//NSOKButton
         
      }//File exists
		
		Textchanged=NO;
}



- (void) AufnahmenArrayExportieren:(NSArray*)derAufnahmenArray 
					 mitUserDialog:(BOOL)userDialogOK
{
	OSErr err=0;
	if ([derAufnahmenArray count]==0)
	return;
	
	RPExportdaten=[[[NSUserDefaults standardUserDefaults]dataForKey:@"RPExportdaten"]mutableCopy];

	ExportOrdnerPfad=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	//NSLog(@"AufnahmenArrayExportieren\n\n");
	//NSLog(@"AufnahmenArrayExportieren:Nach Dialog: Exportdaten: %@",[RPExportdaten length]);
	
	// 8.12.08: HomeDirectory wieder eingestellt
	//ExportOrdnerPfad=[AdminLeseboxPfad stringByDeletingLastPathComponent];//Documents
	
	NSString* s=@"LesestudioExport";
	ExportOrdnerPfad=[ExportOrdnerPfad stringByAppendingPathComponent:s];//Default, wenn keine User-Eingabe
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	BOOL istOrdner=NO;
//	UserExportSpec.parID=0;
	UserExportParID=0;
	if ([Filemanager fileExistsAtPath:ExportOrdnerPfad isDirectory:&istOrdner]&& istOrdner)
	  {
	
		//NSLog(@"RPExport da");
	  }
	else
	  {
		//NSLog(@"RPExport nicht da");
		[Filemanager createDirectoryAtPath:ExportOrdnerPfad  withIntermediateDirectories:NO attributes:NULL error:NULL];
	  }

	NSEnumerator* ExportEnum=[derAufnahmenArray objectEnumerator];
	id einAufnahmePfad;
	int index=0;
	while (einAufnahmePfad=[ExportEnum nextObject])
	{
		//NSLog(@"AufnahmenArrayExportieren: einAufnahmePfad: %@",einAufnahmePfad);
		if (index==0)//Bei erster Aufnahme nach Speicherort fragen
		{
			NSAlert *Warnung = [[NSAlert alloc] init];
			[Warnung addButtonWithTitle:@"OK"];
			[Warnung setMessageText:@"Mehrere Aufnahmen exportieren"];
			NSString* i1= @"Es kann nur der Speicherort gewaehlt werden.";
			NSString* i2=@"Aenderungen im Namen werden ignoriert.";
			NSString* i3=@"Einzelne Aufnahmen in Admin";
			NSString* I0=[NSString stringWithFormat:@"%@\n%@\n%@",i1,i2,i3];
			[Warnung setInformativeText:I0];
			[Warnung setAlertStyle:NSWarningAlertStyle];
			
			//	int Antwort=[Warnung runModal];
			
			NSString* ersteAufnahme=[[derAufnahmenArray objectAtIndex:0]lastPathComponent];
			
			
			NSSavePanel * ExportPanel = [NSSavePanel savePanel];
			[ExportPanel setAllowedFileTypes:[NSArray arrayWithObject:@"aif"]];
			//	[ExportPanel setRequiredFileType:@"wav"];
			[ExportPanel setCanCreateDirectories:YES];
			[ExportPanel setCanSelectHiddenExtension:YES];
         NSString* ExportPanelPfad = [NSHomeDirectory()stringByAppendingPathComponent:@"Desktop"];
         //NSLog(@"ExportPanelPfad: %@",ExportPanelPfad);
         [ExportPanel setDirectoryURL:[NSURL fileURLWithPath:ExportPanelPfad]];
         [ExportPanel setNameFieldStringValue:ersteAufnahme];
			NSString* labelString=@"Erste Aufnahme, die im Ordner gesichert wird:";
			[ExportPanel setNameFieldLabel:labelString];
			NSString* titleString=@"Aufnahmen exportieren";
			[ExportPanel setTitle:titleString];
			//ExportOrdnerPfad=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
			
			
			long modalAntwort=[ExportPanel runModal] ;//ForDirectory:ExportOrdnerPfad file:ersteAufnahme];
			//NSLog(@"ExportPanel: modalAntwort: %d",modalAntwort);
			//NSLog(@"AufnahmenArrayExportieren:Nach Dialog: Expotdaten: %@",[RPExportdaten length]);
			switch (modalAntwort)
			{
				case NSFileHandlingPanelOKButton:
				{
					//NSLog(@"ExportPanel: filename: %@ ExportOrdnerPfad: %@",[ExportPanel filename],ExportOrdnerPfad);
					NSString* 	tempExportFilePfad=[[[ExportPanel URL]path]copy];
					//NSLog(@"ExportPanel: filename: %@ tempExportFilePfad: %@",[ExportPanel filename],tempExportFilePfad);
					ExportOrdnerPfad=[tempExportFilePfad stringByDeletingLastPathComponent];
					//NSLog(@"ExportPanel: filename: %@ ExportOrdnerPfad: %@",[ExportPanel filename],ExportOrdnerPfad);
					
				}break;
				case NSFileHandlingPanelCancelButton:
				{
					//NSLog(@"ExportPanel: keine Eingabe ExportOrdnerPfad: %@",ExportOrdnerPfad);
					return;
				}break;
			}//switch
			
			//NSLog(@"AufnahmenArrayExportieren:Nach Dialog: Expotdaten: %d",[RPExportdaten length]);

			if ([RPExportdaten length]==0)//Noch keine Daten aus Defaults
			{
				//NSLog(@"keine RPExportdaten");
				err=[self getExportEinstellungenvonAufnahme:einAufnahmePfad];
				if (err)
				{
					//NSLog(@"getExportEinstellungenvonAufnahme: err: %d",err);
					return ;
				}
			}
			else
			{
				//NSLog(@"RPExportdaten DA");
				
			}
			//[self setThreadKontroller];
			
			//NSLog(@"AufnahmenarrayExport userDialogOK: %d",userDialogOK);
			[self AufnahmeExportierenMitPfad:einAufnahmePfad
							   mitUserDialog:YES
						   mitSettingsDialog:NO];
			
		}
		else
		{
			//
			//NSLog(@"AufnahmenarrayExport ohne userDialogOK");
			[self AufnahmeExportierenMitPfad:einAufnahmePfad
							   mitUserDialog:NO
						   mitSettingsDialog:NO];
			// 
		}
		index++;
	}//ExportEnum
//NSLog(@"AufnahmenArrayExportieren:2");		
		
}//AufnahmenArrayExportieren

- (void)Export:(NSDictionary*)derExportDic
{
   
	//NSLog(@"Export: derExportDic: %@",[derExportDic description]);
	NSFileManager *Filemanager=[NSFileManager defaultManager];

	int exportvariante=[[derExportDic objectForKey:@"exportvariante"]intValue];
	int exportformatvariante=[[derExportDic objectForKey:@"exportformatvariante"]intValue];
	NSString* exportformatString=[derExportDic objectForKey:@"exportformat"];
	int anzahlExportieren=[[derExportDic objectForKey:@"exportanzahl"]intValue];
	if (anzahlExportieren<0)
	{
		//NSLog(@"Anzahl nochmals Ÿberlegen");
		return;
	}
	
	ExportFormatString=(NSMutableString*)[NSString stringWithString: exportformatString];
	//NSLog(@"Export: ExportFormatString: %@",[ExportFormatString description]);
	
	//[self ExportPrefsSchreiben];
	
	//NSNumber* FileCreatorNumber=[NSNumber numberWithUnsignedLong:'RPDF'];//Creator der markierten Aufnahmen
																		 //NSLog(@"Clean:  Variante: %d  behalten: %d  anzahl: %d",var, behalten, anzahl);
	NSMutableArray* exportNamenArray=[derExportDic objectForKey:@"exportnamen"];
	
	//NSLog(@"Export	exportNamenArray: %@",[exportNamenArray description]);
	
	if (exportNamenArray)
	{
		//NSLog(@"ClearNotificationAktion*** exportNamenArray: %@",[exportNamenArray description]);
		
		NSMutableArray* exportTitelArray=[derExportDic objectForKey:@"exporttitel"];
		//NSLog(@"Export	exportTitelArray: %@",[exportTitelArray description]);

		if (exportTitelArray)
		{
			//NSLog(@"Export*** exportTitelArray: %@",[exportTitelArray description]);
			//Array fŸr zu lÃ¶schende Aufnahmen
			NSMutableArray* ExportTitelPfadArray=[[NSMutableArray alloc]initWithCapacity:0];
			
			NSFileManager* Filemanager=[NSFileManager defaultManager];
			NSEnumerator* NamenEnum=[exportNamenArray objectEnumerator];
			id einName;
			while(einName=[NamenEnum nextObject])
			{		
				
				NSString* tempNamenPfad=[AdminProjektPfad stringByAppendingPathComponent:einName];
				//NSLog(@"Export*** tempNamenPfad %@",tempNamenPfad);
				
				BOOL istOrdner;
				if (([Filemanager fileExistsAtPath:tempNamenPfad isDirectory:&istOrdner])&&istOrdner)
				{
					//NSLog(@"Export*** Ordner am Pfad %@ ist da",tempNamenPfad);
					NSMutableArray* tempAufnahmenArray=[[Filemanager contentsOfDirectoryAtPath:tempNamenPfad error:NULL]mutableCopy];
					int index=0;
					if ([tempAufnahmenArray count])
					{
						if ([[tempAufnahmenArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner entfernen
						{
							[tempAufnahmenArray removeObjectAtIndex:0];
						}
						if ([tempAufnahmenArray containsObject:@"Anmerkungen"]) // Ordner Kommentar entfernen
						{
							[tempAufnahmenArray removeObject:@"Anmerkungen"];
						}
						//NSLog(@"Clean*** tempAufnahmenArray: %@",[tempAufnahmenArray description]);
						//tempAufnahmenArray=(NSMutableArray*)[self sortNachNummer:tempAufnahmenArray];
						
						
						tempAufnahmenArray=[[self sortNachABC:tempAufnahmenArray]mutableCopy];
						//NSLog(@"Export*** tempAufnahmenArray nach sort: %@",[tempAufnahmenArray description]);
						
						switch (exportvariante) //
						{//
							case 0://nur markierte exportieren
							{
								NSEnumerator* AufnahmenEnum=[tempAufnahmenArray objectEnumerator];
								NSMutableArray* tempExportTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
								int anz=0;
								id eineAufnahme;
								while(eineAufnahme=[AufnahmenEnum nextObject])
								{
									if ([exportTitelArray containsObject:[self AufnahmeTitelVon:eineAufnahme]])
									{
										NSString* tempLeserAufnahmePfad=[tempNamenPfad stringByAppendingPathComponent:eineAufnahme];
										if ([Filemanager fileExistsAtPath:tempLeserAufnahmePfad])
										{
											BOOL AdminMark=[self AufnahmeIstMarkiertAnPfad:tempLeserAufnahmePfad];
											if (AdminMark)
											{
												//NSLog(@"Aufnahme %@ ist markiert",eineAufnahme);
												[ExportTitelPfadArray addObject:[tempNamenPfad stringByAppendingPathComponent:eineAufnahme]];

											}
											else
											{
												//NSLog(@"Aufnahme %@ ist nicht markiert",eineAufnahme);
												//[DeleteTitelArray addObject:eineAufnahme];
												
											}
											/*
											NSMutableDictionary* AufnahmeAttribute=[[[Filemanager fileAttributesAtPath:tempLeserAufnahmePfad traverseLink:YES]mutableCopy]autorelease];
											if (AufnahmeAttribute )
											{
												
												if([AufnahmeAttribute fileHFSCreatorCode]==[FileCreatorNumber intValue])
												{
													//NSLog(@"Aufnahme %@ ist markiert",eineAufnahme);
													[ExportTitelPfadArray addObject:[tempNamenPfad stringByAppendingPathComponent:eineAufnahme]];
												}
												else
												{
													//NSLog(@"Aufnahme %@ ist nicht markiert",eineAufnahme);
												}
											}//if (AufnahmeAttribute )
											*/
										}//if tempLeserAufnahmePfad
									}//if in exportTitelArray
								}//while AufnahmeEnum
							}break;
							
							case 1://Anzahl: anzahlExportieren exportierenn
							{
								NSArray* tempLeserTitelArray=[self TitelArrayVon:einName anProjektPfad:AdminProjektPfad];
								NSEnumerator* LeserTitelEnum=[tempLeserTitelArray objectEnumerator];
								id einLeserTitel;
								while(einLeserTitel=[LeserTitelEnum nextObject])
								{
									NSEnumerator* AufnahmenEnum=[tempAufnahmenArray objectEnumerator];
									NSMutableArray* tempExportTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
									int anz=0;
									id eineAufnahme;
									while(eineAufnahme=[AufnahmenEnum nextObject])
									{
										if ([exportTitelArray containsObject:[self AufnahmeTitelVon:eineAufnahme]])
										{
											
											NSString* tempTitel=[self AufnahmeTitelVon:eineAufnahme];
											if ([einLeserTitel isEqualToString:tempTitel])
											{
												NSString* tempLeserAufnahmePfad=[tempNamenPfad stringByAppendingPathComponent:eineAufnahme];
												if ([Filemanager fileExistsAtPath:tempLeserAufnahmePfad])
												{
													[tempExportTitelArray addObject:eineAufnahme ];
													
												}//if tempLeserAufnahmePfad
											}
										}//if in exportTitelArray
									}//while AufnahmenEnum
									
									//NSLog(@"einLeserTitel: %@ * tempExportTitelArray: %@",einLeserTitel,[tempExportTitelArray description]);
									if ([tempExportTitelArray count])
									{
										tempExportTitelArray=[[self sortNachNummer:tempExportTitelArray]mutableCopy];
										//NSLog(@"			*** *** tempExportTitelArray nach sort: %@",[tempExportTitelArray description]);
									}
									
									NSEnumerator* ExportEnum=[tempExportTitelArray objectEnumerator];
									id eineExportAufnahme;
									int i=0;
									while(eineExportAufnahme=[ExportEnum nextObject])
									{
										if (i<anzahlExportieren)//Anzahl zu exportierende Aufnahmen
										{
											//[ExportTitelPfadArray addObject:eineExportAufnahme];
											[ExportTitelPfadArray addObject:[tempNamenPfad stringByAppendingPathComponent:eineExportAufnahme]];
											
										}
										i++;
									}//while ExportEnum
									
									
									
								}//while LeserTitelEnum
								
								
							}break;//case 1
								
								
						}//switch beahlten
							
							
							
					}//if ([tempTitelArray count])
						
				}//if fileExists tempNamenPfad
					
			}//while NamenEnum
				
		//NSLog(@"Export Ergebnis*** ExportTitelPfadArray: %@",[ExportTitelPfadArray description]);
		if ([ExportTitelPfadArray count])
			{
			
			
			int status=0;
				switch (exportformatvariante)
				{
					case 0://letztes Format
					{
						//NSLog(@"Export mit bisherigem Format");
						
						[self AufnahmenArrayExportieren: ExportTitelPfadArray mitUserDialog:NO];
						
						
					}break;
						
					case 1://anderes Format
					{
						//NSLog(@"Export mit anderem Format");
						NSEnumerator* exportEnum=[ExportTitelPfadArray objectEnumerator];
						id einAufnahmePfad;
						BOOL suchen=YES;
						OSErr err=0;
						while ((einAufnahmePfad=[exportEnum nextObject])&&(suchen))
						{
							if ([Filemanager fileExistsAtPath:einAufnahmePfad])
							{
                        /*
								OSErr err=[self getExportEinstellungenvonAufnahme:einAufnahmePfad];
								if (err)
								{
									//NSLog(@"getExportEinstellungenvonAufnahme misslungen. err: %d",err);
									return ;
								}
                         */
								suchen=NO;
							}
						}//while exportEnum
						[self AufnahmenArrayExportieren: ExportTitelPfadArray mitUserDialog:YES];

					}break;
					
					}//switch
					
				
						
			}
			else
			{
				NSAlert *Warnung = [[NSAlert alloc] init];
				[Warnung addButtonWithTitle:@"OK"];
				[Warnung setMessageText:@"Keine markierten Aufnahmen"];
				[Warnung setAlertStyle:NSWarningAlertStyle];
				
				//[Warnung setIcon:RPImage];
				[Warnung runModal];

				//NSLog(@"Nichts zu exportieren");
			}
		}//if (exportTitelArray)
	}//if (exportNamenArray)
		
}

@end
