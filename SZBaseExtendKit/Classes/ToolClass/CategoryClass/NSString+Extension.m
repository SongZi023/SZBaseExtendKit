//
//  NSString+Extension.m
//  HotPotNet
//
//  Created by 天天掌 on 16/12/16.
//  Copyright © 2016年 shepai. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)

#pragma mark Func
NSString * stringWithInt(int number) {
    return [NSString stringWithFormat:@"%d", number];
}

NSString * stringWithInteger(NSInteger number) {
    return [NSString stringWithFormat:@"%zd", number];
}

NSString * stringWithDouble(double number) {
    return [NSString stringWithFormat:@"%.2f", number];
}

NSString * stringWithDoubleAndDecimalCount(double number, unsigned int count) {
    switch (count) {
        case 0:
            return [NSString stringWithFormat:@"%.0f", number];
            break;
        case 1:
            return [NSString stringWithFormat:@"%.1f", number];
            break;
        case 2:
            return [NSString stringWithFormat:@"%.2f", number];
            break;
        case 3:
            return [NSString stringWithFormat:@"%.3f", number];
            break;
        case 4:
            return [NSString stringWithFormat:@"%.4f", number];
            break;
        case 5:
            return [NSString stringWithFormat:@"%.5f", number];
            break;
        default:
            return [NSString stringWithFormat:@"%f", number];
            break;
    }
}


#pragma mark - 显示价格
- (NSString *)showShortPriceString {
    //显示价格，末尾不是0，不是小数点
    //默认最多显示两位小数
    //eg:0.00
    NSString *showString = [NSString stringWithFormat:@"%0.2f",self.doubleValue];
    
    if (showString.length > 3) {
        int  backNumber_0 = [[showString substringWithRange:NSMakeRange(showString.length - 1,1)] intValue];
        int  backNumber_1 = [[showString substringWithRange:NSMakeRange(showString.length - 2,1)] intValue];
        
        if (backNumber_0 == 0) {
            if (backNumber_1 == 0) {
                //整数：1.00
                showString = [NSString stringWithFormat:@"%0.0f",self.doubleValue];
            }
            else {
                //一位小数：1.10
                showString = [NSString stringWithFormat:@"%0.1f",self.doubleValue];
            }
        }
        else {
            //两位小数
            if (backNumber_1 == 0) {
                //1.02
                showString = [NSString stringWithFormat:@"%0.2f",self.doubleValue];
            }
            else {
                //1.12
                showString = [NSString stringWithFormat:@"%0.2f",self.doubleValue];
            }
        }
    }
    return showString;
}

- (NSString *)showOneShortPriceString {
    //显示价格，末尾不是0，不是小数点
    //默认最多显示1位小数
    //eg:0.00
    NSString *showString = [NSString stringWithFormat:@"%0.1f",self.doubleValue];
    
    if (showString.length > 3) {
        int  backNumber_0 = [[showString substringWithRange:NSMakeRange(showString.length - 1,1)] intValue];
        int  backNumber_1 = [[showString substringWithRange:NSMakeRange(showString.length - 2,1)] intValue];
        
        if (backNumber_0 == 0) {
            if (backNumber_1 == 0) {
                //整数：1.00
                showString = [NSString stringWithFormat:@"%0.0f",self.doubleValue];
            }
            else {
                //一位小数：1.10
                showString = [NSString stringWithFormat:@"%0.1f",self.doubleValue];
            }
        }
        else {
            //两位小数
            if (backNumber_1 == 0) {
                //1.02
                showString = [NSString stringWithFormat:@"%0.1f",self.doubleValue];
            }
            else {
                //1.12
                showString = [NSString stringWithFormat:@"%0.1f",self.doubleValue];
            }
        }
    }
    return showString;
}

- (NSString *)UTF8Encoding {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}


#pragma mark - 转成JSon字符串
//
+ (id)jsonStringToObject:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if (error) {
        return nil;
    }
    return object;
}


