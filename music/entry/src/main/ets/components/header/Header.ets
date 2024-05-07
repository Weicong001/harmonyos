import { router } from '@kit.ArkUI';


@Component
export struct Header {

  label:string = '';
  isBack:boolean = true;
  color: ResourceColor = '#fff'
  rightBtn: boolean = false;
  rightText:string = '';

  rightClick:(text:string) => void = () => {}

  @Builder slotContentBuilder() {}

  @Builder
  rightButton() {
    // 发动态
    Button(this.rightText).onClick((event: ClickEvent) => {
      this.rightClick(this.rightText)
    })
  }

  @BuilderParam slotContent:() => void = this.slotContentBuilder

  goBack() {
    if (!this.isBack) return;
    router.back();
  }

  build() {
    Stack({alignContent:Alignment.TopStart}) {
      Flex({alignItems:ItemAlign.Center}) {
        Image(this.isBack ? $r('app.media.back_black') : '')
          .width(32)
          .height(32)
          .onClick(() => {
            this.goBack()
          })
        Column() {
          Text(this.label)
            .fontSize(20)
            .fontWeight(700)
        }
        .layoutWeight(1)

        if (this.rightBtn) {
          this.rightButton()
        } else {
          Image('')
            .width(40)
            .height(40)
        }
      }
      .width('100%')
      .height(60)
      .padding({left:20, right:20})
      .zIndex(10)
      .backgroundColor(this.color)
      Column() {
        this.slotContent()
      }
      .width('100%')
      .height('100%')
      .padding({top:60})
    }
    .width('100%')
    .height('100%')
  }
}