
import { SongItemModel } from './SongItemModel';
import media from '@ohos.multimedia.media';
import { PlayType, SongData } from '../common/interface/interface';
import { AVSession } from '../common/tools/AVSession';

let params:SongData = {
  songId: 0,
  songName: '',
  songUrl: '',
  picUrl: '',
  singer: [],
  groupIds: [],
  test: ''
}

export class AVPlayer {
  public avPlayer: media.AVPlayer | null = null;

  private isCurrent: boolean = true;
  private isPlaying:boolean = false;

  public currentSongItem: SongItemModel

  constructor() {
    this.currentSongItem = new SongItemModel()
    this.createPlayer();
  }

  public static getInstance():AVPlayer {
    let aVPlayer: AVPlayer | undefined = AppStorage.get('aVPlayer');
    if (!aVPlayer) {
      aVPlayer = new AVPlayer();
      AppStorage.setOrCreate('aVPlayer', aVPlayer);
    }
    return aVPlayer as AVPlayer;
  }

  async createPlayer() {
    console.log('--page 创建播放器')
    let avPlayer: media.AVPlayer = await media.createAVPlayer();
    this.avPlayer = avPlayer;
    this.setAVPlayerCallback();
  }

  setAVPlayerCallback() {
    if (!this.avPlayer || this.avPlayer === null) {
      return;
    }
    this.avPlayer.on('seekDone', (seekDoneTime:number) => {
      this.isCurrent = true;
    });
    // 监听播放器的错误信息
    this.avPlayer.on('error', (err) => {
      console.error(`avPlayer failed, code is ${err.code}, message is ${err.message}`);
      if (this.avPlayer) this.avPlayer.reset(); // 调用reset重置资源，触发idle状态
    });

    // 进度条，监听进度条当前位置，刷新当前时间
    this.avPlayer.on('timeUpdate', (updateTime:number) => {
      if (this.isCurrent) {
        AppStorage.setOrCreate('currentTime', updateTime);
        AVSession.getInstance().setUpdateTime(updateTime);
      }
    })

    // 监听播放器的state属性改变
    this.avPlayer.on('stateChange', async (state: media.AVPlayerState, reason: media.StateChangeReason) => {
      let stateString = state.toString();
      switch(stateString) {
        case 'idle':
          console.log('idle')
          // this.currentUrl = this.songListModel.currentUrl;
          // this.currentIndex = this.songListModel.currentIndex;
          //
          // if (this.currentUrl && this.avPlayer) {
          //   this.avPlayer.url = this.currentUrl;
          // }
          break;
        case 'initialized':
          console.log('initialized')
          this.avPlayer?.prepare().then(() => {
          }, (err:Error) => {
          })
          break;
        case 'prepared':
          console.log('prepared')
        // duration
          AppStorage.setOrCreate('totalTime', this.getDuration());
          AppStorage.setOrCreate('currentTime', this.getCurrentTime())
        // AppStorage.SetOrCreate('progressMax', this.getDuration());
          if (this.avPlayer) this.avPlayer.play();
          break;
        case 'playing':
          this.isPlaying = true;
          AppStorage.setOrCreate('isPlaying', true);
          break;
        case 'paused':
          console.log('paused')
          this.isPlaying = false;
          AppStorage.setOrCreate('isPlaying', false);
          break;
        case 'completed':
          console.log('completed')
          this.isPlaying = false;
          AppStorage.setOrCreate('isPlaying', false);
          // 下一首
          this.playNextAuto();
          break;
        case 'stopped':
          console.log('stopped')
          this.isPlaying = false;
          AppStorage.setOrCreate('isPlaying', false);
          if (this.avPlayer) this.avPlayer.reset();
          break;
        case 'released':
          console.log('released')
          AppStorage.setOrCreate('isPlaying', false);
          break;
        default:
          console.log('unKnow')
          AppStorage.setOrCreate('isPlaying', false);
          break;
      }
      // this.updateIsPlay(this.state === AudioPlayerState.PLAY);
    })




  }




  // 设置当前播放数据
  async setSongData(data: SongItemModel) {
    this.currentSongItem = data;
    if (this.avPlayer && this.avPlayer !== null) {
      this.avPlayer.url = data.songUrl;
    }
  }



  // 下一首播放
  async playNextAuto() {
    let songList:SongItemModel[] | undefined = AppStorage.get('songList');
    let currentIndex:number | undefined = AppStorage.get('currentIndex');
    let playType:PlayType | undefined = AppStorage.get('playType');
    if (playType == PlayType.LIST) {
      // 判断是不是最后一首
      if (currentIndex == (songList ? (songList.length - 1) : 0)) {
        AppStorage.set('currentIndex', 0);
        currentIndex = 0;
      } else {
        AppStorage.set('currentIndex', (currentIndex as number) + 1);
        currentIndex = (currentIndex as number) + 1;
      }
    }
    if (this.avPlayer && songList) {
      await this.avPlayer.reset();
      this.setSongData(songList[(currentIndex as number)]);
    }
  }



  // 获取视频时长 单位为毫秒（ms）
  getDuration():number {
    return this.avPlayer?.duration as number;
  }

  // 获取当前时长位置
  getCurrentTime():number {
    let currentTime = 0;
    if (this.avPlayer && this.avPlayer !== null) {
      currentTime = this.avPlayer.currentTime;
    }
    return currentTime;
  }


  async reset() {
    if (this.avPlayer) {
      await this.avPlayer.reset();
    }
  }

  async stop() {
    if (this.avPlayer) {
      await this.avPlayer.stop();
      this.isPlaying = false;
    }
  }

  async play(seek?:number) {
    console.log('播放111', JSON.stringify(this.avPlayer))
    if (this.avPlayer) {
      this.avPlayer.play().then(() => {
        this.seek(seek ? seek : this.getCurrentTime());
        this.isPlaying = true;
      })
    }
  }

  async pause() {
    if (this.avPlayer) {
      this.avPlayer.pause().then(() => {
        this.isPlaying = false;
      })
    }
  }

  async seek(ms:number) {
    console.log('进度', JSON.stringify(ms))
    let seekMode = this.getCurrentTime() < ms ? 0 : 1;
    let realTime = (ms <= 0 ? 0 : (ms >= this.getDuration() ? this.getDuration() : ms));
    this.isCurrent = true;
    if (this.avPlayer) this.avPlayer.seek(realTime, seekMode);
  }



}