#pragma mark - 获取某个字符串或者汉字的首字母
- (NSString *)transformFirstCharactorString {
    NSMutableString *str = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    NSArray *pyArray = [pinYin componentsSeparatedByString:@" "];
    NSString *resultStr = @"";
    //int index = 1;
    for (NSString *tmpString in pyArray) {
        if (tmpString.length > 0) {
            resultStr = [resultStr stringByAppendingString:[tmpString substringToIndex:1]];
        }
    }
    return resultStr;
}


#pragma mark - 限制字数
//判断字符串不超过8个字
+ (BOOL)isValidateName:(NSString *)name maxWordsCount:(NSInteger)maxWordsCount {
    NSUInteger  character = 0;
    for (int i=0; i< [name length];i++) {
        int a = [name characterAtIndex:i];
        if (a >= 0x4e00 && a <= 0x9fa5) {
            //判断是否为中文
            character += 1;
        }
        else {
            character += 1;
        }
    }
    
    if (character <= maxWordsCount) {
        return NO;//不超过
    }
    else {
        return YES;//超过
    }
}


#pragma mark - 向上取整
+ (NSInteger)discountRoundUp:(CGFloat)sellPrice  discountPrice:(CGFloat)discountPrice {
    NSInteger resultDiscount = 0;
    if (discountPrice > 0 && sellPrice > 0) {
        if (discountPrice >= sellPrice) {
            resultDiscount = 100;
        }
        else {
            //折扣0~~100
            CGFloat tmpDiscount = discountPrice/(sellPrice*0.01f);
            resultDiscount = (NSInteger)tmpDiscount;
            
            //检测小数点后几位数字
            if ((tmpDiscount - resultDiscount)*10000 > 1) {
                //向上取整，加 1
                resultDiscount = resultDiscount + 1;
            }
        }
    }
    else {
        resultDiscount = 0;
    }
    return resultDiscount;
}


#pragma mark - 向下取整
+ (NSString *)discountRoundDown:(CGFloat)sellPrice  discount:(CGFloat)discount {
    CGFloat resultDiscountPrice = 0.f;
    //88元 * 50折
    resultDiscountPrice = (sellPrice*discount/100.0)*1000;
    resultDiscountPrice = ((NSInteger)resultDiscountPrice)/1000.f;
    NSString *resultStr = [NSString stringWithFormat:@"%f",resultDiscountPrice];
    return [resultStr showShortPriceString];
}







#pragma mark - other



/*
 * 验证邮箱
 */
+ (BOOL)judgeUserEmail:(NSString *)userEmail {
    NSString *regex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject: userEmail];
}

/*
 * 昵称只能由中文、字母或数字组成
 */
+ (BOOL)judgeUserName:(NSString *)userName {
    NSString *regex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL namePred = [pred evaluateWithObject: userName];
    return namePred;
}

/*
 * 密码：字母和数字的组合
 */
+ (BOOL)judgeUserPassword:(NSString *)password {
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL passwordPred = [pred evaluateWithObject: password];
    return passwordPred;
}

+ (BOOL)jp_JudgeUserPassword:(NSString *)password {
    NSString *regex = @"^[0-9A-Za-z]{6,18}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL passwordPred = [pred evaluateWithObject: password];
    return passwordPred;
}

/*
 * 验证手机号码
 */
+ (BOOL)judgeUserTelephoneNumber:(NSString*)telephoneNumber {
    if (telephoneNumber.length != 11) {
        return NO;
    }
    NSString *pattern = @"1[3456789]\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    if ([pred evaluateWithObject:telephoneNumber]) {
        return YES;
    }
    return NO;
}

/*
 * 验证身份证号码
 */
+ (BOOL)judgeUserIdentityCardnumber:(NSString*)identityString {
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|[Xx])$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for (int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod = idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if (idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]|| ![idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else {
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if (![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            //return NO;
        }
    }
    return YES;
}

//十六进制字符串转数字
+ (NSInteger)numberWithHexString:(NSString *)hexString {
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return (NSInteger)hexNumber;
}

//去空格
- (NSString *)stringByTrimingWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString *)stringWithTimeIntervalSince1970:(long long)secs format:(NSString *)format {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs /1000];
    NSString *dateStr = [self dateStringWithDate:date DateFormat:format];
    return dateStr;
}

