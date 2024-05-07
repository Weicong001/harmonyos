import { AbilityConstant, common, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { startContinuousTask, stopContinuousTask } from '../common/tools/LongTimeTask';
import { AVPlayer } from '../viewmodel/AVPlayer';
import { SongItemModel } from '../viewmodel/SongItemModel';
import { AVSession } from '../common/tools/AVSession';
import { SessionMusicInfo } from '../common/interface/interface';



export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    AppStorage.clear(); // 删除所有存储的歌曲信息
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/login/Login', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      PersistentStorage.persistProp('userId', 0);
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');

    let context = getContext(this) as common.UIAbilityContext;
    if (context) {{
      stopContinuousTask(context);
    }}
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');

    // 长时任务
    // 开始长时任务
    let context = getContext(this) as common.UIAbilityContext;
    const bundleName = context.abilityInfo.bundleName;
    const abilityName = context.abilityInfo.name;
    startContinuousTask(bundleName, abilityName, this.context, async () => {
      console.log('长时任务执行')
      playMusic(context);
    });
  }
}




async function playMusic(context:Context) {
  let params:SessionMusicInfo = {
    currentIndex: AppStorage.get('currentIndex') as number,
    songList: AppStorage.get('songList') as SongItemModel[],
    isPlaying: AppStorage.get('isPlaying') as boolean,
    totalTime: AppStorage.get('totalTime') as number,
    currentTime: AppStorage.get('currentTime') as number,
  }
  // currentTime
  await AVSession.getInstance().createSession(context);
  AVSession.getInstance().setMusicInfo(params); // 设置音乐信息
  AVSession.getInstance().setSessionInfo();
  AVSession.getInstance().activate();

  if (AppStorage.get('isPlaying') as boolean) {
    await AVPlayer.getInstance().play();
  }
  // AVPlayer.getInstance(); // 初始化播放器
  // const currentTime:number | undefined = AppStorage.get('currentTime');
  // const currentIndex:number | undefined = AppStorage.get('currentIndex');
  // const songList:SongItemModel[] | undefined = AppStorage.get('songList');
  // await AVPlayer.getInstance().reset(); // 重置歌曲状态
  // await AVPlayer.getInstance().setSongData((songList as SongItemModel[])[currentIndex as number]);
  // await AVPlayer.getInstance().play(currentTime);
}