// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SearchEngine.m instead.

#import "_SearchEngine.h"

const struct SearchEngineAttributes SearchEngineAttributes = {
	.icon = @"icon",
	.name = @"name",
	.urlPattern = @"urlPattern",
};

@implementation SearchEngineID
@end

@implementation _SearchEngine

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SearchEngine" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SearchEngine";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SearchEngine" inManagedObjectContext:moc_];
}

- (SearchEngineID*)objectID {
	return (SearchEngineID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic icon;

@dynamic name;

@dynamic urlPattern;

@end

