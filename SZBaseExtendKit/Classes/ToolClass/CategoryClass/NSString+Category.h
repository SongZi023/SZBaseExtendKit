//
//  NSString+Category.h
//  AFN
//
//  Created by seven on 15/5/15.
//  Copyright (c) 2015年 toocms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Category)

/**
 *  计算文字尺寸
 *  @param aString     文字
 *  @param fontSize    文字大小
 *  @param stringWidth 所在控件的宽度
 *  @return 文字尺寸
 */
+ (CGSize)getStringRect:(NSString*)aString fontSize:(CGFloat)fontSize width:(int)stringWidth;

/**
 *  计算文字尺寸
 *  @param fontSize    文字大小
 *  @param stringWidth 所在控件的宽度
 *  @return 文字尺寸
 */
- (CGSize)getStringRectWithfontSize:(CGFloat)fontSize width:(int)stringWidth;


+ (void)setLabellineSpacing:(UILabel *)label aString:(NSString *)content setLineSpacing:(CGFloat)LineSpacing;

/**
 *  根据字符串长度计算label的尺寸
 *  @param text     要计算的字符串
 *  @param fontSize 字体大小
 *  @param maxSize  label允许的最大尺寸
 *  @return label的尺寸
 */
+ (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;

/**
 根据内容自适应高度
 */
+ (CGSize)depaendWithContent:(NSString*)content font:(UIFont*)font  withSize:(CGSize)maxSize;

- (CGSize)depaendWithContent:(NSString*)content font:(UIFont*)font  withSize:(CGSize)maxSize;


//
+ (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

// 计算文字宽度
- (float)calculateTextLengthWithSizeHeight:(float)Height andFontSize:(float)fontSize;

// 固定宽度计算文字高度
- (float)calculateTextHeightWithStr:(NSString *)text AndWidth:(float)width AndFontSize:(float)fontSize;


@end
