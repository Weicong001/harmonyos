import { CommentData } from '../../../viewmodel/CommentData'
import { CommentItemModel } from '../../../viewmodel/CommentItemModel'
import { CommentInput } from './CommentInput'
import { CommentItem } from './CommentItem'

@Component
export struct CommentList {
  @Consume commentData: CommentData

  submit:() => void = () => {}


  build() {
    Stack({alignContent: Alignment.BottomStart }) {
      Scroll() {
        Column() {
          Text(`评论区 · ${this.commentData.list.length}`)
            .fontSize(18)
            .fontWeight(700)
            .padding({top:30, bottom:30})
          ForEach(this.commentData.list,(item: CommentItemModel) => {
            CommentItem({
              item
            })
          })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding({left:20, right:20, bottom:80})
      }
      .scrollBar(BarState.Off)
      CommentInput({
        submit: this.submit
      })
    }
    .width('100%')
    .height('100%')
  }
}