//
//  FirstViewController.m
//  DKLive
//
//  Created by liudukun on 2017/3/29.
//  Copyright © 2017年 liudukun. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()<LFLiveSessionDelegate>

@property (nonatomic,strong) LFLiveSession *liveSession;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self requestAccessForVideo];
    [self requestAccessForAudio];
    
    LFLiveAudioConfiguration *aConfig = [LFLiveAudioConfiguration defaultConfiguration];
    LFLiveVideoConfiguration *vConfig = [LFLiveVideoConfiguration defaultConfiguration];
    LFLiveStreamInfo *streamInfo = [[LFLiveStreamInfo alloc]init];
    streamInfo.url = @"rtmp://172.16.100.114:1935/rtmplive/room";
    streamInfo.audioConfiguration = aConfig;
    streamInfo.videoConfiguration = vConfig;
    
    self.liveSession = [[LFLiveSession alloc]initWithAudioConfiguration:aConfig videoConfiguration:vConfig];
    self.liveSession.delegate = self;
    [self.liveSession startLive:streamInfo];
    
}

#pragma mark -- Public Method
- (void)requestAccessForVideo {
    __weak typeof(self) _self = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_self.liveSession setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            // 已经开启授权，可继续
            dispatch_async(dispatch_get_main_queue(), ^{
                [_self.liveSession setRunning:YES];
            });
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            
            break;
        default:
            break;
    }
}

- (void)requestAccessForAudio {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    
}
/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug *)debugInfo{
    
}
/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode{
    
}

@end
