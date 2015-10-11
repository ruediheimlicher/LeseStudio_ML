//
//  ViewController+Lesebox.m
//  Lesestudio
//
//  Created by Ruedi Heimlicher on 18.08.2015.
//  Copyright (c) 2015 Ruedi Heimlicher. All rights reserved.
//

#import "rRecorder.h"

//extern const short 0;
enum
{
   kModusMenuTag=30000,
   kRecPlayTag,
   kAdminTag,
   kKommentarTag,
   kEinstellungenTag
};

@implementation rRecorder (Lesebox)

- (BOOL)Leseboxvorbereiten
{
   /*
   NSString* teststring1 = @"FB 5 alpha.m4a";
   NSString* result1 = [teststring1 extensionVonPfad];
   //NSLog(@"teststring1: %@ result1: %@",teststring1,result1);
   NSString* teststring2 = @"FB .5 alpha.m4a";
   NSString* result2 = [teststring2 extensionVonPfad];
   //NSLog(@"teststring2: %@ result2: %@",teststring2,result2);
   NSString* teststring3 = @"FB. .5. alpha.m4a";
   NSString* result3 = [teststring3 extensionVonPfad];
   //NSLog(@"teststring3: %@ result3: %@",teststring3,result3);
*/
   //NSLog(@"helpString: %@",[Utils helpString:@"infoRecorder"]);

   NSString* teststring = @"ES 1 30. Juni 2010.m4a";
   
   NSString* resultat = [self AufnahmeTitelVon:teststring];
   
   //NSLog(@"teststring: %@ resultat: %@",teststring,resultat);
   
   
   
   self.istSystemVolume= ![Utils istAufExternemVolume];
   
   //NSLog(@"Leseboxvorbereiten istSystemVolume: %d",self.istSystemVolume);
   
  // NSArray* NetworkCompArray=[Utils checkNetzwerkVolumes];
  // NSArray* NetworkCompArray=[NSArray array];

   //NSLog(@"Leseboxvorbereiten	NSHomeDirectory: %@",NSHomeDirectory());
   //NSLog(@"Leseboxvorbereiten	NetworkCompArray: %@",[NetworkCompArray description]);
   //NSString *bundlePfad = [[NSBundle mainBundle] bundlePath];
   //NSLog(@"Leseboxvorbereiten	bundlePfad: %@",bundlePfad);
   
   //NSArray* UserMitLeseboxArray=[Utils checkUsersMitLesebox];
   //NSLog(@"Leseboxvorbereiten	 UserMitLeseboxArray: %@",[UserMitLeseboxArray description]);
   
   
   //	LeseboxDa=YES;
   //	LeseboxPfad=@"/Users/sysadmin/Documents/Lesebox";
   if (!self.LeseboxDa)
   {
      //NSLog(@"User nach gewuenschter Lesebox fragen");
      //User nach gewuenschter Lesebox fragen
      
      self.LeseboxPfad=(NSMutableString*)[self chooseLeseboxPfad];
      
      self.LeseboxURL =[NSURL fileURLWithPath:self.LeseboxPfad];
      //NSLog(@"User nach gewuenschter Lesebox fragen LeseboxPfad: %@",LeseboxPfad);
      //Rücgabe: LeseboxPfad ungeprüft
   }
   NSLog(@"Leseboxvorbereiten: LeseboxPfad: %@",self.LeseboxPfad);
   
   BOOL ArchivOK=NO;
   BOOL ProjektListeOK=NO;
   
   BOOL TitelListeOK=NO;
   
      BOOL NamenListeOK=NO;
   
   NSString* ArchivString=[NSString stringWithFormat:@"Archiv"];
   NSString* KommentarString=@"Anmerkungen";
   self.istSystemVolume=[Utils istSystemVolumeAnPfad:self.LeseboxPfad];
   //NSLog(@"Leseboxvorbereiten istSystemVolume: %d",self.istSystemVolume);
   //NSLog(@"Leseboxvorbereiten vor Leseboxcomplete: LeseboxPfad: %@",self.LeseboxPfad);
   NSArray* checkArray = [Utils LeseboxCompleteAnPfad: self.LeseboxPfad];
   NSLog(@"LeseboxComplete *%@*",checkArray);
   
   self.LeseboxOK=[Utils LeseboxValidAnPfad:self.LeseboxPfad aufSystemVolume:self.istSystemVolume];//Lesebox checken, ev einrichten
   //NSLog(@"Leseboxvorbereiten nach LeseboxOK: LeseboxOK: %d  self.istSystemVolume: %d",self.LeseboxOK,self.istSystemVolume);
   
   
   if (self.LeseboxOK)
   {
      //NSLog(@"Leseboxvorbereiten LeseboxOK=1 PListDic lesen");
      
      self.PListDic=[[Utils PListDicVon:self.LeseboxPfad aufSystemVolume:self.istSystemVolume]mutableCopy];
      
      NSLog(@"Leseboxvorbereiten LeseboxOK=1 PListDic: %@",[self.PListDic description]);
      
      // Anfang busy
      
      if ([self.PListDic objectForKey:@"busy"])
      {
         if ([[self.PListDic objectForKey:@"busy"]boolValue])//Besetzt durch anderen Benutzer auf Netzwerk
         {
            NSAlert *Warnung = [[NSAlert alloc] init];
            [Warnung addButtonWithTitle:@"Nochmals versuchen"];
            //[Warnung addButtonWithTitle:@""];
            //[Warnung addButtonWithTitle:@""];
            [Warnung addButtonWithTitle:@"Beenden"];
            NSString* MessageString=@"Datenordner besetzt";
            [Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
            
            //NSString* s1=NSLocalizedString(@"The data folder cannot be opened.",@"Der Datenordner kann nicht geöffnet werden");
            //NSString* s2=NSLocalizedString(@"It is momentarly used by annother user.",@"Er wird im Moment von einem anderen Computer benutzt");
            NSString* s1=@"Der Datenordner kann nicht geöffnet werden";
            NSString* s2=@"Er wird im Moment von einem anderen Computer benutzt";
            NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
            [Warnung setInformativeText:InformationString];
            [Warnung setAlertStyle:NSWarningAlertStyle];
            
            //[Warnung setIcon:RPImage];
            long antwort=[Warnung runModal];
            
            switch (antwort)
            {
               case NSAlertFirstButtonReturn://	1000
               {
                  //NSLog(@"NSAlertFirstButtonReturn: Nochmals versuchen");
                  return NO;
                  
               }break;
                  
               case NSAlertSecondButtonReturn://1001
               {
                  //NSLog(@"NSAlertSecondButtonReturn: Beenden");
                  //User fragen, ob busy zurückgesetzt werden soll. Notmassnahme
                  NSAlert *BusyWarnung = [[NSAlert alloc] init];
                  [BusyWarnung addButtonWithTitle:@"Datenordner zurücksetzen"];
                  [BusyWarnung addButtonWithTitle:@"Sofort beenden"];
                  NSString* MessageString=@"Datenordner besetzt";
                  [BusyWarnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
                  
                  NSString* s1=@"Es gibt ein Problem mit dem Status des Datenordners.";
                  NSString* s2=@"Soll sein Status vor dem Beenden zurückgesetzt werden?";
                  NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
                  [BusyWarnung setInformativeText:InformationString];
                  [BusyWarnung setAlertStyle:NSWarningAlertStyle];
                  
                  //[Warnung setIcon:RPImage];
                  long antwort=[BusyWarnung runModal];
                  
                  switch (antwort)
                  {
                     case NSAlertFirstButtonReturn://	1000
                     {
                        //NSLog(@"NSAlertFirstButtonReturn: Reset");
                        [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
                        
                        
                     }break;
                        
                     case NSAlertSecondButtonReturn://1001
                     {
                        //NSLog(@"NSAlertSecondButtonReturn: Beenden");
                        
                        
                     }break;
                        
                  }//switch
                  //[Utils setPListBusy:NO anPfad:LeseboxPfad];
                  [NSApp terminate:self];
                  
               }break;
               case NSAlertThirdButtonReturn://
               {
                  //NSLog(@"NSAlertThirdButtonReturn");
                  
               }break;
               case NSAlertThirdButtonReturn+1://
               {
                  //NSLog(@"NSAlertThirdButtonReturn+1");
                  
               }break;
                  
            }//switch
            
            //				return NO;//warten
         }
         else
         {
            
         }
      }
      else
      {
         
      }
      
      //		[Utils setPListBusy:YES anPfad:LeseboxPfad];
      
      
      
      //ende busy
      
      
      
      
      //NSLog(@"LB vorbereiten: PListDic: %@",[self.PListDic description]);
      if ([self.PListDic objectForKey:@"userpasswortarray"])
      {
         [self.UserPasswortArray setArray:[self.PListDic objectForKey:@"userpasswortarray"]];//Aus PList einsetzen
      }
      
      
      
      

         
      //NSLog(@"ProjektArray: %@",[self.ProjektArray description]);
      if ([self.PListDic objectForKey:@"projektarray"])// && [[self.PListDic objectForKey:@"projektarray"]count])
      {
         if ([[self.PListDic objectForKey:@"projektarray"]count]) // Projekte vorhanden
         {
            //NSLog(@"LB vorbereiten: ProjektArray: %@",[[self.PListDic objectForKey:@"projektarray"] description]);
            // Namen der projekte in der PList
            NSArray* PListProjektnamenArray = [[self.PListDic objectForKey:@"projektarray"] valueForKey:@"projekt"];
            
            // checken, ob alle in der Lesebox vorhandenen Projektorder  erfasst sind
            NSString* tempArchivPfad = [self.LeseboxPfad stringByAppendingPathComponent:@"Archiv"];
            NSArray* ArchivProjektNamenArray = [Utils OrderNamenAnPfad:tempArchivPfad];
            //NSLog(@"LB vorbereiten: PListProjektnamenArray: %@ ArchivProjektNamenArray: %@",PListProjektnamenArray,ArchivProjektNamenArray);
            for (long archivindex=0;archivindex < [ArchivProjektNamenArray count];archivindex++)
            {
               NSString* rawprojekt = [ArchivProjektNamenArray objectAtIndex:archivindex];
               const char* rawchar = [rawprojekt cStringUsingEncoding:NSUTF8StringEncoding];
               NSData* rawdata =[rawprojekt dataUsingEncoding:NSMacOSRomanStringEncoding] ;
               NSString* tempProjektName = [[NSString alloc] initWithData:rawdata encoding:NSMacOSRomanStringEncoding ];
              // //NSLog(@"\r\rrawprojekt: *%@*",rawprojekt);
               //NSString* uint8Projektname = [rawprojekt UTF8String];
               
            //tempProjektName in PListPorjektnamenArray suchen.
               BOOL projektda=0;
               BOOL rawprojektda=NO;
               BOOL charprojektda=NO;
               
               int projektvorhanden=0;
               

               for (int suchindex=0;suchindex < [PListProjektnamenArray count];suchindex++)
               {
                  //projektda=NO;
                  //rawprojektda=NO;
                  //charprojektda=NO;
                  
                  NSString* rawplistprojekt = [PListProjektnamenArray objectAtIndex:suchindex];
                  const char* rawplistchar = [rawplistprojekt cStringUsingEncoding:NSUTF8StringEncoding];

                  NSData* rawplistdata =[rawplistprojekt dataUsingEncoding:NSMacOSRomanStringEncoding] ;
                  NSString* tempPlistProjektName = [[NSString alloc] initWithData:rawplistdata encoding:NSMacOSRomanStringEncoding ];
                  //NSLog(@"rawdata: %@\trawplistdata: %@ tempProjektName: *%@* tempPListProjektName: *%@*",rawdata,rawplistdata,tempProjektName,tempPlistProjektName);
                  if (strcmp(rawchar,rawplistchar) == 0)
                  {
                     charprojektda=YES;
                     projektvorhanden++;
                    // //NSLog(@"rawplistchar: *%s* rawchar: *%s* charprojektda: %hhd",rawplistchar,rawchar,charprojektda);
                  }
                  else
                  {
                     charprojektda=NO;
                  }

                  
                  if ([rawplistprojekt isEqualToString:rawprojekt])
                  {
                     rawprojektda=YES;
                     projektvorhanden++;
                     //NSLog(@"rawprojekt: *%@* rawplistprojekt: *%@* rawprojektda: %hhd",rawprojekt,rawplistprojekt,rawprojektda);

                  }
                  else
                  {
                     rawprojektda=NO;
                  }
                 
                  
                  if (([tempProjektName isEqualToString: tempPlistProjektName]))
                  {
                     projektda=YES;
                     projektvorhanden++;
                     //NSLog(@"tempProjektName: *%@* tempPListProjektName: *%@* projektda: %hhd",tempProjektName,tempPlistProjektName,projektda);

                  }
                  else
                  {
                    projektda=NO;
                  }
                  //NSLog(@"tempProjektName: *%@* projektvorhanden: %d",tempProjektName,projektvorhanden);
                 // //NSLog(@"rawdata: %@\trawplistdata: %@ tempProjektName: *%@* tempPListProjektName: *%@* result: %d",rawdata,rawplistdata,tempProjektName,tempPlistProjektName,projektda);

               }
               
              // if ((projektda || rawprojektda || charprojektda)) // projekt nicht in der PList
                  

               //if ([PListProjektnamenArray indexOfObject:tempProjektName] == NSNotFound) // projekt nicht in der PList
              if (projektvorhanden == 0)
               {
                  //NSLog(@"rawprojekt: %@ nicht da",rawprojekt);
                  // Eintrag in projektarray aufbauen
                  NSMutableDictionary* tempZeilenDic = [self PListProjektDicVonProjekt: tempProjektName];
                  //NSLog(@"tempZeilenDic: %@",tempZeilenDic);
                  
                  [[self.PListDic objectForKey:@"projektarray"]addObject:tempZeilenDic];
                  
               }
               else
               {
                  //NSLog(@"rawprojekt: %@ da",rawprojekt);
               }
            }
            
            
            
            
            [self.ProjektArray setArray:[self.PListDic objectForKey:@"projektarray"]];
            
            NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
            NSString* PListName=@"Lesebox.plist";
            NSString* tempPListPfad=[DataPath stringByAppendingPathComponent:PListName];
            BOOL PListOK=[self.PListDic writeToFile:tempPListPfad atomically:YES];
            //NSLog(@"\nsavePList: PListOK: %d",PListOK);
            
            // [self savePList:self.PListDic anPfad:tempArchivPfad];
            
            //NSLog(@"LB vorbereiten vor update: ProjektArray: %@",[[self.ProjektArray valueForKey:@"projekt"]description]);
            
            
         }
         else // im Archiv nachschauen und projektarray aufbauen
         {
            NSError* err;
            BOOL istOrdner;
            NSString* tempArchivPfad = [self.LeseboxPfad stringByAppendingPathComponent:@"Archiv"];
            if ([[NSFileManager defaultManager]fileExistsAtPath:tempArchivPfad isDirectory: &istOrdner] && istOrdner) // Archiv da
            {
               // Sind Projektordner vorhanden? -> In PList Projektarray eintragen
               NSMutableArray* tempProjektArray = (NSMutableArray*)[[NSFileManager defaultManager]contentsOfDirectoryAtPath:tempArchivPfad error: &err];
               [tempProjektArray removeObject:@".DS_Store"];
               //NSLog(@"LB vorbereiten neuer ProjektArray tempProjektArray: %@",[tempProjektArray description]);
               NSMutableArray* PListProjektarray = [[NSMutableArray alloc]initWithCapacity:0];
               if ([tempProjektArray count])
               {
                  for (int projektindex=0;projektindex < [tempProjektArray count]; projektindex++)
                  {
                     //NSLog(@"tempProjektArray index: %d Projekt:  %@",projektindex,[[tempProjektArray objectAtIndex:projektindex]description]);
                     NSMutableDictionary* tempZeilenDic = [self PListProjektDicVonProjekt: [tempProjektArray objectAtIndex:projektindex]];
                     //NSLog(@"tempZeilenDic: %@",tempZeilenDic);
                     [PListProjektarray addObject:tempZeilenDic];
                  }
                  [self.PListDic setObject:PListProjektarray forKey:@"projektarray"];
                  NSString* PListName=@"Lesebox.plist";
                  //NSString* PListPfad = [[self.LeseboxPfad stringByAppendingPathComponent:@"Data"]stringByAppendingPathComponent:PListName];;
                  self.ProjektPfad = [tempArchivPfad stringByAppendingPathComponent:[tempProjektArray objectAtIndex:0]];
                  [self saveProjektArrayInPList:self.PListDic anPfad:self.LeseboxPfad];
               }
               else
               {
                  //NSLog(@"LB vorbereiten Archiv ist leer");
                  
               }
            }
         }
         
         //   [self updateProjektArray];
         [self updatePasswortListe];
         //NSLog(@"LB vorbereiten nach update: ProjektArray: %@",[[self.ProjektArray valueForKey:@"projekt"] description]);
         
      }
      
      if ([self.PListDic objectForKey:RPBewertungKey])
      {
         self.BewertungZeigen=([[self.PListDic objectForKey:RPBewertungKey]intValue]==1);
      }
      else
      {
         self.BewertungZeigen=YES;
      }
      
      if ([self.PListDic objectForKey:RPNoteKey])
      {
         self.NoteZeigen=([[self.PListDic objectForKey:RPNoteKey]intValue]==1);
      }
      else
      {
         self.NoteZeigen=YES;
      }
      
      
      if ([self.PListDic objectForKey:@"timeoutdelay"])
      {
         self.TimeoutDelay=[[self.PListDic objectForKey:@"timeoutdelay"]intValue];
         if (self.TimeoutDelay==0)
         {
            self.TimeoutDelay=60;
         }
      }
      else
      {
         self.TimeoutDelay=60;
      }
      
      
      //TimeoutDelay=5;
      if ([self.PListDic objectForKey:@"adminpw"])
      {
         self.AdminPasswortDic=[self.PListDic objectForKey:@"adminpw"];
      }
      
      if ([self.PListDic objectForKey:@"knackdelay"])
      {
         //NSLog(@"KnackDelay aus PList: %d",[[PListDic objectForKey:@"knackdelay"]intValue]);
         self.KnackDelay=[[self.PListDic objectForKey:@"knackdelay"]intValue];
      }
      
      
      if ([self.PListDic objectForKey:@"mituserpasswort"])
      {
         self.mitUserPasswort=[[self.PListDic objectForKey:@"mituserpasswort"]boolValue];
      }
      else
      {
         self.mitUserPasswort=1;
      }
      
      if (![self.PListDic objectForKey:@"lastdate"])
      {
         [self.PListDic setObject:[NSNumber numberWithLong:heuteTagDesJahres] forKey:@"lastdate"];
      }
      
      
      
      if ([self.PListDic objectForKey:@"leseboxpfad"])
      {
         //NSLog(@"Leseboxvorbereiten LeseboxPfad aus PList: %@",[self.PListDic objectForKey:@"leseboxpfad"]);
         // [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
         NSString* tempPListLeseboxPfad = [[NSString alloc ]initWithData:[self.PListDic objectForKey:@"leseboxpfad"] encoding:NSUTF8StringEncoding];
         //NSLog(@"Leseboxvorbereiten tempPListLeseboxPfad: %@",tempPListLeseboxPfad);
      }

      //NSLog(@"Leseboxvorbereiten ProjektArray aus PList: %@",[self.ProjektArray description]);
      //NSLog(@"Leseboxvorbereiten adminpw aus PList: %@",[[self.PListDic objectForKey:@"adminpw"] description]);
      
      ArchivOK=[Utils ArchivValidAnPfad:self.LeseboxPfad];//Archiv checken, ev einrichten
   }
   else
   {
      [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
      return NO;
   }
   
   if (ArchivOK)
   {
      self.ArchivPfad=[self.LeseboxPfad stringByAppendingPathComponent:ArchivString];//Pfad des Archiv-Ordners
      //NSLog(@"vor ProjektListeOK: ProjektListeValidAnPfad: ProjektArray : \n%@",[self.ProjektArray description]);
      ProjektListeOK=[self ProjektListeValidAnPfad:self.ArchivPfad];//ProjektOrdner checken, ev einrichten,synchronisieren mit PList
      //NSLog(@"nach ProjektListeOK: ProjektListeValidAnPfad: ProjektArray : \n%@",[self.ProjektArray description]);
   }
   else
   {
      [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
      return NO;
   }
   
   
   if (ProjektListeOK)//
   {
      //NSLog(@"lb vorbereiten nach ProjektListeOK: ProjektListeValidAnPfad: ProjektArray : \n%@",[self.ProjektArray description]);
      BOOL Pfadsuchen=YES;
      BOOL istOrdner=NO;
      NSFileManager *Filemanager = [NSFileManager defaultManager];
      //	while (Pfadsuchen)
      
      
     // [self showProjektStart:nil];
      int projektantwort = [self showProjektStartFenster];
      
      if (projektantwort == 1)
      {
         //NSLog(@"Admin");
     
      }
      //NSLog(@"lb vorbereiten nach showProjektStart: %@",self.ProjektPfad);
      
      if ([Filemanager fileExistsAtPath:self.ProjektPfad isDirectory:&istOrdner]&&istOrdner)
      {
         //NSLog(@"ProjektPfad gefunden");
         Pfadsuchen=NO;
      }
      else
      {
         //NSLog(@"ProjektPfad nicht gefunden");
      }
      

      
      //NSLog(@"//Umgebung: %d  ProjektPfad: %@",Umgebung, ProjektPfad);
      
      NamenListeOK=[self NamenListeValidAnPfad:self.ProjektPfad];
      
      TitelListeOK = [self TitelListeValidAnPfad:self.ProjektPfad];
      
      
      
      
      if (!NamenListeOK)//keine Namen im Projektordner
      {
         //NSLog(@"NamenListeOK=NO: Umgebung: %d  ProjektPfad: %@",Umgebung, ProjektPfad);
      }
      
   }//if ProjektListeOK
   
   else
   {
      [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
      return NO;
   }
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   //NSLog(@"LeseboxOK: %d ArchivOK: %d  NamenListeOK: %d",LeseboxOK, ArchivOK, NamenListeOK);
   
   //NSLog(@"vor ProjektMenu: ProjektListeValidAnPfad: ProjektArray : \n%@ \n@",[ProjektArray description],ProjektPfad);
   
   [self setProjektMenu];
   
   //NSString* LeserNamenListe;
   
   if ([Filemanager fileExistsAtPath:self.ProjektPfad])
   {
      NSDictionary* tempProjektDic;
      double ProjektIndex=[[self.ProjektArray valueForKey:@"projekt"]indexOfObject:[self.ProjektPfad lastPathComponent]];
      NSString* ProjektSessionDatum;
      if (ProjektIndex < NSNotFound)
      {
         tempProjektDic=[self.ProjektArray objectAtIndex:ProjektIndex];
         [self checkSessionDatumFor:[self.ProjektPfad lastPathComponent]];
         
         if ([tempProjektDic objectForKey:@"sessiondatum"])
         {
            ProjektSessionDatum=[tempProjektDic objectForKey:@"sessiondatum"];
            
         }
         else
         {
            ProjektSessionDatum=heuteDatumString;
         }
         
         int titelfix = [[tempProjektDic objectForKey:@"fix"]intValue];
         if (titelfix)
         {
            NSImage* roterpunkt = [NSImage imageNamed:@"fixiert"];
            [self.titelfixcheck setImage:roterpunkt];
         }
         else
         {
            NSImage* gruenerpunkt = [NSImage imageNamed:@"editierbar"];
            [self.titelfixcheck setImage:gruenerpunkt];
            
         }

         
      }
      //NSLog(@"LB vorbereiten ProjektSessionDatum: %@",ProjektSessionDatum);
      
      
      NSMutableArray * tempProjektNamenArray=[[NSMutableArray alloc] initWithArray:[Filemanager contentsOfDirectoryAtPath:self.ProjektPfad error:NULL]];
      //long AnzNamen=[tempProjektNamenArray count];											//Anzahl Leser
      //LeserNamenListe=[tempProjektNamenArray description];
      
      if ([tempProjektNamenArray count])
      {
         if ([[tempProjektNamenArray objectAtIndex:0] hasPrefix:@".DS"])					//Unsichtbare Ordner entfernen
         {
            [tempProjektNamenArray removeObjectAtIndex:0];
         }
         
      }
      
      [self setArchivNamenPop];
      
      //NSLog(@"Lb vorbereiten tempProjektNamenArray: %@",[tempProjektNamenArray description]);
      
      [self.Zeitfeld setSelectable:NO];
      [[[self view] window] makeFirstResponder:[[self view] window]];
      
      
      
   }			//Archivpfad
   
   
   //AnzLeseboxObjekte++;
   
   //NSMutableArray* test=[self OrdnernamenArrayVonKlassenliste];
   [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
   [[self.view window] makeKeyAndOrderFront:self];
   [[self.view window] setOrderedIndex:0];
   return YES;
   
}


- (void)KontrollTimerfunktion:(NSTimer*)derTimer
{
   if ([[[self.PListDic objectForKey:@"adminpw"]objectForKey:@"pw"]length]==0)
   {
      [derTimer invalidate];
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"OK"];
      [Warnung setMessageText:@"PList  Kein PList-Eintrag mehr fuer 'pw'"];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      //int antwort=[Warnung runModal];
      
   }
}

- (IBAction)Titelsetzen:(NSButton *)sender
{
   self.TitelString.stringValue = @"Lesestudio";
}




- (NSString*) chooseLeseboxPfadMitUserArray:(NSArray*)derUserArray undNetworkArray:(NSArray*)derNetworkArray;
{
   NSArray* tempUserArray=[NSArray array];
   tempUserArray=[[NSArray alloc]initWithArray:derUserArray];
   if (VolumesPanel)
   {
      
   }
   else
   {
      VolumesPanel = [[rVolumes alloc]init];
   }
   NSModalSession VolumeSession=[NSApp beginModalSessionForWindow:[VolumesPanel window]];
   
   NSString *bundlePfad = [[NSBundle mainBundle] bundlePath];
   //NSLog(@"Leseboxvorbereiten	bundlePfad: %@",bundlePfad);
   NSArray* homeArray = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:[bundlePfad stringByDeletingLastPathComponent] error:nil];
   
   long leseboxindex = [homeArray indexOfObject:@"Lesebox"];
   //NSLog(@"Leseboxvorbereiten	homeArray: %@ leseboxindex: %ld",homeArray,leseboxindex);
   if (leseboxindex < NSNotFound)
   {
      NSString* tempLeseboxPfad =[[bundlePfad stringByDeletingLastPathComponent]stringByAppendingPathComponent:@"Lesebox" ];
      BOOL isDir;
      if ([[NSFileManager defaultManager]fileExistsAtPath:tempLeseboxPfad isDirectory:&isDir] && isDir)
      {
         [VolumesPanel setLeseboxPfad:tempLeseboxPfad];
         [VolumesPanel setLeseboxOK:YES];
      }
      else
      {
         [VolumesPanel setLeseboxPfad:@"--"];
      }
   }
   else
   {
      [VolumesPanel setLeseboxPfad:@"--"];
   }
   
   //in VolumesPanel Daten einsetzen
   // [VolumesPanel setUserArray:tempUserArray];
   
   
   // //NSLog(@" eingesetzt");
   //	if ([tempNetworkArray count])
   //	[VolumesPanel setNetworkArray:tempNetworkArray];
   //    //NSLog(@"tempNetworkArray eingesetzt");
   
   long modalAntwort = [NSApp runModalForWindow:[VolumesPanel window]];
   //NSLog(@"VolumesPanel: Antwort: %d",modalAntwort);
   
   //LeseboxPfad aus Panel abfragen
   NSString* tempLeseboxPfad=[NSString stringWithString:[VolumesPanel LeseboxPfad]];
   
   
   
   //Für Volumes mit System zeigt der Leseboxpfad auf einen Ordner in Documents
   //Für Externe HDs zeigt der Leseboxpfad auf einen Ordner direkt auf der HD.
   //Die PList wird im Ordner 'Data' in der Lesebox abgelegt.
   
   
   // //NSLog(@"LeseboxPfad: %@ LeseboxURL: %@",self.LeseboxPfad,self.LeseboxURL);
   // //NSLog(@"chooseLeseboxPfadVon: Antwort: %d  LeseboxPfad: %@",modalAntwort,tempLeseboxPfad);
   
   [NSApp endModalSession:VolumeSession];
   
   [[VolumesPanel window] orderOut:NULL];
   //NSLog(@"VolumesPanel: Antwort: %d",modalAntwort);
   
   return tempLeseboxPfad;
   
}

- (NSString*) chooseLeseboxPfad
{
   if (VolumesPanel)
   {
      
   }
   else
   {
      VolumesPanel = [[rVolumes alloc]init];
   }
   NSModalSession VolumeSession=[NSApp beginModalSessionForWindow:[VolumesPanel window]];
   
   NSString *bundlePfad = [[NSBundle mainBundle] bundlePath];
   //NSLog(@"Leseboxvorbereiten	bundlePfad: %@",bundlePfad);
   NSArray* homeArray = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:[bundlePfad stringByDeletingLastPathComponent] error:nil];
 
   long leseboxindex = [homeArray indexOfObject:@"Lesebox"];
   //NSLog(@"Leseboxvorbereiten	homeArray: %@ leseboxindex: %ld",homeArray,leseboxindex);
   if (leseboxindex < NSNotFound)
   {
      NSString* tempLeseboxPfad =[[bundlePfad stringByDeletingLastPathComponent]stringByAppendingPathComponent:@"Lesebox" ];
       BOOL isDir;
      if ([[NSFileManager defaultManager]fileExistsAtPath:tempLeseboxPfad isDirectory:&isDir] && isDir)
      {
         [VolumesPanel setLeseboxPfad:tempLeseboxPfad];
         [VolumesPanel setLeseboxOK:YES];
      }
      else
      {
          [VolumesPanel setLeseboxPfad:@"--"];
      }
   }
   else
   {
      [VolumesPanel setLeseboxPfad:@"--"];
   }
 
   
   long modalAntwort = [NSApp runModalForWindow:[VolumesPanel window]];
   
   //NSLog(@"VolumesPanel: Antwort: %d",modalAntwort);
   
   //LeseboxPfad aus Panel abfragen
   NSString* tempLeseboxPfad=[NSString stringWithString:[VolumesPanel LeseboxPfad]];
   
   //Für Volumes mit System zeigt der Leseboxpfad auf einen Ordner in Documents
   //Für Externe HDs zeigt der Leseboxpfad auf einen Ordner direkt auf der HD.
   //Die PList wird im Ordner 'Data' in der Lesebox abgelegt.
   
   self.LeseboxURL =[NSURL URLWithString:self.LeseboxPfad];
   // //NSLog(@"LeseboxPfad: %@ LeseboxURL: %@",self.LeseboxPfad,self.LeseboxURL);
   // //NSLog(@"chooseLeseboxPfadVon: Antwort: %d  LeseboxPfad: %@",modalAntwort,tempLeseboxPfad);
   
   [NSApp endModalSession:VolumeSession];
   
   [[VolumesPanel window] orderOut:NULL];
   //NSLog(@"VolumesPanel: Antwort: %d",modalAntwort);
   
   return tempLeseboxPfad;
   
}//chooseLeseboxPfadVon

- (void)setRepresentedObject:(id)representedObject {
   [super setRepresentedObject:representedObject];
   
   // Update the view, if already loaded.
}



- (IBAction)showProjektListe:(id)sender
{
   
   if (![self checkAdminZugang])
   {
      return;
   }
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:@"ProjektListe" forKey:@"quelle"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"fensterschliessen" object:self userInfo:NotificationDic];

   if (!ProjektPanel)
	  {
        ProjektPanel=[[rProjektListe alloc]init];
     }
   
   
   //NSLog(@"showProjektListe");
   //[ProjektPanel showWindow:self];
  // //NSLog(@"showProjektListe nach init:ProjektArray: %@  ",[self.ProjektArray description]);
   //NSLog(@"ViewController showProjektListe nach init:ProjektArray: %@  \nProjektPfad: %@",[self.ProjektArray description],self.ProjektPfad);
   
   NSMutableArray* tempProjektArray = ( NSMutableArray*)[Utils ProjektArrayAusPListAnPfad:self.LeseboxPfad];
   if ([tempProjektArray count]==0)
   {
      [ProjektPanel setVomStart:YES];
   }
   else
   {
       [ProjektPanel  setVomStart:![self checkAdminPW]];
   }
   
   [self.ProjektArray setArray:tempProjektArray];
   
   //[ProjektPanel showWindow:self];
   NSModalSession ProjektSession=[NSApp beginModalSessionForWindow:[ProjektPanel window]];
   
   if ([self.ProjektArray count])
   {
      [ProjektPanel  setProjektListeArray:self.ProjektArray  inProjekt:[self.ProjektFeld stringValue]];
   }
   else
   {
      
      //NSLog(@"[ProjektArray count]=0");
      [ProjektPanel  setProjektListeLeer];
   }
    long modalAntwort = [NSApp runModalForWindow:[ProjektPanel window]];
   
   [NSApp endModalSession:ProjektSession];
   [[ProjektPanel window] orderOut:NULL];
   
}

- (void)showProjektListeVomStart
{
   [self restartAdminTimer];
   //NSLog(@"showProjektListeVomStart:  Start mit neuem Projekt");
   //NSLog(@"\n\nshowProjektListe start");
   if (!ProjektPanel)
	  {
        ProjektPanel=[[rProjektListe alloc]init];
     }
   //NSLog(@"showProjektListe nach init:ProjektArray: %@  ",[ProjektArray description]);
   //NSLog(@"showProjektListe nach init:ProjektArray: %@  \nProjektPfad: %@",[self.ProjektArray description],self.ProjektPfad);
   
   //[ProjektPanel showWindow:self];
   NSModalSession ProjektSession=[NSApp beginModalSessionForWindow:[ProjektPanel window]];
   
   if ([self.ProjektArray count])
	  {
        [ProjektPanel  setProjektListeArray:self.ProjektArray  inProjekt:[self.ProjektFeld stringValue]];
     }
   else
	  {
        
        //NSLog(@"[ProjektArray count]=0");
        [ProjektPanel  setProjektListeLeer];
     }
	  
   //	  [ProjektPanel setMitUserPasswort:mitUserPasswort];
	  [ProjektPanel  setVomStart:YES];
   
   long modalAntwort = [NSApp runModalForWindow:[ProjektPanel window]];
   //int modalAntwort = [NSApp runModalSession:ProjektSession];
   if (modalAntwort==0)
   {
      
   }
   //NSLog(@"showProjektliste Antwort: %d",modalAntwort);
   [NSApp endModalSession:ProjektSession];							//Ergebnisse aus Notifikation
   
   
   [ProjektPanel  setVomStart:YES];
}

- (void)ProjektListeAktion:(NSNotification*)note
{
   /*
    sendertag:
    CancelTaste:	0
    AuswahlenTaste: 	1
    EntfernenTaste: 	2
    SchliessenTaste: 	3
    InListeTaste: 	5
    */
   
   //Note von Projektliste über neue Projekte und/oder Änderungen am bestehenden Projektarray
   //NSLog(@"*ProjektListeAktion startProjektarray bei Rueckkehr von Panel: %@",[[[note userInfo] objectForKey:@"projektarray"]description]);
   //ProjektArray
   NSMutableArray* tempProjektArray=[[[note userInfo] objectForKey:@"projektarray"]mutableCopy];
   //NSLog(@"\n****ProjektListeAktion projektarray: %@",[[[note userInfo] objectForKey:@"projektarray"]description]);
   //NSLog(@"****      ProjektListeAktion ArchivPfad: %@      tempProjektArray cont: %lu",self.ArchivPfad,(unsigned long)[tempProjektArray count]);
   long sendertag = [[[note userInfo] objectForKey:@"sender"]longValue];
   
   //if (sendertag ==
   if ([[note userInfo] objectForKey:@"projekt"]) //
   {
      self.ProjektPfad=[self.ArchivPfad stringByAppendingPathComponent:[[[note userInfo] objectForKey:@"projekt"]copy]];
   }
   // //NSLog(@"\n****   ProjektListeAktion Projektpfad: %@",self.ProjektPfad);
   NSString* tempProjekt =[[note userInfo] objectForKey:@"projekt"];
   NSArray* tempProjektNamenArray = [tempProjektArray valueForKey:@"projekt"];
   long projektindex = [[tempProjektArray valueForKey:@"projekt"]indexOfObject:tempProjekt];
   if (!(projektindex < NSNotFound))
   {
      return;
   }
   
   NSMutableDictionary* tempProjektDic = (NSMutableDictionary*)[tempProjektArray objectAtIndex:projektindex];
   
   int titelfix = [[[tempProjektArray objectAtIndex:projektindex] objectForKey:@"fix"]intValue];
   
   BOOL TitelEditOK = !titelfix; // im aktuellen Projekt die Einstellungen anpassen (- >Schluss der routine)
   
   if (titelfix)
   {
      NSImage* roterpunkt = [NSImage imageNamed:@"fixiert"];
      [self.titelfixcheck setImage:roterpunkt];
      // von anderesProjekteinrichten
      if ([tempProjektDic objectForKey:@"titelarray"]&&[[tempProjektDic objectForKey:@"titelarray"]count])
      {
         //NSLog(@"ProjektListeAktion Projekt: %@  Titelarray: %@",tempProjekt,[[tempProjektDic objectForKey:@"titelarray"] description]);
      }
      else //noch kein Eintrag im titelarray
      {
         if (titelfix)
         {
            NSAlert *Warnung = [[NSAlert alloc] init];
            [Warnung addButtonWithTitle:@"Titelliste anlegen"];
            [Warnung addButtonWithTitle:@"Fixierung aufheben"];
            //[Warnung addButtonWithTitle:@""];
            // [Warnung addButtonWithTitle:@"Abbrechen"];
            [Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Keine Titelliste"]];
            
            NSString* s1=@"Die Titel fuer dieses Projekt sind fixiert.";
            NSString* s2=@"Die Titelliste enthaelt aber noch keine Titel.";
            NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
            [Warnung setInformativeText:InformationString];
            [Warnung setAlertStyle:NSWarningAlertStyle];
            
            long antwort=[Warnung runModal];
            switch (antwort)//Liste anlegen
            {
               case NSAlertFirstButtonReturn://
               {
                  NSLog(@"ProjektListeAktion NSAlertFirstButtonReturn: Liste anlegen");
                  //[self showTitelListe:NULL];
                  [self showTitelListeInProjekt:tempProjekt];
               }break;
                  
               case NSAlertSecondButtonReturn://Fix aufgeben
               {
                  NSLog(@"ProjektListeAktion NSAlertSecondButtonReturn: Fixierung aufheben");
                  [tempProjektDic setObject:[NSNumber numberWithInt:0]forKey:@"fix"];
                  //PList aktualisieren
                  
                  //NSLog(@"ProjektListeAktion  PListDic lesen LeseboxPfad: %@",self.LeseboxPfad);
                  NSDictionary* tempAktuellePListDic=[Utils PListDicVon:self.LeseboxPfad aufSystemVolume:self.istSystemVolume];
                  if ([tempAktuellePListDic objectForKey:@"projektarray"])//Es hat schon einen ProjektArray
                  {
                     NSMutableArray* tempProjektArray=(NSMutableArray*)[tempAktuellePListDic objectForKey:@"projektarray"];
                     NSUInteger ProjektIndex=[[tempProjektArray valueForKey:@"projekt"] indexOfObject:tempProjekt];
                     
                     if (ProjektIndex < NSNotFound)
                     {
                        //NSLog(@"ProjektListeAktion: tempProjektArray objectAtIndex:ProjektIndex: %@",[[tempProjektArray objectAtIndex:ProjektIndex]description]);
                        [[tempProjektArray objectAtIndex:ProjektIndex]setObject:[NSNumber numberWithInt:0] forKey:@"fix"];
                        //NSLog(@"ProjektListeAktion nach reset fix: tempProjektArray objectAtIndex:ProjektIndex: %@",[[tempProjektArray objectAtIndex:ProjektIndex]description]);
                        [self saveTitelFix:NO inProjekt:tempProjekt];
                     }
                     else
                     {
                        //NSLog(@"ProjektListeAktion  : titelfix: Projekt nicht gefunden");
                     }
                     
                     
                     //NSLog(@"ProjektListeAktion: Projektarray aus PList lastObject: %@",[[[tempAktuellePListDic objectForKey:@"projektarray"]lastObject]description]);
                     //NSLog(@"ProjektListeAktion: Projektarray neu: %@",[[ProjektArray lastObject]description]);
                     
                  }
                  [[self.ProjektArray objectAtIndex:projektindex]setObject:[NSNumber numberWithInt:0] forKey:@"fix"];
                  
                  
                  
                  
                  
               }break;
               case NSAlertThirdButtonReturn://
               {
                  //NSLog(@"NSAlertThirdButtonReturn");
                  
               }break;
               case NSAlertThirdButtonReturn+1://cancel
               {
                  //NSLog(@"NSAlertThirdButtonReturn+1");
                  [NSApp stopModalWithCode:0];
                  //        [[self window] orderOut:NULL];
                  
               }break;
                  
            }//switch
         }//if titelfix
      }//noch keine Titelliste
      
      
      //
   }
   else
   {
      NSImage* gruenerpunkt = [NSImage imageNamed:@"editierbar"];
      [self.titelfixcheck setImage:gruenerpunkt];
      
   }
   
   if (tempProjektArray)
   {
      [self.ProjektArray setArray: tempProjektArray];
      
      [self saveNeuenProjektArray:tempProjektArray];
      [self setProjektMenu];
      
      [self savePListAktion:nil];
      
   }
   
   [self.TitelPop setEditable:!titelfix];//Nur wenn Titel editierbar
   [self.TitelPop setSelectable:!titelfix];
   
   
   
   
   
}

- (void)neuesProjektAktion:(NSNotification*)note
{
   //Note von Projektliste über neues Projekt: reportNeuesProjekt
   BOOL neuesProjektOK=NO;
   NSMutableDictionary* tempNeuesProjektDic=[[[note userInfo] objectForKey:@"neuesprojektdic"]mutableCopy];
   //NSLog(@"ViewController Lesebox neuesProjektAktion: userInfo: %@",[[note userInfo] description]);
   
   //NSLog(@"RPC neuesProjektAktion: tempNeuesProjektDic: %@",[tempNeuesProjektDic description]);
   //NSString* neuesProjektName=[tempNeuesProjektDic objectForKey:projekt];
   NSString* neuesProjektName=[tempNeuesProjektDic objectForKey:@"projekt"];
   NSMutableDictionary* neuesProjektDic;
   if (neuesProjektName)
   {
      if ([neuesProjektName length])
      {
         NSString* tempProjektPfad=[self.ArchivPfad stringByAppendingPathComponent:neuesProjektName];
         //NSLog(@"neuesProjektAktion tempProjektPfad: %@",tempProjektPfad);
         //NSLog(@"ProjektArray ist da: %d",!(ProjektArray==NULL));
         if (self.ProjektArray&&[self.ProjektArray count])
         {
            
            [Utils setUProjektArray:self.ProjektArray];//Bei Wahl von "Neues Projekt" beim Projektstart ist UProjektArray in Utils noch leer
         }
         else
         {
            
         }
         
         if ([Utils ProjektOrdnerEinrichtenAnPfad:tempProjektPfad])
         {
            //NSLog(@"ProjektOrdnerEinrichtenAnPfad: ist OK");
            
            neuesProjektDic=[NSMutableDictionary dictionaryWithObject:neuesProjektName forKey:@"projekt"];
            [neuesProjektDic setObject:[tempProjektPfad copy] forKey:@"projektpfad"];
            [neuesProjektDic setObject: [NSNumber numberWithInt:1] forKey:@"ok"];//Projekt ist aktiviert
           
            //eventuell bei replace all irtuemlichauf gross umgestellt
            [neuesProjektDic setObject: [NSNumber numberWithInt:1] forKey:@"ok"];//Projekt ist aktiviert

            [neuesProjektDic setObject:heuteDatumString forKey:@"sessiondatum"];
            
            NSNumber* tempFix=[tempNeuesProjektDic objectForKey:@"fix"];//Titel fix?
            if (tempFix)
            {
               [neuesProjektDic setObject: tempFix forKey:@"fix"];
               //			[self showTitelListe:NULL];
            }
            else
            {
               [neuesProjektDic setObject: [NSNumber numberWithInt:0] forKey:@"fix"];
            }
            if (tempFix)
            {
               NSImage* roterpunkt = [NSImage imageNamed:@"fixiert"];
               [self.titelfixcheck setImage:roterpunkt];
            }
            else
            {
               NSImage* gruenerpunkt = [NSImage imageNamed:@"editierbar"];
               [self.titelfixcheck setImage:gruenerpunkt];
               
            }

            //NSLog(@"neuesProjektAktion neuesProjektDic: %@",[neuesProjektDic description]);
            
            NSNumber* tempMitUserPW=[tempNeuesProjektDic objectForKey:@"mituserpw"];//Mit Userpasswort?
            if (tempMitUserPW)
            {
               [neuesProjektDic setObject: tempMitUserPW forKey:@"mituserpw"];
               //			[self showTitelListe:NULL];
            }
            else
            {
               [neuesProjektDic setObject: [NSNumber numberWithInt:0] forKey:@"mituserpw"];
            }
            //NSLog(@"neuesProjektAktion neuesProjektDic: %@",[neuesProjektDic description]);
            
            [self.ProjektArray addObject:neuesProjektDic];
            
            neuesProjektOK=YES;
            //NSLog(@"neuesProjektAktion neuesProjektOK: YES");
         }
         else
         {
            //**
            //Kein Projektordner eingerichtet
            //NSLog(@"neuesProjektAktion neuesProjektOK: NO kein Pojekt 	ProjektPanel resetPanel");
            [ProjektPanel resetPanel];
            neuesProjektOK=NO;
         }
         
      }
   }
   
   if (neuesProjektOK)
   {
      [self setProjektMenu];
      [ProjektPanel setNeuesProjekt];
      [ProjektPanel setProjektListeArray:self.ProjektArray inProjekt:neuesProjektName];
      //NSLog(@"\n\n                    +++++   neuesProjektAktion Schluss: ProjektArray: %@\n",[self.ProjektArray description]);
      
      [self saveNeuesProjekt:neuesProjektDic];
//      [AdminPlayer setAdminProjektArray:ProjektArray];
      //29.1.		[self savePListAktion:nil];
      
      
   }//if NeueProjektListeOK
   else
   {
      //NSLog(@"*neuesProjektListeAktion Kein neues Projekt %@",[ProjektArray description]);
      [ProjektPanel resetPanel];
   }
   
   //8.11.06	[self savePListAktion:nil];
   
   //[[ProjektPanel window]close];
   
   
}

- (void)ProjektMenuAktion:(NSNotification*)note
{
   //NSLog(@"\n\n************ ProjektMenuAktion : \nNeues Projekt: %@",[[note userInfo] objectForKey:@"projekt"]);
   NSString* tempProjektString=[NSString stringWithString:[[note userInfo] objectForKey:@"projekt"]];
   if (tempProjektString)
   {
      
      self.ProjektPfad=(NSMutableString*)[self.ArchivPfad stringByAppendingPathComponent:[[note userInfo] objectForKey:@"projekt"]];
      [self setProjektMenu];
   }
}



- (IBAction)anderesProjekt:(id)sender
{
   //NSLog(@"\n\n************	Menü Ablauf:	anderes Projekt: %@\n",[sender title]);
   [self anderesProjektEinrichtenMit:[sender title]];
   
   [self setArchivNamenPop];
   if (self.Umgebung==0)
   {
      [Utils startTimeout:self.TimeoutDelay];
   }
   else
   {
      [Utils stopTimeout];
   }
}

- (IBAction)anderesProjektMitTitel:(NSString*)derTitel
{
   //NSLog(@"\n\n	Menü Ablauf:	anderesProjektMitTitel; %@",derTitel);
   [self anderesProjektEinrichtenMit:derTitel];
   [self setArchivNamenPop];
   //[Utils startTimeout:TimeoutDelay];
}


- (void)updateProjektArray
{
   //NSLog(@"updateProjektArray start: Leseboxpfad: %@ ProjektArray : %@",LeseboxPfad,[ProjektArray description]);
   
   NSMutableArray* tempProjektArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   long anzOrdnerImArchiv=0;
   
   // Projektarray aus PList
   [self.ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:self.LeseboxPfad]];	//	Projektarray aus PList
   
   //NSLog(@"updateProjektArray ProjektArray aus PList: ProjektArray : %@",[ProjektArray description]);
   
   //long anzProjekte=[self.ProjektArray count];//Anzahl Projekte in ProjektArray
   
   //Inhalt von Archiv prüfen
   NSString* tempArchivPfad=[self.LeseboxPfad stringByAppendingPathComponent:@"Archiv"];
   NSMutableArray* tempArchivProjektNamenArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:tempArchivPfad error:NULL];
   //NSLog(@"updateProjektArray: ArchivPfad: %@  tempArchivProjektNamenArray roh : %@",tempArchivPfad,[tempArchivProjektNamenArray description]);
   
   if ([tempArchivProjektNamenArray count]&&[[tempArchivProjektNamenArray objectAtIndex:0] hasPrefix:@".DS"])					//Unsichtbare Ordner entfernen
   {
      [tempArchivProjektNamenArray removeObjectAtIndex:0];
      
   }
   
   anzOrdnerImArchiv=[tempArchivProjektNamenArray count];
   //NSLog(@"updateProjektArray Projektnamen im Archiv: tempArchivProjektNamenArray : %@",[tempArchivProjektNamenArray description]);
   //NSLog(@"updateProjektArray Projektnamen im Archiv: tempArchivProjektNamenArray : %@",[[tempArchivProjektNamenArray valueForKey:@"projekt"]description]);
   
   //Namen im vorhandenen Projektarray aus der PList:
   NSArray* tempProjektArrayNamenArray=[self.ProjektArray valueForKey:@"projekt"];
   //NSLog(@"Projektnamen aus PList: tempProjektArrayNamenArray : %@",[tempProjektArrayNamenArray description]);
   
   //Enum über Namen der Projekte im Projektarray
   //NSString* tempProjekt;
   int index=0; //Index im Projektarray
   
   // Check, ob Projektordern wirklich in der Lesebox vorhanden sind
   
   for (index=0;index<[tempProjektArrayNamenArray  count];index++)
   {
      NSString* tempProjekt =[tempProjektArrayNamenArray  objectAtIndex:index] ;
      //NSLog(@"tempProjekt: %@  index: %d",tempProjekt,index);
      //Ist der Name von tempProjekt im Archiv vorhanden?
      long ArchivPosition=[tempArchivProjektNamenArray indexOfObject:tempProjekt];
      //NSLog(@"tempProjekt: %@  ArchivPosition: %d",tempProjekt,ArchivPosition);
      
      if (ArchivPosition < NSNotFound)//Objekt ist im Archiv
      {
         //Projekt aus Projektarray in neuen ProjektArray kopieren
         [tempProjektArray addObject:[self.ProjektArray objectAtIndex:index]];
      }
      
   }//for
   
   
   //NSLog(@"tempProjektArray : %@",[tempProjektArray description]);
   
   //Projektarray ersetzen
   [self.ProjektArray setArray:tempProjektArray];
   [Utils ProjektArrayInPList:tempProjektArray anPfad:self.LeseboxPfad];
   //NSLog(@"updateProjektArray end");
}

- (void)updatePasswortListe
{
   //NSLog(@"updateNamenListe start:");

   NSFileManager *Filemanager=[NSFileManager defaultManager];
   long anzOrdnerImArchiv=0;
   
   NSString* tempArchivPfad=[self.LeseboxPfad stringByAppendingPathComponent:@"Archiv"];
   NSMutableArray* tempArchivProjektOrdnerArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:tempArchivPfad error:NULL];
   //NSLog(@"updateProjektArray: ArchivPfad: %@  tempArchivProjektOrdnerArray roh : %@",tempArchivPfad,[tempArchivProjektOrdnerArray description]);
   
   if ([tempArchivProjektOrdnerArray count]&&[[tempArchivProjektOrdnerArray objectAtIndex:0] hasPrefix:@".DS"])					//Unsichtbare Ordner entfernen
   {
      [tempArchivProjektOrdnerArray removeObjectAtIndex:0];
      
   }
   anzOrdnerImArchiv=[tempArchivProjektOrdnerArray count];	//	Namen von Ordnern im Archiv
   //NSLog(@"Projektnamen im Archiv: tempArchivProjektOrdnerArray : %@",[tempArchivProjektOrdnerArray description]);
   
   if ([tempArchivProjektOrdnerArray count]==0)
   {
      return;
   }
   NSMutableArray* tempNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSEnumerator* ProjektEnum=[tempArchivProjektOrdnerArray objectEnumerator];
   id einProjektName;
   while (einProjektName=[ProjektEnum nextObject])
   {
      NSString* tempLeserPfad=[tempArchivPfad stringByAppendingPathComponent:einProjektName];
      NSMutableArray* tempLeserNamenArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:tempLeserPfad error:NULL];
      //		//NSLog(@"updateProjektArray: tempLeserPfad: %@  tempLeserNamenArray roh : %@",tempLeserPfad,[tempLeserNamenArray description]);
      
      if ([tempLeserNamenArray count]&&[[tempLeserNamenArray objectAtIndex:0] hasPrefix:@".DS"])					//Unsichtbare Ordner entfernen
      {
         [tempLeserNamenArray removeObjectAtIndex:0];
         
      }
      NSEnumerator* NamenEnum=[tempLeserNamenArray objectEnumerator];
      id einName;
      while (einName=[NamenEnum nextObject])
      {
         if (!([tempNamenArray containsObject:einName]))
         {
            [tempNamenArray addObject:einName];
         }
      }//while
      //
      
   }//while
   //	tempNamenArray: Namen aller Leser im Archiv
   
   //NSLog(@"updatePasswortliste: tempNamenArray : %@",[tempNamenArray description]);
   NSMutableDictionary* tempPListDic=(NSMutableDictionary*)[Utils PListDicVon:self.LeseboxPfad aufSystemVolume:NO];
   NSMutableArray* tempPWArray=(NSMutableArray*)[tempPListDic objectForKey:@"userpasswortarray"];
   //	 tempPWArray: Dics im PWArray der PList
   
   NSArray* tempNamenMitPWArray=[tempPWArray valueForKey:@"name"];
   //	tempNamenMitPWArray: Namen im PWArray der PList
   
   //NSLog(@"updateProjektArray: tempNamenMitPWArray : %@",[tempNamenMitPWArray description]);
   
   //	Neuer Array mit PWDics zu noch vorhandnenen Namen:
   NSMutableArray* tempneuerUserPWArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   NSEnumerator* PWEnum=[tempNamenMitPWArray objectEnumerator]; // Leser mit PW in PList
   id einPWName;
   int index=0;
   while ((einPWName =[PWEnum nextObject]))
   {
      if ([tempNamenArray containsObject:einPWName])
      {
         [tempneuerUserPWArray addObject:[tempPWArray objectAtIndex:index]];
      }
      index++;
   }//while PWEnum
   //NSLog(@"updateProjektArray: tempneuerUserPWArray : %@",[tempneuerUserPWArray description]);
   
   NSString* tempDataPfad=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   //NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
   NSString* PListName=@"Lesebox.plist";
   NSString* tempPListPfad=[tempDataPfad stringByAppendingPathComponent:PListName];
   
   [tempPListDic setObject:[tempneuerUserPWArray copy] forKey:@"userpasswortarray"];
   BOOL PListOK=[tempPListDic writeToFile:tempPListPfad atomically:YES];
   
}//updateNamenListe

