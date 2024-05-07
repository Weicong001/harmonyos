import { Socket } from '../../common/tools/Socket';
import { Control } from './components/Control'
import { MyHeader } from './components/MyHeader'
import { Record } from './components/Record'
import { SocketDialog } from './components/SocketDialog';
import { WebSocket } from './components/WebSocket';

@Entry
@Component
struct MusicControl {

  socketDialogController: CustomDialogController = new CustomDialogController({
    builder: SocketDialog(),
    autoCancel:false,
    alignment:DialogAlignment.Center
  })

  // 连接socket
  async connectSocket() {
    await Socket.getInstanceSync(); // 初始化
    this.socketDialogController.open();
  }

  build() {
    Column() {
      MyHeader()
      Record()
      Control({
        connectSocket:() => {this.connectSocket()}
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.content_color'))
  }

  pageTransition() {
    PageTransitionEnter({ duration: 500 })
      .translate({ x: 0, y: 1000 })
    PageTransitionExit({ duration: 500 })
      .translate({ x: 0, y: 1000 })
  }

}