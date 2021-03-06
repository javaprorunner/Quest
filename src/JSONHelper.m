//
//  JSONHelper.m
//  Quest
//
//  Created by Per Borgman on 2010-03-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JSONHelper.h"

#import "JSON.h"
#import "Vector2.h"

static SBJsonParser *sharedParser = nil;

@implementation JSONHelper
+(NSMutableDictionary*)dictionaryFromJSONURL:(NSURL*)path;
{
	return [JSONHelper dictionaryFromJSONPath:[path path]];
}

+(NSMutableDictionary*)dictionaryFromJSONPath:(NSString*)path {
	NSString *rawData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
	return [JSONHelper dictionaryFromJSONString:rawData];
}

+(NSMutableDictionary*)dictionaryFromJSONString:(NSString*)data {
	if(!sharedParser) sharedParser = [SBJsonParser new];
	
	NSMutableDictionary *root = [sharedParser objectWithString:data];
	return root;
}

+(Vector2*)vectorFromKey:(NSString*)key data:(NSMutableDictionary*)data {
	NSArray *vecData = [data objectForKey:key];
	Vector2* vec = [Vector2 vectorWithX:[[vecData objectAtIndex:0] floatValue]
									  y:[[vecData objectAtIndex:1] floatValue]];
	return vec;
}

@end
