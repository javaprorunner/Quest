//
//  QSTModel2D.m
//  Quest
//
//  Created by Per Borgman on 26/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QSTModel2D.h"

#import "JSONHelper.h"

@implementation QSTModel2D

+(QSTModel2D*)modelWithPath:(NSURL*)modelPath resources:(QSTResourceDB*)resourceDB {
	NSURL *skinPath = $joinUrls(modelPath, @"model.skin");
	NSURL *skelPath = $joinUrls(modelPath, @"model.skeleton");
	
	NSMutableDictionary *skin_root = [JSONHelper dictionaryFromJSONURL:skinPath];
	NSMutableDictionary *skel_root = [JSONHelper dictionaryFromJSONURL:skelPath];
	if(!skin_root || !skel_root) return nil;
	return [[[QSTModel2D alloc] initWithSkeleton:skel_root skin:skin_root resources:resourceDB] autorelease];
}

-(id)initWithSkeleton:(NSMutableDictionary*)skel_data skin:(NSMutableDictionary*)skin_data resources:(QSTResourceDB*)resourceDB {
	if(![super init]) return nil;
	
	NSMutableArray *skel_joints = [skel_data objectForKey:@"skeleton"];
	
	for(NSMutableDictionary *joint in skel_joints) {
		Vector2 *pos = [JSONHelper vectorFromKey:@"position" data:joint];
		NSString *name = [joint objectForKey:@"name"];
		NSNumber *parent = [joint objectForKey:@"parent"];
	}
	
	return self;
}

@end
