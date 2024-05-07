import { GroupLikeParams } from '../../../common/interface/interface'
import { SetSongLikeApi } from '../../../services'
import { AVPlayer } from '../../../viewmodel/AVPlayer'
import { SongItemModel } from '../../../viewmodel/SongItemModel'
import { UserModel } from '../../../viewmodel/UserModel'


@Component
export struct SongItem {
  // 单个歌曲信息
  @StorageLink('currentIndex') currentIndex:number = -1;
  @StorageLink('userId') userId:number = 0;
  @StorageLink('songList') songList:SongItemModel[] = [];
  @Prop index:number
  // @Prop item: SongItemModel
  @ObjectLink item: SongItemModel
  @Link list:SongItemModel[]

  change:(index:number) => void = () => {}

  async play() {
    await AVPlayer.getInstance().reset(); // 重置歌曲状态
    await AVPlayer.getInstance().setSongData(this.item); // 设置当前播放歌曲信息
    this.currentIndex = this.index;
    this.songList = this.list;
    // this.item.onChangeTest('');
    // AppStorage.setOrCreate('songList', this.list);
  }

  // 添加我喜欢/取消我喜欢
  async addLike() {
    let flag = this.item.groupIds.includes(this.userId);
    let params:GroupLikeParams = {
      flag,
      songId: this.item.songId,
      userId: this.userId
    }
    let res = await SetSongLikeApi(params);
    if (res.Code == 200) {
      if (flag) {
        let aIndex = this.item.groupIds.findIndex(row => row == this.userId);
        let groupIds = this.item.groupIds;
        groupIds.splice(aIndex, 1);

        let list = this.list;
        list[this.index].groupIds = groupIds;
        this.list = [...list];
        this.change(this.index);
      } else {
        let groupIds = this.item.groupIds
        groupIds.push(this.userId);

        let list = this.list;
        list[this.index].groupIds = groupIds;
        this.list = [...list];
        this.change(this.index);
      }
    }
  }

  build() {
    Flex({alignItems:ItemAlign.Center}) {
      Text(this.item.test)
      Text(`${this.index + 1}`)
        .width(60)
        .padding({left:15})
        .fontSize(20)
        .fontWeight(700)
        .fontColor(this.list.findIndex((row) => row.songId == this.songList[this.currentIndex]?.songId) == this.index ? $r('app.color.primary_color') : $r('app.color.text_color'))
      Column() {
        Text(this.item.songName || '暂无数据')
          .fontSize(18)
          .fontColor(this.list.findIndex((row) => row.songId == this.songList[this.currentIndex]?.songId) == this.index ? $r('app.color.primary_color') : $r('app.color.text_color'))
        Text(`${(this.item.singer[0] as UserModel)?.nickname || '暂无数据'}`)
          .fontSize(16)
          .lineHeight(30)
          .opacity(0.9)
          .fontColor(this.list.findIndex((row) => row.songId == this.songList[this.currentIndex]?.songId) == this.index ? $r('app.color.primary_color') : $r('app.color.text_color'))
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      Row() {
        Image(this.item.groupIds.includes(this.userId) ? $r('app.media.like_red') : $r('app.media.like_border'))
          .width(30)
          .onClick(() => {
            this.addLike()
          })
        // $r('app.media.more')
        Image('')
          .width(26)
      }
      .width(80)
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