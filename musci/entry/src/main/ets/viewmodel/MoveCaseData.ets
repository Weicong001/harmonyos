import { SongListResponse } from '../common/interface/interface';
import { getMoveCaseListApi, GetSongListApi } from '../services';
import { MoveCaseModel } from './MoveCaseModel'
import { SongItemModel } from './SongItemModel';
import { UserModel } from './UserModel';


@Observed
export class MoveCaseData {
  list: MoveCaseModel[] = [];

  songList: SongItemModel[] = [];
  users: UserModel[] = [];

  selectSongId:number = 0;

  setSongId(Id:number) {
    console.log('设置歌曲id', JSON.stringify(Id))
    this.selectSongId = Id;
  }

  async getMoveCaseList() {
    let res = await getMoveCaseListApi();
    if (res.Code == 200) {
      this.list = res.Data as MoveCaseModel[];
    }
  }

  async getSongs() {
    let res = await GetSongListApi();
    if (res.Code == 200) {
      let data = res.Data as SongListResponse;
      this.songList = data.songs as SongItemModel[];
      this.users = data.users as UserModel[];
    }
  }
}