- (BOOL)ArchivValidAnPfad:(NSString*)derLeseboxPfad
{
   NSString* locBeenden=@"Beenden";
   
   BOOL ArchivValid=0;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* tempArchivPfad=[derLeseboxPfad stringByAppendingPathComponent:@"Archiv"];
   if ([Filemanager fileExistsAtPath:tempArchivPfad])
	  {
        ArchivValid=YES;
     }
   else
	  {
        // Archiv einrichten
        ArchivValid=[Filemanager createDirectoryAtPath:tempArchivPfad  withIntermediateDirectories:NO attributes:NULL error:NULL];
        if (!ArchivValid)
        {
            //
           NSAlert *Warnung = [[NSAlert alloc] init];
           [Warnung setMessageText:@"Archiv einrichten:"];
           [Warnung setInformativeText:@"Der Ordner Archiv konnte auf dem gewählten Computer nicht eingerichtet werden.\rDas Programm wird beendet."];
           [Warnung setAlertStyle:NSWarningAlertStyle];
           
           [Warnung addButtonWithTitle:@"Beenden"];
           [Warnung addButtonWithTitle:@""];
           [Warnung runModal];
           
           [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
            [NSApp terminate:NULL];
        }
        
     }
   return ArchivValid;
}


- (NSMutableDictionary*)PListProjektDicVonProjekt:(NSString*)dasProjekt
{
   NSString* tempProjektPfad =[[self.LeseboxPfad stringByAppendingPathComponent:@"Archiv"]stringByAppendingPathComponent:dasProjekt];
   NSMutableDictionary* tempProjektDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   
   if ([[NSFileManager defaultManager]fileExistsAtPath:tempProjektPfad])
   {
      //NSLog(@"PListProjektDicVonProjekt Projektordner da");
      
     // NSMutableDictionary* tempProjektDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [tempProjektDic setObject:tempProjektPfad forKey:@"projektpfad"]; //Projektpfad einsetzen
      [tempProjektDic setObject:dasProjekt forKey:@"projekt"];
      [tempProjektDic setObject: [NSNumber numberWithInt:1] forKey:@"ok"];
      [tempProjektDic setObject: [NSNumber numberWithInt:1] forKey:@"extern"];
      [tempProjektDic setObject: [NSNumber numberWithInt:0] forKey:@"fix"];
      [tempProjektDic setObject: [NSMutableArray array] forKey:@"titelarray"];
      [tempProjektDic setObject: [NSNumber numberWithInt:0] forKey:@"mituserpw"];
      [tempProjektDic setObject: heuteDatumString forKey:@"sessiondatum"];
      [tempProjektDic setObject:[NSMutableArray array] forKey:@"sessionleserarray"];
   }
   else
   {
      //NSLog(@"PListProjektDicVonProjekt kein Projektordner");
   }
   return tempProjektDic;
}

- (BOOL)ProjektListeValidAnPfad:(NSString*)derArchivPfad
{
   //NSLog(@"ProjektListeValidAnPfad start derArchivPfad: %@",derArchivPfad);
   BOOL ProjektListeValid=NO;
   BOOL erfolg=YES;
   NSMutableArray* tempProjektArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSMutableArray* tempNeueProjekteArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   long anzOrdnerImArchiv=0;
   
   //[ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:LeseboxPfad]];
   
   long anzProjekte=[self.ProjektArray count];//Anzahl Projekte in PList
	  if (anzProjekte)
     {
        [tempNeueProjekteArray setArray:self.ProjektArray];
     }
   NSArray* tempPListProjektnamenArray=[self.ProjektArray valueForKey:@"projekt"];//Namen der Projekte in PList
   //NSLog(@"tempPListProjektnamenArray: %@",[tempPListProjektnamenArray description]);
   
   //Inhalt von Archiv prüfen
   NSMutableArray* tempAdminProjektNamenArray=[[Filemanager contentsOfDirectoryAtPath:derArchivPfad error:NULL]mutableCopy];
   
   //if ([tempAdminProjektNamenArray count])
	  
   if ([tempAdminProjektNamenArray count]&&[[tempAdminProjektNamenArray objectAtIndex:0] hasPrefix:@".DS"])					//Unsichtbare Ordner entfernen
   {
      [tempAdminProjektNamenArray removeObjectAtIndex:0];
      
   }
   anzOrdnerImArchiv=[tempAdminProjektNamenArray count];	//Anzahl Userordner im Archiv
   
   if (anzOrdnerImArchiv)//es hat schon Ordner im Archiv
   {
      //NSLog(@"tempAdminProjektNamenArray: %@",[tempAdminProjektNamenArray description]);
      //NSEnumerator* enumerator=[tempAdminProjektNamenArray objectEnumerator];
      NSString* tempObjekt;
      BOOL istOrdner=NO;
      //NSLog(@"enumerator nextObject: %@",[[enumerator nextObject]description]);
      //while (tempObjekt==[enumerator nextObject])
      for (int projektindex=0;projektindex < [tempAdminProjektNamenArray count];projektindex++)
      {
         tempObjekt =[tempAdminProjektNamenArray  objectAtIndex:projektindex];
         NSString* tempPfad=[derArchivPfad stringByAppendingPathComponent:tempObjekt];//Pfad des Userordners
         //NSLog(@"tempPfad: %@",tempPfad);
         
         if ([Filemanager fileExistsAtPath:tempPfad isDirectory:&istOrdner] && istOrdner)
         {
            NSMutableDictionary* tempProjektDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            [tempProjektDic setObject:tempPfad forKey:@"projektpfad"]; //Projektpfad einsetzen
            [tempProjektDic setObject:[tempPfad lastPathComponent] forKey:@"projekt"];
            NSArray* tempNamenArray=[Filemanager contentsOfDirectoryAtPath: tempPfad error:NULL];
            //NSLog(@"tempNamenArray: %@",[tempNamenArray description]);
            int AnzNamen= (int)[tempNamenArray count];
            if (AnzNamen)
            {
               if ([[tempNamenArray objectAtIndex:0] hasPrefix:@".DS"])
               {
                  AnzNamen--;
               }
               //NSLog(@"ProjektlisteValidAnPfad: Projekt: %@   Anz Namen: %d",tempObjekt,AnzNamen);
               
               [tempProjektDic setObject:[NSNumber numberWithInt:AnzNamen] forKey:@"anznamen"];
               
               //if ([ProjektArray containsObject:tempObjekt])
               if ([self.ProjektArray containsObject:tempProjektDic])
               {
                  //NSLog(@"Objekt schon da");
               }
               else
               {
                  //NSLog(@"Objekt neu");
                  
                  [tempProjektDic setObject:[NSNumber numberWithInt:1] forKey:@"ok"];
                  [tempProjektDic setObject:[NSNumber numberWithInt:0] forKey:@"fix"];
                  [tempProjektDic setObject:[NSNumber numberWithInt:0] forKey:@"mituserpw"];
                  
                  [tempProjektArray addObject:tempProjektDic];
               }
            }//AnzNamen
            
            //[tempProjektArray addObject:tempProjektDic];//Nur einsetzen wenn neu
         }
      }//while
      //NSLog(@"tempProjektArray : %@",[tempProjektArray description]);
      
      //NSLog(@"tempNeueProjekteArray Rest: %@",[tempNeueProjekteArray description]);
      if ([tempProjektArray count])
      {
         NSArray*tempPListArray=[self.PListDic objectForKey:@"projektarray"];
         NSEnumerator* ProjektArrayEnum=[tempProjektArray objectEnumerator];//Array der vorhandenen Ordner im Archiv
         id einProjektDic;
         while (einProjektDic=[ProjektArrayEnum nextObject]) //
         {
            NSString* tempProjektName=[einProjektDic objectForKey:@"projekt"];
            NSEnumerator* PListArrayEnum=[tempPListArray objectEnumerator];
            id einPListProjektDic;
            while (einPListProjektDic=[PListArrayEnum nextObject])//Abgleich mit Daten im Projektarray aus PList
            {
               NSString* tempPListProjektName=[einPListProjektDic objectForKey:@"projekt"];//Projekt aus plist
               if([tempProjektName isEqualToString:tempPListProjektName])//Projekt hat einen Eintrag in der plist
               {
                  if ([einPListProjektDic objectForKey:@"ok"])//objekt für ok ist in plist
                  {
                     [einProjektDic setObject: [einPListProjektDic objectForKey:@"ok"] forKey:@"ok"];
                  }
                  if ([einPListProjektDic objectForKey:@"fix"])//objekt für fix ist in plist
                  {
                     [einProjektDic setObject: [einPListProjektDic objectForKey:@"fix"] forKey:@"fix"];
                  }
                  if ([einPListProjektDic objectForKey:@"titelarray"])//objekt für titelarray ist in plist
                  {
                     [einProjektDic setObject: [einPListProjektDic objectForKey:@"titelarray"] forKey:@"titelarray"];
                  }
                  if ([einPListProjektDic objectForKey:@"mituserpw"])//objekt für mituserpw ist in plist
                  {
                     [einProjektDic setObject: [einPListProjektDic objectForKey:@"mituserpw"] forKey:@"mituserpw"];
                  }
                  
                  if ([einPListProjektDic objectForKey:@"sessiondatum"])//objekt für sessiondatum ist in plist
                  {
                     //NSLog(@"sessiondatum da: %@",[einPListProjektDic objectForKey:@"sessiondatum"]);
                     
                     [einProjektDic setObject: [einPListProjektDic objectForKey:@"sessiondatum"] forKey:@"sessiondatum"];
                  }
                  else
                  {
                     [einProjektDic setObject: heuteDatumString forKey:@"sessiondatum"];
                     [einPListProjektDic setObject: heuteDatumString forKey:@"sessiondatum"];
                     //NSLog(@"neues Sessiondatum: %@",heuteDatumString);
                     [self saveSessionDatum:heuteDatumString inProjekt:tempPListProjektName];
                     
                  }
                  
                  if ([einPListProjektDic objectForKey:@"sessionleserarray"])//objekt für sessionleserarray ist in plist
                  {
                     //NSLog(@"Projekt: %@ sessionleserarray da: %@",tempProjektName,[[einPListProjektDic objectForKey:@"sessionleserarray"]description]);
                     
                     [einProjektDic setObject: [einPListProjektDic objectForKey:@"sessionleserarray"] forKey:@"sessionleserarray"];
                  }
                  else
                  {
                     [einPListProjektDic setObject:[NSMutableArray array] forKey:@"sessionleserarray"];
                     
                     [einProjektDic setObject: [NSMutableArray array] forKey:@"sessionleserarray"];
                     //NSLog(@"neuer sessionleserarray datum: %@",[NSCalendarDate date]);
                  }
                  
                  //NSLog(@"einProjektDic: %@",[einProjektDic description]);
               }
               
            }//while ProjektArrayEnum
            
         }//while ProjektArrayEnum
         
         //NSLog(@"ProjektListeValidAnPfad: tempPListArray : %@",[tempPListArray description]);
         [self.ProjektArray setArray:tempProjektArray];
         
      }
      //NSLog(@"ProjektListeValidAnPfad: tempProjektListeArray : %@",[tempProjektListeArray description]);
      //NSLog(@"ProjektListeValidAnPfad: ProjektArray synchronisiert: %@",[ProjektArray description]);
      
   }//anz
   else//Archiv ist leer
   {
      //NSLog(@"ProjektListeValidAnPfad: Archiv ist leer");
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"Projekt anlegen"];
      [Warnung addButtonWithTitle:@"Abbrechen"];
      [Warnung setMessageText:@"Kein Projekt"];
      [Warnung setInformativeText:@"In'Archiv' muss mindestens ein Ordner für ein Projekt vorhanden sein. \r'Projekt anlegen' führt zu diesem Schritt."];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      // NSImage* RPImage = [NSImage imageNamed: @"MicroIcon"];
      
      //[Warnung setIcon:RPImage];
      long antwort=[Warnung runModal];
      //NSLog(@"antwort: %ld",antwort);
      switch (antwort)
      {
         case NSAlertFirstButtonReturn:
         {
            NSLog(@"ProjektListeValidAnPfad Projekt eingeben");
            
            [self showProjektListe:nil];
            
            if ([self.ProjektArray count])//Ergebnis von showProjektListe aus Notification
            {
               NSEnumerator* ProjektEnum=[self.ProjektArray objectEnumerator];
               id einProjekt;
               while (einProjekt=[ProjektEnum nextObject])
               {
                  BOOL OrdnereinrichtenOK=YES;
                  NSString* tempProjektName=[einProjekt objectForKey:@"projekt"];
                  NSString* tempProjektPfad=[derArchivPfad stringByAppendingPathComponent:tempProjektName];
                  
                  if (![Filemanager fileExistsAtPath:tempProjektPfad])
                  {
                     BOOL OrdnerOK=NO;
                     
                     OrdnerOK=[Utils ProjektOrdnerEinrichtenAnPfad:tempProjektPfad];
                     
                  }//neues Dir
                  
               }//while einProjekt
            }//count
            else
            {
               
               //NSLog(@"Keine Eingabe");
               
            }
            
         }break;
         case NSAlertSecondButtonReturn:
         {
            //NSLog(@"manuell");
            [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
            [NSApp terminate:NULL];
            
         }break;
         case NSAlertThirdButtonReturn:
         {
            
         }break;
      }//switch antwort
      
   }
	 	
   return YES;
   
}

- (BOOL)TitelListeValidAnPfad:(NSString*)derProjektPfad
{
   //NSLog(@"TitelListeValidAnPfad projektarray: %@",self.ProjektArray);
   NSString* tempProjekt = [derProjektPfad lastPathComponent];
   long projektindex = [[self.ProjektArray valueForKey:@"projekt"] indexOfObject:tempProjekt];
   BOOL titellisteOK=NO;
   if (!(projektindex == NSNotFound))
   {
      BOOL tempFix = [[[self.ProjektArray objectAtIndex:projektindex]objectForKey:@"fix"]boolValue];
      
      if (tempFix) // Titelliste fixiert
      {
         NSMutableArray* tempTitelListe;
         if ([[self.ProjektArray objectAtIndex:projektindex]objectForKey:@"titelarray"]) // titelarray da
         {
            tempTitelListe = (NSMutableArray*)[[self.ProjektArray objectAtIndex:projektindex]objectForKey:@"titelarray"];
            if ([tempTitelListe count])
            {
               return YES;
            }
          }
         else // leere Liste anlegen
         {
            tempTitelListe = [[NSMutableArray alloc]initWithCapacity:0];
         }
         // Titelliste erforderlich, aber leer
         // Alert
         NSAlert *Warnung = [[NSAlert alloc] init];
         [Warnung addButtonWithTitle:@"Titelliste anlegen"];
         [Warnung addButtonWithTitle:@"Fixierung aufheben"];
         //[Warnung addButtonWithTitle:@""];
         // [Warnung addButtonWithTitle:@"Abbrechen"];
         [Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Keine Titelliste"]];
         
         NSString* s1=@"Die Titel für dieses Projekt sind fixiert.";
         NSString* s2=@"Die Titelliste enthält aber noch keine Titel.";
         NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
         [Warnung setInformativeText:InformationString];
         [Warnung setAlertStyle:NSWarningAlertStyle];
         
         long antwort=[Warnung runModal];
         switch (antwort)//Liste anlegen
         {
            case NSAlertFirstButtonReturn://
            {
               NSLog(@"TitelListeValidAnPfad NSAlertFirstButtonReturn: Liste anlegen");
               //[self showTitelListe:NULL];
               [self showTitelListeInProjekt:tempProjekt];
            }break;
               
            case NSAlertSecondButtonReturn://Fix aufgeben
            {
               //NSLog(@"ProjektListeAktion NSAlertSecondButtonReturn: Fixierung fuer Projekt aufheben");
               [[self.ProjektArray objectAtIndex:projektindex] setObject:[NSNumber numberWithInt:0]forKey:@"fix"];
               //PList aktualisieren
               
               //NSLog(@"ProjektListeAktion  PListDic lesen LeseboxPfad: %@",self.LeseboxPfad);
               NSDictionary* tempAktuellePListDic=[Utils PListDicVon:self.LeseboxPfad aufSystemVolume:self.istSystemVolume];
               if ([tempAktuellePListDic objectForKey:@"projektarray"])//Es hat schon einen ProjektArray
               {
                  NSMutableArray* tempProjektArray=(NSMutableArray*)[tempAktuellePListDic objectForKey:@"projektarray"];
                  NSUInteger ProjektIndex=[[tempProjektArray valueForKey:@"projekt"] indexOfObject:tempProjekt];
                  
                  if (ProjektIndex < NSNotFound)
                  {
                     //NSLog(@"ProjektListeAktion: tempProjektArray objectAtIndex:ProjektIndex: %@",[[tempProjektArray objectAtIndex:ProjektIndex]description]);
                     [[tempProjektArray objectAtIndex:ProjektIndex]setObject:[NSNumber numberWithInt:0] forKey:@"fix"];
                     //NSLog(@"ProjektListeAktion nach reset fix: tempProjektArray objectAtIndex:ProjektIndex: %@",[[tempProjektArray objectAtIndex:ProjektIndex]description]);
                     [self saveTitelFix:NO inProjekt:tempProjekt];
                  }
                  else
                  {
                     //NSLog(@"ProjektListeAktion  : titelfix: Projekt nicht gefunden");
                  }
                  
                  
                  //NSLog(@"ProjektListeAktion: Projektarray aus PList lastObject: %@",[[[tempAktuellePListDic objectForKey:@"projektarray"]lastObject]description]);
                  //NSLog(@"ProjektListeAktion: Projektarray neu: %@",[[ProjektArray lastObject]description]);
                  
               }
               [[self.ProjektArray objectAtIndex:projektindex]setObject:[NSNumber numberWithInt:0] forKey:@"fix"];
               
               
               
               
               
            }break;
               
         }//switch

         
      }// if fix
      else
      {
         return YES; // keine Titelliste erforderlich
      }
      
   }
   
   return titellisteOK;
}


- (BOOL)NamenListeValidAnPfad:(NSString*)derProjektPfad
{
   BOOL NamenListeValid=NO;
   BOOL erfolg=YES;
   NSError* err;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   //Inhalt von Archiv prüfen
   // //NSLog(@"ProjektPfad 7:retainCount %d",[ProjektPfad retainCount]);
   
   NSArray* tempProjektNamenArray=[Filemanager contentsOfDirectoryAtPath:derProjektPfad error:&err];
   //NSLog(@"ProjektPfad 8:retainCount %d",[ProjektPfad retainCount]);
   
   int anz=0;
   if ([tempProjektNamenArray count])
   {
      
//      NSEnumerator* enumerator=[tempProjektNamenArray objectEnumerator];
      NSString* tempObjekt;
      BOOL istOrdner=NO;
//      while (tempObjekt==[enumerator nextObject])
      for (int projektindex = 0;projektindex < [tempProjektNamenArray count]; projektindex++)
      {
         NSString* tempPfad=[derProjektPfad stringByAppendingPathComponent:[tempProjektNamenArray objectAtIndex:projektindex]];
         if ([Filemanager fileExistsAtPath:tempPfad isDirectory:&istOrdner] && istOrdner)
         {
            anz++;
         }
      }
      //NSLog(@"NamenListeValidAnPfad: anz Ordner: %d\n tempAdminProjektNamenArray: %@",anz,[tempProjektNamenArray description]);
      
   }
   if (anz)
   {
      NamenListeValid=YES;
      return NamenListeValid;
   }
   return NO;
   
}



- (IBAction)showProjektStart:(id)sender
{
   [self restartAdminTimer];
   if (!ProjektStartPanel)
   {
      ProjektStartPanel=[[rProjektStart alloc]init];
   }
   //NSLog(@"showProjektStartt:ProjektArray: %@",[self.ProjektArray description]);
   
   //[ProjektPanel showWindow:self];
   NSModalSession ProjektSession=[NSApp beginModalSessionForWindow:[ProjektStartPanel window]];
   
   //NSLog(@"showProjektStart LeseboxPfad: %@",LeseboxPfad);
   //NSLog(@"ProjektArray A: %@",[[Utils ProjektArrayAusPListAnPfad:self.LeseboxPfad] description]);
   [self.ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:self.LeseboxPfad]];
   NSArray*  tempProjektNamenArray = [NSArray arrayWithArray:[Utils ProjektNamenArrayVon:[self.LeseboxPfad stringByAppendingString:@"/Archiv"]]];
   //NSLog(@"ProjektArray A: %@",[self.ProjektArray description]);
   
   //   [ProjektArray addObjectsFromArray:tempProjektNamenArray];
   //NSLog(@"showProjektStart ProjektArray B: %@",[self.ProjektArray description]);
   if ([self.ProjektArray count])
   {
      [ProjektStartPanel  setProjektArray:self.ProjektArray];
      //NSLog(@"showProjektStart setRecorderTaste: ProjektArray count InputDeviceOK: %d",self.InputDeviceOK);
      [ProjektStartPanel  setRecorderTaste:YES];
      
   }
   if ([self checkAdminPW])
   {
      //NSLog(@"showProjektStart setRecorderTaste: checkAdminPW OK");
      [ProjektStartPanel  setRecorderTaste:YES];
      
   }
   else
   {
      //NSLog(@"showProjektStart setRecorderTaste: Neue LB, noch kein checkAdminPW");
      [ProjektStartPanel  setRecorderTaste:NO];//Neue LB, noch kein checkAdminPW
      
   }
   
   //NSLog(@"showProjektStart start PListDic: %@",[self.PListDic description]);
   if ([self.PListDic objectForKey:@"lastprojekt"])
   {
      //NSLog(@"showProjektStart start lastproject: %@",[self.PListDic objectForKey:@"lastprojekt"]);
      [ProjektStartPanel selectProjekt:[self.PListDic objectForKey:@"lastprojekt"]];
   }
   
   
   long modalAntwort = [NSApp runModalForWindow:[ProjektStartPanel window]];
   
   //NSLog(@"showProjektStart Antwort: %ld",modalAntwort);
   
   [NSApp endModalSession:ProjektSession];
   [[ProjektStartPanel window] orderOut:NULL];
   
   
   //[[NSApp mainWindow] makeKeyAndOrderFront:self];
   //[[self.view window]makeKeyAndOrderFront:self];
   //[[[self view ]window]orderFront:NULL];
   
   
   
}

- (int)showProjektStartFenster
{
   [self restartAdminTimer];
   if (!ProjektStartPanel)
   {
      ProjektStartPanel=[[rProjektStart alloc]init];
   }
   //NSLog(@"showProjektStartFenster: ProjektArray: %@",[self.ProjektArray description]);
   
   //[ProjektPanel showWindow:self];
   NSModalSession ProjektSession=[NSApp beginModalSessionForWindow:[ProjektStartPanel window]];
   
   //NSLog(@"showProjektStartFenster LeseboxPfad: %@",LeseboxPfad);
   //NSLog(@"showProjektStartFenster A: %@",[[Utils ProjektArrayAusPListAnPfad:self.LeseboxPfad] description]);
   [self.ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:self.LeseboxPfad]];
   NSArray*  tempProjektNamenArray = [NSArray arrayWithArray:[Utils ProjektNamenArrayVon:[self.LeseboxPfad stringByAppendingString:@"/Archiv"]]];
   //NSLog(@"ProjektArray A: %@",[self.ProjektArray description]);
   
   //   [ProjektArray addObjectsFromArray:tempProjektNamenArray];
   //NSLog(@"showProjektStartFenster ProjektArray B: %@",[self.ProjektArray description]);
   if ([self.ProjektArray count])
   {
      [ProjektStartPanel  setProjektArray:self.ProjektArray];
      [ProjektStartPanel  setRecorderTaste:YES];
      
   }
   if ([self checkAdminPW])
   {
      //NSLog(@"showProjektStart setRecorderTaste: checkAdminPW OK");
      [ProjektStartPanel  setRecorderTaste:YES];
      
   }
   else
   {
      //NSLog(@"showProjektStart setRecorderTaste: Neue LB, noch kein checkAdminPW");
      [ProjektStartPanel  setRecorderTaste:NO];//Neue LB, noch kein checkAdminPW
      
   }
   
   //NSLog(@"showProjektStart start PListDic: %@",[self.PListDic description]);
   if ([self.PListDic objectForKey:@"lastprojekt"])
   {
      //NSLog(@"showProjektStart start lastproject: %@",[self.PListDic objectForKey:@"lastprojekt"]);
      [ProjektStartPanel selectProjekt:[self.PListDic objectForKey:@"lastprojekt"]];
   }
   
   
   int modalAntwort = (int)[NSApp runModalForWindow:[ProjektStartPanel window]];
   
   //NSLog(@"showProjektStart Antwort: %d",modalAntwort);
   
   [NSApp endModalSession:ProjektSession];
   [[ProjektStartPanel window] orderOut:NULL];
   
   
   //[[NSApp mainWindow] makeKeyAndOrderFront:self];
   //[[self.view window]makeKeyAndOrderFront:self];
   //[[[self view ]window]orderFront:NULL];
   
   return modalAntwort;
   
}

