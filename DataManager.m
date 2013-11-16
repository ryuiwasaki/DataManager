//
//  DataManager.m
//  NiceClipper
//
//  Created by Ryu Iwasaki on 2013/10/06.
//  Copyright (c) 2013年 Ryu Iwasaki. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager{
    NSMutableArray *_dataSource;
}

//--------------------------------------------------------------//
#pragma mark  - Singleton
//--------------------------------------------------------------//

+ (id)sharedManager{
    
    static  id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
        [sharedInstance load];
    });
    
    return sharedInstance;
}

- (id)init{
    self = [super init];
    
    if (self) {
        _dataSource = [NSMutableArray new];
        
    }
    return self;
}

- (NSMutableArray *)dataSource{

    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    
    return _dataSource;
}

//--------------------------------------------------------------//
#pragma mark  - Serialize
//--------------------------------------------------------------//

- (BOOL)load{

    return [self loadFromData];
}

- (BOOL)loadFromData{
    
    NSString *archiveFilePath = [self archiveFilePathWithDirectoryNameInDocumentsDirectory:[self archiveDataDirectoryName]
                                                                                  fileName:[self archiveDataFileName]];
    NSMutableArray *data = [NSKeyedUnarchiver unarchiveObjectWithFile:archiveFilePath];
    
    if (!data) {
        _dataSource = [NSMutableArray new];
        return NO;
    }
    
    _dataSource = data;
    return YES;
}

- (BOOL)loadFromFile{
    
    NSString *archiveFilePath = [self archiveFilePathWithDirectoryNameInDocumentsDirectory:[self archiveDataDirectoryName]
                                                                                  fileName:[self archivePlistFileName]];
    
    _dataSource = [[NSArray arrayWithContentsOfFile:archiveFilePath] mutableCopy];
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        return NO;
    }
    
    return YES;
    
    
}

- (void)save{
    [self saveAtData];
}

- (void)saveAtData{
    
    NSString *archiveFilePath = [self archiveFilePathWithDirectoryNameInDocumentsDirectory:[self archiveDataDirectoryName]
                                                                                  fileName:[self archiveDataFileName]];
    if ( [NSKeyedArchiver archiveRootObject:_dataSource toFile:archiveFilePath] ) {
        
    } else {
        
        // Error Code.
        return;
    }
}

- (void)saveAtFile{
    
    NSString *archiveFilePath = [self archiveFilePathWithDirectoryNameInDocumentsDirectory:[self archiveDataDirectoryName]
                                                                                  fileName:[self archivePlistFileName]];
   
    if ( [_dataSource writeToFile:archiveFilePath atomically:NO] ){
        
    } else {
        
        // Error Code.
        return;
    }
    
}


// Return archive datafile path. there are documents directory.
// Datafile is archived in DataManager Class Name Directory.
// Datafile name is named DataManager Class Name Directory additional extensions.
- (NSString *)archiveFilePathWithDirectoryNameInDocumentsDirectory:(NSString *)dirName fileName:(NSString *)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirPath = [paths objectAtIndex:0];
    NSString *archiveDirPath = [documentsDirPath stringByAppendingPathComponent:dirName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    if (![fileManager fileExistsAtPath:archiveDirPath]) {
        
        if ( [fileManager createDirectoryAtPath:archiveDirPath
                    withIntermediateDirectories:YES
                                     attributes:nil
                                          error:&error] ) {
            if (error) {
                // Error Code.
                
            }
        }
    }
    
    NSString *archiveFilePath = [archiveDirPath stringByAppendingPathComponent:fileName];
    
    return archiveFilePath;
}

- (NSString *)archiveDataDirectoryName{
    
    NSString *dirName = [[NSString alloc]initWithFormat:@".%@",NSStringFromClass([self class])];
    
    return dirName;
}

- (NSString *)archiveDataFileName{
    
    NSString *fileName = [[NSString alloc]initWithFormat:@".%@.dat",NSStringFromClass([self class])];
    
    return fileName;
}

