import { GroupMusicModel } from '../../../viewmodel/GroupMusicModel'


@Component
export struct MusicDetailInfo {
  // 歌单基础信息
  @Prop item: GroupMusicModel
  build() {
    Flex() {
      Column() {
        Text(this.item.groupName)
          .fontSize(18)
          .lineHeight(50)
        Text(this.item.groupId == 0 ? '你收藏的歌曲都在这里显示' : this.item.groupDesc)
          .fontSize(16)
          .padding({top:10})
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({left:20})
    }
    .width('90%')
    .height(150)
    .backgroundColor($r('app.color.content_color'))
    .borderRadius(10)
    .shadow({ radius: 10, color: Color.Gray })
    .offset({y:-20})
  }
}