- (void)ProjektStartAktion:(NSNotification*)note
{
   
   //NSLog(@"ProjektStartAktion: %@",[[note userInfo]description]);
   [[self.view window]display];
   [[self.view window]makeKeyAndOrderFront:[self.view window]];
   
   NSString* tempProjektWahl=[[note userInfo] objectForKey:@"projektwahl"];
   //tempProjektWahl = [tempProjektWahl stringByAppendingPathComponent:tempProjektWahl];
   // //NSLog(@"ProjektStartAktion tempProjektWahl: %@",tempProjektWahl);
   
   self.ProjektPfad=[self.ArchivPfad stringByAppendingPathComponent:tempProjektWahl];
   if ([[note userInfo] objectForKey:@"projektpfad"])
   {
      self.ProjektPfad=[[note userInfo] objectForKey:@"projektpfad"];
   }
   //NSLog(@"ArchivPfad :%@ * ProjektPfad: %@",self.ArchivPfad,self.ProjektPfad);
   BOOL istOrdner;
   
   if ([[NSFileManager defaultManager]fileExistsAtPath:self.ProjektPfad isDirectory:&istOrdner] && istOrdner)
   {
      //NSLog(@"Projektordner vorhanden");
      
      // Namenordner vorhanden?
      NSMutableArray* NamenordnerArray = (NSMutableArray* )[[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.ProjektPfad error: nil];
      [NamenordnerArray removeObject:@".DS_Store"];
      //NSLog(@"Namenordner: %@",NamenordnerArray);
      if ([NamenordnerArray count])
      {
         //NSLog(@"Namenordner vorhanden");
      }
      else
      {
         //NSLog(@"Keine Namenordner vorhanden");
         NSAlert *Warnung = [[NSAlert alloc] init];
         [Warnung addButtonWithTitle:@"Namen eingeben"];
         [Warnung addButtonWithTitle:@"Abbrechen"];
         [Warnung setMessageText:@"Keine Namenordner vorhanden"];
         [Warnung setInformativeText:@"Das Projekt enthaelt noch keine Namen."];
         [Warnung setAlertStyle:NSWarningAlertStyle];
         
         NSModalResponse antwort = [Warnung runModal];
         if (antwort==NSAlertFirstButtonReturn)
         {
            //NSLog(@"ProjektStartAktion: NSAlertFirstButtonReturn: Namen eingeben");
            NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            
            //NSMutableIndexSet* neuerProjektNameIndex=[NSMutableIndexSet indexSet];
            NSMutableDictionary* neuesProjektDic=[NSMutableDictionary dictionaryWithObject:tempProjektWahl forKey:@"projekt"];
            //[neuesProjektDic setObject:[EingabeFeld stringValue] forKey:@"projekt"];
            [neuesProjektDic setObject: [NSNumber numberWithInt:1] forKey:@"ok"];
            [neuesProjektDic setObject: [NSNumber numberWithInt:0] forKey:@"fix"];
            [neuesProjektDic setObject: [NSNumber numberWithInt:0] forKey:@"mituserpw"];
            [neuesProjektDic setObject: [NSNumber numberWithInt:0] forKey:@"definitiv"];
            //[neueProjekteArray addObject:neuesProjektDic];
            //[NotificationDic setObject:ProjektArray forKey:@"projektarray"];
            [NotificationDic setObject:neuesProjektDic forKey:@"neuesprojektdic"];
            //NSLog(@"***\n   ProjektListe reportNeuesProjekt");
            //NSLog(@"neuesProjektDic: %@",[neuesProjektDic description]);
            
            NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"neuesProjekt" object:self userInfo:NotificationDic];
            //Bearbeitung in RecPlayController -> neuesProjektAktion

            
         }
         else if (antwort==NSAlertSecondButtonReturn)
         {
            //NSLog(@"ProjektStartAktion: NSAlertSecondButtonReturn");
         }
      }
      
      //NSString* UmgebungString=[[note userInfo] objectForKey:@"umgebunglabel"];
      int UmgebungZahl =[[[note userInfo] objectForKey:@"umgebung"]intValue];
      
      self.Umgebung = UmgebungZahl;
      //self.mitUserPasswort=NO;
      NSString* MitUserPWString=[[note userInfo] objectForKey:@"mituserpw"];
      if (MitUserPWString)
      {
         self.mitUserPasswort=[[[note userInfo] objectForKey:@"mituserpw"]boolValue];
         //In ProjektArray aendern
         
      }
      //NSLog(@"ProjektStartAktion ende: %@",[ProjektArray description]);
      if ([[note userInfo] objectForKey:@"aktion"])
      {
         switch ([[[note userInfo] objectForKey:@"aktion"] intValue])
         {
            case 1:
            {
               //NSLog(@"case 1");
            }break;
               
            case 2: //neues Projekt
            {
               //NSLog(@"case 2 Start mit neuem Projekt");
               [NSApp abortModal];
               
               self.AdminZugangOK=[self checkAdminZugang];
               if (self.AdminZugangOK)
               {
                  NSLog(@"Start showProjektListeVomStart ProjektPfad: %@",self.ProjektPfad);
                  [self showProjektListeVomStart];
                  
               }
               else
               {
                  if ([self checkAdminPW])
                  {
                     //NSLog(@"ProjektStartAktion: checkAdminPW: YES");
                     self.Umgebung=0;
                  }
                  else
                  {
                     //NSLog(@"ProjektStartAktion: checkAdminPW: YES");
                     [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
                     [NSApp terminate:self];
                     
                  }
               }
               
            }break;
               
            case 13:
            case 14://Abbrechen beim Start
            {
               //NSLog(@"case 13,14");
               [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
               
               [NSApp terminate:self];
            }
         }//switch
      }
      else
      {
         //NSLog(@"Kein Projektordner vorhanden");
      }
      
      
   }
   [self.view.window setIsVisible:YES];
   
   [[self.view window]makeFirstResponder:nil];
   [[self.view window]display];
   [[self.view window]makeKeyAndOrderFront:nil];
   
}

- (void)setProjektMenu
{
   //NSLog(@"RecPlay   setProjektMenu: ProjektArray %@",[ProjektArray description]);
   long anz=[self.ProjektMenu numberOfItems];
   int i=0;
   if (anz)
   {
      for (i=0;i<anz;i++)
      {
         [self.ProjektMenu removeItemAtIndex:0];
         
      }
   }
   //[ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:LeseboxPfad]];
   //NSLog(@"RecPlay   setProjektMenu: ProjektPfad: %@",ProjektPfad);
   NSString* aktuellerProjektName=[self.ProjektPfad lastPathComponent];
   for (i=0;i<[self.ProjektArray count];i++)
   {
      BOOL ProjektOK=[[[self.ProjektArray objectAtIndex:i]objectForKey:@"ok"]boolValue];
      if (ProjektOK)//Projekt ist aktiv und soll in ProjektMenu
      {
         NSString* tempItemString=[[self.ProjektArray objectAtIndex:i]objectForKey:@"projekt"];
         if (![tempItemString isEqualToString:aktuellerProjektName])
         {
            NSMenuItem* tempItem=[[NSMenuItem alloc]initWithTitle:tempItemString
                                                           action:@selector(anderesProjekt:)
                                                    keyEquivalent:@""];
            [tempItem setEnabled:YES];
            [tempItem setTarget:self];
            [self.ProjektMenu addItem:tempItem];
         }
      }//if ProjektOK
   }
   //if (AdminPlayer)
   {
      //[AdminPlayer setProjektPop:ProjektArray];
   }
}

- (IBAction)beginAdminPlayer:(id)sender
{
   [self ArchivZurListe:nil];
   [self resetRecPlay];
   [Utils stopTimeout];
   [self.RecPlayTab selectTabViewItemAtIndex:0];
   //   [self.window setIsVisible:NO];
   
    
   if(!self.AdminPlayer)
   {
      self.AdminPlayer=[[rAdminPlayer alloc]init];
   }
   
   NSLog(@"beginAdminPlayer LeseboxPfad: %@ Projekt: %@",self.LeseboxPfad,[self.ProjektPfad lastPathComponent]);

   [self.AdminPlayer showWindow:self];
   
   
   // [self setLeseb self.LeseboxPfad];
   
   
   //   [self.AblaufMenu setDelegate:self.AdminPlayer];
   // [self.ModusMenu setDelegate:self.AdminPlayer];
   //   [self.RecorderMenu setDelegate:self.AdminPlayer];
   
   //   [[self.ModusMenu itemWithTag:kRecPlayTag] setTarget:self.AdminPlayer];//Recorder
   //   [[self.ModusMenu itemWithTag:kAdminTag] setTarget:self.AdminPlayer];//Admin
   
   [Utils stopTimeout];
   //[AdminPlayer showWindow:self];
   
	     
	  //NSLog(@"beginAdminPlayer vor setAdminPlayer");
	  
   //NSLog(@"\n\n\n\n\n\n	in beginAdminPlayer vor setAdminProjektArray: AdminPlayer:      ProjektArray: \n%@",[self.ProjektArray description]);
   
   //Projektarray aktualisieren: Eventuell Aenderungen von anderen Usern auf dem Netz
   //NSLog(@"beginAdminPlayer PListDic lesen");
   NSDictionary* tempAktuellePListDic=[Utils PListDicVon:self.LeseboxPfad aufSystemVolume:NO];
   
   if ([tempAktuellePListDic objectForKey:@"projektarray"])//Es hat schon einen ProjektArray
   {
      //NSLog(@"beginAdminPlayer: Projektarray aus PList lastObject: %@",[[[tempAktuellePListDic objectForKey:@"projektarray"]lastObject]description]);
      //    [self.ProjektArray setArray:[[tempAktuellePListDic objectForKey:@"projektarray"]copy]];
      //NSLog(@"beginAdminPlayer: Projektarray neu");
      
   }
   if (self.ProjektArray && [self.ProjektArray count])
   {
      // Alles OK
   }
   else
   {
      //NSLog(@"beginAdminPlayer: Projektarray neu anlegen");
      self.ProjektArray = (NSMutableArray*)[Utils ProjektArrayAusPListAnPfad:self.LeseboxPfad];
   }
   
   //NSLog(@"beginAdminPlayer: Projektarray LAST object: %@",[[self.ProjektArray lastObject]description]);
   
   //NSLog(@"in beginAdminPlayer vor setAdminProjektArray: AdminPlayer:      ProjektArray: \n%@",[self.ProjektArray description]);
   
   
   [self.AdminPlayer setAdminPlayer:self.LeseboxPfad inProjekt:[self.ProjektPfad lastPathComponent]];
   [self.AdminPlayer setAdminProjektArray:self.ProjektArray];
   
   //NSLog(@"beginAdminPlayer nach setAdminPlayer");
   self.Umgebung=3;
   // //NSLog(@"in beginAdminPlayer vor setProjektPop: AdminPlayer:      ProjektArray: \n%@",[self.ProjektArray description]);
   
   [self.AdminPlayer setProjektPopMenu:self.ProjektArray];
   
   [self.AdminPlayer showWindow:self];
   {
      
   }
   
   
}
- (void)startAdminTimer // Ablaufzeit fuer AdminpasswortOK
{
   if ([AdminTimer isValid])
   {
      [AdminTimer invalidate];
   }
      
   {
   
      NSMutableDictionary* AdminTimerDic = [[NSMutableDictionary alloc]initWithCapacity:0];
      [AdminTimerDic setObject:[NSNumber numberWithInt:self.AdminTimeoutDelay] forKey:@"max"];
      [AdminTimerDic setObject:[NSNumber numberWithInt:self.AdminTimeoutDelay] forKey:@"pos"];
      [AdminTimerDic setObject:[NSNumber numberWithInt:self.AdminTimeoutDelay] forKey:@"counter"];
      
      AdminTimerCounter = self.AdminTimeoutDelay;
      AdminTimer=[NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(AdminTimerFunktion:)
                                                userInfo:AdminTimerDic
                                                 repeats:YES];
   }

}

- (void)AdminTimerFunktion:(NSTimer*)timer
{
   
   //NSLog(@"AdminTimerFunktion counter: %d info: %@",AdminTimerCounter,[[timer userInfo]description]);
  // //NSLog(@"AdminTimerFunktion counter: %d ",AdminTimerCounter);
   if (AdminTimerCounter)
   {
      AdminTimerCounter--;
      if (AdminTimerCounter == 0) // timer abgelaufen, PW wird ungueltig
      {
         self.AdminZugangOK = NO;
         AdminTimerCounter = -1;
         [timer invalidate];
      }
   }
}
- (void)restartAdminTimer
{
   AdminTimerCounter = self.AdminTimeoutDelay;
}

- (BOOL)checkAdminPW
{
   //NSLog(@"checkAdminPW PListDic: %@",[self.PListDic description]);
   BOOL  allOK = 0;
   if ([self.PListDic objectForKey:@"adminpw"]&&[[self.PListDic objectForKey:@"adminpw"]objectForKey:@"pw"])
   {
      if ([[[self.PListDic objectForKey:@"adminpw"]objectForKey:@"pw"]length])
      {
         allOK=YES;
      }
   }
   //NSLog(@"checkAdminPW: %d",OK);
   return allOK;
}

- (void)setArchivNamenPop
{
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   //NSLog(@"setArchivNamenPop: ProjektArray: %@",[ProjektArray description]);
   //NSLog(@"setArchivNamenPop: Utils ProjektArray: %@",[[Utils ProjektArrayAusPListAnPfad:LeseboxPfad] description]);
   
   //	[ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:LeseboxPfad]];
   
   NSDictionary* tempProjektDic;
   double ProjektIndex=[[self.ProjektArray valueForKey:@"projekt"]indexOfObject:[self.ProjektPfad lastPathComponent]];
   NSString* ProjektSessionDatum;
   if (ProjektIndex<NSNotFound)
   {
      //Dic des aktuellen Projekts im Projektarray
      tempProjektDic=[self.ProjektArray objectAtIndex:ProjektIndex];
      if ([tempProjektDic objectForKey:@"sessiondatum"])
      {
         ProjektSessionDatum=[tempProjektDic objectForKey:@"sessiondatum"];
         
      }
      else
      {
         ProjektSessionDatum=heuteDatumString;
      }
      
   }
   //NSLog(@"ProjektSessionDatum: %@",ProjektSessionDatum);
   
   
   NSMutableArray * tempProjektNamenArray=[[NSMutableArray alloc] initWithArray:[Filemanager contentsOfDirectoryAtPath:self.ProjektPfad error:NULL]];
   double AnzNamen=[tempProjektNamenArray count];											//Anzahl Leser
   //LeserNamenListe=[tempProjektNamenArray description];
   
   if ([tempProjektNamenArray count])
   {
      if ([[tempProjektNamenArray objectAtIndex:0] hasPrefix:@".DS"])					//Unsichtbare Ordner entfernen
      {
         [tempProjektNamenArray removeObjectAtIndex:0];
      }
      
   }
   
   int PopAnz=(int)[self.ArchivnamenPop numberOfItems];
   //NSLog(@"ArchivnamenPop numberOfItems %d",PopAnz);
   
   if (PopAnz>1)//Alle ausser erstes Item entfernen (Name wählen)
   {
      while (PopAnz>1)
      {
         
         //NSLog(@"ArchivnamenPop removeItemAtIndex  %@",[[ArchivnamenPop itemAtIndex:1]description]);
         [self.ArchivnamenPop removeItemAtIndex:1];
         PopAnz--;
         
      }
   }
   
   // NSString* NamenwahlString=@"Namen auswählen";
   NSString* NamenwahlString=@"Namen auswählen";
   
   NSDictionary* tempItemAttr=[NSDictionary dictionaryWithObjectsAndKeys:[NSColor purpleColor], NSForegroundColorAttributeName,[NSFont systemFontOfSize:13], NSFontAttributeName,nil];
   NSAttributedString* tempNamenItem=[[NSAttributedString alloc]initWithString:NamenwahlString attributes:tempItemAttr];
   [[self.ArchivnamenPop itemAtIndex:0]setAttributedTitle:tempNamenItem];
   
   //SessionListe konfig: vorhandene Namen im ProjektArray mit SessionListe abgleichen
   
   //Sessioleserarray
   NSArray* tempSessionLeserArray=[tempProjektDic objectForKey:@"sessionleserarray"];
   
   //NSLog(@"tempSessionLeserArray 1: %@",[tempSessionLeserArray description]);
   NSEnumerator* NamenEnum=[tempProjektNamenArray objectEnumerator];
   id einName;
   while (einName=[NamenEnum nextObject])
   {
      //NSLog(@"einName: %@",einName);
      [self.ArchivnamenPop addItemWithTitle:einName];
   }
	  
   
   
   
   NSEnumerator* SessionNamenEnum=[tempProjektNamenArray objectEnumerator];//Projektnamen im Archiv
   id einSessionName;
   int ItemIndex=1;
   while (einSessionName=[SessionNamenEnum nextObject])
   {
      //NSLog(@"setArchivNamenPop tempProjektNamenArray index: %d: einSessionName: %@",ItemIndex,einSessionName);
      BOOL NameDa=NO;
      
      
      if (tempSessionLeserArray &&[tempSessionLeserArray containsObject:einSessionName])
      {
         //NSLog(@"Name da: %@",einSessionName);
         NameDa=YES;//Name ist in der Sessionsliste
      }
      
      //		[ArchivnamenPop addItemWithTitle:einSessionName];
      NSColor* itemColor=[NSColor blackColor];
      if (NameDa)
      {
         // itemColor=[NSColor greenColor];
         NSColor* SessionColor=[NSColor colorWithDeviceRed:66.0/255 green:185.0/255 blue:37.0/255 alpha:1.0];
         itemColor=SessionColor;
         
      }
      else
      {
         //			   itemColor=[NSColor blackColor];
      }
      
      NSDictionary* tempItemAttr=[NSDictionary dictionaryWithObjectsAndKeys:itemColor, NSForegroundColorAttributeName,[NSFont systemFontOfSize:13], NSFontAttributeName,nil];
      NSAttributedString* tempNamenItem=[[NSAttributedString alloc]initWithString:einSessionName attributes:tempItemAttr];
     // [[self.ArchivnamenPop itemAtIndex:[ArchivnamenPop numberOfItems]-1]setAttributedTitle:tempNamenItem];
      if ([self.ArchivnamenPop numberOfItems]>2)
      {
         [[self.ArchivnamenPop itemAtIndex:ItemIndex]setAttributedTitle:tempNamenItem];
      }
      
      ItemIndex++;
      /*
       NSString* tempDatum;
       //Pfad des Anmerkungenordners:
       BOOL istOrdner=NO;
       NSString* tempAnmerkungenPfad=[ProjektPfad stringByAppendingPathComponent:[einName stringByAppendingPathComponent:@"Anmerkungen"]];
       if ([Filemanager fileExistsAtPath:tempAnmerkungenPfad isDirectory:&istOrdner]&&istOrdner)
       {
       NSMutableArray* tempAnmerkungenArray=(NSMutableArray*)[Filemanager directoryContentsAtPath:tempAnmerkungenPfad];
       if (tempAnmerkungenArray&&[tempAnmerkungenArray count]>1)//ein Object neben .DS
       {
       NSString* tempAnmerkung=[tempAnmerkungenArray lastObject];//neuste Aufnahme
       tempAnmerkungenPfad=[tempAnmerkungenPfad stringByAppendingPathComponent:tempAnmerkung];
       
       NSString* tempAnmerkungString=[NSString stringWithContentsOfFile:tempAnmerkungenPfad encoding:NSMacOSRomanStringEncoding error:NULL];
       if (tempAnmerkungString&&[tempAnmerkungString length])
       {
       tempDatum = [self DatumVon:tempAnmerkungString];//Datum der neusten Aufnahme des Lesers im Projekt
       //NSLog(@"Projekt: %@ Name: %@ tempDatum: %@",[ProjektPfad lastPathComponent],einName,tempDatum);
       }
       }//if Anmerkungenordner nicht leer
       
       }//if Anmerkungenordner da
       //		  BOOL neu=([tempDatum compare:ProjektSessionDatum]==NSOrderedDescending);
       //		  //NSLog(@"ProjektSessionDatum: %@ neu: %d",ProjektSessionDatum,neu);
       //NSLog(@"ProjektSessionDatum: %@",ProjektSessionDatum);
       */
   }//while
   
   //NSLog(@"setArchivnamenPop tempProjektNamenArray: %@",[tempProjektNamenArray description]);
   //	  [ArchivnamenPop addItemsWithTitles:tempProjektNamenArray];
   
   [self.Zeitfeld setSelectable:NO];
   //   [RecPlayFenster makeFirstResponder:RecPlayFenster];
   
   
}

- (void)checkSessionDatumFor:(NSString*)dasProjekt
{
   //[ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:LeseboxPfad]];
   NSUInteger ProjektIndex=[[self.ProjektArray valueForKey:@"projekt"] indexOfObject:dasProjekt];
   if (ProjektIndex<NSNotFound)
   {
      NSMutableDictionary* tempProjektDic=(NSMutableDictionary*)[self.ProjektArray objectAtIndex:ProjektIndex];
      
      int heuteTag=[Utils localTagvonDatumString: heuteDatumString];
      int heuteMonat=[Utils localMonatvonDatumString: heuteDatumString];
      int heuteJahr=[Utils localJahrvonDatumString: heuteDatumString];
      
     // NSUInteger heuteTag=[heute dayOfYear];
     // //NSLog(@"checkSessionDatumFor: %@  heuteJahr: %d heuteMonat: %d heuteTag: %d",dasProjekt,heuteJahr,heuteMonat,heuteTag);
      if ([tempProjektDic objectForKey:@"sessiondatum"])
      {
         NSString* SessionDatum=[tempProjektDic objectForKey:@"sessiondatum"];
         
         //NSLog(@"checkSessionDatumFor SessionDatum: %@",SessionDatum);
        // NSTimeInterval SessionIntervall=[[tempProjektDic objectForKey:@"sessiondatum"]timeIntervalSinceReferenceDate];
         // http://stackoverflow.com/questions/6214094/how-to-get-nsdate-day-month-and-year-in-integer-format
         //SessionDatum=[NSCalendarDate dateWithTimeIntervalSinceReferenceDate:SessionIntervall];
         
         
        // NSUInteger SessionTag=[SessionDatum dayOfYear];
         //double SessionTag = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:[NSDate date]];
         //heuteTag = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:[NSDate date]];
         int SessionTag=[Utils localTagvonDatumString: [tempProjektDic objectForKey:@"sessiondatum"]];
         int SessionJahr=[Utils localJahrvonDatumString: [tempProjektDic objectForKey:@"sessiondatum"]];
         int SessionMonat=[Utils localMonatvonDatumString: [tempProjektDic objectForKey:@"sessiondatum"]];
        
        // //NSLog(@"checkSessionDatumFor: %@  SessionDatum: %@ SessionMonat: %d SessionTag: %d",dasProjekt,SessionDatum,SessionMonat,SessionTag);
         
         //		//NSLog(@"SessionInterval: %f		heuteInterval: %f",SessionInterval,heuteInterval);
         //NSLog(@"lastJahr: %d		heuteJahr: %d",SessionJahr,heuteJahr);
         //int heuteTag=[heute dayOfYear];
         if (SessionJahr<heuteJahr)//Datum vom letzten Jahr, Tag  kann höher sein)
         {
            SessionTag=0;
         }
         
         if (SessionMonat < heuteMonat)//Datum vom letzten Monat, Tag  kann höher sein)
         {
            SessionTag=0;
         }
         
         //NSLog(@"SessionTag: %d		heute: %d",SessionTag,heuteTag);
         if ([tempProjektDic objectForKey:@"sessionleserarray"]&&[[tempProjektDic objectForKey:@"sessionleserarray"]count]) // schon Leser da
         {
            if (heuteTag>SessionTag)//letzteSession ist mindestens von gestern
            {
               //NSLog(@"CheckSessionDatum: alte Session");
               NSAlert *Warnung = [[NSAlert alloc] init];
               [Warnung addButtonWithTitle:@"Neue Session"];
               [Warnung addButtonWithTitle:@"Session weiterfuehren"];
               [Warnung setMessageText:[NSString stringWithFormat:@"Neue Session?"]];
               
               NSString* s1=@"Die aktuelle Session ist mehr als einen Tag alt.";
               NSString* s2=@"Wie weiterfahren?";
               NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
               [Warnung setInformativeText:InformationString];
               [Warnung setAlertStyle:NSWarningAlertStyle];
               
               //[Warnung setIcon:RPImage];
               NSUInteger antwort=[Warnung runModal];
               switch (antwort)
               {
                  case NSAlertFirstButtonReturn://neue Session starten
                  {
                     //NSLog(@"neue Session");
                     [self neueSession:NULL];
                  }break;
                     
                  case NSAlertSecondButtonReturn://alte Session weiterführen
                  {
                     //NSLog(@"Session behalten");
                     heuteTag=SessionTag;
                     SessionDatum=heuteDatumString;
                     [tempProjektDic setObject:heuteDatumString forKey:@"sessiondatum"];
                     [self saveSessionDatum:heuteDatumString inProjekt:dasProjekt];

                     
                  }break;
               }//switch
               
            }
            else
            {
               //NSLog(@"checkSessionDatumFor: aktuelle Session");
               
            }
         }
         else
         {
            [tempProjektDic setObject:heuteDatumString forKey:@"sessiondatum"];//Sessiondatum aktualisieren
         }
      }//if SessionDatum
      
      
   }//if <NSNotFound
   
   
}


- (IBAction)neueSession:(id)sender
{
   //NSLog(@"neueSession Umbebung: %d",self.Umgebung);
   [Utils stopTimeout];
   //double heuteTag = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:[NSDate date]];
   

   switch (self.Umgebung)
   {
      case 0:
      {
         if ([self checkAdminZugang])
         {
            //NSLog(@"neueSession in RecPlay");
            NSFileManager *Filemanager=[NSFileManager defaultManager];
            
            NSMutableDictionary* tempProjektDic;
            long ProjektIndex=[[self.ProjektArray valueForKey:@"projekt"]indexOfObject:[self.ProjektPfad lastPathComponent]];
            
            if (ProjektIndex<NSNotFound)
            {
               tempProjektDic=(NSMutableDictionary*)[self.ProjektArray objectAtIndex:ProjektIndex];
                [tempProjektDic setObject:heuteDatumString forKey:@"sessiondatum"];
               
              // //NSLog(@"neueSession: neues ProjektSessionDatum: %@",heuteDatumString);
               
               NSArray* tempSessionLeserArray=[tempProjektDic objectForKey:@"sessionleserarray"];
               //NSLog(@"alter SessionLeserArray: %@",[tempSessionLeserArray description]);
               
               [tempProjektDic setObject:[NSMutableArray array]forKey:@"sessionleserarray"];
               
               [self saveSessionDatum:heuteDatumString inProjekt:[self.ProjektPfad lastPathComponent]];
               [self clearSessionInProjekt:[self.ProjektPfad lastPathComponent]];
               
               [self setArchivNamenPop];
            }
         }
         
      }break;
         
      //case kAdminUmgebung:
          case 1:
      {
         //NSLog(@"neueSession in Admin");
         NSAlert *Warnung = [[NSAlert alloc] init];
         [Warnung addButtonWithTitle:@"Neue Session"];
         [Warnung addButtonWithTitle:@"Session weiterfuehren"];
         //	[Warnung addButtonWithTitle:@""];
         //	[Warnung addButtonWithTitle:@"Abbrechen"];
         [Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Neue Session?"]];
         
         NSString* s1=@"Soll die Sessionsliste wirklich geloescht werden?";
         NSString* s2=@"";
         NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
         [Warnung setInformativeText:InformationString];
         [Warnung setAlertStyle:NSWarningAlertStyle];
         
         NSUInteger antwort=[Warnung runModal];
         switch (antwort)
         {
            case NSAlertFirstButtonReturn://
            {
               //NSLog(@"Neue Session");
               NSFileManager *Filemanager=[NSFileManager defaultManager];
               
               NSMutableDictionary* tempProjektDic;
               NSUInteger ProjektIndex=[[self.ProjektArray valueForKey:@"projekt"]indexOfObject:[self.ProjektPfad lastPathComponent]];
               
               if (ProjektIndex<NSNotFound)
               {
                  tempProjektDic=(NSMutableDictionary*)[self.ProjektArray objectAtIndex:ProjektIndex];
                  [tempProjektDic setObject:heuteDatumString forKey:@"sessiondatum"];
                  
                  //NSLog(@"neueSession: neues ProjektSessionDatum: %@",heuteDatumString);
                  
                  NSArray* tempSessionLeserArray=[tempProjektDic objectForKey:@"sessionleserarray"];
                  //NSLog(@"alter SessionLeserArray: %@",[tempSessionLeserArray description]);
                  
                  [tempProjektDic setObject:[NSMutableArray array]forKey:@"sessionleserarray"];
                  [self saveSessionDatum:heuteDatumString inProjekt:[self.ProjektPfad lastPathComponent]];
                  [self clearSessionInProjekt:[self.ProjektPfad lastPathComponent]];
                  
                  [self setArchivNamenPop];
                  //                 [AdminPlayer reportAktualisieren:NULL];
               }
               
               
            }break;
               
            case NSAlertSecondButtonReturn://Session weiterführen
            {
               //NSLog(@"Session weiterfuehren");
               [self saveSessionDatum:heuteDatumString inProjekt:[self.ProjektPfad lastPathComponent]];
            }break;
               
         }//switch
         
      }break;
         
   }//switch
}


- (void)SessionListeAktualisieren
{
   AdminTimerCounter = self.AdminTimeoutDelay;
   //NSLog(@"SessionListeAktualisieren  PListDic lesen");
   NSDictionary* tempAktuellePListDic=[Utils PListDicVon:self.LeseboxPfad aufSystemVolume:NO];
   if ([tempAktuellePListDic objectForKey:@"projektarray"])
   {
      //NSLog(@"SessionListeAktualisieren: Projektarray aus PList: %@",[[[tempAktuellePListDic objectForKey:@"projektarray"]lastObject]description]);
      [self.ProjektArray setArray:[[tempAktuellePListDic objectForKey:@"projektarray"]copy]];
      
      //NSLog(@"beginAdminPlayer: Projektarray neu: %@",[[ProjektArray lastObject]description]);
   }
}




- (NSArray*)SessionLeserListeVonProjekt:(NSString*)dasProjekt
{
   NSArray* returnLeserListeArray=[NSArray array];
   //NSLog(@"saveSessionForUser: PList: %@",[PListDic  description]);
   //NSLog(@"SessionListeAktualisierenInProjekt: LeseboxPfad: %@",LeseboxPfad);
   
   //NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
   NSString* PListName=@"Lesebox.plist";
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   
   //NSLog(@"SessionListeAktualisierenInProjekt PListPfad: %@",PListPfad);
   //NSLog(@"***\n                SessionListeAktualisierenInProjekt: %@",[PListDic description]);
   
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (tempPListDic)
   {
      if ([tempPListDic objectForKey:@"projektarray"])
      {
         NSMutableArray* tempProjektArray=[tempPListDic objectForKey:@"projektarray"];
         NSUInteger ProjektIndex=[[tempProjektArray valueForKey:@"projekt"]indexOfObject:dasProjekt];
         if (ProjektIndex<NSNotFound)
         {
            NSMutableDictionary* tempProjektDic=(NSMutableDictionary*)[tempProjektArray objectAtIndex:ProjektIndex];
            [tempProjektDic setObject:[NSNumber numberWithInt:1] forKey:@"extern"];//Hinweis auf neuen leser
            if ([tempProjektDic objectForKey:@"sessionleserarray"])//SessionLeserArray schon da
            {
               //13.2.07
               return [tempProjektDic objectForKey:@"sessionleserarray"];
            }
            
         }//if <notFound
         //		[ProjektArray setArray:[tempProjektArray copy]];
      }//if projektarray
      
   }//if tempPListDic
   return returnLeserListeArray;
   
}

- (BOOL)anderesProjektEinrichtenMit:(NSString*)dasProjekt
{
   
   self.ProjektPfad=(NSMutableString*)[self.ArchivPfad stringByAppendingPathComponent:dasProjekt];
   //NSLog(@"\n*************								anderesProjektEinrichtenMit: Projekt: %@",dasProjekt);
   //Test, ob bei fixiertem Titel für das Projekt schon eine Titelliste vorhanden ist
   //[ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:LeseboxPfad]];
   NSUInteger ProjektIndex=[[self.ProjektArray valueForKey:@"projekt"] indexOfObject:dasProjekt];
   
   if (ProjektIndex<NSNotFound)
   {
      NSMutableDictionary* tempProjektDic=(NSMutableDictionary*)[self.ProjektArray objectAtIndex:ProjektIndex];
      //NSLog(@"anderesProjektEinrichtenMit tempProjektDic: %@",[tempProjektDic description]);
      if ([tempProjektDic objectForKey:@"sessiondatum"])
      {
         NSString* SessionDatum=[tempProjektDic objectForKey:@"sessiondatum"];
         
         //NSLog(@"anderesProjektEinrichtenMit: %@  SessionDatum: %@ heuteDatumString: %@",dasProjekt,SessionDatum, heuteDatumString);
   //      if ([SessionDatum compare:heuteDatumString]== NSOrderedDescending)
         {
            //NSLog(@"anderesProjektEinrichten: alte Session");
         }
        // else
         {
            //NSLog(@"anderesProjektEinrichten: aktuelle Session");
         }
         
      }
      
      int titelfix=[[tempProjektDic objectForKey:@"fix"]intValue];
      if (titelfix)
      {
      NSImage* roterpunkt = [NSImage imageNamed:@"fixiert"];
      [self.titelfixcheck setImage:roterpunkt];
      }
      else
      {
         NSImage* gruenerpunkt = [NSImage imageNamed:@"editierbar"];
         [self.titelfixcheck setImage:gruenerpunkt];
      
      }
      //NSLog(@"anderesProjektEinrichtenMit: %@  titelfix: %d",dasProjekt, titelfix);
      if ([tempProjektDic objectForKey:@"titelarray"]&&[[tempProjektDic objectForKey:@"titelarray"]count])
      {
         //NSLog(@"anderesProjektEinrichtenMit: %@  Titelarray: %@",dasProjekt,[[tempProjektDic objectForKey:@"titelarray"] description]);
      }
      else //noch kein titelarray, neues Projekt
      {
         if (titelfix)
         {
            NSAlert *Warnung = [[NSAlert alloc] init];
            [Warnung addButtonWithTitle:@"Titelliste anlegen"];
            [Warnung addButtonWithTitle:@"Fixierung aufheben"];
            //[Warnung addButtonWithTitle:@""];
            // [Warnung addButtonWithTitle:@"Abbrechen"];
            [Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Keine Titelliste"]];
            
            NSString* s1=@"Die Titel fuer dieses Projekt sind fixiert.";
            NSString* s2=@"Die Titelliste enthaelt aber noch keine Titel.";
            NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
            [Warnung setInformativeText:InformationString];
            [Warnung setAlertStyle:NSWarningAlertStyle];
            
            long antwort=[Warnung runModal];
            switch (antwort)//Liste anlegen
            {
               case NSAlertFirstButtonReturn://
               {
                  NSLog(@"anderesProjektEinrichtenMit NSAlertFirstButtonReturn: Liste anlegen");
                  //[self showTitelListe:NULL];
                  [self showTitelListeInProjekt:dasProjekt];
               }break;
                  
               case NSAlertSecondButtonReturn://Fix aufgeben
               {
                  //NSLog(@"anderesProjektEinrichtenMit NSAlertSecondButtonReturn: Fixierung aufheben");
                  [tempProjektDic setObject:[NSNumber numberWithInt:0]forKey:@"fix"];
                  //PList aktualisieren
                  
                  //NSLog(@"anderesProjektEinrichtenMit  PListDic lesen");
                  NSDictionary* tempAktuellePListDic=[Utils PListDicVon:self.LeseboxPfad aufSystemVolume:NO];
                  if ([tempAktuellePListDic objectForKey:@"projektarray"])//Es hat schon einen ProjektArray
                  {
                     NSMutableArray* tempProjektArray=(NSMutableArray*)[tempAktuellePListDic objectForKey:@"projektarray"];
                     NSUInteger ProjektIndex=[[tempProjektArray valueForKey:@"projekt"] indexOfObject:dasProjekt];
                     
                     if (ProjektIndex < NSNotFound)
                     {
                        //NSLog(@"anderesProjektEinrichtenMit: tempProjektArray objectAtIndex:ProjektIndex: %@",[[tempProjektArray objectAtIndex:ProjektIndex]description]);
                        [[tempProjektArray objectAtIndex:ProjektIndex]setObject:[NSNumber numberWithInt:0] forKey:@"fix"];
                        //NSLog(@"anderesProjektEinrichtenMit nach reset fix: tempProjektArray objectAtIndex:ProjektIndex: %@",[[tempProjektArray objectAtIndex:ProjektIndex]description]);
                        [self saveTitelFix:NO inProjekt:dasProjekt];
                     }
                     else
                     {
                        //NSLog(@"anderesProjektEinrichtenMit  : titelfix: Projekt nicht gefunden");
                     }
                     
                     
                     //NSLog(@"beginAdminPlayer: Projektarray aus PList lastObject: %@",[[[tempAktuellePListDic objectForKey:@"projektarray"]lastObject]description]);
                     //NSLog(@"beginAdminPlayer: Projektarray neu: %@",[[ProjektArray lastObject]description]);
                     
                  }
                  
                  NSUInteger ProjektIndex=[[self.ProjektArray valueForKey:@"projekt"] indexOfObject:dasProjekt];
                  
                  if (ProjektIndex < NSNotFound)
                  {
                     [[self.ProjektArray objectAtIndex:ProjektIndex]setObject:[NSNumber numberWithInt:0] forKey:@"fix"];
                  }
                  
                  
                  
                  
               }break;
               case NSAlertThirdButtonReturn://
               {
                  //NSLog(@"NSAlertThirdButtonReturn");
                  
               }break;
               case NSAlertThirdButtonReturn+1://cancel
               {
                  //NSLog(@"NSAlertThirdButtonReturn+1");
                  [NSApp stopModalWithCode:0];
                  //        [[self window] orderOut:NULL];
                  
               }break;
                  
            }//switch
         }//if titelfix
      }//noch keine Titelliste
      //NSLog(@"anderesProjektEinrichtenMit: tempProjektDic: %@",[tempProjektDic description]);
      if ([tempProjektDic objectForKey:@"mituserpw"])//Mit UserPW
      {
         self.mitUserPasswort=[[tempProjektDic objectForKey:@"mituserpw"]boolValue];
         
      }
      else
      {
         self.mitUserPasswort=YES;
      }
      if (self.mitUserPasswort)
      {
         [self.PWFeld setStringValue:@"Mit Passwort"];
      }
      else
      {
         [self.PWFeld setStringValue:@"Ohne Passwort"];
      }
      //NSLog(@"anderesProjektEinrichtenMit: Umgbung: %d       tempProjektDic: %@",Umgebung, [tempProjektDic description]);
   }
   //NSLog(@"\n+++++++++\nanderesProjektEinrichtenMit:  ProjektPfad: %@\nUmgebung: %d",ProjektPfad,Umgebung);
   [self setProjektMenu];
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:self.ProjektPfad forKey:@"projektpfad"];
   [NotificationDic setObject:self.ProjektPfad forKey:@"projekt"];
   [nc postNotificationName:@"Utils" object:self userInfo:NotificationDic];
   
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   switch (self.Umgebung)
   {
      case 0:
      {
         BOOL NamenListeOK=NO;
         [self resetLesebox:nil];
         [self.ProjektFeld setStringValue:[self.ProjektPfad lastPathComponent]];
         //NSLog(@"                    Umg: RecPlay:        anderesProjektEinrichtenMitProjektPfad: %@",ProjektPfad);
         
         
         NamenListeOK=[self NamenListeValidAnPfad:self.ProjektPfad];
         //NSLog(@"ProjektPfad 4a:retainCount %d",[ProjektPfad retainCount]);
         //NSLog(@"ProjektPfad 4b:retainCount %d",[ProjektPfad retainCount]);
         
         NSString* LeserNamenListe;
         [self.ProjektFeld setStringValue:dasProjekt];
         if ([Filemanager fileExistsAtPath:self.ProjektPfad])
            
         {
            [self setArchivNamenPop];
            [self.Zeitfeld setSelectable:NO];
            //            [RecPlayFenster makeFirstResponder:RecPlayFenster];
            
         }//File exists
      }break;//case RecPlay
         
      case 1:
      {
         NSLog(@"Umgebung:	Admin anderesProjektEinrichtenMit:LeseboxPfad: %@   Zu Projekt %@",self.LeseboxPfad,dasProjekt);
         
         
         
         [self beginAdminPlayer:nil];
         if ([self.AbspielzeitTimer isValid])
         {
            [self.AbspielzeitTimer invalidate];
         }
         /*
          AbspielzeitTimer=[NSTimer scheduledTimerWithTimeInterval:1.0
          target:self
          selector:@selector(Abspieltimerfunktion:)
          userInfo:nil
          repeats:YES];
          */
      }break;
   }//switch Umgebung
   return NO;
}

- (IBAction)showEinzelNamen:(id)sender
{
   if (![self checkAdminZugang])
   {
      return;
   }

   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:@"EinzelNamen" forKey:@"quelle"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"fensterschliessen" object:self userInfo:NotificationDic];

   [Utils showEinzelNamen:NULL];
   
}
- (IBAction)showNamenListe:(id)sender
{
   if (![self checkAdminZugang])
   {
      return;
   }
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:@"NamenListe" forKey:@"quelle"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"fensterschliessen" object:self userInfo:NotificationDic];


 //  if (self.Umgebung==1)
   {
      [Utils showNamenListe:sender];
   }
}

- (void)NameIstEingesetztAktion:(NSNotification*)note
{
   //NSLog(@"View NameIstEingesetztNotificationAktion: %@",[note description]);
   
   if ([[note userInfo]objectForKey:@"einsetzenOK"])
   {
      int EinsetzenOK=[[[note userInfo]objectForKey:@"einsetzenOK"]intValue];
      if (EinsetzenOK)
      {
         [self setArchivNamenPop];
         //[self setAdminPlayer:self.LeseboxPfad inProjekt:[AdminProjektPfad lastPathComponent]];
      }//if 
   }//note
}

- (void)NameIstEntferntAktion:(NSNotification*)note
{
   //NSLog(@"View NameIstEntferntAktion: %@",[note description]);
   
   if ([[note userInfo]objectForKey:@"entfernenOK"])
   {
      int EntfernenOK=[[[note userInfo]objectForKey:@"entfernenOK"]intValue];
      if (EntfernenOK==0)// Erfolg ist 0
      {
         NSArray* EntfernenPfadArray = [[note userInfo]objectForKey:@"entfernenpfadarray"];
         
         [self setArchivNamenPop];
         //[self setAdminPlayer:self.LeseboxPfad inProjekt:[AdminProjektPfad lastPathComponent]];
      }//if
   }//note
}



- (IBAction)showEinzelNamen
{
   if (![self checkAdminZugang])
   {
      return;
   }

   //if (Umgebung==kAdminUmgebung)
   {
      [Utils showEinzelNamen:NULL];
   }
}


- (void) Testknopf:(id)sender
{
   
}


- (void)savePListAktion:(NSNotification*)note
{
   //NSLog(@"savePListAktion: PList: %@",[self.PListDic  description]);
   //NSLog(@"savePListAktion adminpw aus PList: %@",[[PListDic objectForKey:@"adminpw"] description]);
   
   //	//NSLog(@"savePListAktion projektarray aus PList: %@",[[PListDic objectForKey:@"projektarray"] description]);
   
   //NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
   NSString* PListName=@"Lesebox.plist";
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   if ([self.LeseboxPfad length])
   {
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   
   //NSLog(@"PListPfad: %@",PListPfad);
   //NSLog(@"***\n                saveSessionForUser: %@",[PListDic description]);
   
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (!tempPListDic) //noch keine PList
   {
      tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      
   }
   
   if (tempPListDic)
   {
      if (![tempPListDic objectForKey:@"adminpw"])
      {
         NSString* defaultPWString=@"homer";
         const char* defaultpw=[defaultPWString UTF8String];
         NSData* defaultPWData =[NSData dataWithBytes:defaultpw length:strlen(defaultpw)];
         NSMutableDictionary* tempPWDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempPWDic setObject:@"Admin" forKey:@"name"];
         [tempPWDic setObject: [NSData data] forKey:@"pw"];
         [tempPListDic setObject: tempPWDic forKey:@"adminpw"];
         //NSLog(@"\nsavePListAktion:  Default Eintrag fuer 'pw': %@",[tempPListDic description]);
         //return;
      }
      
      if (![tempPListDic objectForKey:@"lastdate"])
      {
         [tempPListDic setObject: [NSNumber numberWithLong:heuteTagDesJahres] forKey:@"lastdate"];
      }
      
      if (![tempPListDic objectForKey:@"projektarray"])
      {
         
         [tempPListDic setObject: [[NSMutableArray alloc]initWithCapacity:0] forKey:@"projektarray"];
      }
      
      //NSLog(@"savePListAktion ProjektPfad: %@",ProjektPfad);
      if (![[self.ProjektPfad lastPathComponent]isEqualToString:@"Archiv"])
      {
         [tempPListDic setObject: [self.ProjektPfad lastPathComponent] forKey:@"lastprojekt"];
      }
      
      //[tempPListDic setObject:[NSNumber numberWithBool:busy] forKey:@"busy"];
      
      [tempPListDic setObject:[NSNumber numberWithInt:self.RPModus] forKey:@"modus"];
      [tempPListDic setObject:[NSNumber numberWithInt:self.Umgebung] forKey:@"umgebung"];
      [tempPListDic setObject:[NSNumber numberWithBool:self.mitAdminPasswort] forKey:@"mitadminpasswort"];
      [tempPListDic setObject:[NSNumber numberWithBool:self.mitUserPasswort] forKey:@"mituserpasswort"];
      [tempPListDic setObject:self.AdminPasswortDic forKey:@"adminpw"];
      [tempPListDic setObject:[NSNumber numberWithInt:(int)self.TimeoutDelay] forKey:@"timeoutdelay"];
      [tempPListDic setObject:[NSNumber numberWithLong:self.KnackDelay] forKey:@"knackdelay"];
      
      //const char* ch=[[self.ProjektPfad lastPathComponent] UTF8String];
      //NSData* d=[NSData dataWithBytes:ch length:strlen(ch)];
      NSData* leseboxpfadData = [self.LeseboxPfad dataUsingEncoding:NSUTF8StringEncoding];
      //NSData* d=[NSData dataWithBytes:LeseboxPfad length:[LeseboxPfad length]];
      //NSLog(@"**savePListAktion: d: %@",d);
      
      [tempPListDic setObject:leseboxpfadData forKey:@"leseboxpfad"];
      [self.PListDic setObject:leseboxpfadData forKey:@"leseboxpfad"];
      
      NSFileManager *Filemanager=[NSFileManager defaultManager];
      
      NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
      BOOL istDirectory=YES;
      if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
      {
         BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
      }
      
      PListPfad=[DataPath stringByAppendingPathComponent:PListName];
      
      //NSLog(@"tempUserPfad: %@",tempUserPfad);
      //NSLog(@"***\nsavePListAktion end: %@",[PListDic description]);
      BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
      //NSLog(@"\nsavePListAktion: PListOK: %d",PListOK);
      
      
   }//if tempPListDic
   
   //
   
   
   
   //	[PListDic setObject: ProjektArray forKey:@"projektarray"];
   
   
   if ([[[self.PListDic objectForKey:@"adminpw"]objectForKey:@"pw"]length]==0)
   {
      //NSLog(@"\n\nPListAktion:  Kein Eintrag fuer 'pw': %@",[self.PListDic description]);
      
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"OK"];
      [Warnung addButtonWithTitle:@"Stop"];
      [Warnung setMessageText:@"PList sichern: Kein PList-Eintrag fuer 'pw'"];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      // 31.8.07 Warnung entfernt
      //		int antwort=[Warnung runModal];
      //	if (antwort==1)
      //	{
      //	return;
      //	}
   }
   //[PListDic setObject:AdminPasswortDic forKey:@"adminpw"];
   
   if (note)
   {
      if ([[note userInfo]objectForKey:@"adminpasswort"])
      {
         const char* adminpw=[[[note userInfo]objectForKey:@"adminpasswort"] UTF8String];
         NSData* AdminPWData=[NSData dataWithBytes:adminpw length:strlen(adminpw)];
         [self.PListDic setObject:AdminPWData forKey:@"adminpasswort"];
       self.mitAdminPasswort=YES;
      }//if adminpasswort
      
      if ([[note userInfo]objectForKey:@"userpasswortarray"])
      {
         NSArray* tempUserPasswortArray=[[note userInfo]objectForKey:@"userpasswortarray"];
         
         self.mitUserPasswort=YES;
      }//if userpasswortarray
      
   }
   //const char* ch="ABCD\n";
   //const char* ch=[[[NSNumber numberWithUnsignedLong:'RPDF']stringValue] UTF8String];
   //const char* ch=[[self.ProjektPfad lastPathComponent] UTF8String];
   //NSData* projektpfadData=[NSData dataWithBytes:ch length:strlen(ch)];
   
   //NSData* d=[NSData dataWithBytes:LeseboxPfad length:[LeseboxPfad length]];
   //NSLog(@"**savePListAktion: projektpfadData: %@",projektpfadData);
  // [self.PListDic setObject:projektpfadData forKey:@"leseboxpfad"];
   
   //NSData decodieren:
   //NSData* dd=[PListDic objectForKey:@"leseboxpfad"];
   //NSLog(@"**savePListAktion decodiert: dd: %@",dd);
   //NSString* tempPfad=  [[NSString alloc] initWithData: dd encoding: NSMacOSRomanStringEncoding];
   //NSLog(@"**savePListAktion: tempPfad nach data: %@",tempPfad);
   
   NSString* tempUserPfad=[self.LeseboxPfad copy];
   //	NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
   //	NSString* PListPfad;
   //NSLog(@"savePListAktion: tempUserPfad start: %@  istSystemVolume: %d",tempUserPfad,istSystemVolume);
   if (self.istSystemVolume)
   {
      while(![[tempUserPfad lastPathComponent] isEqualToString:@"Documents"])//Pfad von User finden
      {
         tempUserPfad=[tempUserPfad stringByDeletingLastPathComponent];
         //NSLog(@"tempUserPfad: %@",tempUserPfad);
      }
      
      
      
      tempUserPfad=[tempUserPfad stringByDeletingLastPathComponent];
      //NSLog(@"tempUserPfad: %@",tempUserPfad);
      tempUserPfad=[tempUserPfad stringByAppendingPathComponent:@"Library"];
      tempUserPfad=[tempUserPfad stringByAppendingPathComponent:@"Preferences"];
      PListPfad=[tempUserPfad stringByAppendingPathComponent:PListName];
   }
   //	else //PList in Lesebox
   {
      NSFileManager *Filemanager=[NSFileManager defaultManager];
      
      NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
      BOOL istDirectory=YES;
      if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
      {
         BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
      }
      
      PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   }
   //NSLog(@"tempUserPfad: %@",tempUserPfad);
   //NSLog(@"***\nsavePListAktion: %@",[PListDic description]);
   BOOL PListOK=[self.PListDic writeToFile:PListPfad atomically:YES];
   //NSLog(@"\nsavePListAktion: PListOK: %d",PListOK);
   }
   //[tempUserInfo release];
}




