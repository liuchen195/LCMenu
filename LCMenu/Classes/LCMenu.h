//
//  LCMenu.h
//  test
//
//  Created by 刘琛 on 2020/3/23.
//  Copyright © 2020 刘琛. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//类对象
@interface LCMenuItem : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) NSTextAlignment alignment;

+ (instancetype)menuItem:(NSString *) title
                   image:(UIImage *) image
              titleColor:(UIColor *) titleColor
                  target:(id) target
                  action:(SEL) action;

@end


typedef struct {
    CGFloat marginXSpacing;
    CGFloat marginYSpacing;
    CGFloat intervalSpacing;
    CGFloat menuCornerRadius;
    Boolean hasSeperatorLine;
    Boolean seperatorLineHasInsets;
    UIColor *textColor;
    UIColor *menuBackgroundColor;
    
}OptionalConfiguration;


@interface LCMenu : UIViewController

@property (atomic, assign) OptionalConfiguration kxMenuViewOptions;

@property (nonatomic, strong) UIFont *titleFont;

+ (void) showMenuInVC:(UIViewController *) vc
             fromView:(UIView *) view
            menuItems:(NSArray *)menuItems
          withOptions:(OptionalConfiguration) options;

+ (instancetype)defaultLCMenuController;


@end


NS_ASSUME_NONNULL_END
