import { PublicMethod } from '../../../common/tools/PublicMethod'
import { CommentItemModel } from '../../../viewmodel/CommentItemModel'
import { CommentChildList } from './CommentChildList'

@Component
export struct CommentItem {
  isChild:boolean = false
  @Prop item: CommentItemModel
  build() {
    Flex() {
      Column() {
        Image(`${this.item?.userData?.picUrl}`)
          .width('100%')
          .height('100%')
          .borderRadius(15)
      }
      .width(30)
      .height(30)
      Column() {
        Text(`${this.item?.userData?.nickname}`)
          .fontSize(16)
          .lineHeight(30)
          .width('100%')
        Text(`${this.item.commentText}`)
          .width('100%')
          .lineHeight(22)
          .padding({top:10, bottom:10})
          .fontSize(14)
          .fontWeight(700)
          .letterSpacing(1)
        Flex({justifyContent:FlexAlign.SpaceBetween, alignItems:ItemAlign.Center}) {
          Text(`${PublicMethod.timestampToDate(this.item.timestamp)}`)
            .fontSize(14)
            .opacity(0.8)
          Row() {
            Row() {
              // Image($r('app.media.like_border'))
              //   .width(30)
              //   .height(30)
              // Text('2')
              //   .padding({left:10, right:20})
            }
            // Image('')
            //   .width(30)
            //   .height(30)
            //   .backgroundColor(Color.Red)
          }
        }
        // 评论列表
        if (this.isChild) {
          CommentChildList()
        }
      }
      .padding({left:10})
      .layoutWeight(1)
    }
    .margin({bottom:20})
  }
}