import { MyUserInfoParams } from '../common/interface/interface';
import { createWantAgent, openNotificationPermission, publishNotification } from '../common/tools/Notification';
import { Player } from '../components/player/Player';
import { GetUserInfoApi } from '../services/users';
import { Mine } from '../view/mine/Mine';
import { MusicList } from './musiclist/MusicList';
import { AVPlayer } from '../viewmodel/AVPlayer';
import { UserModel } from '../viewmodel/UserModel';
import { common, WantAgent } from '@kit.AbilityKit';
import { notificationManager } from '@kit.NotificationKit';
import { startContinuousTask } from '../common/tools/LongTimeTask';



@Entry
@Component
struct Index {
  context = getContext(this) as common.UIAbilityContext;
  @StorageLink('user') user:UserModel = new UserModel();
  @StorageLink('totalTime') totalTime: number = 0; // 音乐总时长
  @StorageLink('currentTime') currentTime: number = 0; // 音乐当前播放位置
  @StorageLink('wantAgentObj') wantAgentObj:WantAgent =  new Object();
  @State active:number = 0;

  @State tabList:string[] = ['音乐库', '我的'];

  onPageShow(): void {
    AVPlayer.getInstance(); // 初始化播放器
  }

  aboutToAppear(): void {
    console.log('--page index');
    // // 问用户调权限
    // openNotificationPermission()
    // //
    // const bundleName = this.context.abilityInfo.bundleName;
    // const abilityName = this.context.abilityInfo.name;
    // // 创建通知
    // console.log('包名', bundleName, abilityName)
    // createWantAgent(bundleName, abilityName).then((want:WantAgent) => {
    //   console.log('want', JSON.stringify(want))
    //   this.wantAgentObj = want;
    // }).catch((err:Error) => {
    //   console.log('创建失败', JSON.stringify(err))
    // })
    // // 询问是否支持进度条模板
    // notificationManager.isSupportTemplate('downloadTemplate');




    // AppStorage.setOrCreate('userId', 108038244); // 固定假数据

    this.getUserInfoApi();
  }



  async getUserInfoApi() {
    let params:MyUserInfoParams = {
      userId: AppStorage.get('userId') as number
    }
    let res = await GetUserInfoApi(params);
    if (res.Code == 200) {
      this.user = res.Data as UserModel;
      if (this.user.isFirst) {
        // 第一次进来 可能会填一下信息
        console.log('第一次进来');
      }
    }
  }

  @Builder TabBuilder(title:string, index:number) {
    Column() {
      Image('')
      Text(title)
        .fontColor(this.active == index? $r('app.color.primary_color') : $r('app.color.text_color'))
    }
  }

  build() {
    Stack({alignContent:Alignment.BottomStart}) {
      Tabs({index:this.active, barPosition: BarPosition.End }) {
        TabContent() {
          Player({isPageHome:true}) {
            Column() {
              MusicList()
            }
          }
        }.tabBar(this.TabBuilder(this.tabList[0], 0))
        TabContent() {
          Player({isPageHome:true}) {
            Column() {
              Mine()
            }
          }
        }.tabBar(this.TabBuilder(this.tabList[1], 1))
      }
      .animationDuration(400)
      .onChange((index:number) => {
        this.active = index;
      })
      .width('100%')
      .height('100%')
      // TabBar({active:$active})
    }
    .width('100%')
    .height('100%')
  }

  pageTransition() {
    PageTransitionEnter({ duration: 200 })
      .opacity(1)
    PageTransitionExit({ duration: 200 })
      .opacity(0)
  }

}

@Component
struct TabBar {
  @Link active:number;
  list = ['音乐库', '我的']

  changeTab(index:number) {
    this.active = index;
  }

  build() {
    Flex({justifyContent:FlexAlign.SpaceEvenly, alignItems:ItemAlign.Center}) {
      ForEach(this.list, (item:string, index:number) => {
        Column() {
          Image('')
          Text(item)
            .fontColor(this.active == index? $r('app.color.primary_color') : $r('app.color.text_color'))
        }
        .onClick(() => {
          this.changeTab(index);
        })
      })
    }
    .width('100%')
    .height(60)
    .backgroundColor($r('app.color.content_color'))
  }
}