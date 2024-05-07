import { WantAgent, wantAgent } from '@kit.AbilityKit'

import Base from '@ohos.base';
import { NOTIFICATION_ID } from '../constant/Constant';
import { promptAction } from '@kit.ArkUI';
import { notificationManager } from '@kit.NotificationKit';


export const createWantAgent = (bundleName:string, abilityName:string) => {
  // https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V1/js-apis-inner-wantagent-wantagentinfo-0000001630146105-V1
  const wantAgentInfo: wantAgent.WantAgentInfo = {
    wants:[
      {
        bundleName,
        abilityName
      }
    ],
    operationType: wantAgent.OperationType.START_ABILITY,
    requestCode:0,
    wantAgentFlags:[wantAgent.WantAgentFlags.CONSTANT_FLAG]
  }
  return wantAgent.getWantAgent(wantAgentInfo)
}

// 发布通知
export const publishNotification = (progress: number, progressMaxValue:number, wantAgentObj: WantAgent) => {
  // 模板
  const template: notificationManager.NotificationTemplate = {
    name: 'downloadTemplate',
    data: {
      progressValue: progress,
      progressMaxValue: progressMaxValue,
      isProgressIndeterminate:false
    }
  }
  // 构造进度条模板对象，并发布通知
  const notificationRequest: notificationManager.NotificationRequest = {
    id: NOTIFICATION_ID,
    content:{
      notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
      normal: {
        title: 'test_title',
        text: 'test_text',
        additionalText: `进度条:${progress}`
      }
    },
    template:template,
    wantAgent: wantAgentObj
  }
  notificationManager.publish(notificationRequest, (err:Base.BusinessError) => {
    if (err) {
      console.error(`Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
      return;
    }
    console.info('Succeeded in publishing notification.');
  })
}

// 授权弹窗 询问用户是否允许
export function openNotificationPermission() {
  notificationManager.requestEnableNotification().then(res => {
    console.log('授权成功')
    publishNotice();
  }).catch((err:Error) => {
    console.log('授权失败')
    promptAction.showToast({
      message: '如想体验完整功能，请去设置处打开通知权限'
    })
  })
}


function publishNotice() {
  let currentTime:number | undefined = AppStorage.get('currentTime');
  let totalTime:number | undefined = AppStorage.get('totalTime');
  let wantAgentObj:WantAgent | undefined = AppStorage.get('wantAgentObj');
  console.log('发送通知', JSON.stringify(currentTime), JSON.stringify(totalTime), JSON.stringify(wantAgentObj))
  publishNotification(currentTime as number, totalTime as number, wantAgentObj as WantAgent);
}
