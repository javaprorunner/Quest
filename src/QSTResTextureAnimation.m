//
//  QSTResTextureAnimation.m
//  Quest
//
//  Created by Per Borgman on 22/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QSTResTextureAnimation.h"

#import "QSTResTexture.h"
#import "QSTBoundingBox.h"

@implementation QSTResTextureAnimation

@synthesize maxFrames;

-(id)initWithData:(NSMutableDictionary*)data path:(NSURL*)path {
	fps = [[data objectForKey:@"fps"] floatValue];
	loopStart = [[data objectForKey:@"loopstart"] intValue];
	maxFrames = [[data objectForKey:@"frames"] intValue];
	
	startFrame = 0;
	
	NSString *textureName = [data objectForKey:@"texture"];
	NSURL *texturePath = $joinUrls(path, textureName);
		
	return [super initWithTexturePath:texturePath frames:maxFrames];
}

-(QSTBoundingBox*)useWithFrame:(int)frame {
	[texture use];
	return [subdivs objectAtIndex:frame];
}

@end
