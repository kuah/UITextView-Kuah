//
//  ViewController.m
//  UITextView-Kuah
//
//  Created by 陈世翰 on 2018/2/11.
//  Copyright © 2018年 Kuah. All rights reserved.
//

#import "ViewController.h"
#import "UITextView+PlaceHolder.h"

@interface ViewController ()<UITextViewDelegate>
/**
 *   <#decr#>
 */
@property (nonatomic,strong)UITextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITextView * textView = [UITextView new];
    textView.frame = (CGRect){0,0,[UIScreen mainScreen].bounds.size.width,200};
    textView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    textView.delegate = self;
    textView.placeholder = @"11111";
    textView.placeholderColor = [UIColor redColor];
    [self.view addSubview:textView];
    self.textView = textView;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
}
-(void)tap:(id)sender{
    [self.view endEditing:YES];
}
-(void)textViewDidChange:(UITextView *)textView{
    NSLog(@"%@",textView.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end




