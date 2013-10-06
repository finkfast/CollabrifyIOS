//
//  bufferStuff.h
//  WeWrite
//
//  Created by Jiaju Xu on 9/28/13.
//  Copyright (c) 2013 Joe Finkel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <data.pb.h>
#import <google/protobuf/io/zero_copy_stream_impl_lite.h>
#import <google/protobuf/io/coded_stream.h>

@interface bufferStuff : NSObject

NSData *parseDelimitedProtoBufMessageFromData(::google::protobuf::Message &message, NSData *data);
NSData *dataForProtoBufMessage(::google::protobuf::Message &message);

@end
