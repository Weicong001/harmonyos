import { SongDialog } from '../../../components/songdialog/SongDialog';
import { display, router } from '@kit.ArkUI';
import { SongItemModel } from '../../../viewmodel/SongItemModel';
import { UserModel } from '../../../viewmodel/UserModel';
import { CommentType, GroupLikeParams, InspectParams, PlayType } from '../../../common/interface/interface';
import { SetSongLikeApi } from '../../../services';
import { AVPlayer } from '../../../viewmodel/AVPlayer';
import { Socket } from '../../../common/tools/Socket';
import { PublicMethod } from '../../../common/tools/PublicMethod';
import { common } from '@kit.AbilityKit';

@Component
export struct Control {
  songDialogController: CustomDialogController | null = new CustomDialogController({
    builder: SongDialog(),
    closeAnimation:{
      curve:Curve.Ease,
      tempo:100,
      delay:100
    },
    openAnimation:{
      curve:Curve.Ease,
      tempo:100,
      delay:100
    },
    backgroundColor:'#fff'
  })
  @StorageLink('isPlaying') @Watch('playChange') isPlaying: boolean = false;
  @StorageLink('totalTime') totalTime: number = 0; // 音乐总时长
  @StorageLink('currentTime') currentTime: number = 0; // 音乐当前播放位置
  @StorageLink('currentIndex') currentIndex: number = 0; // 音乐当前播放位置
  @StorageLink('songList') songList:SongItemModel[] = [];
  @StorageLink('userId') userId:number = 0;
  @StorageLink('playType') playType:PlayType = PlayType.LIST; // 默认列表播放 / 单曲循环




  playChange() {

  }

  // 收藏 / 取消收藏
  async changeLikeStatus(flag:boolean) {
    console.log(JSON.stringify(flag))
    let params:GroupLikeParams = {
      flag,
      songId: this.songList[this.currentIndex].songId,
      userId: this.userId
    };
    let res = await SetSongLikeApi(params);
    if (res.Code == 200) {
      if (flag) {
        let aIndex = this.songList[this.currentIndex].groupIds.findIndex(row => row == this.userId);
        let groupIds = this.songList[this.currentIndex].groupIds;
        groupIds.splice(aIndex, 1);

        let list = this.songList;
        list[this.currentIndex].groupIds = groupIds;
        this.songList = [...list];
      } else {
        let groupIds = this.songList[this.currentIndex].groupIds
        groupIds.push(this.userId);

        let list = this.songList;
        list[this.currentIndex].groupIds = groupIds;
        this.songList = [...list];
      }
    }
  }

  // 切换播放类型
  changePlayType() {
    if (this.playType == PlayType.LIST) {
      this.playType = PlayType.SINGLE;
    } else {
      this.playType = PlayType.LIST;
    }
  }

  // 上一曲/下一曲
  async changePlayData(index:number) {
    await AVPlayer.getInstance().reset(); // 重置歌曲状态
    if (index == 0) {
      // 上一首
      if (this.currentIndex == 0) {
        this.currentIndex = this.songList.length - 1;
      } else {
        this.currentIndex = this.currentIndex - 1;
      }
    } else {
      if (this.currentIndex == (this.songList.length - 1)) {
        // 最后一首
        this.currentIndex = 0;
      } else {
        this.currentIndex = this.currentIndex + 1;
      }
    }
    await AVPlayer.getInstance().setSongData(this.songList[this.currentIndex]);
  }

  connectSocket:() => void = () => {}

  // 控制进度
  async seek(e:ClickEvent) {
    let x = e.x;
    let width = (display.getDefaultDisplaySync().width) - 40;
    let vpWidth = px2vp(width)
    let time = (x / vpWidth) * this.totalTime;
    await AVPlayer.getInstance().seek(time);
  }

  build() {
    Column() {
      // 名称
      Flex({justifyContent:FlexAlign.SpaceBetween, alignItems:ItemAlign.Center}) {
        Column(){
          Text(`${this.songList.length ? this.songList[this.currentIndex]?.songName : '暂无歌曲'}`)
            .whiteColor()
            .fontSize(24)
            .fontWeight(700)
          // 歌手名称
          Text(`${this.songList.length ? (this.songList[this.currentIndex]?.singer as UserModel[])[0]?.nickname : ''}`)
            .whiteColor()
            .fontSize(18)
            .lineHeight(40)
            .opacity(0.8)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/user/UserDetail',
                params:{
                  userId: (this.songList[this.currentIndex].singer as UserModel[])[0].userId
                }
              })
            })
        }
        .layoutWeight(1)
        Row() {
          Column() {
            // $r('app.media.like_border')
            // $r('app.media.like_red')
            if (this.songList.length && this.songList[this.currentIndex]?.groupIds.includes(this.userId) == true) {
              Image($r('app.media.like_red'))
                .width(40)
                .height(40)
                .onClick(() => {
                  this.changeLikeStatus(true)
                })
            } else {
              Image($r('app.media.like_border'))
                .width(40)
                .height(40)
                .onClick(() => {
                  this.changeLikeStatus(false)
                })
            }
          }

          Column() {
            Image($r('app.media.comment_border'))
              .width(36)
              .height(36)
              .onClick(() => {
                router.pushUrl({
                  url:'pages/musicComment/MusicComment',
                  params:{
                    songId: this.songList[this.currentIndex].songId,
                    type: CommentType.SONG
                  }
                })
              })
          }
        }
        .width(130)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      // 进度条
      Stack({alignContent: Alignment.Start}) {
        Row() {
          Progress({
            value: this.currentTime,
            total: this.totalTime
          })
            .id('progress')
            .color($r('app.color.primary_color'))
            .backgroundColor('#6d6767')
        }
        .width('100%')
        .height(40)
        .onClick((e) => {
          this.seek(e)
        })
        Text('')
          .width(10)
          .height(10)
          .backgroundColor($r('app.color.primary_color'))
          .borderRadius(5)
          .offset({
            x:(this.currentTime / this.totalTime) * 98 + '%',
            y:0
          })
      }
      .margin({
        top:25
      })
      // 按钮
      Flex({justifyContent:FlexAlign.SpaceBetween, alignItems:ItemAlign.Center}) {
        // 播放类型：列表播放 单曲循环
        Image(this.playType == PlayType.LIST ? $r('app.media.play_list') : $r('app.media.single_loop'))
          .width(30)
          .height(30)
          .onClick(() => {
            this.changePlayType()
          })
        Image($r('app.media.last'))
          .width(40)
          .height(40)
          .onClick(() => {
            this.changePlayData(0);
          })
        Image(this.isPlaying ? $r('app.media.play') : $r('app.media.pause'))
          .width(50)
          .height(50)
          .onClick(() => {
            this.isPlaying = !this.isPlaying;
          })
        Image($r('app.media.next'))
          .width(40)
          .height(40)
          .onClick(() => {
            this.changePlayData(1);
          })
        Image($r('app.media.list'))
          .width(30)
          .height(30)
          .onClick(() => {
            this.songDialogController?.open()
          })
      }
      .margin({top:20})
      .height(100)

      Flex({justifyContent:FlexAlign.End,alignItems:ItemAlign.Center}) {
        Text('聊一聊')
          .fontSize(14)
          .onClick(() => {
            this.connectSocket()
          })
      }
    }
    .width('100%')
    .height('35%')
    .padding({left:20, right:20})
  }
}

@Extend(Text)
function whiteColor() {
  .width('100%')
  .fontColor(Color.Black)
}