//
//  QSTResourceDB.h
//  Quest
//
//  Created by Per Borgman on 21/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class QSTResTexture;
@class QSTResSprite;
@class QSTModel2D;
@class QSTCore;

@interface QSTResourceDB : NSObject {
	QSTCore *core;
	NSMutableDictionary *textures;
	NSMutableDictionary *sprites;
	NSMutableDictionary *models;

}
-(id)initOnCore:(QSTCore*)core;

-(QSTResTexture*)getTextureWithPath:(NSURL*)path;
-(QSTResSprite*)getSpriteWithName:(NSString*)name;
-(QSTModel2D*)getModelWithName:(NSString*)name;

@end
