//
//  NSString+Extension.h
//  HotPotNet
//
//  Created by 天天掌 on 16/12/16.
//  Copyright © 2016年 shepai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

// 将int类型转成NSString
FOUNDATION_EXTERN NSString *stringWithInt(int number);

// 将NSInteger类型转成NSString
FOUNDATION_EXTERN NSString *stringWithInteger(NSInteger number);

// 将double类型转成NSString，默认2位小数
FOUNDATION_EXTERN NSString *stringWithDouble(double number);

// 将double类型转成NSString并带上小数位数
FOUNDATION_EXTERN NSString *stringWithDoubleAndDecimalCount(double number, unsigned int count);

/**
 价格显示处理：末尾不是0，不是小数点
 @return showString
 */
- (NSString *)showShortPriceString;

- (NSString *)showOneShortPriceString;


//去空格
- (NSString *)stringByTrimingWhitespace;

/**
 * Json字符串转换成NSDictionary或者NSArray
 * @jsonString： Json字符串
 * @return：NSDictionary或者NSArray
 */
+ (id)jsonStringToObject:(NSString *)jsonString;


//获取某个字符串或者汉字的首字母
- (NSString *)transformFirstCharactorString;

//判断字符串不超过8个字
+ (BOOL)isValidateName:(NSString *)name maxWordsCount:(NSInteger)maxWordsCount;

//向上取整
+ (NSInteger)discountRoundUp:(CGFloat)sellPrice  discountPrice:(CGFloat)discountPrice;

//向下取整
+ (NSString *)discountRoundDown:(CGFloat)sellPrice  discount:(CGFloat)discount;


//十六进制字符串转数字
+ (NSInteger)numberWithHexString:(NSString *)hexString;

/*
 * 验证邮箱
 */
+ (BOOL)judgeUserEmail:(NSString *)userEmail;

/*
 * 昵称只能由中文、字母或数字组成
 */
+ (BOOL)judgeUserName:(NSString *)userName;

/*
 * 密码：字母和数字的组合
 */
+ (BOOL)judgeUserPassword:(NSString *)password;
+ (BOOL)jp_JudgeUserPassword:(NSString *)password;

/*
 * 验证手机号码
 */
+ (BOOL)judgeUserTelephoneNumber:(NSString*)telephoneNumber;

/*
 * 验证身份证号码
 */
+ (BOOL)judgeUserIdentityCardnumber:(NSString *)identityString;

/**
 时间戳转字符串时间
 @param secs 距1970年的时间戳毫秒
 @param format 时间格式
 @return 转化后的字符串时间
 */
+ (NSString *)stringWithTimeIntervalSince1970:(long long)secs format:(NSString *)format;

//时间转换
+ (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat;

/** 获取当前时间的时间戳 */
+ (NSString *)getNowTimeTimestamp;

//  判断是否以字母开头
- (BOOL)isEnglishFirst:(NSString *)str;

//  判断是否以汉字开头
- (BOOL)isChineseFirst:(NSString *)str;

// base64 编码
- (NSString *)encode:(NSString *)string;

// base64解码
- (NSString *)dencode:(NSString *)base64String;

+ (NSString *)safeString:(id) string;

//判断是否为空字符串
- (BOOL)isNilString;

//判断字符串是否为数字
+ (BOOL)isNumber:(NSString *)strValue;

//判断是否输入除英文中文的字符
+ (BOOL)judgeTheiIllegalCharacter:(NSString *)content;

+ (NSString *)stringFromNumberWithCutMoreZore:(double)number;

/**
 * @param timeiNt : 参数为 秒的时间戳
 * @reture 对应的00:00:00字符串
 */
+ (NSString *)calculateCountDownTimeWithTimeiNt:(NSInteger)timeiNt;

/**
 *  将长数字以3位用逗号隔开表示（例如：18000 -> 18,000）
 *  @param numberString 数字字符串 （例如：@"124234")
 *  @return 以3位用逗号隔开的数字符串（例如：124,234）
 */
+ (NSString *)formatNumber:(NSString *)numberString;
- (NSString *)formatNumber;

/** md5加密 */
- (NSString *)MD5String;
+ (NSString *)MD5String:(NSString *)string;

/** 移除html标签 */
+ (NSString *)removeHTML:(NSString *)html;
+ (NSString *)removeHTML2:(NSString *)html;

//验证是否有效银行卡
+ (BOOL)validateBankCard:(NSString *)bankCard;

//验证IP合法性
+ (BOOL)validateIP:(NSString *)IP;
- (BOOL)isValidIP;

//验证url
+ (BOOL)validateUrl:(NSString *)url;
- (BOOL)validateUrl;

//验证全汉字
+ (BOOL)validateChinese:(NSString *)chinese;
- (BOOL)validateChinese;

//验证文本（忽略大小写）
- (BOOL)isEqualSimString:(NSString *)string;

/** 验证用户名 */
+ (BOOL)validateUserName:(NSString *)name;

/** 字符串是否包含特殊字符 */
- (BOOL)isIncludeSpecialCharact;

//字符串中是否包含汉字
+ (BOOL)hasChinese:(NSString *)str;

//将NSInteger类型转成NSString 自动补位 1-> 01
+ (NSString *)intgerExchageToString:(NSInteger)integer;

/**
 格式化金额
 @param amount 原值 nsinteger
 @return 格式化后的字符串
 */
+ (NSString *)KGDecimalMoney:(NSInteger)amount;

//不需除以1000的格式化
+ (NSString *)KGNormalMoney:(id)amount;

//不需除以1000的格式化 scale精确到小数点后多少位
+ (NSString *)KGDecimalMoney:(NSInteger)amount decimalScale:(NSInteger)scale;

+ (NSString *)formatInputMoney:(NSString *)amount;

//保留几位小数
+ (NSString *)decimalwithFormat:(NSString *)format floatV:(float)floatV;

+ (NSString *)decimalwithFloatV:(float)floatV;

//
+ (NSString *)KGFormatScale:(id)scale;


@end
