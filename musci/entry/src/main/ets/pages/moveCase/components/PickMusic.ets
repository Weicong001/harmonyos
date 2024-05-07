import { MoveCaseData } from '../../../viewmodel/MoveCaseData'
import { SongItemModel } from '../../../viewmodel/SongItemModel'


@CustomDialog
export struct PickMusic {
  controller:CustomDialogController

  @ObjectLink moveCaseData: MoveCaseData

  build() {
    Column() {
      ForEach(this.moveCaseData.songList, (item:SongItemModel) => {
        Column() {
          Text(item.songName)
            .fontSize(20)
            .fontWeight(700)
          // Text(`${item.singer}`)
          //   .fontSize(16)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .margin({
          bottom:20
        })
        .onClick(() => {
          this.moveCaseData.setSongId(item.songId);
          this.controller.close();
        })
      })
    }
    .width('100%')
    .height('90%')
    .backgroundColor($r('app.color.content_color'))
    .padding(20)
  }
}