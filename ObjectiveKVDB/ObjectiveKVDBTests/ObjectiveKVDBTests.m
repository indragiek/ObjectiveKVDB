//
//  ObjectiveKVDBTests.m
//  ObjectiveKVDBTests
//
//  Created by Indragie Karunaratne on 12/15/2013.
//  Copyright (c) 2013 Indragie Karunaratne. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KVDBDatabase_Tests.h"

// Test Data
static NSString * const KVDBTestKey = @"emoji key 👻🍔👍";
static NSString * const KVDBTestValue = @"emoji value 💥🌟⚡️";

@interface ObjectiveKVDBTests : XCTestCase
@property (nonatomic, strong) KVDBDatabase *db;
@end

@implementation ObjectiveKVDBTests

- (void)setUp
{
    [super setUp];
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"ObjectiveKVDB.db"];
	self.db = [KVDBDatabase databaseWithPath:path];
}

- (void)tearDown
{
    [super tearDown];
	[self.db close];
	[[NSFileManager defaultManager] removeItemAtPath:self.db.path error:nil];
}

- (void)testInitialization
{
	XCTAssertNotNil(self.db, @"KVDBDatabase should not be nil.");
}

- (void)testAssignment
{
	self.db[KVDBTestKey] = KVDBTestValue;
	XCTAssertEqualObjects(KVDBTestValue, self.db[KVDBTestKey], @"Values assigned using subscripting notation should be equal.");
}

- (void)testDeletion
{
	self.db[KVDBTestKey] = KVDBTestValue;
	self.db[KVDBTestKey] = nil;
	XCTAssertEqualObjects(nil, self.db[KVDBTestKey], @"Value should be nil after deletion.");
}

- (void)testPersistence
{
	self.db[KVDBTestKey] = KVDBTestValue;
	[self.db close];
	
	KVDBDatabase *newDB = [KVDBDatabase databaseWithPath:self.db.path];
	XCTAssertEqualObjects(newDB[KVDBTestKey], KVDBTestValue, @"Persisted values should be equal");
}

- (void)testEnumeration
{
	const int count = 20;
	for (int i = 0; i < count; i++) {
		NSString *stringValue = @(i).stringValue;
		self.db[stringValue] = stringValue;
	}
	__block int numberOfEnumerations = 0;
	[self.db enumerateKeysAndValuesUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
		XCTAssertEqualObjects(key, value, @"Enumerated keys and values should be equal");
		numberOfEnumerations++;
	}];
	XCTAssertEqual(numberOfEnumerations, count, @"All keys should have been enumerated");
	
	const int enumerationCount = 10;
	numberOfEnumerations = 0;
	[self.db enumerateKeysAndValuesUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
		XCTAssertEqualObjects(key, value, @"Enumerated keys and values should be equal");
		numberOfEnumerations++;
		if (numberOfEnumerations == enumerationCount) {
			*stop = YES;
		}
	}];
	XCTAssertEqual(numberOfEnumerations, enumerationCount, @"Only a certain number of keys and values should have been enumerated");
}

@end
