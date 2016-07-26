//
//  Connect.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/5/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  接口 192.168.18.62 192.168.0.100 192.168.1.104
//  http://comment.bilibili.com/( danmaku id).xml // 获取弹幕

#ifndef Connect_h
#define Connect_h

#define Server_App @"http://app.bilibili.com"
#define Server_Api @"http://api.bilibili.com"
#define Server_Umeng @"http://oc.umeng.com"
#define Server_Bangumi @"http://bangumi.bilibili.com"



// 启动页
#define kSplashURL Server_App@"/x/splash"

// 推荐轮播图
#define kBannerURL Server_App@"/x/banner"

// 推荐内容
#define kRecommendContentURL Server_App@"/x/show"

// 检查配置更新
#define kCheck_config_updateURL Server_Umeng@"/check_config_update"

// 番剧详情页面内容
#define kBangumiDetailContentURL Server_Bangumi@"/api/season_v3"

// 番剧详情获取剧集信息
#define kBangumiDetailEpisodeInfoURL Server_Bangumi@"/api/get_source?"


// 回复内容
#define kReplyContentURL Server_Api@"/x/reply"


#endif /* Connect_h */
