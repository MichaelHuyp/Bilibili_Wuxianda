//
//  CryptorTools.h
//  加密/解密工具
//
//  Created by 刘凡 on 15/4/26.
//  Copyright (c) 2015年 joyios. All rights reserved.
//

#import <Foundation/Foundation.h>

///  加密工具类
///  提供RSA & AES & DES加密方法
@interface CryptorTools : NSObject

#pragma mark - DES 加密/解密
///  DES 加密
///
///  @param data      要加密的二进制数据
///  @param keyString 加密密钥
///  @param iv        IV向量
///
///  @return 加密后的二进制数据
+ (NSData *)DESEncryptData:(NSData *)data keyString:(NSString *)keyString iv:(NSData *)iv;

///  DES 加密字符串
///
///  @param string    要加密的字符串
///  @param keyString 加密密钥
///  @param iv        IV向量
///
///  @return 加密后的 BASE64 编码字符串
+ (NSString *)DESEncryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv;

///  DES 解密
///
///  @param data      要解密的二进制数据
///  @param keyString 解密密钥
///  @param iv        IV向量
///
///  @return 解密后的二进制数据
+ (NSData *)DESDecryptData:(NSData *)data keyString:(NSString *)keyString iv:(NSData *)iv;

///  DES 解密
///
///  @param string    要解密的 BASE64 编码字符串
///  @param keyString 解密密钥
///  @param iv        IV向量
///
///  @return 解密后的二进制数据
+ (NSString *)DESDecryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv;

#pragma mark - AES 加密/解密
///  AES 加密
///
///  @param data      要加密的二进制数据
///  @param keyString 加密密钥
///  @param iv        IV向量
///
///  @return 加密后的二进制数据
+ (NSData *)AESEncryptData:(NSData *)data keyString:(NSString *)keyString iv:(NSData *)iv;

///  AES 加密字符串
///
///  @param string    要加密的字符串
///  @param keyString 加密密钥
///  @param iv        IV向量
///
///  @return 加密后的 BASE64 编码字符串
+ (NSString *)AESEncryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv;

///  AES 解密
///
///  @param data      要解密的二进制数据
///  @param keyString 解密密钥
///  @param iv        IV向量
///
///  @return 解密后的二进制数据
+ (NSData *)AESDecryptData:(NSData *)data keyString:(NSString *)keyString iv:(NSData *)iv;

///  AES 解密
///
///  @param string    要解密的 BASE64 编码字符串
///  @param keyString 解密密钥
///  @param iv        IV向量
///
///  @return 解密后的二进制数据
+ (NSString *)AESDecryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv;

#pragma mark - RSA 加密/解密算法
///  加载公钥
///
///  @param filePath DER 公钥文件路径
- (void)loadPublicKeyWithFilePath:(NSString *)filePath;

///  加载私钥
///
///  @param filePath P12 私钥文件路径
///  @param password P12 密码
- (void)loadPrivateKey:(NSString *)filePath password:(NSString *)password;

///  RSA 加密数据
///
///  @param data 要加密的数据
///
///  @return 加密后的二进制数据
- (NSData *)RSAEncryptData:(NSData *)data;

///  RSA 加密字符串
///
///  @param string 要加密的字符串
///
///  @return 加密后的 BASE64 编码字符串
- (NSString *)RSAEncryptString:(NSString *)string;

///  RSA 解密数据
///
///  @param data 要解密的数据
///
///  @return 解密后的二进制数据
- (NSData *)RSADecryptData:(NSData *)data;

///  RSA 解密字符串
///
///  @param string 要解密的 BASE64 编码字符串
///
///  @return 解密后的字符串
- (NSString *)RSADecryptString:(NSString *)string;


- (NSString *)RSAEncryptString:(NSString *)string publicKey:(NSString *)publicKey;

+ (SecKeyRef)getPublicKeyRef;
+ (SecKeyRef)getPrivateKeyRef;

@end
