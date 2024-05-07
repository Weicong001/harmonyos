import { UserModel } from '../../../viewmodel/UserModel'
import { router } from '@kit.ArkUI'

@Component
export struct MyUserInfo {
  @Prop user:UserModel
  @Prop myUserId:number
  build() {
    Column() {
      Column() {
        Image('')
      }
      .width('100%')
      .height(120)
      .backgroundColor($r('app.color.primary_color'))
      Column() {
        // 头像
        Flex({justifyContent:FlexAlign.SpaceBetween}) {
          Image(this.user.picUrl)
            .width(80)
            .height(80)
            .borderRadius(40)
            .offset({y:-50})
          if (this.myUserId == this.user.userId) {
            Button('编辑资料')
              .onClick(() => {
                router.pushUrl({
                  url:'pages/user/EditMyUser'
                })
              })
          }
        }
        // 名称
        Row() {
          Text(`${this.user.nickname}`)
            .fontSize(18)
            .fontWeight(700)
            .padding({top:10})
        }
        .width('100%')
        .offset({y:-50})
        .justifyContent(FlexAlign.Start)
      }
      .width('90%')
      .backgroundColor(Color.White)
      .padding({left:20, right:20, top:20, bottom:10})
      .shadow({ radius: 10, color: '#ededed'})
      .borderRadius(10)
      .offset({y:-50})
    }
  }
}