- (void)saveSessionDatum:(NSString*)dasDatum inProjekt:(NSString*)dasProjekt
{
   //NSLog(@"saveSessionForUser: PList: %@",[PListDic  description]);
   //NSLog(@"saveSessionDatum: Datum: %@  LeseboxPfad: %@",dasDatum,LeseboxPfad);
   
   //NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
   NSString* PListName=@"Lesebox.plist";
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   
   //NSLog(@"PListPfad: %@",PListPfad);
   //NSLog(@"***\n                saveSessionForUser: %@",[PListDic description]);
   
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (tempPListDic)
   {
      if ([tempPListDic objectForKey:@"projektarray"])
      {
         NSMutableArray* tempProjektArray=[tempPListDic objectForKey:@"projektarray"];
         long ProjektIndex=[[tempProjektArray valueForKey:@"projekt"]indexOfObject:dasProjekt];
         if (ProjektIndex < NSNotFound)
         {
            [[tempProjektArray objectAtIndex:ProjektIndex] setObject:dasDatum forKey:@"sessiondatum"];
         }//if <notFound
      }//if projektarray
   }//if tempPListDic
   
   BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES ];
   //NSLog(@"PListOK: %d",PListOK);
   
   //[tempUserInfo release];
}

- (void)saveNeuenProjektArray:(NSArray*)derProjektArray
{
   //NSLog(@"saveNeuenProjektArray");
   //NSLog(@"saveNeuenProjektArray: derProjektArray: %@",[derProjektArray   description]);
   //NSLog(@"saveNeuenProjektArray: ProjektNamen: %@  LeseboxPfad: %@",[[derProjektArray valueForKey:@"projekt"]description],LeseboxPfad);
   
   
   
   //NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
   NSString* PListName=@"Lesebox.plist";
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   
   NSMutableDictionary* tempPListDic;
   
   tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   
   //NSLog(@"saveNeuenProjektArray: tempPListDic: %@",[[tempPListDic objectForKey:@"projektarray" ]description]);
   
   if (tempPListDic)
   {
      [tempPListDic setObject:derProjektArray forKey:@"projektarray"];
      self.ProjektArray =(NSMutableArray*)derProjektArray;
      [self.PListDic setObject:derProjektArray forKey:@"projektarray"];
   }//if tempPListDic
   else
   {
      //31.8.07 Noch keine PList bei Einrichten der neuen LB
      tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [tempPListDic setObject:derProjektArray forKey:@"projektarray"];
   }
   
   BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
   //NSLog(@"PListOK: %d",PListOK);
   
   
   
   // Kontrolle
    tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   
   //NSLog(@"tempPListDic nach: %@",[tempPListDic description]);
   //NSLog(@"self.ProjektArray nach: %@",[self.ProjektArray description]);
   //[tempUserInfo release];
}

