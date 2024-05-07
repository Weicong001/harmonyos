import { UserModel } from '../../../viewmodel/UserModel'
import { router } from '@kit.ArkUI';

@Component
export struct UserInfo {
  @StorageLink('userId') userId:number = 0;
  @StorageLink('user') user: UserModel = new UserModel();
  build() {
    Flex({alignItems:ItemAlign.Center}) {
      Image(this.user?.picUrl)
        .width(80)
        .height(80)
        .borderRadius(40)
      Column() {
        Text(this.user?.nickname)
          .fontSize(18)
          .fontWeight(700)
      }
      .padding({left:20})
    }
    .width('100%')
    .height(200)
    .backgroundColor($r('app.color.content_color'))
    .borderRadius(10)
    .margin({top:20})
    .padding({left:20, right:20})
    .onClick(() => {
      router.pushUrl({
        url: 'pages/user/UserDetail',
        params:{
          userId: this.userId
        }
      })
    })
  }
}