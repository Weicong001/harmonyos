import { CommentData } from '../../../viewmodel/CommentData'
import { UserModel } from '../../../viewmodel/UserModel'

@Component
export struct CommentSongInfo {
  @Consume commentData: CommentData

  build() {
    Flex({alignItems:ItemAlign.Center}) {
      Column() {
        Image(`${this.commentData?.songData?.picUrl}`)
          .width(100)
          .height(100)
          .borderRadius(10)
      }
      Column() {
        Text(`${this.commentData?.songData?.songName}`)
          .fontSize(20)
          .lineHeight(40)
        Text(`${(this.commentData?.songData?.singer[0] as UserModel)?.nickname}`)
          .fontSize(16)
          .opacity(0.8)
          .lineHeight(40)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .padding({left:10})
    }
    .width('100%')
    .padding({left:20, right:20})
  }
}