- (void)saveNeuesProjekt:(NSDictionary*)derProjektDic
{
   NSString* ProjektName=[derProjektDic objectForKey:@"projekt"];
   //NSLog(@"				saveNeuesProjekt");
   //NSLog(@"saveNeuesProjekt: derProjektDic: %@",[derProjektDic  description]);
   //NSLog(@"saveNeuesProjekt: ProjektName: %@  LeseboxPfad: %@",ProjektName,LeseboxPfad);
   NSString* ArchivPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Archiv"];
   self.ProjektPfad=(NSMutableString*)[ArchivPath stringByAppendingPathComponent:ProjektName];
   
  // NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
   NSString* PListName=@"Lesebox.plist";
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      //NSLog(@"neue PList");
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   
   //NSLog(@"saveNeuesProjekt PListPfad: %@",PListPfad);
   //NSLog(@"***\n                saveSessionForUser: %@",[PListDic description]);
   
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   NSMutableArray* tempProjektArray;
   if (tempPListDic)	//PList schon vorhanden
   {
      //NSLog(@"tempPListDic da");
      if ([tempPListDic objectForKey:@"projektarray"])
      {
         tempProjektArray=[tempPListDic objectForKey:@"projektarray"];
         //NSLog(@"***	saveNeuesProjekt tempProjektArray: %@",[tempProjektArray description]);
      }//if projektarray
      else
      {
         tempProjektArray=[[NSMutableArray alloc]initWithCapacity:0];
      }
      NSUInteger ProjektIndex=[[tempProjektArray valueForKey:@"projekt"]indexOfObject:ProjektName];
      if (ProjektIndex==NSNotFound)
      {
         [tempProjektArray addObject:[derProjektDic copy]];
      }//if notFound
      else
      {
         //			[tempProjektArray addObject:[derProjektDic copy]];
      }
      [self.ProjektArray addObject:[derProjektDic copy]];
      //NSLog(@"saveNeuesProjekt: ProjektArray nach add: %@",[ProjektArray description]);
      [tempPListDic setObject:tempProjektArray forKey:@"projektarray"];
      
      BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
      //NSLog(@"PListOK: %d",PListOK);
      
   }//if tempPListDic
   
   else	//keine PList
   {
      [self.ProjektArray addObject:[derProjektDic copy]];
      
      NSMutableDictionary* tempNeuesProjektDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      tempProjektArray=[[NSMutableArray alloc]initWithCapacity:0];
      [tempProjektArray addObject:[derProjektDic copy]];
      //NSLog(@"saveNeuesProjekt  tempProjektArray: %@",[tempProjektArray description]);
      [tempNeuesProjektDic setObject:tempProjektArray forKey:@"projektarray"];
      //[tempNeuesProjektDic setObject:ProjektName forKey:@"neuesprojektname"];
      //NSLog(@"vor savePList: tempNeuesProjektDic: %@",[tempNeuesProjektDic description]);
      BOOL savePListOK=[self savePList:tempNeuesProjektDic anPfad:self.LeseboxPfad];
      
      //NSLog(@"nach savePList: savePListOK: %d",savePListOK);
      
      
      
      
   }
   
   
   
   
   
}

