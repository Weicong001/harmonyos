import { SongItemModel } from './SongItemModel'
import { UserModel } from './UserModel'

@Observed
export class MoveCaseModel {
  moveId: number = 0
  userId: number = 0 // 发布人ID
  userData: UserModel = new UserModel() // 发布人
  content: string = '' // 动态内容
  imgs: string[] = [] // ['', '']
  timestamp: number = 0 // 时间
  likeUserIds: number[] = [] // [1]
  songId: number = 0 // 绑定的音乐
  songData: SongItemModel = new SongItemModel()

  constructor(params: MoveCaseModel) {
    this.moveId = params.moveId;
    this.userId = params.userId;
    this.userData = params.userData;
    this.content = params.content;
    this.imgs = params.imgs;
    this.timestamp = params.timestamp;
    this.likeUserIds = params.likeUserIds;
    this.songId = params.songId;
    this.songData = params.songData;
  }

  setSongData(data:SongItemModel) {
    this.songData = data;
  }

}