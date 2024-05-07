import { router } from '@kit.ArkUI'
import { publishNotification } from '../../common/tools/Notification'
import { AVPlayer } from '../../viewmodel/AVPlayer'
import { SongItemModel } from '../../viewmodel/SongItemModel'
import { SongDialog } from '../songdialog/SongDialog'
import { WantAgent } from '@kit.AbilityKit'

@Component
export struct Player {

  @BuilderParam slotContent:() => void

  @Prop isPageHome:boolean = false

  build() {
    Stack({alignContent:Alignment.BottomStart}) {
      Column() {
        this.slotContent()
      }
      .width('100%')
      .height('100%')
      .padding({bottom: this.isPageHome ? 120 : 60})
      Flex() {
        MusicInfo()
      }
      .width('100%')
      .height(60)
      // .backgroundColor($r('app.color.content_color'))
      .backgroundColor($r('app.color.primary_color'))
      .offset({y: this.isPageHome ? 0 : 0})
    }
    .width('100%')
    .height('100%')
  }
}


@Component
struct MusicInfo {

  // @Consume songList:SongItem[];
  @StorageLink('wantAgentObj') wantAgentObj:WantAgent =  new Object();
  @StorageLink('isPlaying') @Watch('playChange') isPlaying: boolean = false;
  @StorageLink('totalTime') totalTime: number = 0; // 音乐总时长
  @StorageLink('currentTime') currentTime: number = 0; // 音乐当前播放位置
  @StorageLink('currentIndex') currentIndex: number = -1; // 音乐当前播放位置songList
  @StorageLink('songList') songList: SongItemModel[] = []; // 音乐当前播放位置
  timer:number = 0;
  rotateTimer:number = 1;
  @State rotateAngle:number = 0;

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

  async aboutToAppear() {
    if (this.isPlaying) {
      this.rotateImage();
    }
  }


  aboutToDisappear(): void {
    this.songDialogController = null;
  }

  rotateImage() {
    this.rotateTimer = setInterval(() => {
      this.rotateAngle += 20;
    }, 1000)
  }

  async play() {
    await AVPlayer.getInstance().play();
    this.rotateImage();
  }
  async pause() {
    await AVPlayer.getInstance().pause();
    clearInterval(this.rotateTimer)
  }

  playChange() {
    if (this.isPlaying) {
      this.play();
    } else {
      this.pause();
    }
  }

  goMusicControlPage() {
    if (this.songList.length) {
      router.pushUrl({
        url:'pages/musicControl/MusicControl'
      })
    }
  }

  openSongListDialog() {
    this.songDialogController?.open();
  }



  build() {
    Flex({alignItems:ItemAlign.Center}) {
      Button() {
        Button() {
          Image(`${this.songList.length ? this.songList[this.currentIndex]?.picUrl : ''}`)
            .width(36)
            .height(36)
            .borderRadius(18)
            .rotate({ angle: this.rotateAngle })
            .animation({ duration: 1000, curve: Curve.Linear })
        }
        .width(36)
        .height(36)
        .backgroundColor(Color.Black)
      }
      .width(50)
      .height(50)
      .backgroundColor(Color.Black)
      Text(`${this.songList.length ? this.songList[this.currentIndex]?.songName : '暂无信息'}`)
        .layoutWeight(1)
        .padding({left:10})
        .fontSize(16)
        .sl(1)
      Row() {
        Stack() {
          Progress({ value: this.currentTime, total: this.totalTime , type: ProgressType.Ring })
            .width('100%')
            .color(Color.Black)
          Image(this.isPlaying ? $r('app.media.play') : $r('app.media.pause'))
            .width(18)
            .alignSelf(ItemAlign.Center)
        }
        .width(35)
        .height(35)
        .onClick(() => {
          if (this.songList.length) {
            this.isPlaying = !this.isPlaying;
          }
        })
        Column() {
          Image($r('app.media.list'))
            .width('100%')
            .height('100%')
            .onClick(() => {
              this.openSongListDialog()
            })
        }
        .width(32)
        .height(32)
      }
      .width(90)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .height(60)
    .padding({
      left:10,
      right:10
    })
    .onClick(() => {
      this.goMusicControlPage()
    })
  }
}




@Extend(Text)
function sl(count:number) {
  .textOverflow({overflow:TextOverflow.Ellipsis})
  .maxLines(count)
}