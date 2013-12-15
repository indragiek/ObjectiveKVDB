//
//  KVDBDatabase.m
//  ObjectiveKVDB
//
//  Created by Indragie Karunaratne on 12/15/2013.
//  Copyright (c) 2013 Indragie Karunaratne. All rights reserved.
//

#import "KVDBDatabase.h"
#import "KVDBDatabase_Tests.h"
#include <kvdb/kvdb.h>

static int const KVDBIOErrorCode = -2;
static int const KVDBNotFoundErrorCode = -1;

@interface KVDBDatabase ()
@property (nonatomic, copy) void(^enumerationBlock)(NSString *, NSString *, BOOL *);
@end

@implementation KVDBDatabase {
	kvdb *_db;
}

#pragma mark - Initialization

- (id)initWithDatabasePath:(NSString *)path
{
	if ((self = [super init])) {
		_path = [path copy];
		_db = kvdb_new(path.UTF8String);
		if (_db == nil) return nil;
		kvdb_open(_db);
	}
	return self;
}

+ (KVDBDatabase *)databaseWithPath:(NSString *)path
{
	return [[self alloc] initWithDatabasePath:path];
}

#pragma mark - Subscripting

- (id)objectForKeyedSubscript:(id <NSCopying>)key
{
	NSAssert([(id)key isKindOfClass:NSString.class], @"Only NSString keys are supported.");
	const char *cKey = [(NSString *)key UTF8String];
	char *value = NULL;
	size_t value_size;
	int code = kvdb_get(_db, cKey, strlen(cKey), &value, &value_size);
	if (code == KVDBIOErrorCode) {
		NSLog(@"[%@]: I/O error reading key \"%@\"", self, key);
	} else if (code != KVDBIOErrorCode && value != NULL) {
		return [[NSString alloc] initWithBytesNoCopy:value length:value_size encoding:NSUTF8StringEncoding freeWhenDone:YES];
	}
	return nil;
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
	NSAssert([(id)key isKindOfClass:NSString.class], @"Only NSString keys are supported.");
	NSAssert(obj == nil || [obj isKindOfClass:NSString.class], @"Only NSString values are supported.");
	
	const char *cKey = [(NSString *)key UTF8String];
	const char *cValue = [(NSString *)obj UTF8String];
	int code = 0;
	if (obj == nil) {
		code = kvdb_delete(_db, cKey, strlen(cKey));
	} else {
		code = kvdb_set(_db, cKey, strlen(cKey), cValue, strlen(cValue));
	}
	if (code == KVDBIOErrorCode) {
		NSLog(@"[%@]: I/O error assigning key \"%@\"", self, key);
	}
}

#pragma mark - Enumeration

- (void)enumerateKeysAndValuesUsingBlock:(void(^)(NSString *key, NSString *value, BOOL *stop))block
{
	if (block == nil) return;
	
	self.enumerationBlock = block;
	kvdb_enumerate_keys(_db, enumeration_callback, (__bridge void *)self);
}

static void enumeration_callback(kvdb *db, struct kvdb_enumerate_cb_params * params,
								 void * data, int * stop) {
	KVDBDatabase *database = (__bridge id)data;
	NSString *key = [[NSString alloc] initWithCString:params->key encoding:NSUTF8StringEncoding];
	NSString *value = database[key];
	database.enumerationBlock(key, value, (BOOL *)stop);
}

#pragma mark - Private

- (void)close
{
	kvdb_close(_db);
}

#pragma mark - Memory Management

- (void)dealloc
{
	[self close];
	kvdb_free(_db);
}

@end
