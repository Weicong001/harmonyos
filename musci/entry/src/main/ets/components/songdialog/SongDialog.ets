import { PlayingList } from './PlayingList'


@CustomDialog
export struct SongDialog {
  control: CustomDialogController
  build() {
    Column() {
      Text('当前播放列表')
        .width('100%')
        .fontSize(20)
        .fontWeight(700)
        .padding({top:20, bottom:20})
      PlayingList()
    }
    .width('100%')
    .height('90%')
    .padding({left:20, right:20})
    // .backgroundColor($r('app.color.content_color'))
  }
}