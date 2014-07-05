//
//  MDWampPublish.m
//  MDWamp
//
//  Created by Niko Usai on 10/04/14.
//  Copyright (c) 2014 mogui.it. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "MDWampPublish.h"

@implementation MDWampPublish

- (id)initWithPayload:(NSArray *)payload
{
    self = [super init];
    if (self) {
        NSMutableArray *tmp = [payload mutableCopy];

        if ([tmp[0] isKindOfClass:[NSString class]]) {
            // version 1 PUBLISH
            // [ TYPE_ID_PUBLISH , topicURI , event , exclude , eligible ]
            #warning exclude , eligible not implemented
            self.topic = [tmp shift];
            self.argumentsKw = [tmp shift];
        } else {
            // [PUBLISH, Request|id, Options|dict, Topic|uri, Arguments|list, ArgumentsKw|dict]
            self.request    = [tmp shift];
            self.options    = [tmp shift];
            self.topic      = [tmp shift];
            if ([tmp count] > 0) self.arguments     = [tmp shift];
            if ([tmp count] > 0) self.argumentsKw   = [tmp shift];
        }
    }
    return self;
}

- (NSArray *)marshallFor:(MDWampVersion)version
{
    if ([version  isEqual: kMDWampVersion1]) {
        return @[@7, self.topic, self.event];
    } else {
        if (self.arguments && self.argumentsKw) {
            return @[@16, self.request, self.options, self.topic, self.arguments, self.argumentsKw ];
        } else if(self.arguments) {
            return @[@16, self.request, self.options, self.topic, self.arguments ];
        } else if(self.argumentsKw) {
            return @[@16, self.request, self.options, self.topic, @[], self.argumentsKw ];
        } else {
            return @[@16, self.request, self.options, self.topic];
        }
    }
}

- (NSDictionary *)event {
    return self.argumentsKw;
}

- (void)setEvent:(NSDictionary *)event {
    self.argumentsKw = event;
}

@end
