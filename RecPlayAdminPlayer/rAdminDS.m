#import "rAdminDS.h"

@implementation rAdminDS

-(id) init
{
    return [self initWithRowCount: 0];
}

- (id)initWithRowCount: (long)rowCount
{
    int i;

    if ((self = [super init]))
    {
        _editable = YES;
    
        rowData = [[NSMutableArray alloc] initWithCapacity: rowCount];
        for (i=0; i < rowCount; i++)
        {
            [rowData addObject: [NSMutableDictionary dictionary]];
       }
		
		AufnahmeFiles=[[NSMutableArray alloc] initWithCapacity: rowCount];
		for (i=0; i < rowCount; i++)
        {
            [AufnahmeFiles addObject: [NSMutableArray array]];
		}

		AuswahlArray=[[NSMutableArray alloc] initWithCapacity: rowCount];
		for (i=0; i < rowCount; i++)
        {
            [AuswahlArray addObject: [NSNumber numberWithInt:0]];
		}
		
		MarkArray=[[NSMutableArray alloc] initWithCapacity: rowCount];
		for (i=0; i < rowCount; i++)
		  {
			NSMutableArray* tempMarkArray=[[NSMutableArray alloc] initWithCapacity: 25];
			int k;
			for (k=0;k<25;k++)
			  {
				NSNumber* tempMark=[NSNumber numberWithBool:0];
				
				[tempMarkArray addObject:tempMark];
			  }
			
            [MarkArray addObject: tempMarkArray];
		  }
		
    }
   
    return self;
}


- (void) awakeFromNib
{

}

- (void)dealloc
{
}

- (BOOL)isEditable
{
    return _editable;
}

- (void)setEditable:(BOOL)b
{
    _editable = b;
}

#pragma mark -
#pragma mark Accessing Row Data:
- (NSArray*)rowData
{
return rowData;
}

- (NSArray*)AufnahmeFiles
{
   return AufnahmeFiles;
}


- (void)setData: (NSDictionary *)someData forRow: (long)rowIndex
{
    NSMutableDictionary *aRow;
    
    NS_DURING
        aRow = [rowData objectAtIndex: rowIndex];
    NS_HANDLER
        if ([[localException name] isEqual: @"NSRangeException"])
        {
            return;
        }
        else [localException raise];
    NS_ENDHANDLER
    
    [aRow addEntriesFromDictionary: someData];
}

- (NSDictionary *)dataForRow: (long)rowIndex
{
    NSDictionary *aRow;

    NS_DURING
        aRow = [rowData objectAtIndex: rowIndex];
    NS_HANDLER
        if ([[localException name] isEqual: @"NSRangeException"])
        {
            //NSLog(@"Setting data out of bounds.");
            return nil;
        }
        else [localException raise];
    NS_ENDHANDLER

    return [NSDictionary dictionaryWithDictionary: aRow];
}

- (long)ZeileVonLeser:(NSString*)derLeser
{
//NSLog(@"rowData: %@",[rowData description]);
long index=[[rowData valueForKey:@"namen"]indexOfObject:derLeser];
return index;
}

- (void)setAufnahmeFiles:(NSArray*)derArray forRow: (long)dieZeile
{
   //NSLog(@"setAufnahmeFiles Zeile: %ld  Array: %@",dieZeile, derArray);

	//NSArray* tempArray=[derArray copy];
	NSMutableArray* eineZeile;
	eineZeile=[AufnahmeFiles objectAtIndex:dieZeile];
	[eineZeile addObjectsFromArray:derArray];
  
}

- (NSArray*)AufnahmeFilesFuerZeile:(long)dieZeile
{
	//NSLog(@"AufnahmeFilesFuerZeile: %d",dieZeile);
	NSMutableArray* eineZeile;
	eineZeile=[AufnahmeFiles objectAtIndex:dieZeile];
	return eineZeile;

}

