import { AVPlayer } from '../../viewmodel/AVPlayer';
import { SongItemModel } from '../../viewmodel/SongItemModel'
import { UserModel } from '../../viewmodel/UserModel';

@Component
export struct PlayingList {
  // 正在播放的音乐列表
  @StorageLink('songList') songList: SongItemModel[] = [];

  build() {
    Scroll() {
      Column() {
        ForEach(this.songList, (item: SongItemModel, index:number) => {
          PlayingSongItem({
            item,
            index
          })
        })
      }
      .padding({bottom:60})
    }
    .scrollBar(BarState.Off)
  }
}

@Component
struct PlayingSongItem {
  @StorageLink('currentIndex') currentIndex:number = -1;
  @Prop item: SongItemModel
  @Prop index: number

  // 播放歌曲
  async play() {
    await AVPlayer.getInstance().reset(); // 重置歌曲状态
    await AVPlayer.getInstance().setSongData(this.item); // 设置当前播放歌曲信息
    this.currentIndex = this.index;
  }
  // 删除本地存储的歌曲
  deletePlayingSong() {

  }
  build() {
    Flex({alignItems:ItemAlign.Center}) {
      Column() {
        Text(this.item.songName || '暂无数据')
          .fontSize(18)
          .fontColor(this.currentIndex == this.index ? $r('app.color.primary_color') : $r('app.color.text_color'))
        Text(`${(this.item.singer[0] as UserModel)?.nickname || '暂无数据'}`)
          .fontSize(16)
          .lineHeight(30)
          .opacity(0.9)
          .fontColor(this.currentIndex == this.index ? $r('app.color.primary_color') : $r('app.color.text_color'))
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      Row() {
        // $r('app.media.like_border')
        // Image($r('app.media.error'))
        //   .width(20)
        //   .height(20)
        //   .onClick(() => {
        //     this.deletePlayingSong()
        //   })
      }
      .width(40)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({right:10})
    }
    .width('100%')
    .margin({bottom:20})
    .onClick(() => {
      this.play()
    })
  }
}