//时间转换
+ (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateFormat:dateFormat];
    NSString *str = [dateFormatter stringFromDate:date];
    return str;
}

/**
 获取当时间的时间戳
 @return 返回当前时间的时间戳
 */
+ (NSString *)getNowTimeTimestamp {
    NSDate *date = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]];
    return timeSp;
}

//  判断是否以字母开头
- (BOOL)isEnglishFirst:(NSString *)str {
    NSString *regular = @"^[A-Za-z].+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    
    if ([predicate evaluateWithObject:str] == YES){
        return YES;
    }
    else {
        return NO;
    }
}

//  判断是否以汉字开头
- (BOOL)isChineseFirst:(NSString *)str {
    int utfCode = 0;
    void *buffer = &utfCode;
    NSRange range = NSMakeRange(0, 1);
    BOOL b = [str getBytes:buffer maxLength:2 usedLength:NULL encoding:NSUTF16LittleEndianStringEncoding options:NSStringEncodingConversionExternalRepresentation range:range remainingRange:NULL];
    if (b && (utfCode >= 0x4e00 && utfCode <= 0x9fa5)){
        return YES;
    }
    else {
        return NO;
    }
}

// base64 编码
- (NSString *)encode:(NSString *)string {
    // 先将string转换成dat
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    return baseString;
}
    
// base64解码
- (NSString *)dencode:(NSString *)base64String {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return string;
}

+ (NSString *)safeString:(id)string {
    if ((NSNull *)string == [NSNull null]) {
        return @"";
    }
    else if (string == nil) {
        return @"";
    }
    else if ([string isKindOfClass:[NSString class]]) {
        if ([string isEqualToString:@"<null>"]) {
            return @""; 
        }
        else if ([string isEqualToString:@"(null)"]) {
            return @"";
        }
        else if ([string isEqualToString:@"<nil>"]) {
            return @"";
        }
        else if ([string isEqualToString:@"null"]) {
            return @"";
        }
        return string;
    }
    else if ([string integerValue] == 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",string];
}

- (BOOL)isNilString {
    if ((NSNull *)self == [NSNull null]) {
        return YES;
    }
    else if (self == nil) {
        return YES;
    }
    else if ([self isKindOfClass:[NSString class]]) {
        if ([self isEqualToString:@"<null>"]) {
            return YES;
        }
        else if ([self isEqualToString:@"(null)"]) {
            return YES;
        }
        else if (self.length == 0){
            return YES;
        }
        return NO;
    }
    return NO;
}

//
+ (BOOL)isNumber:(NSString *)strValue {
    if ([strValue isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    else {
        if (strValue.length <= 0) {
            return NO;
        }
    }
   
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSString *filtered = [[strValue componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if (![strValue isEqualToString:filtered]) {
        return NO;
    }
    return YES;
}

+ (BOOL)judgeTheiIllegalCharacter:(NSString *)content {
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:content]) {
        return YES;
    }
    return NO;
}

+ (NSString *)stringFromNumberWithCutMoreZore:(double)number {
    NSString *str = [NSString stringWithFormat:@"%.3lf",number];
    return [NSString stringWithFormat:@"%@",@(str.floatValue)];
}

//
+ (NSString *)calculateCountDownTimeWithTimeiNt:(NSInteger)timeiNt {
    NSString *timeString = @"";
    
    if (timeiNt <= 60) { //1分钟内
        NSString *secondString = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:timeiNt]];
        if (timeiNt < 10) {
            secondString = [NSString stringWithFormat:@"0%@", [NSNumber numberWithInteger:timeiNt]];
        }
        timeString = [NSString stringWithFormat:@"00:00:%@", secondString];
    }
    
    if (timeiNt > 60 && timeiNt <= (60 *60)) { //1小时内
        NSInteger minute_int = timeiNt /60; //分钟
        NSString *minuteString = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:minute_int]];
        if (minute_int < 10) {
            minuteString = [NSString stringWithFormat:@"0%@", [NSNumber numberWithInteger:minute_int]];
        }
        
        NSInteger second_int = timeiNt - (minute_int *60); //秒数
        NSString *secondString = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:second_int]];
        if (second_int < 10) {
            secondString = [NSString stringWithFormat:@"0%@", [NSNumber numberWithInteger:second_int]];
        }
        timeString = [NSString stringWithFormat:@"00:%@:%@", minuteString, secondString];
    }
    
    if (timeiNt > (60 *60)) { //1小时以上
        NSInteger hours_int = timeiNt / (60 *60); // 小时
        NSString *hoursString = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:hours_int]];
        if (hours_int < 10) {
            hoursString = [NSString stringWithFormat:@"0%@", [NSNumber numberWithInteger:hours_int]];
        }
        
        if (hours_int > 24) {
            NSInteger days_int = hours_int /24;
            NSInteger afterHours_int = hours_int -(days_int *24);
            
            hoursString = [NSString stringWithFormat:@"%@天 %@", [NSNumber numberWithInteger:days_int], [NSNumber numberWithInteger:afterHours_int]];
            if (afterHours_int < 10) {
                 hoursString = [NSString stringWithFormat:@"%@天 0%@", [NSNumber numberWithInteger:days_int], [NSNumber numberWithInteger:afterHours_int]];
            }
        }
        
        NSInteger minute_int = (timeiNt -(hours_int *60 *60)) /60; //分钟
        NSString *minuteString = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:minute_int]];
        if (minute_int < 10) {
            minuteString = [NSString stringWithFormat:@"0%@", [NSNumber numberWithInteger:minute_int]];
        }
        
        NSInteger second_int = timeiNt - (hours_int *60 *60) -(minute_int *60); //秒数
        NSString *secondString = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:second_int]];
        if (second_int < 10) {
            secondString = [NSString stringWithFormat:@"0%@", [NSNumber numberWithInteger:second_int]];
        }
        timeString = [NSString stringWithFormat:@"%@:%@:%@", hoursString, minuteString, secondString];
    }
    return timeString;
}