- (void)deleteZeileMitAufnahme:(NSString*)aufnahme
{
   for (int paket=0;paket < [AufnahmeFiles count];paket++)
   {
      long zeilenindex = [[AufnahmeFiles objectAtIndex:paket]indexOfObject:aufnahme];
      //NSLog(@"aufnahme: %@ paket: %d zeilenindex: %ld",aufnahme, paket, zeilenindex);
      if (zeilenindex < NSNotFound) // aufnahme ist da
      {
         
      }
   }
}


#pragma mark -

- (long)rowCount
{
    return [rowData count];
}



#pragma mark -

- (void) insertRowAt:(long)rowIndex
{
    [self insertRowAt: rowIndex withData: [NSMutableDictionary dictionary]];
}

- (void) insertRowAt:(long)rowIndex withData:(NSDictionary *)someData
{
    [rowData insertObject: someData atIndex: rowIndex];
}

- (void) insertZeileAn:(int)rowIndex mitData:(NSDictionary *)dieDaten
{
	if ([dieDaten objectForKey:@"namen"])
	{
		NSDictionary* temprowDic=[NSDictionary dictionaryWithObject:[dieDaten objectForKey:@"namen"] forKey:@"namen"];
		[rowData insertObject: temprowDic atIndex: rowIndex];
		
		if ([dieDaten objectForKey:@"anz"])
		{
			NSDictionary* tempAnzDic=[NSDictionary dictionaryWithObject:[dieDaten objectForKey:@"anz"] forKey:@"anz"];
			[AuswahlArray insertObject: tempAnzDic atIndex: rowIndex];
			
		}
		else
		{
			NSDictionary* tempAnzDic=[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"anz"];
			[AuswahlArray insertObject: tempAnzDic atIndex: rowIndex];
			
		}
			
	}//if namen
}

- (void) deleteRowAt:(long)rowIndex
{    
    [rowData removeObjectAtIndex: rowIndex];
	[AufnahmeFiles removeObjectAtIndex: rowIndex];
	[AuswahlArray removeObjectAtIndex: rowIndex];
}


- (void)deleteDataZuName:(NSString*)derName
{
   //NSLog(@"deleteDataZuName: %@  ",derName);
   NSEnumerator* rowEnum=[rowData objectEnumerator];
   id einObject;
   int deleteIndex=-1;
   int index=0;
   while(einObject=[rowEnum nextObject])
   {
      if ([[einObject objectForKey:@"namen"] isEqualToString:derName])
      {
         //NSLog(@"einObject: *%@* derName: +%@+ ",[einObject objectForKey:@"namen"],derName);
         deleteIndex=index;
      }
      index++;
   }//while
   //NSLog(@"deleteDataZuName: %@   deleteIndex: %d",derName,deleteIndex);
   if (deleteIndex>=0)
   {
      [self deleteRowAt:deleteIndex];
   }
}


- (void) deleteAllData
{
	[rowData removeAllObjects];
	[AufnahmeFiles removeAllObjects];
	[AuswahlArray removeAllObjects];
	
}


- (void)setAuswahl:(long)dasItem forRow:(long) rowIndex
{
	NSNumber* tempItem=[NSNumber numberWithLong:dasItem];
	[AuswahlArray replaceObjectAtIndex:rowIndex withObject:tempItem];
}

- (int)AuswahlFuerZeile:(long)dieZeile
{
	return [[AuswahlArray objectAtIndex:dieZeile]intValue];
}

- (void)setMarkArray:(NSArray*)derArray forRow:(long)dieZeile
{
	[MarkArray replaceObjectAtIndex:dieZeile withObject:derArray];
}

- (void)setMark:(BOOL)derStatus forRow:(long)dieZeile forItem:(long)dasItem
{
	NSNumber* statusNumber=[NSNumber numberWithBool:derStatus];
	
	[[MarkArray objectAtIndex:dieZeile]replaceObjectAtIndex:dasItem withObject:statusNumber];
}

- (NSArray*)MarkArrayForRow:(long)dieZeile
{
	return [MarkArray objectAtIndex:dieZeile];
}

