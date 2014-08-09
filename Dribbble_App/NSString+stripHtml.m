//
//  NSString+stripHtml.m
//  Dribbble_App
//
//  Created by oda yuma on 2014/08/10.
//  Copyright (c) 2014年 yuma oda. All rights reserved.
//

#import "NSString+stripHtml.h"

@implementation NSString (stripHtml)

-(NSString *)stringByStrippingHTML
{
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

@end