// 将长数字以3位用逗号隔开表示（例如：18000 -> 18,000）
+ (NSString *)formatNumber:(NSString *)numberString {
    return numberString.formatNumber;
}

- (NSString *)formatNumber {
    if ([self containsString:@"."]) {
        NSArray<NSString *> * arr = [self componentsSeparatedByString:@"."];
        NSString * first = arr.firstObject.formatNumber;
        return [NSString stringWithFormat:@"%@.%@", first, arr[1]];
    }
    if ([self containsString:@"."]) {
        NSArray<NSString *> * arr = [self componentsSeparatedByString:@"."];
        NSString * first = arr.firstObject.formatNumber;
        return [NSString stringWithFormat:@"%@.%@", first, arr[1]];
    }

    int count = 0;
    long long int a = self.longLongValue;
    while (a != 0) {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:self];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}


#pragma mark - MD5加密
+ (NSString *)MD5String:(NSString *)string {
    return [string MD5String];
}

- (NSString *)MD5String {
    //32位MD5加密方式
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_SHA256( cStr, (int)self.length, digest );
    NSMutableString * md5String = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5String appendFormat:@"%02x", digest[i]];
    }
    //经过这个for循环 已经转化成md5字符串
    return [md5String copy];
}


#pragma mark - 移除html标签
//转化html为字符串
+ (NSString *)removeHTML:(NSString *)html {
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL];
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text];
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    
    NSScanner *theScanner2 = [NSScanner scannerWithString:html];
    while ([theScanner2 isAtEnd] == NO) {
        // find start of tag
        [theScanner2 scanUpToString:@"&" intoString:NULL] ;
        
        // find end of tag
        [theScanner2 scanUpToString:@";" intoString:&text] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@;", text] withString:@""];
    }
    return html;
}

