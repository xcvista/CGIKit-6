//
//  MSDataEncryptionTest.m
//  MSBooster
//
//  Created by Maxthon Chan on 9/19/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "MSDataEncryptionTest.h"

@implementation MSDataEncryptionTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testConstantStringCrypto
{
    NSString *sourceString = @"This is a plaintext";
    NSString *key = @"hush";
    
    NSData *sourceData = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *IV = [NSData randomDataWithLength:64];
    
    NSLog(@"Source Plaintext: %@", sourceData);
    NSLog(@"Key: %@", keyData);
    
    NSData *cryptData = [sourceData scrambleUsingKey:keyData initializer:IV delegate:nil];
    
    STAssertNotNil(cryptData, nil);
    
    NSLog(@"Ciphertext: %@", cryptData);
    
    NSData *decryptedData = [cryptData scrambleUsingKey:keyData initializer:IV delegate:nil];
    
    STAssertEqualObjects(sourceData, decryptedData, nil);
    NSLog(@"Decrypted: %@", decryptedData);
}

- (void)testRandomStringCrypto
{
    
    NSFileHandle *urandom = [NSFileHandle fileHandleForReadingAtPath:@"/dev/urandom"];
    
    NSData *sourceData = [urandom readDataOfLength:512];
    NSData *keyData = [urandom readDataOfLength:80];
    NSData *IV = [NSData randomDataWithLength:64];
    
    NSLog(@"Source Plaintext: %@", sourceData);
    NSLog(@"Key: %@", keyData);
    
    NSData *cryptData = [sourceData scrambleUsingKey:keyData initializer:IV delegate:nil];
    
    STAssertNotNil(cryptData, nil);
    
    NSLog(@"Ciphertext: %@", cryptData);
    
    NSData *decryptedData = [cryptData scrambleUsingKey:keyData initializer:IV delegate:nil];
    
    STAssertEqualObjects(sourceData, decryptedData, nil);
    NSLog(@"Decrypted: %@", decryptedData);
}

- (void)testRandomStringAESCrypto
{
    
    NSFileHandle *urandom = [NSFileHandle fileHandleForReadingAtPath:@"/dev/urandom"];
    
    NSData *sourceData = [urandom readDataOfLength:512];
    NSData *keyData = [urandom readDataOfLength:80];
    NSData *IV = [NSData randomDataWithLength:64];
    
    NSLog(@"Source Plaintext: %@", sourceData);
    NSLog(@"Key: %@", keyData);
    
    NSData *cryptData = [sourceData encryptUsingKey:keyData initializer:IV];
    
    STAssertNotNil(cryptData, nil);
    
    NSLog(@"Ciphertext: %@", cryptData);
    
    NSData *decryptedData = [cryptData decryptUsingKey:keyData initializer:IV];
    
    STAssertEqualObjects(sourceData, decryptedData, nil);
    NSLog(@"Decrypted: %@", decryptedData);
}

- (void)testBigRandomStringCrypto
{
    
    NSLog(@"Crypto 1MB");
    
    NSFileHandle *urandom = [NSFileHandle fileHandleForReadingAtPath:@"/dev/urandom"];
    
    NSData *sourceData = [urandom readDataOfLength:1UL << 20]; // 1MB of data
    NSData *keyData = [urandom readDataOfLength:1UL << 10]; // 1KB of keyfile
    NSData *IV = [NSData randomDataWithLength:64];
    
    NSLog(@"Read 1MB");
    
    //NSLog(@"Source Plaintext: %@", sourceData);
    //NSLog(@"Key: %@", keyData);
    
    NSData *cryptData = [sourceData scrambleUsingKey:keyData initializer:IV delegate:nil];
    
    STAssertNotNil(cryptData, nil);
    
    //NSLog(@"Ciphertext: %@", cryptData);
    
    NSLog(@"Decrypto 1MB");
    
    NSData *decryptedData = [cryptData scrambleUsingKey:keyData initializer:IV delegate:nil];
    
    STAssertEqualObjects(sourceData, decryptedData, nil);
    //NSLog(@"Decrypted: %@", decryptedData);
    
    NSLog(@"Done 1MB");
}

