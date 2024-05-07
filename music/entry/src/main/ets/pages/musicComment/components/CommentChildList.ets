

import { CommentItemModel } from '../../../viewmodel/CommentItemModel'
import { CommentItem } from './CommentItem'

@Component
export struct CommentChildList {
  @State list:CommentItemModel[] = [
    new CommentItemModel(),
    new CommentItemModel(),
  ]
  build() {
    Column() {
      ForEach(this.list,() => {
        CommentItem({isChild:false})
      })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding({left:20, right:20, top:20})
  }
}