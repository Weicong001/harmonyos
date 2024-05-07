
import { MenuList } from './components/MenuList'
import { UserInfo } from './components/UserInfo'

@Component
export struct Mine {
  build() {
    Column() {
      UserInfo()
      MenuList()
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_color'))
    .padding({
      left:10,
      right:10
    })
  }
}