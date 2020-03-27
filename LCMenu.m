//
//  LCMenu.m
//  test
//
//  Created by 刘琛 on 2020/3/23.
//  Copyright © 2020 刘琛. All rights reserved.
//

#import "LCMenu.h"

//生成相应的model
@implementation LCMenuItem
+ (instancetype)menuItem:(NSString *)title image:(UIImage *)image titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action {
    
    return [[LCMenuItem alloc] init:title image:image titleColor:titleColor target:target action:action];
    
}

- (id) init:(NSString *) title image:(UIImage *) image titleColor:(UIColor *)titleColor target:(id) target action:(SEL) action {
    
    NSParameterAssert(title.length || image);
    
    self = [super init];
    if (self) {
        _title = title;
        _image = image;
        _titleColor = titleColor;
        _target = target;
        _action = action;
    }
    return self;
}

- (BOOL) enabled {
    
    return _target != nil && _action != nil;
}

- (void) performAction
{
    __strong id target = self.target;
    
    if (target && [target respondsToSelector:_action]) {
        
        [target performSelectorOnMainThread:_action withObject:self waitUntilDone:YES];
    }
}

@end


//页面
@interface LCMenu ()

@property (nonatomic, strong) NSArray *menuItems;

@end


@implementation LCMenu

+ (instancetype)defaultLCMenuController {
    static LCMenu *tbc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tbc = [[LCMenu alloc] init];
        tbc.modalPresentationStyle = UIModalPresentationPopover;
        tbc.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        tbc.popoverPresentationController.canOverlapSourceViewRect = NO;
    });
    return tbc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //在显示的时候根据箭头位置调整frame的位置关系
    if (self.popoverPresentationController.arrowDirection == 1) {
        //箭头朝上
        UIView *view = [self.view viewWithTag:1000];
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + 10, view.frame.size.width, view.frame.size.height);
    }else if (self.popoverPresentationController.arrowDirection == 4) {
        //箭头在左边
        UIView *view = [self.view viewWithTag:1000];
        view.frame = CGRectMake(view.frame.origin.x + 10, view.frame.origin.y , view.frame.size.width, view.frame.size.height);
        
    }

}

- (void)createButtons {
    
    //删除全部的view
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    if (!_menuItems.count) {
        return;
    }
    
    const CGFloat kMinMenuItemHeight = 32.f;
    const CGFloat kMinMenuItemWidth = 32.f;
    //配置：左右边距
    const CGFloat kMarginX = self.kxMenuViewOptions.marginXSpacing;
    //配置：上下边距
    const CGFloat kMarginY = self.kxMenuViewOptions.marginYSpacing;
    
    UIFont *titleFont = self.titleFont;
    if (!titleFont) titleFont = [UIFont boldSystemFontOfSize:16];
    
    CGFloat maxImageWidth = 0;
    CGFloat maxItemHeight = 0;
    CGFloat maxItemWidth = 0;
    
    for (LCMenuItem *menuItem in _menuItems) {
        
        const CGSize imageSize = menuItem.image.size;
        if (imageSize.width > maxImageWidth)
            maxImageWidth = imageSize.width;
    }
    
    if (maxImageWidth) {
        maxImageWidth += kMarginX;
    }
    
    for (LCMenuItem *menuItem in _menuItems) {
        const CGSize titleSize = [menuItem.title sizeWithAttributes:@{NSFontAttributeName: titleFont}];
        
        //这个地方设置item宽度
        const CGFloat itemWidth = ((!menuItem.enabled && !menuItem.image) ? titleSize.width : maxImageWidth + titleSize.width) + kMarginX * 2 + self.kxMenuViewOptions.intervalSpacing;
        
        if (itemWidth > maxItemWidth)
        maxItemWidth = itemWidth;
    }
    
    maxItemWidth  = MAX(maxItemWidth, kMinMenuItemWidth);
    maxItemHeight = kMinMenuItemHeight;
    
    //这个地方设置字图间距
    const CGFloat titleX = maxImageWidth + self.kxMenuViewOptions.intervalSpacing;
    
    const CGFloat titleWidth = maxItemWidth - titleX - kMarginX *2;
    
    UIImage *selectedImage = [self selectedImage:(CGSize){maxItemWidth, maxItemHeight + 2}];
    
    //配置：分隔线是与内容等宽还是与菜单等宽
    int insets = 0;
    if (self.kxMenuViewOptions.seperatorLineHasInsets) {
        insets = 4;
    }
    
    UIImage *gradientLine = [self gradientLine: (CGSize){maxItemWidth - kMarginX * insets, 0.4}];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.autoresizingMask = UIViewAutoresizingNone;
    
    contentView.backgroundColor = [UIColor clearColor];
    
    contentView.opaque = NO;
    
    contentView.tag = 1000;
    
    CGFloat itemY = kMarginY * 2;
    
    NSUInteger itemNum = 0;
    
    for (LCMenuItem *menuItem in _menuItems) {
        const CGRect itemFrame = (CGRect){0, itemY - kMarginY * 2 + self.kxMenuViewOptions.menuCornerRadius, maxItemWidth, maxItemHeight};
        
        UIView *itemView = [[UIView alloc] initWithFrame:itemFrame];
        itemView.autoresizingMask = UIViewAutoresizingNone;
        
        itemView.opaque = NO;
        
        [contentView addSubview:itemView];
        
        if (menuItem.enabled) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = itemNum;
            button.frame = itemView.bounds;
            button.enabled = menuItem.enabled;
            button.backgroundColor = [UIColor clearColor];
            
            button.opaque = NO;
            button.autoresizingMask = UIViewAutoresizingNone;
            
            [button addTarget:self
                       action:@selector(performAction:)
             forControlEvents:UIControlEventTouchUpInside];
            
            [button setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
            
            [itemView addSubview:button];
        }
        
        if (menuItem.title.length) {
            
            CGRect titleFrame;
            
            if (!menuItem.enabled && !menuItem.image) {
                
                titleFrame = (CGRect){
                    kMarginX * 2,
                    kMarginY,
                    maxItemWidth - kMarginX * 4,
                    maxItemHeight - kMarginY * 2
                };
                
            } else {
                
                titleFrame = (CGRect){
                    titleX,
                    kMarginY,
                    titleWidth,
                    maxItemHeight - kMarginY * 2
                };
            }
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
            titleLabel.text = menuItem.title;
            titleLabel.font = titleFont;
            titleLabel.textAlignment = menuItem.alignment;
            
            //配置：menuItem字体颜色
            if (menuItem.titleColor) {
                titleLabel.textColor = menuItem.titleColor ? menuItem.titleColor : [UIColor blackColor];
                
            }else {
                
                titleLabel.textColor = self.kxMenuViewOptions.textColor;
            }
            
            titleLabel.backgroundColor = [UIColor clearColor];
            
            titleLabel.autoresizingMask = UIViewAutoresizingNone;
            
            [itemView addSubview:titleLabel];
            
            if (menuItem.image) {
                
                const CGRect imageFrame = {kMarginX * 2, kMarginY, maxImageWidth, maxItemHeight - kMarginY * 2};
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
                imageView.image = menuItem.image;
                imageView.clipsToBounds = YES;
                imageView.contentMode = UIViewContentModeCenter;
                imageView.autoresizingMask = UIViewAutoresizingNone;
                [itemView addSubview:imageView];
            }
            
            if (itemNum < _menuItems.count - 1) {
                
                UIImageView *gradientView = [[UIImageView alloc] initWithImage:gradientLine];
                
                //配置：分隔线是与内容等宽还是与菜单等宽
                if (self.kxMenuViewOptions.seperatorLineHasInsets) {
                    gradientView.frame = (CGRect){kMarginX * 2, maxItemHeight + 1, gradientLine.size};
                } else {
                    gradientView.frame = (CGRect){0, maxItemHeight + 1 , gradientLine.size};
                }
                
                gradientView.contentMode = UIViewContentModeLeft;
                
                //配置：有无分隔线
                if (self.kxMenuViewOptions.hasSeperatorLine) {
                    [itemView addSubview:gradientView];
                    itemY += 2;
                }
                
                itemY += maxItemHeight;
            }
            
            ++itemNum;
        }
    }
    itemY += self.kxMenuViewOptions.menuCornerRadius;
    
    contentView.frame = CGRectMake(0, 0, maxItemWidth, itemY + 5.5 * 2 + self.kxMenuViewOptions.menuCornerRadius * 2);
    
    NSLog(@"%@", NSStringFromCGRect(contentView.frame));
    [self.view addSubview:contentView];
    
    self.preferredContentSize = CGSizeMake(maxItemWidth, itemY + 5.5 * 2 + self.kxMenuViewOptions.menuCornerRadius * 2);
    
    //给背景设置颜色
    self.view.backgroundColor  = self.kxMenuViewOptions.menuBackgroundColor;
    
}

