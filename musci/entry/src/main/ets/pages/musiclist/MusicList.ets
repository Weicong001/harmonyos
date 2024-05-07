
import { Songs } from '../../view/musiclist/components/Songs'


// @Entry
@Component
export struct MusicList {
  // 音乐库
  @State pageFlag:boolean = false;

  aboutToAppear(): void {
    console.log('--page aboutToAppear', JSON.stringify(this.pageFlag))
  }

  onPageShow(): void {
    this.pageFlag = true;
    console.log('--page onPageShow', JSON.stringify(this.pageFlag))
  }

  onPageHide(): void {
    this.pageFlag = false;
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          Songs({pageFlag: $pageFlag})
        }
        .padding({top:40})
      }
    }
    .width('100%')
    // .height('100%')
  }
}