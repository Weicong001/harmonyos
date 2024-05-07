import { MyUserInfoParams, SocketChatParams, SocketParams} from '../../../common/interface/interface';
import { Socket } from '../../../common/tools/Socket';
import { buffer, util } from '@kit.ArkTS';
import { SongItemModel } from '../../../viewmodel/SongItemModel';
import { UserModel } from '../../../viewmodel/UserModel';
import { GetUserInfoApi } from '../../../services/users';
import { SocketData } from '../../../viewmodel/SocketData';
import { SocketItemModel } from '../../../viewmodel/SocketItemModel';
import { SocketItem } from './SocketItem';

@Component
export struct WebSocket {
  @StorageLink('currentIndex') currentIndex: number = 0; // 音乐当前播放位置
  @StorageLink('songList') songList:SongItemModel[] = [];
  @StorageLink('userId') userId:number = 0;
  @State user: UserModel = new UserModel();
  @State socketData:SocketData = new SocketData()


  @State message:string = '';

  timer:number = 1;

  async aboutToAppear(): Promise<void> {
    await this.getMyUser();

    let params:SocketParams = {
      type:'joinRoom',
      value: `${this.songList[this.currentIndex].songId}`
    }
    let jsonString = JSON.stringify(params);

    this.timer = setInterval(() => {
      if (Socket.getInstance().ws) {
        Socket.getInstance().send(jsonString)
        clearInterval(this.timer)
      }
    }, 1000)

    Socket.getInstance().message((value:string | ArrayBuffer) => {
      let data:SocketItemModel = JSON.parse(value as string) as SocketItemModel
      console.log('获取信息', this.socketData.list.length + '')
      this.socketData.add(data);
    })
  }
  async getMyUser() {
    let params:MyUserInfoParams = {
      userId: this.userId
    }
    let res = await GetUserInfoApi(params);
    if (res.Code == 200) {
      this.user = res.Data as UserModel;
    }
  }

  send() {
    console.log('准备发消息', JSON.stringify(this.user))
    let params:SocketParams = {
      type:'chat',
      value: {
        songId: this.songList[this.currentIndex].songId,
        user: this.user,
        message: this.message
      } as SocketChatParams
    };
    let jsonString = JSON.stringify(params);
    Socket.getInstance().send(jsonString)
  }

  build() {
    Column() {
      Column() {
        // 在线人数
        List() {
          ForEach(this.socketData.list, (item:SocketItemModel) => {
            SocketItem({
              item: item
            })
          })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#ededed')
      }
      .width('100%')
      .height('90%')
      Flex() {
        TextInput({text:this.message})
          .onChange((value:string) => {
            this.message = value;
          })
        Button('发送')
          .onClick(() => {
            this.send()
          })
      }
      .width('100%')
      .height('10%')
    }
    .width('100%')
    .height('55%')
  }
}