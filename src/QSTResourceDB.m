//
//  QSTResourceDB.m
//  Quest
//
//  Created by Per Borgman on 21/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QSTResourceDB.h"

#import "JSON.h"
#import "QSTResTexture.h"
#import "QSTResSprite.h"
#import "QSTModel2D.h"
#import "QSTCore.h"

#import "QSTLog.h"

@interface QSTResourceDB ()
@property (assign) QSTCore *core;
@property (retain) NSMutableDictionary *textures;
@property (retain) NSMutableDictionary *sprites;
@property (retain) NSMutableDictionary *models;
@end


@implementation QSTResourceDB
@synthesize core, textures, sprites, models;

-(id)initOnCore:(QSTCore*)core_;
{
	if(![super init]) return nil;
	
	Info(@"Engine", @"-------- Initializing Resource DB --------");
	
	self.core = core_;
	textures = [[NSMutableDictionary alloc] init];
	sprites = [[NSMutableDictionary alloc] init];
	models = [[NSMutableDictionary alloc] init];
	
	return self;
}
-(void)dealloc;
{
	self.textures = self.sprites = self.models = nil;
	self.core = nil;
	[super dealloc];
}

-(QSTResTexture*)getTextureWithPath:(NSURL*)path {
	QSTResTexture *texture = [textures objectForKey:path];
	if(texture != nil) { return texture; }
	
	NSURL *fullPath = [path URLByAppendingPathExtension:@"png"];
	NSBitmapImageRep *img = [NSBitmapImageRep imageRepWithContentsOfURL:fullPath];
	
	if(!img) {
		Error(@"Engine", @"ResourceDB: Texture not found: '%@'", [fullPath relativeString]);
		// TODO: Return a generated error texture
		return nil;
	}
		
	unsigned char *data = [img bitmapData];
	int	width = [img pixelsWide];
	int height = [img pixelsHigh];
	BOOL hasAlpha = [img hasAlpha];
			
	texture = [[QSTResTexture alloc] initWithData:data width:width height:height hasAlpha:hasAlpha];
	[textures setObject:texture forKey:path];
	[texture release];
	return texture;
}

-(QSTResSprite*)getSpriteWithName:(NSString*)name {	
	QSTResSprite *sprite = [sprites objectForKey:name];
	if(sprite != nil) { return sprite; }
	
	NSURL *spritePath = $joinUrls(core.gamePath, @"sprites", name);
  	sprite = [QSTResSprite spriteWithPath:spritePath resources:self];
	if(!sprite) {
		Error(@"Engine", @"ResourceDB: Sprite not found: '%s'", [[spritePath relativeString] UTF8String]);
		return nil;
	}
	[sprites setObject:sprite forKey:name];
	
	return sprite;
}

-(QSTModel2D*)getModelWithName:(NSString*)name {
	QSTModel2D *model = [models objectForKey:name];
	if(model != nil) return model;
	
	NSURL *modelPath = $joinUrls(core.gamePath, @"models", name);
	model = [QSTModel2D modelWithPath:modelPath resources:self];
	if(!model) {
		Error(@"Engine", @"ResourceDB: Model not found: '%s'", [[modelPath relativeString] UTF8String]);
		return nil;
	}
	[models setObject:model forKey:name];
	
	return model;
}


@end
