## ObjectiveKVDB
### Objective-C wrapper for [kvdb](https://github.com/dinhviethoa/kvdb)

ObjectiveKVDB is a super simple Objective-C wrapper for [@dinhviethoa](http://github.com/dinhviethoa)'s kvdb, a key-value store written in C.

#### Submodule

To build the framework and run tests, the kvdb submodule needs to be cloned first by running:

```
git submodule update --init
```

#### Example Usage

All keys and values are stored as UTF-8 encoded string data. Only `NSString` keys and values are supported.

```obj-c
KVDBDatabase *db = [KVDBDatabase databaseWithPath:@"/path/to/database.db"];

// Store a value
db[@"some key"] = @"some value";

// Delete a value
db[@"some key"] = nil;

// Enumerate values
for (int i = 0; i < 20; i++) {
	NSString *stringValue = @(i).stringValue;
	self.db[stringValue] = stringValue;
}

[db enumerateKeysAndValuesUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
	NSLog(@"%@ : %@", key, value);
}];
```
