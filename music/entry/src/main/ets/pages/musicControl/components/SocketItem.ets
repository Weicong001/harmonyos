import { SocketItemModel } from '../../../viewmodel/SocketItemModel'

@Component
export struct SocketItem {
  @ObjectLink item : SocketItemModel
  build() {
    ListItem() {
        Text(`${this.item.user.nickname}：${this.item.message}`)
          .fontSize(14)
          .fontWeight(500)
          .padding({top:5, bottom:5})
      // Flex() {
      //   Column() {
      //     Image(this.item.user.picUrl)
      //       .width(30)
      //       .height(30)
      //       .borderRadius(15)
      //     Text(this.item.user.nickname)
      //   }
      //   .width(100)
      //   .height(50)
      //   .justifyContent(FlexAlign.Center)
      //   Text(this.item.message)
      //     .layoutWeight(1)
      // }
    }
    .margin({
      bottom:10
    })
  }
}