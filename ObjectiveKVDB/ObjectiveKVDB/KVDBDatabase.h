//
//  KVDBDatabase.h
//  ObjectiveKVDB
//
//  Created by Indragie Karunaratne on 12/15/2013.
//  Copyright (c) 2013 Indragie Karunaratne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVDBDatabase : NSObject

/**
 *  Creates a new KVDBDatabase instance for a database file at the specified path.
 *
 *  @param path The database path.
 *
 *  @return A new instance of KVDBDatabase.
 */
- (id)initWithDatabasePath:(NSString *)path;

/**
 *  Creates a new KVDBDatabase instance for a database file at the specified path.
 *
 *  @param path The database path.
 *
 *  @return A new instance of KVDBDatabase.
 */
+ (KVDBDatabase *)databaseWithPath:(NSString *)path;

/**
 *  Returns the database path.
 */
@property (nonatomic, copy, readonly) NSString *path;

#pragma mark - Subscripting

/**
 *  
 *  Example usage:
 *      db[@"some key"] = @"some value";
 *      NSLog(@"%@", db[@"some key"]); ==> @"some value"
 *
 *  To remove a key, set it's value to `nil`:
 *      db[@"key to remove"] = nil;
 *
 */
- (id)objectForKeyedSubscript:(id <NSCopying>)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

#pragma mark - Enumeration

/**
 *  Enumerate all keys and values in the receiver.
 *
 *  @param block Block to be called on each enumerated value.
 */
- (void)enumerateKeysAndValuesUsingBlock:(void(^)(NSString *key, NSString *value, BOOL *stop))block;

@end
