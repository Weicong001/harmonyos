import { router } from '@kit.ArkUI'

@Component
export struct MyHeader {
  label:string = ''

  goBack() {
    router.back();
  }

  build() {
    Flex({justifyContent:FlexAlign.SpaceBetween, alignItems:ItemAlign.Center}) {
      Image($r('app.media.select_icon'))
        .width(30)
        .height(30)
        .onClick(() => {
          this.goBack()
        })
      Text(this.label)
        .fontSize(18)
        .fontColor(Color.Black)
      Image('')
        .width(32)
        .height(32)
        // .backgroundColor(Color.Black)
    }
    .width('100%')
    .height('10%')
    .padding({left:20, right:20})
  }

}