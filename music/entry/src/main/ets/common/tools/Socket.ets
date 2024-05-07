
import webSocket from '@ohos.net.webSocket';
import { BusinessError } from '@ohos.base';
import { socketServer } from '../../config/config';

export class Socket {
  url:string = socketServer
  ws: webSocket.WebSocket | null = null

  constructor() {
    this.init();
  }

  public static async getInstanceSync():Promise<Socket> {
    return new Promise((resolve) => {
      let socket:Socket | undefined = AppStorage.get('socket');
      if (!socket) {
        socket = new Socket();
        AppStorage.setOrCreate('socket', socket);
      }
      resolve(socket as Socket)
    })
  }

  public static getInstance() {
    let socket:Socket | undefined = AppStorage.get('socket');
    if (!socket) {
      socket = new Socket();
      AppStorage.setOrCreate('socket', socket);
    }
    return socket as Socket
  }

  close() {
    this.ws = null;
    AppStorage.setOrCreate('socket', null);
  }


  init() {
    console.log('初始化')
    let ws = webSocket.createWebSocket();
    this.ws = ws;
    this.connect();
  }


  open() {
    // 订阅WebSocket的打开事件
    if (!this.ws) return;
    this.ws.on('open', (err: BusinessError, value: Object) => {
      console.log('开放 socket')
    })
  }

  public send(msg:string | ArrayBuffer) {
    console.log('发送信息', msg, JSON.stringify(this.ws))
    // 通过WebSocket连接发送数据
    if (!this.ws) return;
    this.ws?.send(msg, (err: BusinessError, value:boolean) => {
      console.log('发送消息', JSON.stringify(value))
    })
  }


  message(callback:(value:string | ArrayBuffer) => void) {
    if (!this.ws) return;
    this.ws.on('message', (err:BusinessError, value: string | ArrayBuffer) => {
      // console.log('收到消息', JSON.stringify(value))
      callback(value);
    })
  }


  connect() {
    // 根据URL地址，建立一个WebSocket连接
    this.ws?.connect(this.url, (err:BusinessError, value: boolean) => {
      if (!err) {
        console.log('连接成功')
      }
    })
  }

  // 关闭连接 方法
  // public close() {
  //  this.ws?.close();
  // }


}