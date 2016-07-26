//
//  CryptorTools.m
//  加密/解密工具
//
//  Created by 刘凡 on 15/4/26.
//  Copyright (c) 2015年 joyios. All rights reserved.
//

#import "CryptorTools.h"
#import <CommonCrypto/CommonCrypto.h>

// 填充模式
#define kTypeOfWrapPadding		kSecPaddingPKCS1

@interface CryptorTools() {
    SecKeyRef _publicKeyRef;                             // 公钥引用
    SecKeyRef _privateKeyRef;                            // 私钥引用
}

@end

@implementation CryptorTools

#pragma mark - DES 加密/解密
#pragma mark 加密
+ (NSData *)DESEncryptData:(NSData *)data keyString:(NSString *)keyString iv:(NSData *)iv {
    return [self CCCryptData:data algorithm:kCCAlgorithmDES operation:kCCEncrypt keyString:keyString iv:iv];
}

+ (NSString *)DESEncryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [self DESEncryptData:data keyString:keyString iv:iv];
    
    // BASE 64 编码
    return [result base64EncodedStringWithOptions:0];
}

#pragma mark 解密
+ (NSData *)DESDecryptData:(NSData *)data keyString:(NSString *)keyString iv:(NSData *)iv {
    return [self CCCryptData:data algorithm:kCCAlgorithmDES operation:kCCDecrypt keyString:keyString iv:iv];
}

+ (NSString *)DESDecryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv {
    // BASE 64 解码
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSData *result = [self DESDecryptData:data keyString:keyString iv:iv];
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

#pragma mark - AES 加密/解密
#pragma mark 加密
+ (NSData *)AESEncryptData:(NSData *)data keyString:(NSString *)keyString iv:(NSData *)iv {
    return [self CCCryptData:data algorithm:kCCAlgorithmAES operation:kCCEncrypt keyString:keyString iv:iv];
}

+ (NSString *)AESEncryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [self AESEncryptData:data keyString:keyString iv:iv];
    
    // BASE 64 编码
    return [result base64EncodedStringWithOptions:0];
}

#pragma mark 解密
+ (NSData *)AESDecryptData:(NSData *)data keyString:(NSString *)keyString iv:(NSData *)iv {
    return [self CCCryptData:data algorithm:kCCAlgorithmAES operation:kCCDecrypt keyString:keyString iv:iv];
}

+ (NSString *)AESDecryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv {
    // BASE 64 解码
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSData *result = [self AESDecryptData:data keyString:keyString iv:iv];
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

#pragma mark 对称加密&解密核心方法
///  对称加密&解密核心方法
///
///  @param data      加密/解密的二进制数据
///  @param algorithm 加密算法
///  @param operation 加密/解密操作
///  @param keyString 密钥字符串
///  @param iv        IV 向量
///
///  @return 加密/解密结果
+ (NSData *)CCCryptData:(NSData *)data algorithm:(CCAlgorithm)algorithm operation:(CCOperation)operation keyString:(NSString *)keyString iv:(NSData *)iv {
    
    int keySize = (algorithm == kCCAlgorithmAES) ? kCCKeySizeAES128 : kCCKeySizeDES;
    int blockSize = (algorithm == kCCAlgorithmAES) ? kCCBlockSizeAES128: kCCBlockSizeDES;
    
    // 设置密钥
    NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t cKey[keySize];
    bzero(cKey, sizeof(cKey));
    [keyData getBytes:cKey length:keySize];
    
    // 设置 IV 向量
    uint8_t cIv[blockSize];
    bzero(cIv, blockSize);
    int option = kCCOptionPKCS7Padding | kCCOptionECBMode;
    if (iv) {
        [iv getBytes:cIv length:blockSize];
        option = kCCOptionPKCS7Padding;
    }
    
    // 设置输出缓冲区
    size_t bufferSize = [data length] + blockSize;
    void *buffer = malloc(bufferSize);
    
    // 加密或解密
    size_t cryptorSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          algorithm,
                                          option,
                                          cKey,
                                          keySize,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &cryptorSize);
    
    NSData *result = nil;
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:cryptorSize];
    } else {
        free(buffer);
        NSLog(@"[错误] 加密或解密失败 | 状态编码: %d", cryptStatus);
    }
    
    return result;
}

