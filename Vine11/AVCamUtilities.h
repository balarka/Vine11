//
//  AVCamUtilities.h
//  Vine11
//
//  Created by Balarka Velidi on 7/10/13.
//  Copyright (c) 2013 Balarka Velidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVCaptureConnection;

@interface AVCamUtilities : NSObject {
    
}

+ (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections;

@end