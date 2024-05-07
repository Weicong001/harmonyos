import { TipControl } from './TipControl'


@Component
export struct Tip {
  @BuilderParam content:() => void
  @ObjectLink control: TipControl;

  build() {
    Stack({alignContent: Alignment.Top}) {
        if (this.control.show) {
          Column() {
            Image(this.control.type == 'success' ? $r('app.media.success') : $r('app.media.fail'))
              .width(40)
              .height(40)
            Text(this.control.label)
              .fontColor(Color.White)
              .padding({top:20})
              .fontSize(20)
          }
          .width(160)
          .height(160)
          .backgroundColor('#4c4c4c')
          .borderRadius(10)
          .justifyContent(FlexAlign.Center)
          .offset({
            y:'35%'
          })
          .padding({left:10, right:10})
        }

        Column() {
          this.content()
        }
    }
    .width('100%')
    .height('100%')
  }
}