//转化html为字符串
+ (NSString *)removeHTML2:(NSString *)html {
    NSArray *components = [html componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    NSMutableArray *componentsToKeep = [NSMutableArray array];
    
    for (int i = 0; i < [components count]; i = i + 2) {
        [componentsToKeep addObject:[components objectAtIndex:i]];
    }
    NSString *plainText = [componentsToKeep componentsJoinedByString:@""];
    return plainText;
}

//银行卡验证
+ (BOOL)validateBankCard:(NSString *)bankCard {
    if (bankCard.length < 16) {
        return NO;
    }
    NSInteger oddsum = 0;     //奇数求和
    NSInteger evensum = 0;    //偶数求和
    NSInteger allsum = 0;
    NSInteger cardNoLength = (NSInteger)[bankCard length];
    // 取了最后一位数
    NSInteger lastNum = [[bankCard substringFromIndex:cardNoLength-1] intValue];
    //测试的是除了最后一位数外的其他数字
    bankCard = [bankCard substringToIndex:cardNoLength - 1];
    for (NSInteger i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [bankCard substringWithRange:NSMakeRange(i-1, 1)];
        NSInteger tmpVal = [tmpString integerValue];
        if (cardNoLength % 2 ==1 ) {//卡号位数为奇数
            if((i % 2) == 0){//偶数位置
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }
            else {//奇数位置
                oddsum += tmpVal;
            }
        }
        else {
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }
            else {
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}


#pragma mark - 验证IP是否合法
+ (BOOL)validateIP:(NSString *)IP {
    return [IP isValidIP];
}

- (BOOL)isValidIP {
    NSString *regex = [NSString stringWithFormat:@"^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL rc = [pre evaluateWithObject:self];
    if (rc) {
        NSArray *componds = [self componentsSeparatedByString:@","];
        BOOL v = YES;
        for (NSString *s in componds) {
            if (s.integerValue > 255) {
                v = NO;
                break;
            }
        }
        return v;
    }
    return NO;
}


#pragma mark - 验证URL
+ (BOOL)validateUrl:(NSString *)url {
    return [url validateUrl];
}

- (BOOL)validateUrl {
    NSString *regex = @"^((http)|(https))+:[^\\s]+\\.[^\\s]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}


#pragma mark - 验证全汉字
+ (BOOL)validateChinese:(NSString *)chinese {
    return [chinese validateChinese];
}

- (BOOL)validateChinese {
    NSString *chineseRegex = @"[\u4e00-\u9fa5]+";
    NSPredicate *chineseTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", chineseRegex];
    return [chineseTest evaluateWithObject:self];
}


#pragma mark - 文本验证忽略大小写
- (BOOL)isEqualSimString:(NSString *)string {
    BOOL result = [self compare:string options:NSCaseInsensitiveSearch |NSNumericSearch] == NSOrderedSame;
    return result;
}


#pragma mark - 验证户名
+ (BOOL) validateUserName:(NSString *)name {
    NSString *userNameRegex = @"^[A-Za-z0-9]{4,18}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}


//字符串是否包含特殊字符
- (BOOL)isIncludeSpecialCharact {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [self rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound) {
        return NO;
    }
    return YES;
}

//字符串中是否包含汉字
+ (BOOL)hasChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

//将NSInteger类型转成NSString 自动补位 1-> 01
+ (NSString *)intgerExchageToString:(NSInteger)integer {
    NSString *string = @"0";
    if (integer > 0 && integer < 10) {
        string = [NSString stringWithFormat:@"0%@", [NSNumber numberWithInteger:integer]];
    }
    else {
        string = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:integer]];
    }
    return string;
}


#pragma mark - 格式化金额
// 格式化金额 需要除以1000
+ (NSString *)KGDecimalMoney:(NSInteger)amount {
    NSString *amounts = [NSString stringWithFormat:@"%zd",amount];
    //获取精确值
    NSDecimalNumber *originStr = [NSDecimalNumber decimalNumberWithString:amounts];
    NSDecimalNumber *kgUnit = [NSDecimalNumber decimalNumberWithString:@"0.001"];
    //乘积
    NSDecimalNumber *multiply = [originStr decimalNumberByMultiplyingBy:kgUnit];
    //比较
    NSDecimalNumber *zero = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSComparisonResult result = [multiply compare:zero];
    if (result == NSOrderedSame) {
        return @"0.00";
    }
    return multiply.stringValue;
}

// 不需除以1000的 格式化
+ (NSString *)KGNormalMoney:(id)amount {
    NSString *string;
    if ([amount isKindOfClass:[NSNumber class]]) {
        if ([amount isEqualToNumber:@(0)]) {
            return @"0.00";
        }
        else {
            NSString *originStr = [NSString stringWithFormat:@"%.3lf",[amount doubleValue]];
            if ([originStr containsString:@"."]) {
                for(NSInteger i = originStr.length - 1; i >= 0; i--){
                    NSString *subString = [originStr substringFromIndex:i];
                    if(![subString isEqualToString:@"0"]) {
                        if ([subString isEqualToString:@"."]) {
                            return [originStr substringToIndex:originStr.length - 1];
                        }
                        else {
                            return originStr;
                        }
                    }
                    else {
                        originStr = [originStr substringToIndex:i];
                    }
                }
            }
            return originStr;
        }
    }
    return string;
}

//不需除以1000的格式化 scale精确到小数点后多少位
+ (NSString *)KGDecimalMoney:(NSInteger)amount decimalScale:(NSInteger)scale{
    NSString *amounts = [NSString stringWithFormat:@"%zd",amount];
    //获取精确值
    NSDecimalNumber *originStr = [NSDecimalNumber decimalNumberWithString:amounts];
    NSDecimalNumber *kgUnit = [NSDecimalNumber decimalNumberWithString:@"0.001"];
    //乘积
    NSDecimalNumber *multiply = [originStr decimalNumberByMultiplyingBy:kgUnit];
    //比较
    NSDecimalNumber *zero = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSComparisonResult result = [multiply compare:zero];
    if (result == NSOrderedSame) {
        return @"0.00";
    }
    else {
        NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                          scale:scale
                                                                                               raiseOnExactness:NO
                                                                                                raiseOnOverflow:NO
                                                                                               raiseOnUnderflow:NO
                                                                                            raiseOnDivideByZero:NO];
        
        NSDecimalNumber *resultR = [multiply decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        //四舍五入后重新与0比较
        NSComparisonResult result2 = [resultR compare:zero];
        if (result2 == NSOrderedSame) {
            return @"0.00";
        }
        else {
            return resultR.stringValue;
        }
    }
}

//
+ (NSString *)formatInputMoney:(NSString *)amount {
    NSString *abStr = amount;
    if (!amount.length) {
        return @"0";
    }
    NSDecimalNumber *deNum = [NSDecimalNumber decimalNumberWithString:abStr];
    
    NSDecimalNumber *nan = [NSDecimalNumber notANumber];
    if ([deNum isEqualToNumber:nan]) {
        return @"0";
    }

    //比较0
    NSDecimalNumber *zero = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSComparisonResult result = [deNum compare:zero];
    if (result == NSOrderedSame) {
        return @"0";
    }
    return deNum.stringValue;
}

//
+ (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:format];
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

//
+ (NSString *)decimalwithFloatV:(float)floatV {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"0.000"];
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

//
+ (NSString *)KGFormatScale:(id)scale {
    if ([scale isKindOfClass:[NSNumber class]]) {
        if ([scale isEqualToNumber:@(0)]) {
            return @"0";
        }
        else {
            NSString *originStr = [NSString stringWithFormat:@"%.3lf",[scale doubleValue]];
            if ([originStr containsString:@"."]) {
                for(NSInteger i = originStr.length - 1; i >= 0; i--){
                    NSString *subString = [originStr substringFromIndex:i];
                    if(![subString isEqualToString:@"0"]) {
                        if ([subString isEqualToString:@"."]) {
                            return [originStr substringToIndex:originStr.length - 1];
                        }
                        else {
                            return originStr;
                        }
                    }
                    else {
                        originStr = [originStr substringToIndex:i];
                    }
                }
            }
            return originStr;
        }
    }
    return [NSString stringWithFormat:@"%@",scale];
}


@end