- (void)testBigRandomStringAESCrypto
{
    
    NSLog(@"Crypto 1MB");
    
    NSFileHandle *urandom = [NSFileHandle fileHandleForReadingAtPath:@"/dev/urandom"];
    
    NSData *sourceData = [urandom readDataOfLength:1UL << 20]; // 1MB of data
    NSData *keyData = [urandom readDataOfLength:1UL << 10]; // 1KB of keyfile
    NSData *IV = [NSData randomDataWithLength:64];
    
    NSLog(@"Read 1MB");
    
    //NSLog(@"Source Plaintext: %@", sourceData);
    //NSLog(@"Key: %@", keyData);
    
    NSData *cryptData = [sourceData encryptUsingKey:keyData initializer:IV];
    
    STAssertNotNil(cryptData, nil);
    
    //NSLog(@"Ciphertext: %@", cryptData);
    
    NSLog(@"Decrypto 1MB");
    
    NSData *decryptedData = [cryptData decryptUsingKey:keyData initializer:IV];
    
    STAssertEqualObjects(sourceData, decryptedData, nil);
    //NSLog(@"Decrypted: %@", decryptedData);
    
    NSLog(@"Done 1MB");
}

- (void)testHugeRandomStringCrypto
{
    
    NSLog(@"Crypto 32MB");
    
    NSFileHandle *urandom = [NSFileHandle fileHandleForReadingAtPath:@"/dev/urandom"];
    
    NSData *sourceData = [urandom readDataOfLength:1UL << 25]; // 32MB of data
    NSData *keyData = [urandom readDataOfLength:1UL << 10]; // 1KB of keyfile
    NSData *IV = [NSData randomDataWithLength:64];
    
    NSLog(@"Read 32MB");
    
    //NSLog(@"Source Plaintext: %@", sourceData);
    //NSLog(@"Key: %@", keyData);
    
    NSData *cryptData = [sourceData scrambleUsingKey:keyData initializer:IV delegate:nil];
    
    //NSLog(@"Ciphertext: %@", cryptData);
    
    NSLog(@"Decrypto 32MB");
    
    NSData *decryptedData = [cryptData scrambleUsingKey:keyData initializer:IV delegate:nil];
    
    STAssertEqualObjects(sourceData, decryptedData, nil);
    //NSLog(@"Decrypted: %@", decryptedData);
    
    NSLog(@"Done 32MB");
}

- (void)testHugeRandomStringAESCrypto
{
    
    NSLog(@"Crypto 32MB");
    
    NSFileHandle *urandom = [NSFileHandle fileHandleForReadingAtPath:@"/dev/urandom"];
    
    NSData *sourceData = [urandom readDataOfLength:1UL << 25]; // 32MB of data
    NSData *keyData = [urandom readDataOfLength:1UL << 10]; // 1KB of keyfile
    NSData *IV = [NSData randomDataWithLength:64];
    
    NSLog(@"Read 32MB");
    
    //NSLog(@"Source Plaintext: %@", sourceData);
    //NSLog(@"Key: %@", keyData);
    
    NSData *cryptData = [sourceData encryptUsingKey:keyData initializer:IV];
    
    STAssertNotNil(cryptData, nil);
    
    //NSLog(@"Ciphertext: %@", cryptData);
    
    NSLog(@"Decrypto 1MB");
    
    NSData *decryptedData = [cryptData decryptUsingKey:keyData initializer:IV];
    
    STAssertEqualObjects(sourceData, decryptedData, nil);
    //NSLog(@"Decrypted: %@", decryptedData);
    
    NSLog(@"Done 32MB");
}

@end
