import { GroupDetailParams } from '../../common/interface/interface';
import { Header } from '../../components/header/Header';
import { Player } from '../../components/player/Player';
import { GetSongGroupApi } from '../../services';
import { GetUserListApi } from '../../services/users';
import { GroupMusicModel } from '../../viewmodel/GroupMusicModel';
import { SongItemModel } from '../../viewmodel/SongItemModel';
import { UserModel } from '../../viewmodel/UserModel';
import { MusicDetailBackground } from './components/MusicDetailBackground';
import { MusicDetailInfo } from './components/MusicDetailInfo';
import { SongList } from './components/SongList';

interface ResponseGroupDetail {
  group: GroupMusicModel,
  songList: SongItemModel[]
}


@Entry
@Component
struct MusicDetailList {
  // 歌单详情页
  @StorageLink('userId') userId:number = 0;
  @State list:SongItemModel[] = [];
  @State users:UserModel[] = [];
  @State groupInfo: GroupMusicModel = new GroupMusicModel();


  aboutToAppear(): void {

  }

  onPageShow(): void {
    this.getSongGroupApi();
  }

  async getSongGroupApi() {
    let params:GroupDetailParams = {
      groupId:0,
      userId:this.userId
    }
    let res = await GetSongGroupApi(params);
    let userResponse = await GetUserListApi();
    if (userResponse.Code == 200) {
      this.users = userResponse.Data as UserModel[];
    }
    if (res.Code == 200) {
      let data = res.Data as ResponseGroupDetail;
      let list = data.songList;
      list.forEach((item) => {
        item.singer.forEach((u:number | UserModel, index:number) => {
          let users:UserModel[] = this.users.filter((row) => u == row.userId);
          item.singer[index] = users[0];
        })
      });
      this.list = [...list];
      this.groupInfo = data.group;
    }
  }

  async change(index:number) {
    let list = this.list;
    list.splice(index, 1);
    this.list = [...list]
  }

  build() {
    Column() {
      Header({label:'歌单'}) {
        Player() {
          Scroll() {
            Column() {
              // 背景
              MusicDetailBackground()
              // 歌单信息
              MusicDetailInfo({item: this.groupInfo})
              // 歌曲列表
              SongList({list: this.list, change: this.change})
            }
          }
        }
      }
    }
  }
}

