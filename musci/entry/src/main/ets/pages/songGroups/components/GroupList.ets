

@Component
export struct GroupList {
  build() {
    Column() {
      Scroll() {
        Column() {
          Text('999')
        }
      }
    }
    .width('100%')
    .height('100%')
    .padding({top:60})
  }
}