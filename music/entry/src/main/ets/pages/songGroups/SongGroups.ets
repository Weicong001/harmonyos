import { Header } from '../../components/header/Header'
import { GroupList } from './components/GroupList'
import { GroupTabBar } from './components/GroupTabBar'

@Entry
@Component
struct SongGroups {
  // 歌单列表


  build() {
    Column() {
      Header({label:'歌单列表'}) {
        Stack({alignContent: Alignment.TopStart}) {
          GroupList()
          GroupTabBar()
        }
        .width('100%')
        .height('100%')
      }
    }
  }
}


