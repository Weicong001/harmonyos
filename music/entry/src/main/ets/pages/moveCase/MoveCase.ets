import { Header } from '../../components/header/Header'
import { MoveCaseItem } from './components/MoveCaseItem'
import { router } from '@kit.ArkUI'
import { MoveCaseData } from '../../viewmodel/MoveCaseData';
import { MoveCaseModel } from '../../viewmodel/MoveCaseModel';
import { PreviewImage } from '../../components/previewImage/PreviewImage';
import { PreviewData } from '../../components/previewImage/PreviewData';

@Entry
@Component
struct MoveCase {
  // 动态
  @State moveCaseData:MoveCaseData = new MoveCaseData();
  @State previewData:PreviewData = new PreviewData();

  async onPageShow(): Promise<void> {
    await this.moveCaseData.getMoveCaseList();
  }


  build() {
    Column() {
      PreviewImage({previewData: this.previewData}) {
        Header({label:'动态', color:'#fff'}) {
          Stack({alignContent: Alignment.BottomEnd }) {
            Column() {
              Scroll() {
                Column() {
                  ForEach(this.moveCaseData.list, (item:MoveCaseModel) => {
                    MoveCaseItem({
                      item: new MoveCaseModel(item),
                      previewData: this.previewData
                    })
                  })
                }
              }
            }
            .width('100%')
            .height('100%')
            Button('添加')
              .offset({x:-10, y: -50})
              .onClick(() => {
                router.pushUrl({
                  url:'pages/moveCase/MoveCaseAdd'
                })
              })
          }
          .width('100%')
          .height('100%')
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ededed')
  }

  pageTransition() {
    PageTransitionEnter({ duration: 1000 })
      .opacity(1)
    PageTransitionExit({ duration: 1200 })
      .opacity(0)
  }

}