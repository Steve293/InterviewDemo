//
//  API.h
//  InterviewDemo
//
//  Created by stave on 2017/5/16.
//  Copyright © 2017年 stave. All rights reserved.
//

#ifndef API_h
#define API_h

#define API_BASE_URL @"https://api.github.com"
#define API_SEARCH [NSString stringWithFormat:@"%@/search/users",API_BASE_URL]
#define API_REPOS(str)   [NSString stringWithFormat:@"%@/users/%@/repos",API_BASE_URL,str]

#endif /* API_h */
