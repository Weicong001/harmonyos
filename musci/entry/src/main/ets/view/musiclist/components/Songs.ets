import { SongItem } from '../../../pages/musicDetailList/components/SongItem';
import { GetSongListApi } from '../../../services';
import { SongItemModel } from '../../../viewmodel/SongItemModel';
import { UserModel } from '../../../viewmodel/UserModel';

interface ResponseSongData {
  songs:SongItemModel[],
  users:UserModel[]
}

@Component
export struct Songs {
  // 音乐库 歌曲列表
  @State users:UserModel[] = [new UserModel()];
  @State songList:SongItemModel[] = []

  @Link @Watch('onPageChange') pageFlag:boolean

  aboutToAppear(): void {
    this.getSongListApi();
  }
  aboutToDisappear(): void {

  }

  onPageChange() {
    // if (this.pageFlag) {
    //   this.getSongListApi();
    // }
  }

  async getSongListApi() {
    let res = await GetSongListApi();
    if (res.Code == 200) {
      let data = res.Data as ResponseSongData;
      let list = data.songs as SongItemModel[];
      this.users = data.users;
      list.forEach((item) => {
        item.singer.forEach((u:number | UserModel, index:number) => {
          let users:UserModel[] = this.users.filter((row) => u == row.userId);
          item.singer[index] = users[0];
        })
      });
      this.songList = list;
    }
  }


  build() {
    Column() {
      // LazyForEach()
      ForEach(this.songList, (item:SongItemModel, index:number) => {
        SongItem({
          index: index,
          item: item,
          list: $songList,
          change:() => {

          }
        })
      })
    }
  }
}