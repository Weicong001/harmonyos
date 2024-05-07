import { PublicMethod } from '../../../common/tools/PublicMethod'
import { MoveCaseModel } from '../../../viewmodel/MoveCaseModel'
import { SongItemModel } from '../../../viewmodel/SongItemModel';
import { router } from '@kit.ArkUI';
import { AVPlayer } from '../../../viewmodel/AVPlayer';
import { GetUserInfoApi } from '../../../services/users';
import { MyUserInfoParams } from '../../../common/interface/interface';
import { UserModel } from '../../../viewmodel/UserModel';
import { PreviewData } from '../../../components/previewImage/PreviewData';

@Component
export struct MoveCaseItem {
  @StorageLink('currentIndex') currentIndex:number = -1;
  @StorageLink('songList') songList:SongItemModel[] = [];
  @ObjectLink item: MoveCaseModel
  @ObjectLink previewData:PreviewData

  async play() {
    // 设置歌手信息
    if (typeof (this.item.songData.singer[0]) == 'number') {
      let params:MyUserInfoParams = {
        userId: this.item.songData.singer[0] as number
      }
      let res = await GetUserInfoApi(params);
      if (res.Code == 200) {
        let songData = this.item.songData;
        songData.singer = [res.Data as UserModel]
        this.item.setSongData(songData);
        await AVPlayer.getInstance().reset(); // 重置歌曲状态
        await AVPlayer.getInstance().setSongData(this.item.songData); // 设置当前播放歌曲信息
        this.currentIndex = 0;
        this.songList = [this.item.songData];
        router.pushUrl({
          url:'pages/musicControl/MusicControl'
        })
      }
    } else {
      this.item.setSongData(this.item.songData);
      await AVPlayer.getInstance().reset(); // 重置歌曲状态
      await AVPlayer.getInstance().setSongData(this.item.songData); // 设置当前播放歌曲信息
      this.currentIndex = 0;
      this.songList = [this.item.songData];
      router.pushUrl({
        url:'pages/musicControl/MusicControl'
      })
    }
  }

  previewMyImage(list:string[], index:number) {
    this.previewData.show(list, index);
  }

  build() {
    Column() {
      // 用户信息
      Flex() {
        Image(this.item?.userData?.picUrl)
          .width(30)
          .height(30)
          .backgroundColor(Color.Black)
          .borderRadius(25)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/user/UserDetail',
              params:{
                userId: this.item.userData.userId
              }
            })
          })
        Column() {
          Text(this.item?.userData?.nickname)
            .fontSize(16)
          Text(`${ PublicMethod.timestampToDate(this.item?.timestamp)}`)
            .fontSize(14)
            .padding({top:6})
            .opacity(0.8)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .padding({left:10})
      }
      .width('100%')
      // 评论内容
      Text(`${this.item?.content}`)
        .width('100%')
        .padding({top:10})
        .fontSize(16)
        .lineHeight(30)
      // 图片
      if (this.item.imgs && this.item.imgs.length) {
        Flex() {
          ForEach(this.item.imgs, (item:string, index:number) => {
            Column(){
              Image(item)
                .width('100%')
            }
            .width((100 / 3) +'%')
            .height(120)
            .margin(2)
            .backgroundColor(Color.Black)
            .onClick(() => {
              this.previewMyImage(this.item.imgs, index)
            })
          })
        }
        .width('100%')
      }
      // 绑定音乐
      if (this.item?.songId) {
        Flex({alignItems:ItemAlign.Center}) {
          Column() {
            Image(`${this.item.songData.picUrl}`)
              .width(60)
              .height(60)
              .backgroundColor(Color.Black)
          }
          Column() {
            Text(`${this.item?.songData?.songName}`)
              .fontSize(18)
              .fontColor($r('app.color.text_color'))
            // Text(`${this.item.songData.singer}`)
            //   .fontSize(16)
            //   .opacity(0.9)
            //   .fontColor($r('app.color.text_color'))
            //   .padding({top:5})
          }
          .layoutWeight(1)
          .padding({left:10})
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
        }
        .margin({top:10})
        .backgroundColor($r('app.color.bg_color'))
        .borderRadius(10)
        .onClick(() => {
          this.play()
        })
      }
    }
    .width('100%')
    .padding({left:20, right:15, top:25, bottom:25})
    .backgroundColor($r('app.color.content_color'))
    .margin({bottom:10})
  }
}