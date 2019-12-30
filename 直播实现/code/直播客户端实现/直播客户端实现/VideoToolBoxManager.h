//
//  VideoToolBoxManager.h
//  直播客户端实现
//
//  Created by 冯才凡 on 2019/12/30.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoToolBoxManager : NSObject

+ (instancetype)shareInstance;

- (void)encode:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_END
