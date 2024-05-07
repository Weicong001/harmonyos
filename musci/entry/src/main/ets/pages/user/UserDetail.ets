import { MyUserInfoParams } from '../../common/interface/interface';
import { Header } from '../../components/header/Header';
import { GetUserInfoApi } from '../../services/users';
import { MyUserData } from '../../viewmodel/MyUserData';
import { UserModel } from '../../viewmodel/UserModel';
import { MyUserInfo } from './components/MyUserInfo'
import { router } from '@kit.ArkUI';

interface ParamsData {
  userId:number
}

@Entry
@Component
struct UserDetail {
  @StorageLink('userId') myUserId:number = 0;
  @State userId:number = (router.getParams() as ParamsData).userId;
  @State myUserData:MyUserData = new MyUserData(); // 数据

  onPageShow(): void {
    this.myUserData.getUserDetail(this.userId)
  }


  build() {
    Column() {
      Header({label:'个人信息'}) {
        MyUserInfo({
          user: this.myUserData.user,
          myUserId: this.myUserId
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ededed')
  }

  pageTransition() {
    PageTransitionEnter({ duration: 1000 })
      .opacity(1)
    PageTransitionExit({ duration: 1200 })
      .opacity(0)
  }

}