import { WantAgent, wantAgent } from '@kit.AbilityKit'
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { BusinessError } from '@kit.BasicServicesKit';


export const startContinuousTask = (bundleName:string, abilityName:string, context:Context, callback:() => void ) => {
  const wantAgentInfo: wantAgent.WantAgentInfo = {
    wants: [
      {
        bundleName,
        abilityName,
      }
    ],
    actionType: wantAgent.OperationType.START_ABILITY,
    requestCode:10,
    wantAgentFlags:[wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
  };

  wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj: WantAgent) => {
    backgroundTaskManager.startBackgroundRunning(context,
      backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK, wantAgentObj).then(() => {
      console.info(`Succeeded in operationing startBackgroundRunning.`);
      callback();
    }).catch((err:BusinessError) => {
      console.error(`Failed to operation startBackgroundRunning. Code is ${err.code}, message is ${err.message}`);
    })
  })
}

export const stopContinuousTask = (context: Context) => {
  backgroundTaskManager.stopBackgroundRunning(context).then(() => {
    console.info(`Succeeded in operationing stopBackgroundRunning.`);
  }).catch((err: BusinessError) => {
    console.error(`Failed to operation stopBackgroundRunning. Code is ${err.code}, message is ${err.message}`);
  })
}
