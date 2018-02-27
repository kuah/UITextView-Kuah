//
//  KTextViewDelegateTransition.h
//  UITextView-Kuah
//
//  Created by 陈世翰 on 2018/2/11.
//  Copyright © 2018年 Kuah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface KTextViewDelegateTransition : NSObject<UITextViewDelegate>
/**
 *   <#decr#>
 */
@property (nonatomic,weak)UITextView *placeholderTextView;
-(instancetype)initWithTarget:(id)target placeholderTextView:(UITextView *)placeholderTextView;
-(instancetype)initWithTarget:(id)target;
-(void)setRealDelegate:(id<UITextViewDelegate>)delegate;
@end
