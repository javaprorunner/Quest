//
//  QSTCore.m
//  Quest
//
//  Created by Per Borgman on 20/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QSTCore.h"

#import "Vector2.h"
#import "QSTGraphicsSystem.h"
#import "QSTPhysicsSystem.h"
#import "QSTInputSystem.h"
#import "QSTCmpPosition.h"
#import "QSTCmpSprite.h"
#import "QSTCmpPhysics.h"
#import "QSTCmpCollisionMap.h"
#import "QSTSceneLayered2D.h"
#import "QSTInputSystem.h"
#import "JSON.h"
#import "QSTLine.h"
#import "QSTEntity.h"
#import "QSTEntityDB.h"
#import "QSTResourceDB.h"
#import "QSTPropertyDB.h"

@implementation QSTCore

@synthesize graphicsSystem;
@synthesize physicsSystem;
@synthesize inputSystem;

-(id)init {
	if(self = [super init]) {
		// Create systems
		graphicsSystem = [[QSTGraphicsSystem alloc] init];
		physicsSystem = [[QSTPhysicsSystem alloc] init];
		inputSystem = [[QSTInputSystem alloc] init];
		
		
		QSTInputMapper *mapper = [[QSTInputMapper alloc] init];
		[mapper registerActionWithName:@"jump" action:@selector(jump) target:self];
		[mapper mapKey:49 toAction:@"jump"];
		inputSystem.mapper = mapper;
		[mapper release];
		
		
		[self loadArea:@"test"];
						   
		/*
		// Creating an entity
		// Entity is composed of a physical aspect and a
		// graphical one.
		QSTCmpPosition *pos = [[QSTCmpPosition alloc] initWithEID:0];
		pos.position.x = 1.3f;
		pos.position.y = 3.0f;
		QSTCmpSprite *gfx = [[QSTCmpSprite alloc] initWithEID:0 name:@"lasse" position:pos];
		QSTCmpPhysics *ph = [[QSTCmpPhysics alloc] initWithEID:0 position:pos sprite:gfx];
		
		//QSTCmpCollisionMap *cm = [[QSTCmpCollisionMap alloc] initWithEID:1];
		
		[graphicsSystem.scene addComponent:gfx toLayer:0];
		//[graphicsSystem addDebugComponent:cm];
		[physicsSystem addComponent:ph toLayer:0];
		//[physicsSystem setCollisionMap:cm forLayer:0];
		
		playerPhys = ph;
		
		[pos release];
		[gfx release];
		[ph release];
		//[cm release];
		
		
		pos = [[QSTCmpPosition alloc] initWithEID:1];
		pos.position.x = 5.0f;
		pos.position.y = 0.0f;
		gfx = [[QSTCmpSprite alloc] initWithEID:1 name:@"64x64" position:pos];
		ph = [[QSTCmpPhysics alloc] initWithEID:1 position:pos sprite:gfx];
		
		[graphicsSystem.scene addComponent:gfx toLayer:0];
		[physicsSystem addComponent:ph toLayer:0];
		
		[pos release];
		[gfx release];
		[ph release];
		
		pos = [[QSTCmpPosition alloc] initWithEID:2];
		pos.position.x = 7.0f;
		pos.position.y = 1.0f;
		gfx = [[QSTCmpSprite alloc] initWithEID:2 name:@"lasse" position:pos];
		ph = [[QSTCmpPhysics alloc] initWithEID:2 position:pos sprite:gfx];
		
		[graphicsSystem.scene addComponent:gfx toLayer:0];
		[physicsSystem addComponent:ph toLayer:0];
		
		[pos release];
		[gfx release];
		[ph release];
		 */
	}
	return self;
}

-(void)loadArea:(NSString*)areaName {
	NSString *areaPath = [NSString stringWithFormat:@"testgame/areas/%@.area", areaName];
	NSString *rawData = [NSString stringWithContentsOfFile:areaPath encoding:NSUTF8StringEncoding error:NULL];
		
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSMutableDictionary *r_root = [parser objectWithString:rawData];
	[parser release];
	
	// Later there will be some area-global data here, like
	// music and mood etc
			
	NSMutableArray *r_layers = [r_root objectForKey:@"layers"];
	for(int i=0; i<[r_layers count];i++)
		[self loadLayer:[r_layers objectAtIndex:i] withIndex:i];
}

-(void)loadLayer:(NSMutableDictionary*)theLayer withIndex:(int)theIndex {
	
	printf("Load layer %d...\n", theIndex);
	
	NSMutableArray *r_colmap = [theLayer objectForKey:@"colmap"];
	
	QSTCmpCollisionMap *colmap = [[QSTCmpCollisionMap alloc] initWithEID:0];
	for(NSMutableArray *vec in r_colmap) {
		Vector2 *v1 = [Vector2 vectorWithX:[[vec objectAtIndex:0] floatValue]
										 y:[[vec objectAtIndex:1] floatValue]];
		Vector2 *v2 = [Vector2 vectorWithX:[[vec objectAtIndex:2] floatValue]
										 y:[[vec objectAtIndex:3] floatValue]];
		
		[colmap.lines addObject:[QSTLine lineWithA:v1 b:v2]];
	}
	[graphicsSystem addDebugComponent:colmap];
	[physicsSystem setCollisionMap:colmap forLayer:theIndex];
	
	NSMutableArray *r_entities = [theLayer objectForKey:@"entities"];
	
	for(NSMutableDictionary *r_entity in r_entities) {
		[self createEntity:r_entity];
	}	
}

-(void)createEntity:(NSMutableDictionary*)data {
	NSString *r_entity_type = [data objectForKey:@"type"];
	
	printf("Create entity of type %s...\n", [r_entity_type UTF8String]);
	
	// Get archetype
	QSTEntity *ent = [QSTEntity entityWithType:r_entity_type];
	
	// Override with specific
	NSMutableDictionary *r_entity_components = [data objectForKey:@"components"];
	NSDictionary *properties = [QSTPropertyDB propertiesFromDictionary:r_entity_components];
	for(NSString *key in properties)
		[ent setProperty:key to:[properties objectForKey:key]];
	
	printf("After override:\n");
	[ent printProperties];
	
}

-(void)jump {
	printf("JUMP!\n");
	playerPhys.velocity.y = -4.0f;
}

-(void)tick {
	
	float delta = 0.0166f;

	[physicsSystem tick:delta];
	[graphicsSystem tick];
}

@end
