import { SongItemModel } from '../../../viewmodel/SongItemModel';

@Component
export struct Record {
  @StorageLink('isPlaying') @Watch('playChange') isPlaying: boolean = false;
  @StorageLink('currentIndex') currentIndex: number = 0; // 音乐当前播放位置
  @StorageLink('songList') songList:SongItemModel[] = [];
  @State rotateAngle:number = 0;
  @State angle:number = 0;
  timer:number = 0
  rotateTimer:number = 1;

  aboutToAppear(): void {
    this.onRotate();
    if (this.isPlaying) {
      this.rotateImage();
    } else {
      clearInterval(this.rotateTimer); // 关闭唱片滚动
    }
  }

  playChange() {
    this.onRotate();
    if (this.isPlaying) {
      this.rotateImage();
    } else {
      clearInterval(this.rotateTimer); // 关闭唱片滚动
    }
  }

  // 唱片滚动
  rotateImage() {
    clearInterval(this.rotateTimer); // 关闭唱片滚动
    this.rotateTimer = setInterval(() => {
      this.rotateAngle += 1;
    }, 10)
  }

  onRotate() {
    clearInterval(this.timer)
    if (!this.isPlaying) {
      this.timer = setInterval(() => {
        if (this.angle == 0) {
          clearInterval(this.timer)
        }
        this.angle -= 1;
      }, 10)
    } else {
      this.timer = setInterval(() => {
        if (this.angle >= 23) {
          clearInterval(this.timer)
        }
        this.angle += 1;
      }, 10)
    }
  }
  build() {
    Column() {
      Image($r('app.media.control'))
        .width(150)
        .height(150)
        .offset({y:60, x:90})
        .rotate({
          x:0,
          y:0,
          z:1,
          angle:this.angle,
          centerX:'50%',
          centerY:0
        })
        .zIndex(10)
      Button() {
        Image(this.songList.length ? this.songList[this.currentIndex].picUrl : '')
          .width(200)
          .height(200)
          .backgroundColor(Color.Red)
          .borderRadius(100)
          .rotate({
            angle:this.rotateAngle,
          })
      }
      .width(300)
      .height(300)
      .backgroundColor(Color.Black)
      .offset({y:-40})
      .onClick(() => {
        console.log('点击')
        this.onRotate();
      })

    }
    .width('100%')
    .height('55%')
    .justifyContent(FlexAlign.Center)
  }
}