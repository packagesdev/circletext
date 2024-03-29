/*
 Copyright (c) 2015-2018, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "CIRCAboutBoxWindowController.h"

#ifndef NSAppKitVersionNumber10_12
#define NSAppKitVersionNumber10_12 1504
#endif

@interface CIRCAboutBoxWindowController ()
{
    IBOutlet NSTextField *_versionLabel;
    IBOutlet NSTextField *_copyrightLabel;
	IBOutlet NSTextField *_portCreditsLabel;
}

@end

@implementation CIRCAboutBoxWindowController

- (NSString *)windowNibName
{
    return @"CIRCAboutBoxWindowController";
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    NSBundle * tBundle=[NSBundle bundleForClass:[self class]];
    
    NSDictionary * tInfoDictionary=[tBundle infoDictionary];
    
    [_versionLabel setStringValue:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Version %@ (%@)",@"Localizable",tBundle,@""),[tInfoDictionary objectForKey:@"CFBundleShortVersionString"],[tInfoDictionary objectForKey:@"CFBundleVersion"]]];
    
    [_copyrightLabel setStringValue:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Legal terms",@"Localizable",tBundle,@""),[[NSCalendarDate date] yearOfCommonEra]]];

	NSString * tOSName=nil;
	
	if (NSAppKitVersionNumber>=NSAppKitVersionNumber10_12)
	{
		tOSName=@"macOS";
	}
	else if (NSAppKitVersionNumber>=NSAppKitVersionNumber10_8)
	{
		tOSName=@"OS X";
	}
	else
	{
		tOSName=@"Mac OS X";
	}
	
	NSString * tCreditsLabel=[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Port credits",@"Localizable",tBundle,@""),tOSName];
	
	[_portCreditsLabel setStringValue:tCreditsLabel];
}

@end
