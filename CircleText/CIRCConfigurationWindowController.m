/*
 Copyright (c) 2015, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "CIRCConfigurationWindowController.h"

#import <ScreenSaver/ScreenSaver.h>

#import "CIRCAboutBoxWindowController.h"

#import "CIRCUserDefaults+Constants.h"

#import "CIRCSettings.h"

#import "CIRCWindow.h"

#import "CIRCSentenceFormatter.h"

#import "CIRCDefinitionSettingsRowView.h"
#import "CIRCDefinitionSettingsView.h"

@interface CIRCConfigurationWindowController () <CIRCWindowDelegate,NSTableViewDataSource,NSTableViewDelegate>
{
	IBOutlet NSTableView *_tableView;
	
	IBOutlet NSButton *_addButton;
	
	IBOutlet NSButton *_removeButton;
	
	IBOutlet NSTextField * _statusLabel;
	
	IBOutlet NSButton * _mainScreenCheckBox;
	
	IBOutlet NSButton * _cancelButton;
	
	CIRCSentenceFormatter * _sentenceFormatter;
	
	NSRect _savedCancelButtonFrame;
	
	CIRCSettings * _circSettings;
	
	BOOL _mainScreenSetting;
}

- (IBAction)removeSpecificCircle:(id)sender;

- (IBAction)setSentenceText:(id)sender;

- (IBAction)setCircleOffsetX:(id)sender;

- (IBAction)setCircleOffsetY:(id)sender;

- (IBAction)setCircleRadius:(id)sender;

- (IBAction)setCircleScale:(id)sender;

- (IBAction)setCircleRotationSpeed:(id)sender;

- (IBAction)addCircle:(id)sender;

- (IBAction)removeCircle:(id)sender;

- (IBAction)showAboutBox:(id)sender;

- (IBAction)resetDialogSettings:(id)sender;

- (IBAction)closeDialog:(id)sender;

@end

@implementation CIRCConfigurationWindowController

- (id)init
{
	self=[super init];
	
	if (self!=nil)
	{
		NSString *tIdentifier = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
		ScreenSaverDefaults *tDefaults = [ScreenSaverDefaults defaultsForModuleWithName:tIdentifier];
		
		_circSettings=[[CIRCSettings alloc] initWithDictionaryRepresentation:[tDefaults dictionaryRepresentation]];
		
		_mainScreenSetting=[tDefaults boolForKey:CIRCUserDefaultsMainDisplayOnly];
		
		_sentenceFormatter=[CIRCSentenceFormatter new];
	}
	
	return self;
}

- (NSString *)windowNibName
{
	return NSStringFromClass([self class]);
}

- (void)windowDidLoad
{
	[super windowDidLoad];
	
	_savedCancelButtonFrame=[_cancelButton frame];
}

#pragma mark -

- (void)restoreUI
{
	[_tableView deselectAll:nil];
	
	[_tableView reloadData];
	
	[_tableView scrollRowToVisible:0];
	
	[self tableViewSelectionDidChange:[NSNotification notificationWithName:NSTableViewSelectionDidChangeNotification object:_tableView]];
	
	[_mainScreenCheckBox setState:(_mainScreenSetting==YES) ? NSOnState : NSOffState];
}

#pragma mark -

- (IBAction)showAboutBox:(id)sender
{
	static CIRCAboutBoxWindowController * sAboutBoxWindowController=nil;
	
	if (sAboutBoxWindowController==nil)
		sAboutBoxWindowController=[CIRCAboutBoxWindowController new];
	
	if ([sAboutBoxWindowController.window isVisible]==NO)
		[sAboutBoxWindowController.window center];
	
	[sAboutBoxWindowController.window makeKeyAndOrderFront:nil];
}

- (IBAction)resetDialogSettings:(id)sender
{
	[_circSettings resetSettings];
	
	[self restoreUI];
}

- (IBAction)closeDialog:(id)sender
{
	NSString *tIdentifier = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
	ScreenSaverDefaults *tDefaults = [ScreenSaverDefaults defaultsForModuleWithName:tIdentifier];
	
	if ([sender tag]==NSModalResponseOK)
	{
		// Scene Settings
		
		NSDictionary * tDictionary=[_circSettings dictionaryRepresentation];
		
		[tDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *bKey,id bObject, BOOL * bOutStop){
			[tDefaults setObject:bObject forKey:bKey];
		}];
		
		// Main Screen Only
		
		_mainScreenSetting=([_mainScreenCheckBox state]==NSOnState);
		
		[tDefaults setBool:_mainScreenSetting forKey:CIRCUserDefaultsMainDisplayOnly];
		
		[tDefaults synchronize];
	}
	else
	{
		_circSettings=[[CIRCSettings alloc] initWithDictionaryRepresentation:[tDefaults dictionaryRepresentation]];
		
		_mainScreenSetting=[tDefaults boolForKey:CIRCUserDefaultsMainDisplayOnly];
	}
	
	[NSApp endSheet:self.window];
}

#pragma mark -

- (IBAction)removeSpecificCircle:(id)sender
{
	NSInteger tRowIndex=[_tableView rowForView:sender];
	
	NSArray * tDefinitionsArray=_circSettings.definitions;
	
	if (tRowIndex>=0 && tRowIndex<[tDefinitionsArray count])
	{
		[_tableView beginUpdates];
		[_tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:tRowIndex] withAnimation:NSTableViewAnimationEffectGap];
		[_tableView endUpdates];
		
		[_circSettings.definitions removeObjectAtIndex:tRowIndex];
		
		[self tableViewSelectionDidChange:[NSNotification notificationWithName:NSTableViewSelectionDidChangeNotification object:_tableView]];
	}
}

- (IBAction)setSentenceText:(id)sender
{
	NSInteger tRowIndex=[_tableView rowForView:sender];
	
	if (tRowIndex>=0)
	{
		CIRCDefinitionSettings * tDefnitionSettings=_circSettings.definitions[tRowIndex];
		
		tDefnitionSettings.text=[sender stringValue];
	}
}

- (IBAction)setCircleOffsetX:(id)sender
{
	NSInteger tRowIndex=[_tableView rowForView:sender];
	
	if (tRowIndex>=0)
	{
		CIRCDefinitionSettings * tDefnitionSettings=_circSettings.definitions[tRowIndex];
		
		tDefnitionSettings.xOffset=[sender integerValue];
	}
}

- (IBAction)setCircleOffsetY:(id)sender
{
	NSInteger tRowIndex=[_tableView rowForView:sender];
	
	if (tRowIndex>=0)
	{
		CIRCDefinitionSettings * tDefnitionSettings=_circSettings.definitions[tRowIndex];
		
		tDefnitionSettings.yOffset=[sender integerValue];
	}
}

- (IBAction)setCircleRadius:(id)sender
{
	NSInteger tRowIndex=[_tableView rowForView:sender];
	
	if (tRowIndex>=0)
	{
		CIRCDefinitionSettings * tDefnitionSettings=_circSettings.definitions[tRowIndex];
		
		tDefnitionSettings.radius=[sender integerValue];
	}
}

- (IBAction)setCircleScale:(id)sender
{
	NSInteger tRowIndex=[_tableView rowForView:sender];
	
	if (tRowIndex>=0)
	{
		CIRCDefinitionSettings * tDefnitionSettings=_circSettings.definitions[tRowIndex];
		
		tDefnitionSettings.scale=[sender integerValue];
	}
}

- (IBAction)setCircleRotationSpeed:(id)sender
{
	NSInteger tRowIndex=[_tableView rowForView:sender];
	
	if (tRowIndex>=0)
	{
		CIRCDefinitionSettings * tDefnitionSettings=_circSettings.definitions[tRowIndex];
		
		tDefnitionSettings.speed=(-5*[sender integerValue]+55);
	}
}

- (IBAction)addCircle:(id)sender
{
	CIRCDefinitionSettings * tNewDefinitionSettings=[CIRCDefinitionSettings new];
	
	[_circSettings.definitions addObject:tNewDefinitionSettings];
	
	[_tableView reloadData];
	
	[_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:[_circSettings.definitions count]-1] byExtendingSelection:NO];
	
	[self tableViewSelectionDidChange:[NSNotification notificationWithName:NSTableViewSelectionDidChangeNotification object:_tableView]];
	
	// Make the view visible
	
	[_tableView scrollRowToVisible:[_tableView numberOfRows]-1];
}

- (IBAction)removeCircle:(id)sender
{
	NSIndexSet * tSelectedRowIndexSet=[_tableView selectedRowIndexes];
	
	[_tableView beginUpdates];
	[_tableView removeRowsAtIndexes:tSelectedRowIndexSet withAnimation:NSTableViewAnimationEffectGap];
	[_tableView endUpdates];
	
	[_circSettings.definitions removeObjectsAtIndexes:tSelectedRowIndexSet];
	
	[self tableViewSelectionDidChange:[NSNotification notificationWithName:NSTableViewSelectionDidChangeNotification object:_tableView]];
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)inTableView
{
	if (inTableView==_tableView)
		return [_circSettings.definitions count];
	
	return 0;
}

- (NSTableRowView *)tableView:(NSTableView *)inTableView rowViewForRow:(NSInteger)inRow
{
	if (inTableView==_tableView)
	{
		CIRCDefinitionSettingsRowView * tRowiew=[CIRCDefinitionSettingsRowView new];
	
		return tRowiew;
	}
	
	return nil;
}

- (NSView *)tableView:(NSTableView *)inTableView viewForTableColumn:(NSTableColumn *)inTableColumn row:(NSInteger)inRow
{
	if (inTableView==_tableView)
	{
		NSString * tColumIdentifier=[inTableColumn identifier];
		
		if ([tColumIdentifier isEqualToString:@"Settings"]==YES)
		{
			CIRCDefinitionSettingsView * tCellView=(CIRCDefinitionSettingsView *)[_tableView makeViewWithIdentifier:@"circle.definition.settings.view" owner:self];
			
			CIRCDefinitionSettings * tDefnitionSettings=_circSettings.definitions[inRow];
			
			[tCellView.sentenceTextField setFormatter:_sentenceFormatter];
			[tCellView.sentenceTextField setStringValue:tDefnitionSettings.text];
			
			[tCellView.centerOffsetXSlider setIntegerValue:tDefnitionSettings.xOffset];
			
			[tCellView.centerOffsetYSlider setIntegerValue:tDefnitionSettings.yOffset];
			
			[tCellView.radiusSlider setIntegerValue:tDefnitionSettings.radius];
			
			[tCellView.scaleSlider setIntegerValue:tDefnitionSettings.scale];
			
			[tCellView.rotationSpeedSlider setIntegerValue:(-0.2*tDefnitionSettings.speed+11)];
			
			return tCellView;
		}
	}
	
	return nil;
}

#pragma mark - TableView delegate

- (void)tableViewSelectionDidChange:(NSNotification *)inNotification
{
	if (inNotification.object==_tableView)
	{
		NSUInteger tSelectedRowsCount=[_tableView numberOfSelectedRows];
		NSBundle * tBundle=[NSBundle bundleForClass:[self class]];
		
		if (tSelectedRowsCount==0)
		{
			[_removeButton setEnabled:NO];
			
			switch([_circSettings.definitions count])
			{
				case 0:
					
					[_statusLabel setStringValue:NSLocalizedStringFromTableInBundle(@"No circles",@"Localizable",tBundle,@"")];
					break;
					
				case 1:
					
					[_statusLabel setStringValue:NSLocalizedStringFromTableInBundle(@"1 circle",@"Localizable",tBundle,@"")];
					break;
					
				default:
					
					[_statusLabel setStringValue:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"%d circles",@"Localizable",tBundle,@""),(int)[_circSettings.definitions count]]];
					break;
			}
		}
		else
		{
			[_removeButton setEnabled:YES];
			
			if (tSelectedRowsCount==1)
				[_statusLabel setStringValue:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"1 of %d selected",@"Localizable",tBundle,@""),(int)[_circSettings.definitions count]]];
			else
				[_statusLabel setStringValue:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"%d of %d selected",@"Localizable",tBundle,@""),(int)tSelectedRowsCount,(int)[_circSettings.definitions count]]];
		}
	}
}

#pragma mark -

- (void)window:(NSWindow *)inWindow modifierFlagsDidChange:(NSEventModifierFlags) inModifierFlags
{
	if ((inModifierFlags & NSAlternateKeyMask) == NSAlternateKeyMask)
	{
		NSRect tOriginalFrame=[_cancelButton frame];
		
		[_cancelButton setTitle:NSLocalizedStringFromTableInBundle(@"Reset",@"Localizable",[NSBundle bundleForClass:[self class]],@"")];
		[_cancelButton setAction:@selector(resetDialogSettings:)];
		
		[_cancelButton sizeToFit];
		
		NSRect tFrame=[_cancelButton frame];
		
		tFrame.size.width+=10.0;	// To compensate for sizeToFit stupidity
		
		if (NSWidth(tFrame)<84.0)
			tFrame.size.width=84.0;
		
		tFrame.origin.x=NSMaxX(tOriginalFrame)-NSWidth(tFrame);
		
		[_cancelButton setFrame:tFrame];
	}
	else
	{
		[_cancelButton setTitle:NSLocalizedStringFromTableInBundle(@"Cancel",@"Localizable",[NSBundle bundleForClass:[self class]],@"")];
		[_cancelButton setAction:@selector(closeDialog:)];
		
		[_cancelButton setFrame:_savedCancelButtonFrame];
	}
}

@end