- (BOOL)MarkForRow:(long)dieZeile forItem:(long)dasItem
{
   //NSLog(@"MarkForRow MarkArray: %@",MarkArray);
	return [[[MarkArray objectAtIndex:dieZeile]objectAtIndex:dasItem]boolValue];
}

- (void)setAufnahmenMarkAuswahlOption:(long)zeile
{
   
   AufnahmenMarkAuswahlOption = zeile;
}

#pragma mark -
#pragma mark Table Data Source:

- (long)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [rowData count];
}

- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn 
    row:(long)rowIndex
{
  // //NSLog(@"objectValueForTableColumn");
    NSDictionary *aRow;
        
    NS_DURING
        aRow = [rowData objectAtIndex: rowIndex];
   
   if ([[aTableColumn identifier]isEqualTo:@"aufnahmen"])
   {
      
    //  BOOL tempMark =[[MarkArray objectAtIndex: rowIndex]intValue];
      
      //NSLog(@"setObjectValue aRow: %@ mark: %@",aRow,[MarkArray objectAtIndex: rowIndex]);
   }

    NS_HANDLER
        if ([[localException name] isEqual: @"NSRangeException"])
        {
            return nil;
        }
        else [localException raise];
    NS_ENDHANDLER
    
    return [aRow objectForKey: [aTableColumn identifier]];
}

- (void)tableView:(NSTableView *)aTableView 
    setObjectValue:(id)anObject 
    forTableColumn:(NSTableColumn *)aTableColumn 
    row:(long)rowIndex
{
    NSString *columnName;
    NSMutableDictionary *aRow;
    
    if ( [self isEditable] )
    {
        NS_DURING
            aRow = [rowData objectAtIndex: rowIndex];
        NS_HANDLER
            if ([[localException name] isEqual: @"NSRangeException"])
            {
                return;
            }
            else [localException raise];
        NS_ENDHANDLER
        
        columnName = [aTableColumn identifier];
        [aRow setObject:anObject forKey: columnName];
    }
}

#pragma mark -
#pragma mark Table Delegate:

- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(long)rowIndex
{
	//NSLog(@"shouldEditTableColumn");
    return [self isEditable];
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(long)row
{
	////NSLog(@"AdminDS willDisplayCell Zeile: %d, numberOfSelectedRows:%d", row ,[tableView numberOfSelectedRows]);
	
   if ([[tableColumn identifier] isEqualToString:@"aufnahmen"])
	{
		[cell removeAllItems];
		[cell setImagePosition:NSImageRight];
      //[cell setTextAlignment:NSRightTextAlignment];
		if ([[AufnahmeFiles objectAtIndex:row]count]) //Der Leser hat Aufnahmen
		{
         //long col = 1;
         NSRect cellFeld = [tableView frameOfCellAtColumn:1 row:row];

			NSImage* MarkOnImg=[NSImage imageNamed:@"MarkOnImg.tif"];
         NSImageView* MarkOnView = [[NSImageView alloc] initWithFrame:cellFeld];
         [MarkOnView setImage:MarkOnImg];
			//NSImage* MarkOffImg=[NSImage imageNamed:@"MarkOffImg.tif"];
			//[MarkOnImg setBackgroundColor:[NSColor clearColor]];
			//NSLog(@"MarkArrayvon Zeile %d : %@",row,[[MarkArray objectAtIndex:row] description]);
			NSEnumerator* AufnahmenEnumerator=[[AufnahmeFiles objectAtIndex:row] objectEnumerator];
			id eineAufnahme;
			int index=0;
         BOOL inPopOK=YES; // Alle Files aufnehmen
			while(eineAufnahme=[AufnahmenEnumerator nextObject])//Aufnahmen für Menu
         {
         //   [cell addItemWithTitle:eineAufnahme];
            if (AufnahmenMarkAuswahlOption) // nur markierte aufnehmen
            {
               inPopOK=NO;
            }

            //double menuIndex=[cell indexOfItemWithTitle:eineAufnahme];
            //NSLog(@"eineAufnahme: %@ index: %d  menuIndex: %d",eineAufnahme,index,menuIndex);
            BOOL tempState=NO;
            if ([[MarkArray objectAtIndex:row]count])
            {
               // //NSLog(@"MarkArray count: %d",[[MarkArray objectAtIndex:row] count]);
               if(index<[[MarkArray objectAtIndex:row]count])
               {
                  tempState=[[[MarkArray objectAtIndex:row]objectAtIndex:index]boolValue];
                  //NSLog(@"tempState:%d",tempState);
                  if (tempState)
						{
                     //[[cell itemAtIndex:index]setImage:MarkOnImg];
                     //[cell itemAtIndex:index].imageView = MarkOnView;
    //                 [cell itemAtIndex:index].backgroundColor=[NSColor redColor];
                     //[cell itemAtIndex:index].attributedTitle = nil;
						}
                  else
						{
   //                  [[cell itemAtIndex:index]setImage:MarkOffImg];
                     //[cell itemAtIndex:index].imageView = MarkOffImg;

						}
               }
               NSString* tempAufnahmeString = eineAufnahme;
               
               // Mark setzen
               if (tempState)
               {
                  tempAufnahmeString = [NSString stringWithFormat:@"%@\t%@",@"X",tempAufnahmeString];
               }
               else
               {
                  tempAufnahmeString = [NSString stringWithFormat:@"\t%@",tempAufnahmeString];
                 
               }
               // in Pop aufnehmen je nach Status von AufnahmenaAuswahlOption
               switch (AufnahmenMarkAuswahlOption)
               {
                  case 0: // alle aufnehmen
                  {
                     [cell addItemWithTitle:tempAufnahmeString];

                  }break;
                  case 1: // nur markierte aufnehmen
                  {
                     if (tempState)
                     {
                        [cell addItemWithTitle:tempAufnahmeString];
                     }
                  }break;
               }
               
                               
               
               
               
            }
            //else
            {
               //[[cell itemAtIndex:0]setImage:NULL];
            }
            
            index++;
         }
			
			
			
			//NSFont* cellFont=[NSFont systemFontOfSize: 12];
         
			//[cell setFont:cellFont];
			//[cell addItemsWithTitles:[AufnahmeFiles objectAtIndex:row]];
			
			//NSLog(@"willDisplayCell: AuswahlArray:%@",[AuswahlArray description]);
         
			int hit=[[AuswahlArray objectAtIndex:row]intValue];
         
         
			//NSLog(@"willDisplayCell: hit:%d",hit);
			[cell selectItemAtIndex:hit];
			//NSColor * MarkFarbe=[NSColor orangeColor];
			//[cell setTextColor:MarkFarbe];
			//[cell setImagePosition:NSImageLeft];
			//NSImage* StartPlayImg=[NSImage imageNamed:@"StartPlayImg.tif"];
			//[cell setImage:StartPlayImg];
			//[cell setBackgroundColor:[NSColor redColor]];
			[cell setEnabled:YES];
			//[MarkCheckbox setEnabled:YES];
		}
		else
		{
			[cell addItemWithTitle:@"leer"];
			[cell setEnabled:NO];
			//[MarkCheckbox setEnabled:NO];
			
		}
   }
	if ([[tableColumn identifier] isEqualToString:@"namen"])
   {
		//NSLog(@"willDisplayCell: row: %d Dic: %@ ",row, [[rowData objectAtIndex:row]description]);
      
		//NSLog(@"willDisplayCell: row: %d Namen: %@ session: %d",row, [[rowData objectAtIndex:row]objectForKey:@"namen"],[[[rowData objectAtIndex:row] objectForKey:@"insession"]boolValue]);
		if ([[[rowData objectAtIndex:row] objectForKey:@"insession"]boolValue])//Namen ist in SessionArray
		{
         [cell setTextColor:[NSColor greenColor]];
		}
		else
		{
         [cell setTextColor:[NSColor blackColor]];
		}
      
		if ([[AufnahmeFiles objectAtIndex:row]count])
      {
         
      }
		else
      {
			[cell setSelectable:NO];
         
      }
   }
   
	if ([[tableColumn identifier] isEqualToString:@"anz"])
	{
		//[cell setIntValue:[[AufnahmeFiles objectAtIndex:row]count]];
		//if ([[AufnahmeFiles objectAtIndex:row]count])
		{
			//[cell setEnabled:YES];
			
			//if ([tableView isRowSelected :row])
			{
				//[cell setEnabled:YES];
				//[cell setTransparent:NO];
				//[cell setTitle:@">"];
				//[cell setKeyEquivalent:@"\r"];
			}
			//else
			{
				//[cell setTransparent:YES];
				//[cell setTitle:@""];
				//[cell setEnabled:NO];
				//[cell setKeyEquivalent:@""];
			}
		}
		//else
		{
         //	[cell setTitle:@""];
			//[cell setKeyEquivalent:@""];
         //	[cell setEnabled:NO];
         //	[cell setTransparent:YES];
		}
	}
   
   //NSString* s=[[AufnahmeFiles objectAtIndex:row] description];
   //NSString* nach=[[cell itemTitles]description];
   //NSLog(@"      willDisplayCell cell nach: %@",nach);
   
   //NSLog(@"willDisplayCell Liste: %@",s);
	
}
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(long)row
{
	
	//NSLog(@"**AdminDS tableView  shouldSelectRow: %d  [tableView clickedRow]:%d" ,row,[tableView clickedRow]);
	
	long selektierteZeile=[tableView selectedRow];//vorher selektierte Zeile
   //NSLog(@"**AdminDS tableView  shouldSelectRow: %ld  clickedRow :%d selectedRow: %d" ,row,[tableView clickedRow],[tableView selectedRow]);

	NSString* tempLastLesernamen=[NSString string];//leer wenn zeilennummer=-1 beim ersten Klick
	
	NSMutableDictionary* AdminZeilenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[AdminZeilenDic setObject:@"AdminView" forKey:@"Quelle"];
	NSNumber* 	ZeilenNummer=[NSNumber numberWithLong:selektierteZeile];
	[AdminZeilenDic setObject:ZeilenNummer forKey:@"AdminLastZeilenNummer"];
		
	[AdminZeilenDic setObject:[NSNumber numberWithLong:row] forKey:@"AdminNextZeilenNummer"];
	[AdminZeilenDic setObject:[[rowData objectAtIndex:row]objectForKey:@"namen"] forKey:@"nextLeser"];
   //NSLog(@"rowData row: %ld  Daten: %@",row, [[rowData objectAtIndex:row]description]);
   [AdminZeilenDic setObject:[[rowData objectAtIndex:row]objectForKey:@"anz"] forKey:@"anz"];
	if (selektierteZeile>=0)//schon eine Zeile selektiert, sonst -1
	{
		//NSLog(@"rowData last Zeile: %ld  Daten: %@",selektierteZeile, [[rowData objectAtIndex:selektierteZeile]description]);
		tempLastLesernamen= [[rowData objectAtIndex:selektierteZeile]objectForKey:@"namen"];
		[AdminZeilenDic setObject:[[rowData objectAtIndex:selektierteZeile]objectForKey:@"namen"] forKey:@"LasttName"];
		
	}//eine Zeile selektiert, eventuell Kommentar sichern
	
	//NSLog(@"rowData next Zeile: %d  Daten: %@",row, [[rowData objectAtIndex:row]description]);
	
	//NSLog(@"[AuswahlArray: %@",[[AuswahlArray objectAtIndex:row]description]);
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"AdminselektierteZeile" object:AdminZeilenDic]; // AdminZeilenNotifikationAktion
	//NSLog(@"AdmintableView  shouldSelectRow ende: %d",row);
	//[[[tableView tableColumnWithIdentifier:@"aufnahmen"]dataCellForRow:row]action];
	
	return YES;
}


@end