#pragma mark - RSA 加密/解密算法
- (void)loadPublicKeyWithFilePath:(NSString *)filePath; {
    
    NSAssert(filePath.length != 0, @"公钥路径为空");
    
    // 删除当前公钥
    if (_publicKeyRef) CFRelease(_publicKeyRef);
    
    // 从一个 DER 表示的证书创建一个证书对象
    NSData *certificateData = [NSData dataWithContentsOfFile:filePath];
    SecCertificateRef certificateRef = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
    NSAssert(certificateRef != NULL, @"公钥文件错误");
    
    // 返回一个默认 X509 策略的公钥对象，使用之后需要调用 CFRelease 释放
    SecPolicyRef policyRef = SecPolicyCreateBasicX509();
    // 包含信任管理信息的结构体
    SecTrustRef trustRef;
    
    // 基于证书和策略创建一个信任管理对象
    OSStatus status = SecTrustCreateWithCertificates(certificateRef, policyRef, &trustRef);
    NSAssert(status == errSecSuccess, @"创建信任管理对象失败");
    
    // 信任结果
    SecTrustResultType trustResult;
    // 评估指定证书和策略的信任管理是否有效
    status = SecTrustEvaluate(trustRef, &trustResult);
    NSAssert(status == errSecSuccess, @"信任评估失败");
    
    // 评估之后返回公钥子证书
    _publicKeyRef = SecTrustCopyPublicKey(trustRef);
    NSAssert(_publicKeyRef != NULL, @"公钥创建失败");
    
    if (certificateRef) CFRelease(certificateRef);
    if (policyRef) CFRelease(policyRef);
    if (trustRef) CFRelease(trustRef);
}

- (void)loadPrivateKey:(NSString *)filePath password:(NSString *)password {
    
    NSAssert(filePath.length != 0, @"私钥路径为空");
    
    // 删除当前私钥
    if (_privateKeyRef) CFRelease(_privateKeyRef);
    
    NSData *PKCS12Data = [NSData dataWithContentsOfFile:filePath];
    CFDataRef inPKCS12Data = (__bridge CFDataRef)PKCS12Data;
    CFStringRef passwordRef = (__bridge CFStringRef)password;
    
    // 从 PKCS #12 证书中提取标示和证书
    SecIdentityRef myIdentity;
    SecTrustRef myTrust;
    const void *keys[] = {kSecImportExportPassphrase};
    const void *values[] = {passwordRef};
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    
    // 返回 PKCS #12 格式数据中的标示和证书
    OSStatus status = SecPKCS12Import(inPKCS12Data, optionsDictionary, &items);
    
    if (status == noErr) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items, 0);
        myIdentity = (SecIdentityRef)CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        myTrust = (SecTrustRef)CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
    }

    if (optionsDictionary) CFRelease(optionsDictionary);
    
    NSAssert(status == noErr, @"提取身份和信任失败");
    
    SecTrustResultType trustResult;
    // 评估指定证书和策略的信任管理是否有效
    status = SecTrustEvaluate(myTrust, &trustResult);
    NSAssert(status == errSecSuccess, @"信任评估失败");
    
    // 提取私钥
    status = SecIdentityCopyPrivateKey(myIdentity, &_privateKeyRef);
    NSAssert(status == errSecSuccess, @"私钥创建失败");
    CFRelease(items);
}

//- (NSString *)RSAEncryptString:(NSString *)string publicKey:(NSString *)publicKey
//{
//    NSData *cipher = [self RSAEncryptData:[string dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    return [cipher base64EncodedStringWithOptions:0];
//}

- (NSString *)RSAEncryptString:(NSString *)string {
    NSData *cipher = [self RSAEncryptData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    return [cipher base64EncodedStringWithOptions:0];
}

- (NSData *)RSAEncryptData:(NSData *)data {
    OSStatus sanityCheck = noErr;
    size_t cipherBufferSize = 0;
    size_t keyBufferSize = 0;
    
    NSAssert(data, @"明文数据为空");
    NSAssert(_publicKeyRef, @"公钥为空");
    
    NSData *cipher = nil;
    uint8_t *cipherBuffer = NULL;
    
    // 计算缓冲区大小
    cipherBufferSize = SecKeyGetBlockSize(_publicKeyRef);
    keyBufferSize = data.length;
    
    if (kTypeOfWrapPadding == kSecPaddingNone) {
        NSAssert(keyBufferSize <= cipherBufferSize, @"加密内容太大");
    } else {
        NSAssert(keyBufferSize <= (cipherBufferSize - 11), @"加密内容太大");
    }
    
    // 分配缓冲区
    cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0x0, cipherBufferSize);
    
    // 使用公钥加密
    sanityCheck = SecKeyEncrypt(_publicKeyRef,
                                kTypeOfWrapPadding,
                                (const uint8_t *)data.bytes,
                                keyBufferSize,
                                cipherBuffer,
                                &cipherBufferSize
                                );
    
    NSAssert(sanityCheck == noErr, @"加密错误，OSStatus == %d", sanityCheck);
    
    // 生成密文数据
    cipher = [NSData dataWithBytes:(const void *)cipherBuffer length:(NSUInteger)cipherBufferSize];
    
    if (cipherBuffer) free(cipherBuffer);
    
    return cipher;
}

