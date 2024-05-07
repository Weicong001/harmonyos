import { MoveCaseAddParams } from '../../common/interface/interface';
import { Header } from '../../components/header/Header'
import { AddMoveCase } from '../../services';
import { promptAction, router } from '@kit.ArkUI';
import window from '@ohos.window';
import { PickMusic } from './components/PickMusic';
import { MoveCaseData } from '../../viewmodel/MoveCaseData';
import { PickPhoto } from '../../common/tools/PickPhoto';

@Entry
@Component
struct MoveCaseAdd {
  @State moveCaseData:MoveCaseData = new MoveCaseData();
  @StorageLink('userId') userId:number = 0;
  @State screenHeight: number = 0;
  @State text:string = '';
  @State images: string[] = [];
  @State pickPhoto:PickPhoto = new PickPhoto();

  dialogController: CustomDialogController = new CustomDialogController({
    builder: PickMusic({moveCaseData: this.moveCaseData}),
    showInSubWindow:true
  })

  aboutToAppear(): void {
    window.getLastWindow(getContext(this)).then(currentWindow =>{
      let property = currentWindow.getWindowProperties();
      let avoidArea = currentWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_KEYBOARD);
      // 初始化显示区域高度
      this.screenHeight = px2vp(property.windowRect.height - avoidArea.bottomRect.height);
      // 监视软键盘的弹出和收起
      currentWindow.on('avoidAreaChange', async data => {
        if (data.type !== window.AvoidAreaType.TYPE_KEYBOARD) {
          return;
        }
        this.screenHeight = px2vp(property.windowRect.height - data.area.bottomRect.height);
      })
    })
  }

  // 发布动态
  async submit() {

    let params:MoveCaseAddParams = {
      userId: this.userId,
      content: this.text,
      songId: this.moveCaseData.selectSongId,
      imgs: this.images
    };

    let res = await AddMoveCase(params);
    if (res.Code == 200) {
      promptAction.showToast({
        message:'添加成功'
      });
      router.back();
    }
  }

  // 上传图片
  async uploadImages() {
    try {
      let images:string[] = this.images;
      let paths = await this.pickPhoto.pickImage();
      for(let path of paths) {
        let url = await this.pickPhoto.getFileUrl(path);
        images.push(url);
      }
      this.images = images;
    } catch(err) {
      console.log(JSON.stringify(err))
    }
  }

  build() {
    Column() {
      Header({
        label:'发动态',
        rightBtn:true,
        rightText:'发布',
        rightClick:() => {this.submit()}
      }) {
        Stack({alignContent:Alignment.BottomStart}) {
          Column() {
            TextArea({
              text:this.text,
              placeholder: '请输入内容'
            })
              .fontSize(20)
              .placeholderFont({
                size: 20
              })
              .padding({top:20, bottom:20})
              .backgroundColor($r('app.color.bg_color'))
              .onChange((value:string) => {
                this.text = value;
              })
            // 图片
            Flex({wrap:FlexWrap.Wrap, justifyContent:FlexAlign.Start}) {
              ForEach(this.images, (item:string, index:number) => {
                Column() {
                  Stack({alignContent:Alignment.Center}) {
                    Image(item)
                      .width('100%')
                    Column() {
                      Image($r('app.media.error'))
                        .width(20)
                        .height(20)
                        .margin(5)
                        .onClick(() => {
                          this.images.splice(index, 1);
                        })
                    }
                    .width('100%')
                    .height('100%')
                    .alignItems(HorizontalAlign.End)
                    .justifyContent(FlexAlign.End)
                  }
                  .padding(1)
                }
                .width((100 / 4) + '%')
                .height(100)
                .padding(1)
                .backgroundColor(Color.Black)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                // 预览
              })
              Column() {
                Row() {
                  Text('+')
                    .fontSize(40)
                    .fontWeight(700)
                }
                  .width('100%')
                  .height('100%')
                .justifyContent(FlexAlign.Center)
                .alignItems(VerticalAlign.Center)
                  .backgroundColor('#ccc')
              }
                .width((100 / 4) + '%')
                .height(100)
                .padding(1)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .onClick(() => {
                  this.uploadImages()
                })
            }
            .width('100%')
            .padding({left:10, right:10, top:20})
            // 音乐
            if (this.moveCaseData.selectSongId) {
              SelectSongItemInfo({moveCaseData:this.moveCaseData})
            }
          }
          .width('100%')
          .height('100%')
          .padding({bottom:60})
          Flex({alignItems:ItemAlign.Center}) {
            Image($r('app.media.music'))
              .width(30)
              .height(30)
              // .backgroundColor(Color.Black)
              .onClick(async () => {
                if (this.moveCaseData.selectSongId) return;
                await this.moveCaseData.getSongs()
                this.dialogController.open()
                console.log(JSON.stringify(this.moveCaseData.songList.length) )
              })
          }
          .width('100%')
          // .height(60)
          .backgroundColor('#ededed')
          .padding({left:20, right:20, bottom:20})
          .zIndex(10)
          .offset({y: -(30 + 60)})
        }
        .width('100%')
        .height(this.screenHeight)
      }
    }.width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_color'))
  }
}

@Component
struct SelectSongItemInfo {
  @ObjectLink moveCaseData:MoveCaseData
  build() {
    Flex({justifyContent:FlexAlign.SpaceAround, alignItems:ItemAlign.Center}) {
      Image(this.moveCaseData?.songList.filter(item => item.songId == this.moveCaseData?.selectSongId)[0]?.picUrl ?? '')
        .width(40)
        .height(40)
      Column() {
        Text(`${this.moveCaseData?.songList.filter(item => item.songId == this.moveCaseData?.selectSongId)[0]?.songName ?? ''}`)
        // Text(`${this.moveCaseData?.songList.filter(item => item.songId == this.moveCaseData?.selectSongId)[0]?.singer ?? ''}`)
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      .layoutWeight(1)
      .padding({left:20})
      Image($r('app.media.error'))
        .width(20)
        .height(20)
        // .backgroundColor(Color.Black)
        .onClick(() => {
          this.moveCaseData.setSongId(0)
        })
    }
    .padding({left:20, right:20})
    .margin({top:30})
  }
}