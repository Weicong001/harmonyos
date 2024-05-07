import { PreviewData } from './PreviewData';


@Component
export struct PreviewImage {
  @BuilderParam content : () => void
  @ObjectLink previewData:PreviewData;

  aboutToAppear(): void {

  }
  // 预览图片
  build() {
    Stack() {
      this.content()
      if (this.previewData.visible) {
        Column() {
          Swiper(this.previewData.controller) {
            ForEach(this.previewData.list, (item:string) => {
              Column() {
                Image(item)
                  .width('100%')
                  .objectFit(ImageFit.Auto)
              }
              .width('100%')
              .height('100%')
              .justifyContent(FlexAlign.Center)
            })
          }
          .width('100%')
          .height('100%')
          .padding({top:20, bottom:20, left:10, right:10})
          .index(this.previewData.index)
          .displayMode(SwiperDisplayMode.STRETCH)
        }
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.7)')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.previewData.hide();
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}