- (NSString *)archivePlistFileName{
    
    NSString *fileName = [[NSString alloc]initWithFormat:@".%@.plist",NSStringFromClass([self class])];
    
    return fileName;
}


//--------------------------------------------------------------//
#pragma mark  - DataSource
//--------------------------------------------------------------//

- (NSUInteger)indexOfObject:(id)anObject{
    return [_dataSource indexOfObject:anObject];
}

- (NSUInteger)indexOfObject:(id)anObject inRange:(NSRange)range{
    return [_dataSource indexOfObject:anObject inRange:range];
}

- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject{
    return [_dataSource indexOfObjectIdenticalTo:anObject];
}

- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject inRange:(NSRange)range{
    return [_dataSource indexOfObjectIdenticalTo:anObject inRange:range];
}

- (id)objectAtIndex:(NSUInteger)index{
    return _dataSource[index];
}

- (id)firstObject NS_AVAILABLE(10_6, 4_0){
    return [_dataSource firstObject];
}

- (id)lastObject{
    return [_dataSource lastObject];
}

- (NSEnumerator *)objectEnumerator{
    return [_dataSource objectEnumerator];
}

- (NSEnumerator *)reverseObjectEnumerator{
    return [_dataSource reverseObjectEnumerator];
}

- (NSInteger)count{
    
    return _dataSource.count;
}

- (void)addObject:(id)anObject{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource addObject:anObject];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource insertObject:anObject atIndex:index];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)removeLastObject{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource removeLastObject];
    [self didChangeValueForKey:@"dataSource"];
}


- (void)removeObjectAtIndex:(NSUInteger)index{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource removeObjectAtIndex:index];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource replaceObjectAtIndex:index withObject:anObject];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)addObjectsFromArray:(NSArray *)otherArray{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource addObjectsFromArray:otherArray];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)removeAllObjects{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource removeAllObjects];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)removeObject:(id)anObject inRange:(NSRange)range{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource removeObject:anObject inRange:range];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)removeObject:(id)anObject{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource removeObject:anObject];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource removeObjectIdenticalTo:anObject inRange:range];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)removeObjectIdenticalTo:(id)anObject{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource removeObjectIdenticalTo:anObject];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)removeObjectsInArray:(NSArray *)otherArray{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource removeObjectsInArray:otherArray];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)removeObjectsInRange:(NSRange)range{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource removeObjectsInRange:range];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray range:(NSRange)otherRange{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource replaceObjectsInRange:range withObjectsFromArray:otherArray];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)setArray:(NSArray *)otherArray{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource setArray:otherArray];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)sortUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource sortUsingFunction:compare context:context];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)sortUsingSelector:(SEL)comparator{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource sortUsingSelector:comparator];
    [self didChangeValueForKey:@"dataSource"];
}


- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource insertObjects:objects atIndexes:indexes];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource removeObjectsAtIndexes:indexes];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects{
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource replaceObjectsAtIndexes:indexes withObjects:objects];
    [self didChangeValueForKey:@"dataSource"];
}


- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0){
    [self willChangeValueForKey:@"dataSource"];
    [_dataSource setObject:obj atIndexedSubscript:idx];
    [self didChangeValueForKey:@"dataSource"];
}

- (void)sortUsingComparator:(NSComparator)cmptr NS_AVAILABLE(10_6, 4_0){
    [_dataSource sortUsingComparator:cmptr];
}

- (void)sortWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr NS_AVAILABLE(10_6, 4_0){
    [_dataSource sortWithOptions:opts usingComparator:cmptr];
}


- (NSArray *)searchedDataFromObjectKey:(NSString *)key value:(NSString *)value{
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"%K = CONTAINS '%K'",key,value];
    NSArray *results = [_dataSource filteredArrayUsingPredicate:filter];
    
    return results;
}


@end
