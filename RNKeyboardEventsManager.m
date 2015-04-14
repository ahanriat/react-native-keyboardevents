//
//  RNKeyboardEventsManager.m
//  RNKeyboardEventsManager
//
//  Created by Johannes Lumpe on 12/04/15.
//  Copyright (c) 2015 Johannes Lumpe. All rights reserved.
//

#import "RNKeyboardEventsManager.h"
#import "RCTConvert.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

static NSString* RNKeyboardEventsDidShow = @"keyboardDidShow";
static NSString* RNKeyboardEventsDidHide = @"keyboardDidHide";
static NSString* RNKeyboardEventsWillShow = @"keyboardWillShow";
static NSString* RNKeyboardEventsWillHide = @"keyboardWillHide";


@implementation RNKeyboardEventsManager

@synthesize bridge = _bridge;
RCT_EXPORT_MODULE();

- (instancetype)init {
  if (self = [super init]) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

  }
  
  return self;
}

- (NSDictionary*)getDictionaryForRect:(CGRect)rect {
  CGSize size = rect.size;
  CGPoint origin = rect.origin;
  int h = MIN(size.height, size.width);
  int w = MAX(size.height, size.width);
  
  return @{
    @"width": [NSNumber numberWithInt:w],
    @"height": [NSNumber numberWithInt:h],
    @"x": [NSNumber numberWithInt:origin.x],
    @"y": [NSNumber numberWithInt:origin.y]
  };
}

- (NSDictionary*) makeBodyFromNotification:(NSNotification*)notification {
  CGRect keyboardBeginRect = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  CGRect keyboardEndRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  
  NSDictionary *body = @{
    @"begin": [self getDictionaryForRect:keyboardBeginRect],
    @"end": [self getDictionaryForRect:keyboardEndRect]
  };
  
  return body;
}

- (void)keyboardWillHide:(NSNotification*)notification {
  [_bridge.eventDispatcher sendDeviceEventWithName:RNKeyboardEventsWillHide
                                              body:[self makeBodyFromNotification:notification]];
}

- (void)keyboardDidHide:(NSNotification*)notification {
  [_bridge.eventDispatcher sendDeviceEventWithName:RNKeyboardEventsDidHide
                                              body:[self makeBodyFromNotification:notification]];
}

- (void)keyboardWillShow:(NSNotification*)notification {
  [_bridge.eventDispatcher sendDeviceEventWithName:RNKeyboardEventsWillShow
                                              body:[self makeBodyFromNotification:notification]];
}

- (void)keyboardDidShow:(NSNotification*)notification {
  [_bridge.eventDispatcher sendDeviceEventWithName:RNKeyboardEventsDidShow
                                              body:[self makeBodyFromNotification:notification]];
}

- (NSDictionary *)constantsToExport
{
  return @{
    @"KeyboardDidShow": RNKeyboardEventsDidShow,
    @"KeyboardDidHide": RNKeyboardEventsDidHide,
    @"KeyboardWillShow": RNKeyboardEventsWillShow,
    @"KeyboardWillHide": RNKeyboardEventsWillHide,
  };
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end