- (NSString *)RSADecryptString:(NSString *)string {
    NSData *keyData = [self RSADecryptData:[[NSData alloc] initWithBase64EncodedString:string options:0]];
    
    return [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];
}

- (NSData *)RSADecryptData:(NSData *)data {
    OSStatus sanityCheck = noErr;
    size_t cipherBufferSize = 0;
    size_t keyBufferSize = 0;
    
    NSData *key = nil;
    uint8_t *keyBuffer = NULL;
    
    SecKeyRef privateKey = _privateKeyRef;
    NSAssert(privateKey != NULL, @"私钥不存在");
    
    // 计算缓冲区大小
    cipherBufferSize = SecKeyGetBlockSize(privateKey);
    keyBufferSize = data.length;
    
    NSAssert(keyBufferSize <= cipherBufferSize, @"解密内容太大");
    
    // 分配缓冲区
    keyBuffer = malloc(keyBufferSize * sizeof(uint8_t));
    memset((void *)keyBuffer, 0x0, keyBufferSize);
    
    // 使用私钥解密
    sanityCheck = SecKeyDecrypt(privateKey,
                                kTypeOfWrapPadding,
                                (const uint8_t *)data.bytes,
                                cipherBufferSize,
                                keyBuffer,
                                &keyBufferSize
                                );
    
    NSAssert1(sanityCheck == noErr, @"解密错误，OSStatus == %d", sanityCheck);
    
    // 生成明文数据
    key = [NSData dataWithBytes:(const void *)keyBuffer length:(NSUInteger)keyBufferSize];
    
    if (keyBuffer) free(keyBuffer);
    
    return key;
}


+ (SecKeyRef)getPublicKeyRef {
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"rsacert" ofType:@"der"];
    NSData *certData = [NSData dataWithContentsOfFile:resourcePath];
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, (CFDataRef)certData);
    SecKeyRef key = NULL;
    SecTrustRef trust = NULL;
    SecPolicyRef policy = NULL;
    if (cert != NULL) {
        policy = SecPolicyCreateBasicX509();
        if (policy) {
            if (SecTrustCreateWithCertificates((CFTypeRef)cert, policy, &trust) == noErr) {
                SecTrustResultType result;
                if (SecTrustEvaluate(trust, &result) == noErr) {
                    key = SecTrustCopyPublicKey(trust);
                }
            }
        }
    }
    if (policy) CFRelease(policy);
    if (trust) CFRelease(trust);
    if (cert) CFRelease(cert);
    return key;
}

+ (SecKeyRef)getPrivateKeyRef {
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"p" ofType:@"p12"];
    NSData *p12Data = [NSData dataWithContentsOfFile:resourcePath];
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    SecKeyRef privateKeyRef = NULL;
    //change to the actual password you used here
    [options setObject:@"password_for_the_key" forKey:(id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((CFDataRef) p12Data,
                                             (CFDictionaryRef)options, &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp =
        (SecIdentityRef)CFDictionaryGetValue(identityDict,
                                             kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    CFRelease(items);
    return privateKeyRef;
}

- (void)rsaTest
{
    NSString *encryptionStr = @"yllOp/M6ZAK0ch6buZZIMFdkrQqNveJaO9jfu+0GoG1O2U/Q+OFAwgmn+qn7KfWtfSJsElYwoX9agaKlHQyexN5L+yqRw9fGDPgwKC6eXCOkbDNVJpWSwllW6FLQMSxfytt4pLnv/tQZXFAAb8DyR5IrmezE7e7N1Z1pN8L0YmY=";
    
    SecKeyRef publicKey = [CryptorTools getPublicKeyRef];
    
    NSLog(@"%@",publicKey);
    
    // 创建加密对象
    CryptorTools *tool = [[CryptorTools alloc] init];
    // 要加密的内容
    NSString *msg = @"i love you";
    // 加载公钥
    NSString *pubPath = [[NSBundle mainBundle] pathForResource:@"rsacert.der" ofType:nil];
    [tool loadPublicKeyWithFilePath:pubPath];
    // 使用公钥加密
    NSString *result = [tool RSAEncryptString:msg];
    NSLog(@"加密 = %@",result);
    
    
    //解密
    //加载私钥
    //密码是导出p12密码
    NSString *privatePath = [[NSBundle mainBundle] pathForResource:@"p.p12" ofType:nil];
    [tool loadPrivateKey:privatePath password:@"123456"];
    //使用私钥解密
    NSString *result2 = [tool RSADecryptString:encryptionStr];
    NSLog(@"解密 = %@",result2);
    
}

@end