#pragma mark 显示页面等信息

+ (void)showMenuInVC:(UIViewController *)vc fromView:(UIView *)view menuItems:(NSArray *)menuItems withOptions:(OptionalConfiguration)options {

    [[self defaultLCMenuController] showMenuInVC:vc fromView:view menuItems:menuItems withOptions:options];
    
}

- (void)showMenuInVC:(UIViewController *)vc fromView:(UIView *)view menuItems:(NSArray *)menuItems withOptions:(OptionalConfiguration)options {
    
    if ([view isKindOfClass:[UIBarButtonItem class]]) {
        self.popoverPresentationController.barButtonItem = (UIBarButtonItem *)view;
    }else {
        
        self.popoverPresentationController.sourceView = view;
        self.popoverPresentationController.sourceRect = view.bounds;
    }

    self.kxMenuViewOptions = options;
    
    _menuItems = menuItems;
    
    [self createButtons];
    
    [vc presentViewController:self animated:YES completion:^{
        
    }];
    
}

- (void)performAction:(id)sender
{
   
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIButton *button = (UIButton *)sender;
    LCMenuItem *menuItem = _menuItems[button.tag];
    [menuItem performAction];
}



#pragma mark 图片分割线等处理
- (UIImage *) gradientLine: (CGSize) size
{
    const CGFloat locations[5] = {0,0.2,0.5,0.8,1};
    
    const CGFloat R = 0.890f, G = 0.890f, B = 0.890f; //分隔线的颜色 -- 隐藏属性
    
    const CGFloat components[20] = {
        R,G,B,1,
        R,G,B,1,
        R,G,B,1,
        R,G,B,1,
        R,G,B,1
    };
    
    return [self gradientImageWithSize:size locations:locations components:components count:5];
}

- (UIImage *) selectedImage: (CGSize) size
{

    const CGFloat locations[] = {0,1};
    //配置：选中时阴影的颜色  -- 隐藏属性
    const CGFloat components[] = {
        0.890,0.890,0.890,1,
        0.890,0.890,0.890,1
    };
    
    return [self gradientImageWithSize:size locations:locations components:components count:2];
}


- (UIImage *) gradientImageWithSize:(CGSize) size
                          locations:(const CGFloat []) locations
                         components:(const CGFloat []) components
                              count:(NSUInteger)count
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawLinearGradient(context, colorGradient, (CGPoint){0, 0}, (CGPoint){size.width, 0}, 0);
    CGGradientRelease(colorGradient);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
