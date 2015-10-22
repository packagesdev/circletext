/*
 Copyright (c) 2015, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "CIRCSettings.h"

NSString * const CIRCUserDefaultsDefinitionsKey=@"circles.definitions";

NSString * const CIRCUserDefaultsDefinitionTextKey=@"text";
NSString * const CIRCUserDefaultsDefinitionSpeedKey=@"speed";
NSString * const CIRCUserDefaultsDefinitionScaleKey=@"scale";
NSString * const CIRCUserDefaultsDefinitionRadiusKey=@"radius";
NSString * const CIRCUserDefaultsDefinitionXOffsetKey=@"x";
NSString * const CIRCUserDefaultsDefinitionYOffsetKey=@"y";

@implementation CIRCDefinitionSettings

- (instancetype)init
{
	self=[super init];
	
	if (self!=nil)
	{
		_text=NSLocalizedStringFromTableInBundle(@"default sentence ", @"Localizable", [NSBundle bundleForClass:[self class]], @"");
		_speed=20;
		_scale=3000;
		_radius=200;
		_xOffset=0;
		_yOffset=0;
	}
	
	return self;
}

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)inDictionary
{
	self=[super init];
	
	if (self!=nil)
	{
		_text=inDictionary[CIRCUserDefaultsDefinitionTextKey];
		_speed=[inDictionary[CIRCUserDefaultsDefinitionSpeedKey] unsignedIntValue];
		_scale=[inDictionary[CIRCUserDefaultsDefinitionScaleKey] unsignedIntValue];
		_radius=[inDictionary[CIRCUserDefaultsDefinitionRadiusKey] unsignedIntValue];
		_xOffset=[inDictionary[CIRCUserDefaultsDefinitionXOffsetKey] unsignedIntValue];
		_yOffset=[inDictionary[CIRCUserDefaultsDefinitionYOffsetKey] unsignedIntValue];
		
		return self;
	}
	
	return nil;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary * tMutableDictionary=[NSMutableDictionary dictionary];
	
	if (tMutableDictionary!=nil)
	{
		tMutableDictionary[CIRCUserDefaultsDefinitionTextKey]=_text;
		tMutableDictionary[CIRCUserDefaultsDefinitionSpeedKey]=@(_speed);
		tMutableDictionary[CIRCUserDefaultsDefinitionScaleKey]=@(_scale);
		tMutableDictionary[CIRCUserDefaultsDefinitionRadiusKey]=@(_radius);
		tMutableDictionary[CIRCUserDefaultsDefinitionXOffsetKey]=@(_xOffset);
		tMutableDictionary[CIRCUserDefaultsDefinitionYOffsetKey]=@(_yOffset);
	}
	
	return [tMutableDictionary copy];
}

@end

#pragma mark -

@implementation CIRCSettings

- (id)initWithDictionaryRepresentation:(NSDictionary *)inDictionary
{
	self=[super init];
	
	if (self!=nil)
	{
		NSArray * tArray=inDictionary[CIRCUserDefaultsDefinitionsKey];
		
		if (tArray==nil)
		{
			[self resetSettings];
		}
		else
		{
			self.definitions=[NSMutableArray array];
			
			for(NSDictionary * tDictionary in tArray)
			{
				CIRCDefinitionSettings * tCircleDefinitionSettings=[[CIRCDefinitionSettings alloc] initWithDictionaryRepresentation:tDictionary];
				
				if (tCircleDefinitionSettings!=nil)
					[self.definitions addObject:tCircleDefinitionSettings];
				else
					NSLog(@"Unable to create circle definition settings from dictionary %@",tDictionary);
			}
		}
		
		return self;
	}
	
	return nil;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary * tMutableDictionary=[NSMutableDictionary dictionary];
	
	if (tMutableDictionary!=nil)
	{
		NSMutableArray * tMutableArray=[NSMutableArray array];
		
		if (tMutableArray!=nil)
		{
			for(CIRCDefinitionSettings * tDefinitionSettings in self.definitions)
			{
				NSDictionary * tDefinitionDictionary=[tDefinitionSettings dictionaryRepresentation];
				
				if (tDefinitionDictionary!=nil)
					[tMutableArray addObject:tDefinitionDictionary];
				else
					NSLog(@"Unable to get dictionaryRepresentation for %@",tDefinitionSettings);
					
			}
			
			[tMutableDictionary setObject:tMutableArray forKey:CIRCUserDefaultsDefinitionsKey];
		}
		else
		{
			NSLog(@"Low Memory.");
		}
	}
	
	return [tMutableDictionary copy];
}

#pragma mark -

- (void)resetSettings
{
	NSArray * tArray=[NSArray arrayWithContentsOfURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"DefaultSettings" withExtension:@"plist"]];
	
	self.definitions=[NSMutableArray array];
	
	for(NSDictionary * tDictionary in tArray)
	{
		CIRCDefinitionSettings * tCircleDefinitionSettings=[[CIRCDefinitionSettings alloc] initWithDictionaryRepresentation:tDictionary];
		
		if (tCircleDefinitionSettings!=nil)
			[self.definitions addObject:tCircleDefinitionSettings];
		else
			NSLog(@"Unable to create circle definition settings from dictionary %@",tDictionary);
	}
}

@end
