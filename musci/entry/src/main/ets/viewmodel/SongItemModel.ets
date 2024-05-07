import { SongData } from '../common/interface/interface'
import { UserModel } from './UserModel'




@Observed
export class SongItemModel {
  songId:number
  songName:string
  songUrl:string
  picUrl:string
  singer: UserModel[] | number[]
  groupIds:number[]
  test:string
  constructor() {
    // this.songId = params.songId;
    // this.songName = params.songName;
    // this.songUrl = params.songUrl;
    // this.picUrl = params.picUrl;
    // this.singer = params.singer;
    // this.groupIds = params.groupIds;
    // this.test = params.test;
    //
    this.songId = 0;
    this.songName = '';
    this.songUrl = '';
    this.picUrl = '';
    this.singer = [];
    this.groupIds = [0];
    this.test = '111'
  }

  public  onChangeGroupIds(list:number[]) {
    console.log('列表')
    this.groupIds = list;
    console.log('列表', JSON.stringify(list))
  }
  public onChangeTest(str:string) {
    console.log('设置test')
    this.test = str;
  }
}
