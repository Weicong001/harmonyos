
import { SongItemModel } from '../../../viewmodel/SongItemModel';
import { SongListModel } from '../../../viewmodel/SongListModel';
import { SongItem } from './SongItem'



@Component
export struct SongList {
  @Prop @Watch('changeList') list:SongItemModel[] = [];

  @State songList:SongItemModel[] = []
  // 歌单列表
  // @Prop  list:SongItemModel[];
  change:(index:number) => void = () => {}

  aboutToAppear(): void {

  }

  changeList() {
    console.log('设置list999')
    this.songList = this.list;
  }

  build() {
    Column() {
      ForEach(this.songList, (item:SongItemModel, index:number) => {
        SongItem({
          index: index,
          item: item,
          list: $songList,
          change:this.change
        })
      })
    }
  }
}