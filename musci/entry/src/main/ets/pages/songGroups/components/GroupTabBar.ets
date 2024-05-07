

@Component
export struct GroupTabBar {
  list = ['我的歌单', '歌单广场']
  @State active:number = 0
  build() {
    Flex({justifyContent:FlexAlign.SpaceBetween}) {
      ForEach(this.list,(item:string, index:number) => {
        Column() {
          Text(item)
            .fontColor(this.active == index ? $r('app.color.primary_color') : $r('app.color.text_color'))
        }
        .width((100 / this.list.length) + '%')
        .height(60)
        .backgroundColor('#ededed')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.active = index;
        })
      })
    }
  }
}