- (void)saveTitelListe:(NSArray*)dieTitelListe inProjekt:(NSString*)dasProjekt
{
   
   //NSLog(@"saveTitelListe: dieTitelListe: %@ Projekt: %@",[dieTitelListe  description],dasProjekt);
   
   //NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
   NSString* PListName=@"Lesebox.plist";
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   
   //NSLog(@"PListPfad: %@",PListPfad);
   
   //NSLog(@"***\n   saveTitelListe           saveSessionForUser PList vorhanden : %@",[self.PListDic description]);

   
   // TitelArray in ProjektArray einsetzen
   NSUInteger ProjektIndex=[[self.ProjektArray valueForKey:@"projekt"]indexOfObject:dasProjekt];
   if (ProjektIndex<NSNotFound)//Projekt ist da
   {
      [[self.ProjektArray objectAtIndex:ProjektIndex]setObject:[dieTitelListe copy]forKey:@"titelarray"];
   }
   //NSLog(@"self.ProjektArray objectAtIndex:ProjektIndex: %@",[self.ProjektArray objectAtIndex:ProjektIndex]);
   
   
   // TitelArray in PList einsetzen
   NSMutableArray* tempProjektArray=[self.PListDic objectForKey:@"projektarray"];
   NSUInteger PListIndex=[[tempProjektArray valueForKey:@"projekt"]indexOfObject:dasProjekt];
   if (PListIndex<NSNotFound)//Projekt ist da
   {
      [[[self.PListDic objectForKey:@"projektarray"] objectAtIndex:PListIndex]setObject:[dieTitelListe copy]forKey:@"titelarray"];
      
   
   }//if notFound

   
   //NSLog(@"***\n      saveTitelListe     PList nach : %@",[self.PListDic description]);
   
   // PList sichern
   BOOL PListOK=[self.PListDic writeToFile:PListPfad atomically:YES];
   //NSLog(@"PListOK: %d",PListOK);
   
   //[tempUserInfo release];
}


