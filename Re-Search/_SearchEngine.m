// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SearchEngine.m instead.

#import "_SearchEngine.h"

const struct SearchEngineAttributes SearchEngineAttributes = {
	.icon = @"icon",
	.name = @"name",
	.order = @"order",
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

	if ([key isEqualToString:@"orderValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"order"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic icon;

@dynamic name;

@dynamic order;

- (int16_t)orderValue {
	NSNumber *result = [self order];
	return [result shortValue];
}

- (void)setOrderValue:(int16_t)value_ {
	[self setOrder:@(value_)];
}

- (int16_t)primitiveOrderValue {
	NSNumber *result = [self primitiveOrder];
	return [result shortValue];
}

- (void)setPrimitiveOrderValue:(int16_t)value_ {
	[self setPrimitiveOrder:@(value_)];
}

@dynamic urlPattern;

@end

