//
//  NSData+AES256.h
//  Burn
//
//  Created by Adam Venturella on 7/26/13.
//  Copyright (c) 2013 HappyGravity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)
- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;
@end