- (void)saveTitelFix:(BOOL)derStatus inProjekt:(NSString*)dasProjekt
{
   
   //NSLog(@"saveTitelFix: derStatus: %d Projekt: %@",derStatus ,dasProjekt);
   
   //NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
   NSString* PListName=@"Lesebox.plist";
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   // Data-Ordner da?
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   
   //NSLog(@"PListPfad: %@",PListPfad);
   //NSLog(@"***\n                saveSessionForUser: %@",[PListDic description]);
   
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (tempPListDic)
   {
      if ([tempPListDic objectForKey:@"projektarray"])
      {
         NSMutableArray* tempProjektArray=[tempPListDic objectForKey:@"projektarray"];
         long ProjektIndex=[[tempProjektArray valueForKey:@"projekt"]indexOfObject:dasProjekt];
         if (ProjektIndex<NSNotFound)//Projekt ist da
         {
            [[tempProjektArray objectAtIndex:ProjektIndex]setObject:[NSNumber numberWithBool:derStatus]forKey:@"fix"];
         }//if notFound
         else
         {
            
         }
      }//if projektarray
      
   }//if tempPListDic
   
   BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
   //NSLog(@"PListOK: %d",PListOK);
   if (self.PListDic)
   {
      if ([self.PListDic objectForKey:@"projektarray"])
      {
         NSMutableArray* tempProjektArray=[self.PListDic objectForKey:@"projektarray"];
         long ProjektIndex=[[tempProjektArray valueForKey:@"projekt"]indexOfObject:dasProjekt];
         if (ProjektIndex<NSNotFound)//Projekt ist da
         {
            [[[self.PListDic objectForKey:@"projektarray"] objectAtIndex:ProjektIndex]setObject:[NSNumber numberWithBool:derStatus]forKey:@"fix"];
         }//if notFound
         else
         {
            
         }
         [[self.ProjektArray objectAtIndex:ProjektIndex]setObject:[NSNumber numberWithBool:derStatus] forKey:@"fix"];
         
         if (derStatus)
         {
            NSImage* roterpunkt = [NSImage imageNamed:@"fixiert"];
            [self.titelfixcheck setImage:roterpunkt];
         }
         else
         {
            NSImage* gruenerpunkt = [NSImage imageNamed:@"editierbar"];
            [self.titelfixcheck setImage:gruenerpunkt];
         }

      }//if projektarray
      
   }//if tempPListDic

   
   
   
   //[tempUserInfo release];
}

- (void)saveUserPasswortDic:(NSDictionary*)derPasswortDic
{
   //NSLog(@"saveUserPasswortArray: PasswortDic: %@",[derPasswortDic  description]);
   //NSLog(@"saveUserPasswortArray: PasswortDic: %@  LeseboxPfad: %@",[derPasswortDic  description],self.LeseboxPfad);
   
   //NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
   NSString* PListName=@"Lesebox.plist";
   NSString* PListPfad;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   //NSLog(@"PListPfad: %@",PListPfad);
   NSString* tempUserName=[derPasswortDic objectForKey:@"name"];
   if (tempUserName &&[tempUserName length])
   {
      NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
      if (tempPListDic)
      {
         NSMutableArray* tempUserPWArray=(NSMutableArray*)[tempPListDic objectForKey:@"userpasswortarray"];
         if (tempUserPWArray)//Array schon da
         {
            NSUInteger UserIndex=[[tempUserPWArray valueForKey:@"name"]indexOfObject:tempUserName];
            if (UserIndex==NSNotFound)//User hat noch kein pw
            {
               [tempUserPWArray addObject:derPasswortDic];
            }
            else
            {
               [tempUserPWArray replaceObjectAtIndex:UserIndex withObject:derPasswortDic];
            }
         }
         else
         {
            tempUserPWArray=[NSMutableArray arrayWithObject:derPasswortDic];
         }
         [tempPListDic setObject:tempUserPWArray forKey:@"userpasswortarray"];
      }//if tempPListDic
      
      BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
      
      //NSLog(@"saveUserPasswortArray PListOK: %d",PListOK);
   }//if Username
}

- (void)saveUserPasswortArray:(NSArray*)derPasswortArray
{
   //NSLog(@"saveUserPasswortArray: PasswortArray: %@",[derPasswortArray  description]);
   //NSLog(@"saveUserPasswortArray: saveUserPasswortArray: %@  LeseboxPfad: %@",[derPasswortArray  description],self.LeseboxPfad);
   
   //NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
   NSString* PListName=@"Lesebox.plist";
   NSString* PListPfad;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   //NSLog(@"PListPfad: %@",PListPfad);
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (tempPListDic)
   {
      [tempPListDic setObject:derPasswortArray forKey:@"userpasswortarray"];
   }//if tempPListDic
   
   BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
   //NSLog(@"saveUserPasswortArray PListOK: %d",PListOK);
}


- (void)saveAdminPasswortDic:(NSDictionary*)derPasswortDic
{
   //NSLog(@"saveAdminPasswortDic: PasswortArray: %@",[derPasswortArray  description]);
   //NSLog(@"saveAdminPasswortDic: AdminPasswortDic: %@  LeseboxPfad: %@",[derPasswortDic  description],self.LeseboxPfad);
   
   //NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
   NSString* PListName=@"Lesebox.plist";
   
   NSString* PListPfad;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   //NSLog(@"PListPfad: %@",PListPfad);
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (tempPListDic)
   {
      [tempPListDic setObject:derPasswortDic forKey:@"adminpw"];
   }//if tempPListDic
   
   BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
   //NSLog(@"saveAdminPasswortDic PListOK: %d",PListOK);
}



- (void)saveSessionForUser:(NSString*)derUser inProjekt:(NSString*)dasProjekt
{
   //NSLog(@"saveSessionForUser: PList: %@",[self.PListDic  description]);
   //NSLog(@"saveSessionForUser: LeseboxPfad: %@",LeseboxPfad);
   //NSLog(@"saveSessionForUser: derUser: %@ dasProjekt: %@",derUser, dasProjekt);
   
   //NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
   NSString* PListName=@"Lesebox.plist";
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   
   //NSLog(@"PListPfad: %@",PListPfad);
   //NSLog(@"***\n                saveSessionForUser: %@",[PListDic description]);
   
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (tempPListDic)
   {
      
      if ([tempPListDic objectForKey:@"projektarray"])
      {
         NSMutableArray* tempProjektArray=[tempPListDic objectForKey:@"projektarray"];
         NSUInteger ProjektIndex=[[tempProjektArray valueForKey:@"projekt"]indexOfObject:dasProjekt];
         if (ProjektIndex<NSNotFound)
         {
            NSMutableDictionary* tempProjektDic=(NSMutableDictionary*)[tempProjektArray objectAtIndex:ProjektIndex];
            [tempProjektDic setObject:[NSNumber numberWithInt:1] forKey:@"extern"];//Hinweis auf neuen leser
            if ([tempProjektDic objectForKey:@"sessionleserarray"])//SessionLeserArray schon da
            {
               if (![[tempProjektDic objectForKey:@"sessionleserarray"]containsObject:derUser])
               {
                  [[tempProjektDic objectForKey:@"sessionleserarray"]addObject:derUser];
               }
            }
            else
            {
               [tempProjektDic setObject:[NSArray arrayWithObject:derUser] forKey:@"sessionleserarray"];
               
            }
            
            
         }//if <notFound
         //		[ProjektArray setArray:[tempProjektArray copy]];
      }//if projektarray
      
   }//if tempPListDic
   
   
   BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
   //NSLog(@"saveSessionForUser  PListOK: %d",PListOK);
   
   
   
   self.PListDic = tempPListDic;
   
   
   
   //[tempUserInfo release];
}

- (void)clearSessionInProjekt:(NSString*)dasProjekt
{
   //NSLog(@"clearSessionInProjekt: PList: %@",[PListDic  description]);
   //NSLog(@"clearSessionInProjekt: LeseboxPfad: %@",self.LeseboxPfad);
   
   
   
   //NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
   NSString* PListName=@"Lesebox.plist";
   
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   
   //NSLog(@"PListPfad: %@",PListPfad);
   //NSLog(@"***\n                saveSessionForUser: %@",[PListDic description]);
   
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (tempPListDic)
   {
      
      if ([tempPListDic objectForKey:@"projektarray"])
      {
         NSMutableArray* tempProjektArray=[tempPListDic objectForKey:@"projektarray"];
         NSUInteger ProjektIndex=[[tempProjektArray valueForKey:@"projekt"]indexOfObject:dasProjekt];
         if (ProjektIndex<NSNotFound)
         {
            NSMutableDictionary* tempProjektDic=(NSMutableDictionary*)[tempProjektArray objectAtIndex:ProjektIndex];
            [tempProjektDic setObject:[NSArray array] forKey:@"sessionleserarray"];
            [tempProjektDic setObject:[NSNumber numberWithInt:0] forKey:@"extern"];
         }//if <notFound
      }//if projektarray
      
   }//if tempPListDic
   
   BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES ];
   //NSLog(@"clearSessioInProjekt   PListOK: %d",PListOK);
   
   //[tempUserInfo release];
}


- (BOOL)savePList:(NSDictionary*)diePList anPfad:(NSString*)derLeseboxPfad
{
   BOOL PListOK=NO;
   NSString* tempUserPfad=[derLeseboxPfad copy];
   //NSLog(@"savePList: tempUserPfad start: %@",tempUserPfad);
   
   // NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
   NSString* PListName=@"Lesebox.plist";
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   //NSLog(@"PListPfad: %@",PListPfad);
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (!tempPListDic) //noch keine PList
   {
      //NSLog(@"savePList: neue PList anlegen");
      tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      
   }
   if (tempPListDic)
   {
      if (![tempPListDic objectForKey:@"adminpw"])
      {
         NSString* defaultPWString=@"homer";
         const char* defaultpw=[defaultPWString UTF8String];
         NSData* defaultPWData =[NSData dataWithBytes:defaultpw length:strlen(defaultpw)];
         NSMutableDictionary* tempPWDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempPWDic setObject:@"Admin" forKey:@"name"];
         [tempPWDic setObject: [NSData data] forKey:@"pw"];
         [tempPListDic setObject: tempPWDic forKey:@"adminpw"];
         //NSLog(@"\nsavePList:  Default Eintrag fuer 'pw': %@",[tempPListDic description]);
         //return;
      }
      
      if (![tempPListDic objectForKey:@"lastdate"])
      {
         [tempPListDic setObject: [NSNumber numberWithLong:heuteTagDesJahres] forKey:@"lastdate"];
      }
      
      if (![tempPListDic objectForKey:@"projektarray"])
      {
         if ([diePList objectForKey:@"projektarray"])
         {
            [tempPListDic setObject:[diePList objectForKey:@"projektarray"] forKey:@"projektarray"];
         }
         else	//leerer array
         {
            [tempPListDic setObject: [[NSMutableArray alloc]initWithCapacity:0] forKey:@"projektarray"];
         }
      }
      
      if (![[self.ProjektPfad lastPathComponent]isEqualToString:@"Archiv"])
      {
         if ([self.ProjektPfad length])
         {
         [tempPListDic setObject: [self.ProjektPfad lastPathComponent] forKey:@"lastprojekt"];
            const char* ch=[[self.ProjektPfad lastPathComponent] UTF8String];
            NSData* d=[NSData dataWithBytes:ch length:strlen(ch)];
            
            //NSData* d=[NSData dataWithBytes:LeseboxPfad length:[LeseboxPfad length]];
            //NSLog(@"**savePListAktion: d: %@",d);
            [tempPListDic setObject:d forKey:@"leseboxpfad"];

         }
      }
      
      //[tempPListDic setObject:[NSNumber numberWithBool:busy] forKey:@"busy"];
      
      [tempPListDic setObject:[NSNumber numberWithInt:self.RPModus] forKey:@"modus"];
      [tempPListDic setObject:[NSNumber numberWithInt:self.Umgebung] forKey:@"umgebung"];
      [tempPListDic setObject:[NSNumber numberWithBool:self.mitAdminPasswort] forKey:@"mitadminpasswort"];
      [tempPListDic setObject:[NSNumber numberWithBool:self.mitUserPasswort] forKey:@"mituserpasswort"];
      [tempPListDic setObject:self.AdminPasswortDic forKey:@"adminpw"];
      [tempPListDic setObject:[NSNumber numberWithInt:(int)self.TimeoutDelay] forKey:@"timeoutdelay"];
      [tempPListDic setObject:[NSNumber numberWithInt:(int)self.KnackDelay] forKey:@"knackdelay"];
      
      
      
      //NSFileManager *Filemanager=[NSFileManager defaultManager];
      
      
      //NSLog(@"tempUserPfad: %@",tempUserPfad);
      //NSLog(@"***\nsavePListAktion: %@",[self.PListDic description]);
      PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
      //NSLog(@"\nsavePList: PListOK: %d",PListOK);
      
      
   }
   
   //NSLog(@"savePList   PListOK: %d",PListOK);
   return PListOK;
   
}
- (BOOL)saveProjektArrayInPList:(NSDictionary*)diePList anPfad:(NSString*)derLeseboxPfad
{
   // Neuer ProjektArray, eventuell fehlende Items ergaenzen
   BOOL PListOK=NO;
   NSString* tempUserPfad=[derLeseboxPfad copy];
   //NSLog(@"savePList: tempUserPfad start: %@",tempUserPfad);
   
  // NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
   NSString* PListName=@"Lesebox.plist";
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   //NSLog(@"PListPfad: %@",PListPfad);
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (!tempPListDic) //noch keine PList
   {
      //NSLog(@"savePList: neue PList anlegen");
      tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      
   }
   if (tempPListDic)
   {
      if (![tempPListDic objectForKey:@"adminpw"])
      {
         NSString* defaultPWString=@"homer";
         const char* defaultpw=[defaultPWString UTF8String];
         NSData* defaultPWData =[NSData dataWithBytes:defaultpw length:strlen(defaultpw)];
         NSMutableDictionary* tempPWDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempPWDic setObject:@"Admin" forKey:@"name"];
         [tempPWDic setObject: [NSData data] forKey:@"pw"];
         [tempPListDic setObject: tempPWDic forKey:@"adminpw"];
         //NSLog(@"\nsavePList:  Default Eintrag fuer 'pw': %@",[tempPListDic description]);
         //return;
      }
      
      if (![tempPListDic objectForKey:@"lastdate"])
      {
         [tempPListDic setObject: [NSNumber numberWithLong:heuteTagDesJahres] forKey:@"lastdate"];
      }
      
      {
         if ([diePList objectForKey:@"projektarray"])
         {
            [tempPListDic setObject:[diePList objectForKey:@"projektarray"] forKey:@"projektarray"];
         }
         else	//leerer array
         {
            [tempPListDic setObject: [[NSMutableArray alloc]initWithCapacity:0] forKey:@"projektarray"];
         }
      }
      
      if (self.ProjektPfad && (![[self.ProjektPfad lastPathComponent]isEqualToString:@"Archiv"]))
      {
         [tempPListDic setObject: [self.ProjektPfad lastPathComponent] forKey:@"lastprojekt"];
      }
      
      //[tempPListDic setObject:[NSNumber numberWithBool:busy] forKey:@"busy"];
      
      [tempPListDic setObject:[NSNumber numberWithInt:self.RPModus] forKey:@"modus"];
      [tempPListDic setObject:[NSNumber numberWithInt:self.Umgebung] forKey:@"umgebung"];
      [tempPListDic setObject:[NSNumber numberWithBool:self.mitAdminPasswort] forKey:@"mitadminpasswort"];
      [tempPListDic setObject:[NSNumber numberWithBool:self.mitUserPasswort] forKey:@"mituserpasswort"];
      //[tempPListDic setObject:self.AdminPasswortDic forKey:@"adminpw"];
      [tempPListDic setObject:[NSNumber numberWithInt:(int)self.TimeoutDelay] forKey:@"timeoutdelay"];
      [tempPListDic setObject:[NSNumber numberWithLong:self.KnackDelay] forKey:@"knackdelay"];
      
      NSString* defaultPWString=@"homer";
      const char* defaultpw=[defaultPWString UTF8String];
      NSData* defaultPWData =[NSData dataWithBytes:defaultpw length:strlen(defaultpw)];
      NSMutableDictionary* tempPWDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      
      [tempPWDic setObject:@"Admin" forKey:@"name"];
      [tempPWDic setObject:defaultPWData forKey:@"pw"];
      
      [tempPListDic setObject:tempPWDic forKey:@"adminpw"];//AdminPasswort muss vorhanden sein
     
      NSData* d=[NSData dataWithBytes:(__bridge const void *)(derLeseboxPfad) length:[derLeseboxPfad length]];
      //NSLog(@"**savePListAktion: d: %@",d);
      [tempPListDic setObject:d forKey:@"leseboxpfad"];
      
      
      NSFileManager *Filemanager=[NSFileManager defaultManager];
      
      
      //NSLog(@"tempUserPfad: %@",tempUserPfad);
      //NSLog(@"***\nsavePListAktion: %@",[self.PListDic description]);
      PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
      //NSLog(@"\nsavePList: PListOK: %d",PListOK);
      
      
   }
   
   //NSLog(@"savePList   PListOK: %d",PListOK);
   return PListOK;
   
}

