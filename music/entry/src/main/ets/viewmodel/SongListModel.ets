import { SongData } from '../common/interface/interface';
import { SongItemModel } from './SongItemModel'




@Observed
export class SongListModel {
  songList:SongItemModel[] = [];



  setList(list:SongItemModel[]) {
    console.log('设置列表1')
    this.songList = list
  }

}