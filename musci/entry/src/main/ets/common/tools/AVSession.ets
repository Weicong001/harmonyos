

import AVSessionManager from '@ohos.multimedia.avsession';
import { BusinessError } from '@kit.BasicServicesKit';
import { SongItemModel } from '../../viewmodel/SongItemModel';
import { SessionMusicInfo } from '../interface/interface';
import { UserModel } from '../../viewmodel/UserModel';

export class AVSession {
  private songList:SongItemModel[] = []
  private currentIndex:number = 0
  private isPlaying:boolean = false;
  private totalTime:number = 0;
  private currentTime:number = 0;
  private updateTime:number = 0;

  public session: AVSessionManager.AVSession | null = null;
  context :Context | null = null;

  constructor() {

  }

  // 获取实例
  public static getInstance(): AVSession {
    let avSession: AVSession | undefined = AppStorage.get('avSession');
    if (!avSession) {
      avSession = new AVSession();
      AppStorage.setOrCreate('avSession', avSession);
    }
    return avSession as AVSession;
  }

  async createSession(context:Context) {
    let sessionName = 'SESSION_NAME';
    let type: AVSessionManager.AVSessionType = 'audio';
    this.session = await AVSessionManager.createAVSession(context,sessionName, type);
    this.context = context;
    this.listenEvent();
  }


  public setSessionInfo() {
    // 设置必要的媒体信息
    let metadata: AVSessionManager.AVMetadata = {
      // assetId:'0',
      assetId: this.songList[this.currentIndex]?.songId + '', // 由应用指定，用于标识应用媒体库里的媒体
      title: this.songList[this.currentIndex]?.songName, // 音乐名称
      artist: (this.songList[this.currentIndex]?.singer as UserModel[])[0]?.nickname, // 歌手信息
      mediaImage: this.songList[this.currentIndex]?.picUrl
    };
    this.session?.setAVMetadata(metadata).then(() => {
      console.info(`SetAVMetadata successfully`);
    }).catch((err: BusinessError) => {
      console.error(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`);
    });



  }


  async activate() {
    await this.session?.activate();
  }


  // 设置歌曲信息
  setMusicInfo(data: SessionMusicInfo) {
    this.currentIndex = data.currentIndex;
    this.songList = data.songList;
    this.isPlaying = data.isPlaying;
    this.totalTime = data.totalTime;
    this.currentTime = data.currentTime;
    this.setPlayState();
  }

  setUpdateTime(updateTime:number) {
    this.updateTime = updateTime;
  }


  // 设置播放状态
  setPlayState() {
    // 播放状态

    let state = this.isPlaying ? AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY : AVSessionManager.PlaybackState.PLAYBACK_STATE_PAUSE
    console.log('设置状态', JSON.stringify(state))
    let playbackState: AVSessionManager.AVPlaybackState = {
      state: state,
      isFavorite:false,
      position: { // 进度条
        elapsedTime: this.currentTime, // 已经播放的位置，以ms为单位
        updateTime: this.updateTime, // 应用更新当前位置的时间戳，以ms为单位
      },
      duration: this.totalTime
    };
    this.session?.setAVPlaybackState(playbackState, (err: BusinessError) => {
      if (err) {
        console.error(`Failed to set AVPlaybackState. Code: ${err.code}, message: ${err.message}`);
      } else {
        console.info(`设置状态成功`);
      }
    });
  }

  // 监听通知栏操作
  listenEvent() {
    this.session?.on('play', () => {
      console.log('后台- play')
    })
    this.session?.on('pause', () => {
      console.log('后台- pause')
    })
    this.session?.on('stop', () => {
      console.log('后台- stop')
    })
    this.session?.on('stop', () => {
      console.log('后台- stop')
    })
    this.session?.on('playNext', () => {
      console.log('后台- playNext')
    })
    this.session?.on('playPrevious', () => {
      console.log('后台- playPrevious')
    })
    this.session?.on('fastForward', () => {
      console.log('后台- fastForward')
    })
    this.session?.on('rewind', () => {
      console.log('后台- rewind')
    })
    this.session?.on('seek', () => {
      console.log('后台- seek')
    })
    this.session?.on('setSpeed', () => {
      console.log('后台- setSpeed')
    })
    this.session?.on('setLoopMode', () => {
      console.log('后台- setLoopMode')
    })
    this.session?.on('toggleFavorite', () => {
      console.log('后台- toggleFavorite')
    })
  }



}
