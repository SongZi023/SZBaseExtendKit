//
//  NSString+Category.m
//  AFN
//
//  Created by toocmstoocms on 15/5/15.
//  Copyright (c) 2015年 toocmstoocms. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "NSString+Category.h"

@implementation NSString (Category)

// 获取字符串高度
+ (CGSize)getStringRect:(NSString*)aString fontSize:(CGFloat)fontSize width:(int)stringWidth {
    return [aString getStringRectWithfontSize:fontSize width:stringWidth];
}

// 计算文字尺寸
- (CGSize)getStringRectWithfontSize:(CGFloat)fontSize width:(int)stringWidth {
    CGSize size;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary* dic = @{NSFontAttributeName:font};
    size = [self boundingRectWithSize:CGSizeMake(stringWidth, 2000)  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return  size;
}

//设置UIlabel行间距
+ (void)setLabellineSpacing:(UILabel *)label aString:(NSString *)content setLineSpacing:(CGFloat)LineSpacing {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:15];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    [label setAttributedText:attributedString];
    [label sizeToFit];
}

// 根据字符串长度计算label的尺寸
+ (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    return labelSize;
}


#pragma mark - 根据内容自适应高度
+ (CGSize)depaendWithContent:(NSString*)content font:(UIFont*)font  withSize:(CGSize)maxSize {
    return [self depaendWithContent:content font:font withSize:maxSize];
}

- (CGSize)depaendWithContent:(NSString*)content font:(UIFont*)font  withSize:(CGSize)maxSize {
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [content boundingRectWithSize:maxSize
                                           options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                        attributes:attribute
                                           context:nil].size;
    
    return retSize;
}


#pragma mark - 
+ (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    return [self sizeWithFont:font maxSize:maxSize];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


#pragma mark - 
// 计算文字宽度
- (float)calculateTextLengthWithSizeHeight:(float)Height andFontSize:(float)fontSize {
    CGSize requiredSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, Height)
                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                          attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}
                                             context:nil].size;
    float requiredHeight = requiredSize.width;
    return requiredHeight;
}

// 固定宽度, 计算文字高度
- (float)calculateTextHeightWithStr:(NSString *)text AndWidth:(float)width AndFontSize:(float)fontSize {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 0)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                     context:nil];
    
    return rect.size.height;
}

@end
