/*
 *  pinyin.h
 *  Chinese Pinyin First Letter
 *
 *  Created by George on 4/21/10.
 *  Copyright 2010 RED/SAFI. All rights reserved.
 *
 */


//--------------------------------------------
//      MARK:NSString 扩展
//-------------------------------------------
@interface NSString (FirstLetter)

//  获取第一个汉字拼音首字母
- (NSString *)firstLetter;

//  获取所有汉字拼音首字母
- (NSString *)firstLetters;

@end


//--------------------------------------------
//      MARK:NSArray 扩展
//-------------------------------------------
@interface NSArray (FirstLetterArray)

//	如果给定的数组对象里边都是字符串则调用此方法
- (NSDictionary *)sortedArrayUsingFirstLetter;

//	如果给定的数组里边是Model，或者字典则用这个，并且给出KeyPath
- (NSDictionary *)sortedArrayUsingFirstLetterByKeypath:(NSString *)keyPath;

@end


//--------------------------------------------
//      MARK:HTFirstLetter
//-------------------------------------------
@interface HTFirstLetter : NSObject

//获取汉字首字母，如果参数既不是汉字也不是英文字母，则返回 @“#”
+ (NSString *)firstLetter:(NSString *)chineseString;

//返回参数中所有汉字的首字母，遇到其他字符，则用 # 替换
+ (NSString *)firstLetters:(NSString *)chineseString;

@end