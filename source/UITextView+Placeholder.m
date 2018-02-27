//
//  UITextView+Placeholder.m
//  UITextView-Kuah
//
//  Created by 陈世翰 on 2018/2/11.
//  Copyright © 2018年 Kuah. All rights reserved.
//

#import "UITextView+Placeholder.h"
#import "KTextViewDelegateTransition.h"
#import <objc/runtime.h>
@implementation NSObject (Kuah)
+ (void)k_exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)k_exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end
@implementation UITextView (Kuah)
#pragma mark -private
-(UITextView *)placeholderTextView{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setPlaceholderTextView:(UITextView *)placeholderTextView{
    objc_setAssociatedObject(self,@selector(placeholderTextView), placeholderTextView,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(KTextViewDelegateTransition *)transitionDelegate{
    KTextViewDelegateTransition *t_delegate = objc_getAssociatedObject(self, _cmd);
    if (!t_delegate) {
        KTextViewDelegateTransition *transition = [[KTextViewDelegateTransition alloc]initWithTarget:self];
        [self setTransitionDelegate:transition];
    }
    return objc_getAssociatedObject(self, _cmd);
}
-(KTextViewDelegateTransition *)_transitionDelegate{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setTransitionDelegate:(KTextViewDelegateTransition *)transitionDelegate{
    objc_setAssociatedObject(self,@selector(transitionDelegate), transitionDelegate,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.delegate = transitionDelegate;
}

#pragma mark -extension
-(NSString *)placeholder{
    UITextView * t = [self placeholderTextView];
    return (t && t.text.length>0)?[self placeholderTextView].text:nil;
}
-(void)setPlaceholder:(NSString *)placeholder{
    UITextView * t = [self placeholderTextView];
    if (placeholder.length>0) {
        if (!t) {
            [self addplaceholderTextView];
        }
        [self placeholderTextView].text = placeholder;
    }else{
        if(t)t.hidden = YES;
    }
}
-(UIColor *)placeholderColor{
    UITextView * t = [self placeholderTextView];
    if (t) {
        return t.textColor;
    }
    return nil;
}
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    UITextView * t = [self placeholderTextView];
    if (!t) {
        [self addplaceholderTextView];
    }
    t.textColor = placeholderColor;
}

#pragma mark -else
/* !!!!!!!
 由于UITextView并没有实现 setDelegate: 而是使用了父类 UIScrollView 的 setDelegate: 方法；
 所以如果不写此方法，直接使用swizzling ,被替换的会是 UIScrollView 的 setDelegate:方法，而 UITableView，UICollectionView等都会受到影响而调用到 k_setDelegate: ，单被替换了的  k_setDelegate:  ~> setDelegate: 属于在 UITextView分类的方法，所以在UITableView，UICollectionView 等调用到 k_setDelegate: 中的k_setDelegate:方法， 最终会报错找不到该方法而崩溃
 */
-(void)setDelegate:(id<UITextViewDelegate>)delegate{
    [super setDelegate:delegate];
}
+(void)load{
    [self k_exchangeInstanceMethod1:@selector(setDelegate:) method2:@selector(k_setDelegate:)];
    [self k_exchangeInstanceMethod1:@selector(setFrame:) method2:@selector(k_setFrame:)];
    [self k_exchangeInstanceMethod1:@selector(setTextContainerInset:) method2:@selector(k_setTextContainerInset:)];
    [self k_exchangeInstanceMethod1:@selector(setTextAlignment:) method2:@selector(k_setTextAlignment:)];
    [self k_exchangeInstanceMethod1:@selector(setFont:) method2:@selector(k_setFont:)];
}
-(void)k_setDelegate:(id<UITextViewDelegate>)delegate{
   
    if (![self isKindOfClass:[UITextView class]])return ;
    if ((!delegate)) {
        if ([self _transitionDelegate]) [[self _transitionDelegate] setRealDelegate:delegate];
        return;
    }
    if(![delegate conformsToProtocol:@protocol(UITextViewDelegate)] || ![self respondsToSelector:@selector(transitionDelegate)]){
        [self k_setDelegate:delegate];
        return;
    }
    if (delegate!=[self transitionDelegate]) {
         [[self transitionDelegate] setRealDelegate:delegate];
    }else{
        [self k_setDelegate:delegate];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self placeholderTextView].frame = self.bounds;
}
-(void)k_setFrame:(CGRect)frame{
    [self k_setFrame:frame];
    [self placeholderTextView].frame = (CGRect){0,0,self.bounds.size};
}
-(void)k_setTextContainerInset:(UIEdgeInsets)textContainerInset{
    [self k_setTextContainerInset:textContainerInset];
    [[self placeholderTextView] setTextContainerInset:textContainerInset];
}
-(void)k_setTextAlignment:(NSTextAlignment)textAlignment{
    [self k_setTextAlignment:textAlignment];
    [[self placeholderTextView] setTextAlignment:textAlignment];
}
-(void)k_setFont:(UIFont *)font{
    [self k_setFont:font];
    self.placeholderTextView.font = font;
}

#pragma mark -another textView
-(void)addplaceholderTextView{
    UITextView *textView = [[UITextView alloc]initWithFrame:(CGRect){0,0,self.frame.size.width,self.frame.size.width}];
    [self addSubview:textView];
    textView.editable = NO;
    textView.selectable = NO;
    textView.backgroundColor  = [UIColor clearColor];
    textView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [textView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
    [self setPlaceholderTextView:textView];
    [self transitionDelegate].placeholderTextView = textView;
}
-(void)tap:(UITapGestureRecognizer *)gesture{
    self.placeholderTextView.hidden = YES;
    [self becomeFirstResponder];
}

@end
