//
//  DecriptClass.h
//  FolderApp
//
//  Created by Junkyu Nam on 02/08/2019.
//  Copyright © 2019 com.leadon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DecriptClass : NSObject
    
    
+ (instancetype)sharedDecript;
- (NSString*)AES256Decrypt:(NSString*)rapterKey key:(NSString*)baseKey;

@end

NS_ASSUME_NONNULL_END
