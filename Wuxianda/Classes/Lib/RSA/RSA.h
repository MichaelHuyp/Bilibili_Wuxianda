// RSA.h
//
// Copyright (c) 2012 scott ban
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

typedef void (^GenerateSuccessBlock)(void);

@interface RSA : NSObject{
@private
    NSData * publicTag;
	NSData * privateTag;
    NSOperationQueue * cryptoQueue;
    GenerateSuccessBlock success;
}

@property (nonatomic,readonly) SecKeyRef publicKeyRef;
@property (nonatomic,readonly) SecKeyRef privateKeyRef;
@property (nonatomic,readonly) NSData   *publicKeyBits;
@property (nonatomic,readonly) NSData   *privateKeyBits;


+ (id)shareInstance;
//生成公钥和私钥
- (void)generateKeyPairRSACompleteBlock:(GenerateSuccessBlock)_success;

//公钥加密
- (NSData *)RSA_EncryptUsingPublicKeyWithData:(NSData *)data;
//私钥加密
- (NSData *)RSA_EncryptUsingPrivateKeyWithData:(NSData*)data;
//公钥解密
- (NSData *)RSA_DecryptUsingPublicKeyWithData:(NSData *)data;
//私钥解密
- (NSData *)RSA_DecryptUsingPrivateKeyWithData:(NSData*)data;


+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSString *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;

@end



