- (BOOL)checkAdminZugang
{
   if (self.AdminZugangOK)
   {
      [self restartAdminTimer];
      return YES;
   }
   BOOL ZugangOK=NO;
   
   self.mitAdminPasswort=YES;
   //NSLog(@"checkAdminZugang: mitAdminPasswort: %d",self.mitAdminPasswort);
   if (self.mitAdminPasswort)
   {
      NSMutableDictionary* tempAdminPWDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      
      if ((![self.PListDic objectForKey:@"adminpw"])||([[[self.PListDic objectForKey:@"adminpw"]objectForKey:@"pw"]length]==0))//kein Eintrag da
      {
         //NSLog(@"kein Eintrag");
         [tempAdminPWDic setObject:@"Admin" forKey:@"name"];
         [tempAdminPWDic setObject:[NSData data] forKey:@"pw"];
      }
      else
      {
         tempAdminPWDic=[self.PListDic objectForKey:@"adminpw"];
         //NSLog(@"Eintrag da: %@",[tempAdminPWDic description]);
      }
      
      
      NSData* tempPWData=[tempAdminPWDic objectForKey:@"pw"];
      if ([tempPWData length])//Passwort existiert
      {
         //NSLog(@"checkAdminZugang: Passwort abfragen");
         ZugangOK=[Utils confirmPasswort:[tempAdminPWDic copy]];
      }
      else//keinPasswort
      {
         //NSLog(@"checkAdminZugang pw="": neues Passwort eingeben");
         NSDictionary* tempNeuesPWDic=[Utils changePasswort:[tempAdminPWDic copy]];
         //NSLog(@"checkAdminZugang tempNeuesPWDic: %@",[tempNeuesPWDic description]);
         if ([[tempNeuesPWDic objectForKey:@"pw"]length])//neues PW ist da
         {
            //NSLog(@"tempNeuesPWDic: %@",[tempNeuesPWDic description]);
            //[PListDic setObject:AdminPasswortDic forKey:@"adminpw"];
            [self.PListDic setObject:[tempNeuesPWDic copy] forKey:@"adminpw"];
            //Passwort in PList sichern
            //NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
            NSString* PListName=@"Lesebox.plist";
            NSString* PListPfad;
            NSFileManager *Filemanager=[NSFileManager defaultManager];
            NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
            BOOL istDirectory=YES;
            if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))//Ordner Data schon da?
            {
               BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];//Ordner Data einrichten
            }
            
            PListPfad=[DataPath stringByAppendingPathComponent:PListName];
            
            //NSLog(@"checkAdminZugang: PListPfad: %@",PListPfad);
            NSMutableDictionary* tempPListDic;
            if ([Filemanager fileExistsAtPath:PListPfad])
            {
               //PList holen
               //NSLog(@"PList holen");
               tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
            }
            else
            {
               //NSLog(@"neue PList");
               tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
               //NSLog(@"neue PList geholt");
            }
            
            //NSLog(@"checkAdminZugang: tempPListDic: %@",[tempPListDic description]);
            
            if (tempPListDic)
            {
               //NSLog(@"neue PList existiert");
               [tempPListDic setObject: tempNeuesPWDic forKey:@"adminpw"];
               
               if (![tempPListDic objectForKey:@"lastdate"])
               {
                  [tempPListDic setObject: [NSNumber numberWithLong:heuteTagDesJahres] forKey:@"lastdate"];
               }
               //NSLog(@"checkAdminZugang: tempPListDic mit lastDate: %@",[tempPListDic description]);
               
               if (![[self.ProjektPfad lastPathComponent]isEqualToString:@"Archiv"])
               {
                  [tempPListDic setObject: [self.ProjektPfad lastPathComponent] forKey:@"lastprojekt"];
               }
               //NSLog(@"checkAdminZugang: tempPListDic mit lastProjekt: %@",[tempPListDic description]);
               
               //aus savePListAktion:
               //	[tempPListDic setObject:[NSNumber numberWithBool:busy] forKey:@"busy"];
               //	[tempPListDic setObject:[NSNumber numberWithInt:RPModus] forKey:@"modus"];
               //	[tempPListDic setObject:[NSNumber numberWithInt:Umgebung] forKey:@"umgebung"];
               //	[tempPListDic setObject:[NSNumber numberWithBool:mitAdminPasswort] forKey:@"mitadminpasswort"];
               //	[tempPListDic setObject:[NSNumber numberWithBool:mitUserPasswort] forKey:@"mituserpasswort"];
               //	[tempPListDic setObject:[NSNumber numberWithInt:(int)TimeoutDelay] forKey:@"timeoutdelay"];
               //	[tempPListDic setObject:[NSNumber numberWithInt:KnackDelay] forKey:@"knackdelay"];
               
               //	const char* ch=[[ProjektPfad lastPathComponent] UTF8String];
               //	NSData* d=[NSData dataWithBytes:ch length:strlen(ch)];
               
               //	NSData* d=[NSData dataWithBytes:LeseboxPfad length:[LeseboxPfad length]];
               //	//NSLog(@"**savePListAktion: d: %@",d);
               //	[tempPListDic setObject:d forKey:@"leseboxpfad"];
               
               
               
               //NSLog(@"tempUserPfad: %@",tempUserPfad);
               //NSLog(@"***\ncheckAdminZugang tempPListDic: %@",[tempPListDic description]);
               BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
               //NSLog(@"\nsavePListAktion: PListOK: %d",PListOK);
               
               
            }
            
            
            
            // ende PList sichern
            
            self.AdminPasswortDic =[tempNeuesPWDic copy];
            
            //NSLog(@"PListDic in checkAdminZugang: %@",[PListDic description]);
            ZugangOK=YES;
         }
         else
         {
            //NSLog(@"checkAdminZugang: neues Passwort misslungen");
            //neues PW misslungen
         }
      }
      
      
   }//mitAdminPasswort
   else
   {
      ZugangOK=YES;
   }
   if (ZugangOK)
   {
      [self startAdminTimer];
   }
   self.AdminZugangOK = ZugangOK;
   return ZugangOK;
}

- (void)showChangePasswort:(id)sender
{
   if (![self checkAdminZugang])
   {
      return;
   }

   switch (self.Umgebung)
   {
      case 0:
      {
         if ([self.Leser length])
         {
            //NSLog(@"changepasswort von RecPlayUmgebung");
            [Utils stopTimeout];
            BOOL PasswortOK=NO;
            NSData* tempPWData=[NSData data];
            NSEnumerator* PWEnum=[self.UserPasswortArray objectEnumerator];//vorhandenen PWDics
            id einNamenDic;
            int index=0;
            int position=-1;
            while(einNamenDic=[PWEnum nextObject])
            {
               if ([[einNamenDic objectForKey:@"name"]isEqualToString:self.Leser])
               {
                  if (position<0)//erstes Auftreten
                  {
                     tempPWData=[einNamenDic objectForKey:@"pw"];
                     position=index;
                  }
               }//if
               index++;
            }//while einNamenDic
            //const char* altespw=[@"anna" UTF8String];
            //tempPWData =[NSData dataWithBytes:altespw length:strlen(altespw)];
            
            NSMutableDictionary* tempPWDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
            [tempPWDictionary setObject:self.Leser forKey:@"name"];
            [tempPWDictionary setObject:tempPWData forKey:@"pw"];
            
            //NSLog(@"showChangePasswort RecPlay	tempPWDictionary: %@",[tempPWDictionary description]);
            NSDictionary* neuesPWDic=[Utils changePasswort:[tempPWDictionary copy]];
            //NSLog(@"showChangePasswort:		neuesPWDic: %@",[neuesPWDic description]);
            if ([neuesPWDic count]&&!(position<=0))
            {
               PasswortOK=YES;
               //NSLog(@"Passwort ersetzen");
               [self.UserPasswortArray replaceObjectAtIndex:position withObject:neuesPWDic];
               
               
            }
            
            [self saveUserPasswortDic:neuesPWDic];
            
            
            
            [Utils startTimeout:self.TimeoutDelay];
            if(!PasswortOK)
            {
               return;
            }
         }//if leser
      }break;
      case 1:
      {
         //NSMutableDictionary* tempPWDictionary=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
         //[tempPWDictionary setObject:@"Admin" forKey:@"name"];
         //[tempPWDictionary setObject:AdminPasswortData forKey:@"pw"];
         //NSDictionary* neuesPWDic=[Utils changePasswort:AdminPasswortDic];
         NSDictionary* neuesPWDic=[Utils changePasswort:[[self.PListDic objectForKey:@"adminpw"]copy]];
         //NSLog(@"neues admin PWDic: %@",[neuesPWDic description]);
         //if ([neuesPWDic count])
         if (neuesPWDic)
         {
            [self.AdminPasswortDic setDictionary:neuesPWDic];
            [self.PListDic setObject:neuesPWDic forKey:@"adminpw"];
            [self saveAdminPasswortDic:neuesPWDic];
         }
         
      }//break;//file://localhost/Users/sysadmin/Desktop/RecPlayVII.app/
   }//switch
}

- (IBAction)showChangeAdminPasswort:(id)sender
{
   if (![self checkAdminZugang])
   {
      return;
   }

   //NSDictionary* neuesPWDic=[Utils changePasswort:AdminPasswortDic];
   NSDictionary* neuesPWDic=[Utils changePasswort:[[self.PListDic objectForKey:@"adminpw"]copy]];
   //NSLog(@"neues admin PWDic: %@",[neuesPWDic description]);
   if (neuesPWDic)
   {
      [self.AdminPasswortDic setDictionary:neuesPWDic];
      [self.PListDic setObject:neuesPWDic forKey:@"adminpw"];
      [self saveAdminPasswortDic:neuesPWDic];
   }
   
}


- (IBAction)showPasswortListe:(id)sender
{
   
   if (![self checkAdminZugang])
   {
      return;
   }

   //NSLog(@"showPasswortListe");
   if (!PasswortListePanel)
	  {
        PasswortListePanel=[[rPasswortListe alloc]init];
     }
   
   //[ProjektPanel showWindow:self];
   NSModalSession PasswortSession=[NSApp beginModalSessionForWindow:[PasswortListePanel window]];
   
   if ([self.UserPasswortArray count])
   {
      [PasswortListePanel setPasswortArray:self.UserPasswortArray];
   }
   long modalAntwort = [NSApp runModalForWindow:[PasswortListePanel window]];
   //NSLog(@"showPasswortliste Antwort: %d",modalAntwort);
   [NSApp endModalSession:PasswortSession];
   if (modalAntwort==1)//OK gedrückt
   {
      [self.UserPasswortArray setArray:[[PasswortListePanel PasswortArray]mutableCopy]];
      [self saveUserPasswortArray:[PasswortListePanel PasswortArray]];
   }
   //NSLog(@"UserPasswortArray nach change: %@",[UserPasswortArray description]);
   
}


- (IBAction)showTitelListe:(id)sender
{
   if (![self checkAdminZugang])
   {
      return;
   }
   
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:@"TitelListe" forKey:@"quelle"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"fensterschliessen" object:self userInfo:NotificationDic];

   
   //NSLog(@"\n\n\n										showTitelListe\n");
   if (!TitelListePanel)
   {
      TitelListePanel=[[rTitelListe alloc]init];
   }
   //NSLog(@"showTitelliste Start  Projekt: %@: ProjektArray: %@",[self.ProjektPfad lastPathComponent],[self.ProjektArray description]);
   
   //ProjektArray aktualisieren mitneuen Werten aus aktueller PList
   [self.ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:self.LeseboxPfad]];
   //NSLog(@"showTitelListe: ProjektArray: %@",[self.ProjektArray description]);
   NSModalSession TitelSession=[NSApp beginModalSessionForWindow:[TitelListePanel window]];
   
   NSArray* tempProjektNamenArray;
   
   tempProjektNamenArray=[self.ProjektArray valueForKey:@"projekt"];
   
   //	Projektarray aus PList
   //	tempProjektNamenArray=[[[Utils PListDicVon:LeseboxPfad aufSystemVolume:NO]objectForKey:@"projektarray"] valueForKey:@"projekt"];
   if (tempProjektNamenArray)
   {
      
      NSUInteger ProjektIndex=[tempProjektNamenArray indexOfObject:[self.ProjektPfad lastPathComponent]];
      
      NSArray* tempTitelArray;
      
      if (!(ProjektIndex==NSNotFound))
      {
         
         tempTitelArray=[[self.ProjektArray objectAtIndex:ProjektIndex]objectForKey:@"titelarray"];
         
         {
            //NSLog(@"showTitelListe:index: %d tempTitelArray: %@",ProjektIndex,[tempTitelArray description]);
            
            [TitelListePanel setTitelArray:tempTitelArray  inProjekt:[self.ProjektPfad lastPathComponent]];
            
            //NSLog(@"showTitelliste nach  setTitelArray Projekt: %@:  ProjektArray: %@",[ProjektPfad lastPathComponent],[ProjektArray description]);
         }
      }//if [ProjektArray valueForKey:@"projekt"]
      
   }//if tempProjektNamenArray
  [NSApp runModalForWindow:[TitelListePanel window]];
   
   //Rückmeldung durch Notifikation
   
   
   //NSLog(@"showTitelListe Antwort: %d",modalAntwort);
   [NSApp endModalSession:TitelSession];
   
   
}

- (void)showTitelListeInProjekt:(NSString*)zielprojekt
{
   if (![self checkAdminZugang])
   {
      return;
   }

   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:@"TitelListe" forKey:@"quelle"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"fensterschliessen" object:self userInfo:NotificationDic];

   //NSLog(@"\n\n\n										showTitelListe\n");
   if (!TitelListePanel)
   {
      TitelListePanel=[[rTitelListe alloc]init];
   }
   //NSLog(@"showTitelliste Start  Projekt: %@: ProjektArray: %@",[self.ProjektPfad lastPathComponent],[self.ProjektArray description]);
   
   //ProjektArray aktualisieren mitneuen Werten aus aktueller PList
   [self.ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:self.LeseboxPfad]];
   //NSLog(@"showTitelListe: ProjektArray Projekt: %@ %@",zielprojekt,[self.ProjektArray description]);
   NSModalSession TitelSession=[NSApp beginModalSessionForWindow:[TitelListePanel window]];
   
   [TitelListePanel setProjekt:zielprojekt];
   NSArray* tempProjektNamenArray;
   
   tempProjektNamenArray=[self.ProjektArray valueForKey:@"projekt"];
   
   //	Projektarray aus PList
   //	tempProjektNamenArray=[[[Utils PListDicVon:LeseboxPfad aufSystemVolume:NO]objectForKey:@"projektarray"] valueForKey:@"projekt"];
   if (tempProjektNamenArray)
   {
      
      NSUInteger ProjektIndex=[tempProjektNamenArray indexOfObject:[self.ProjektPfad lastPathComponent]];
      
      NSArray* tempTitelArray;
      
      if (!(ProjektIndex==NSNotFound))
      {
         
         tempTitelArray=[[self.ProjektArray objectAtIndex:ProjektIndex]objectForKey:@"titelarray"];
         
         {
            //NSLog(@"showTitelListe:index: %d tempTitelArray: %@",ProjektIndex,[tempTitelArray description]);
            
            [TitelListePanel setTitelArray:tempTitelArray  inProjekt:[self.ProjektPfad lastPathComponent]];
            
            //NSLog(@"showTitelliste nach  setTitelArray Projekt: %@:  ProjektArray: %@",[ProjektPfad lastPathComponent],[ProjektArray description]);
         }
      }//if [ProjektArray valueForKey:@"projekt"]
      
   }//if tempProjektNamenArray
   [NSApp runModalForWindow:[TitelListePanel window]];
   
   //Rückmeldung durch Notifikation
   
   
   //NSLog(@"showTitelListe Antwort: %d",modalAntwort);
   [NSApp endModalSession:TitelSession];
   
   
}


- (void)TitelListeAktion:(NSNotification*)note
{
   //NSLog(@"\n\n\n			TitelListeAktion ProjektPfad: %@",self.ProjektPfad);
   //NSLog(@"TitellisteAktion: ProjektArray Anfang: %@",[self.ProjektArray description]);
   
   if ([[note userInfo] objectForKey:@"fix"])
   {
      //NSLog(@"TitelListeAktion: fix: %d",[[[note userInfo] objectForKey:@"fix"]intValue]);
      
   }
   
   
   if ([[note userInfo] objectForKey:@"titelarray"])
   {
      
      //NSLog(@"TitelListeAktion: TitelArray: %@",[[[note userInfo] objectForKey:@"titelarray"]description]);
      
      NSArray* tempProjektNamenArray=[self.ProjektArray valueForKey:@"projekt"];//Liste der Projektnamen
      //NSLog(@"tempProjektNamenArray: %@",[tempProjektNamenArray description]);
      
      //index des Projekts
      
      NSUInteger ProjektIndex=[tempProjektNamenArray indexOfObject:[self.ProjektPfad lastPathComponent]];
      //NSLog(@"ProjektIndex: %ld",ProjektIndex);
      
     NSArray* tempTitelArray=[[[note userInfo] objectForKey:@"titelarray"]copy];
      if ([tempTitelArray count] )
      {
         if (!(ProjektIndex == NSNotFound))
         {
            //NSLog(@"TitelListeAktion: Projekt ist da: %@ ",[ProjektPfad lastPathComponent]);
            NSDictionary* tempDic=[self.ProjektArray objectAtIndex:ProjektIndex];
            //NSLog(@"tempDic: %@",[tempDic description]);
            //        [[self.ProjektArray objectAtIndex:ProjektIndex]setObject:tempTitelArray forKey:@"titelarray"];
         
         // sichern in Projektarray und PList
         [self saveTitelListe:tempTitelArray inProjekt:[self.ProjektPfad lastPathComponent]];
        
         // ProjektArray update
         [[self.ProjektArray objectAtIndex:ProjektIndex]setObject:tempTitelArray forKey:@"titelarray"];
         }
         else{
            
            //NSLog(@"Fehler in Titellisteaktion: ProjektPfad: %@",self.ProjektPfad);
         }
      
      } // if count
      else // Fixierung aufhebnen
      {
         //NSLog(@"TitellisteAktion Fixierung aufheben in Projekt: %@",[self.ProjektPfad lastPathComponent]);
         
         
         [self saveTitelFix:NO inProjekt:[self.ProjektPfad lastPathComponent]];
         
         // ProjektArray update
         [[self.ProjektArray objectAtIndex:ProjektIndex]setObject:[NSNumber numberWithBool:NO] forKey:@"fix"];
      }
      //NSLog(@"TitellisteAktion: ProjektArray Schluss: %@",[self.ProjektArray description]);
   }
   else
   {
      //NSLog(@"TitellisteAktion: noch kein Titelarray");
   }
   
}



- (void)AdminEntfernenNotificationAktion:(NSNotification*)note
{
   //NSLog(@"AdminEntfernenNotificationAktion note: %@",[[note userInfo] description]);
   
}


@end
