import { MyUserInfoParams, SocketChatParams, SocketParams } from '../../../common/interface/interface';
import { Socket } from '../../../common/tools/Socket';
import { GetUserInfoApi } from '../../../services/users';
import { SocketData } from '../../../viewmodel/SocketData';
import { SocketItemModel } from '../../../viewmodel/SocketItemModel';
import { SongItemModel } from '../../../viewmodel/SongItemModel';
import { UserModel } from '../../../viewmodel/UserModel';
import { SocketItem } from './SocketItem';

@CustomDialog
export struct SocketDialog {
  control: CustomDialogController
  scroller: ListScroller = new ListScroller();
  @StorageLink('currentIndex') currentIndex: number = 0; // 音乐当前播放位置
  @StorageLink('songList') songList:SongItemModel[] = [];
  @StorageLink('userId') userId:number = 0;
  @State user: UserModel = new UserModel();
  @State socketData:SocketData = new SocketData()


  @State text:string = '';
  timer:number = 1;

  async aboutToAppear(): Promise<void> {
    console.log('天窗')
    await this.getMyUser();

    // 监听 初始化
    let params:SocketParams = {
      type:'joinRoom',
      value:{
        songId:this.songList[this.currentIndex].songId,
        user: this.user,
        message:'加入房间'
      } as SocketChatParams
    };
    let jsonString = JSON.stringify(params);

    this.timer = setInterval(() => {
      if (Socket.getInstance().ws) {
        Socket.getInstance().send(jsonString)
        clearInterval(this.timer)
      }
    }, 1000);

    Socket.getInstance().message((value:string | ArrayBuffer) => {
      let data:SocketItemModel = JSON.parse(value as string) as SocketItemModel
      this.socketData.add(data);
      this.scroller.scrollToIndex((this.socketData.list.length as number) - 1)
    })

  }

  // 获取我的信息
  async getMyUser() {
    let params:MyUserInfoParams = {
      userId: this.userId
    }
    let res = await GetUserInfoApi(params);
    if (res.Code == 200) {
      this.user = res.Data as UserModel;
    }
  }

  sendMessage() {
    if (!this.text) return;
    let params:SocketParams = {
      type:'chat',
      value: {
        songId: this.songList[this.currentIndex].songId,
        user: this.user,
        message: this.text
      } as SocketChatParams
    };
    let jsonString = JSON.stringify(params);
    Socket.getInstance().send(jsonString);
    this.text = '';
  }

  leaveRoom() {
    let params:SocketParams = {
      type:'leaveRoom',
      value: {
        songId: this.songList[this.currentIndex].songId,
        user: this.user,
        message: '离开房间'
      } as SocketChatParams
    };
    let jsonString = JSON.stringify(params);
    Socket.getInstance().send(jsonString);
    this.socketData.clear();
    // Socket.getInstance().close();
    this.control.close();
  }

  build() {
    Column() {
      Flex({justifyContent:FlexAlign.SpaceAround, alignItems:ItemAlign.Center}) {
        Text('聊天室')
          .fontSize(16)
          .fontWeight(700)
        Text('离开')
          .fontColor($r('app.color.primary_color'))
          .fontSize(16)
          .onClick(() => {
            this.leaveRoom()
          })
      }
      .width('100%')
      .height('10%')
      List({scroller: this.scroller}){
        ForEach(this.socketData.list, (item:SocketItemModel) => {
          SocketItem({
            item: item
          })
        })
      }
      .width('100%')
      .height('80%')
      .backgroundColor($r('app.color.bg_color'))
      .padding({
        left:20,
        right:20
      })
      Flex({alignItems:ItemAlign.Center}) {
        TextInput({text: this.text, placeholder:'请输入内容'})
          .backgroundColor(Color.White)
          .onChange((value:string) => {
            this.text = value;
          })
          .layoutWeight(1)
        Button('发送')
          .fontSize(12)
          .borderRadius(10)
          .onClick(() => {
            this.sendMessage()
          })
      }
      .width('100%')
      .height('10%')
      .padding({top:3, bottom:3, left:5, right:5})
    }
    .width('100%')
    .height('80%')
    .backgroundColor(Color.White)
  }
}