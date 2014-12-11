/*
 *  CDVTabBar
 *
 *  Based on:
 *
 *  NativeControls
 *  Created by Jesse MacFadyen on 10-02-03.
 *  MIT Licensed
 *
 *  Originally this code was developed my Michael Nachbaur
 *  Formerly -> PhoneGap :: UIControls.h
 *  Created by Michael Nachbaur on 13/04/09.
 *  Copyright 2009 Decaf Ninja Software. All rights reserved.
 */
#import "CDVTabBar.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation CDVTabBar
#ifndef __IPHONE_3_0
@synthesize webView;
#endif

@synthesize callbackId = _callbackId;
@synthesize listenerCallbackId = _listenerCallbackId;

- (void)pluginInitialize
{
}

#pragma mark - Listener
/**
 * Bind listener for didSelectItem.
 */
-(void)bindListener:(CDVInvokedUrlCommand*)command
{
  self.listenerCallbackId = command.callbackId;

  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  [pluginResult setKeepCallbackAsBool:true];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - TabBar

/**
 * Create a native tab bar at either the top or the bottom of the display.
 * @brief creates a tab bar
 * @param arguments unused
 * @param options used to indicate options for where and how the tab bar should be placed
 * - \c height integer indicating the height of the tab bar (default: \c 49)
 */
- (void)createTabBar:(CDVInvokedUrlCommand*)command
{
  NSDictionary *options = [command.arguments objectAtIndex:0];
  UIView *sv = self.webView.superview;
  CGFloat height = 0.0f;

  if (options) {
    height = [[options objectForKey:@"height"] floatValue];
  }

  if (height == 0.0f) {
    height = 49.0f;
  }

  tabBar = [UITabBar new];
  tabBar.delegate = self;

  tabBar.translatesAutoresizingMaskIntoConstraints = NO;
  tabBar.barTintColor = [UIColor colorWithRed:0.129 green:0.129 blue:0.120 alpha:1];
  tabBar.tintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];

  // tabBar.multipleTouchEnabled   = NO;
  tabBar.hidden = YES;
  // tabBar.userInteractionEnabled = YES;

  [sv addSubview:tabBar];

  [sv addConstraint:[NSLayoutConstraint constraintWithItem:tabBar
          attribute:NSLayoutAttributeHeight
          relatedBy:NSLayoutRelationEqual
             toItem:nil
          attribute:NSLayoutAttributeNotAnAttribute
         multiplier:1.0
           constant:height]];

  [sv addConstraint:[NSLayoutConstraint constraintWithItem:tabBar
          attribute:NSLayoutAttributeWidth
          relatedBy:NSLayoutRelationEqual
             toItem:sv
          attribute:NSLayoutAttributeWidth
         multiplier:1.0
           constant:0]];

  [sv addConstraint:[NSLayoutConstraint constraintWithItem:tabBar
          attribute:NSLayoutAttributeBottom
          relatedBy:NSLayoutRelationEqual
             toItem:sv
          attribute:NSLayoutAttributeBottom
         multiplier:1.0
           constant:0]];

  [sv addConstraint:[NSLayoutConstraint constraintWithItem:tabBar
          attribute:NSLayoutAttributeLeading
          relatedBy:NSLayoutRelationEqual
             toItem:sv
          attribute:NSLayoutAttributeLeading
         multiplier:1.0
           constant:0]];

  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

/**
* Show the tab bar after its been created.
* @brief show the tab bar
* @param arguments unused
* @param options determines how to show the tab bar
* - \c animate boolean indicating whether the tab bar should be animated (default: \c false)
*/
- (void)showTabBar:(CDVInvokedUrlCommand*)command
{
  NSDictionary *options = [command.arguments objectAtIndex:0];
  BOOL animate = false;

  if (options) {
    animate = [[options objectForKey:@"animate"] boolValue];
  }

  if (animate) {
    tabBar.transform = CGAffineTransformMakeTranslation(0.0f, tabBar.bounds.size.height);
    tabBar.hidden = NO;
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void) {
                       tabBar.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished){}];
  } else {
    tabBar.hidden = NO;
  }

  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
  // Create Plugin Result
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:item.tag];
  [pluginResult setKeepCallbackAsBool:true];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:self.listenerCallbackId];
}

@end
