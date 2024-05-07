import { ResponseData } from '../../common/interface/interface';
import { onLoginApi, sendCodeApi } from '../../services/users';
import promptAction from '@ohos.promptAction';
import { UIContext } from '@ohos.arkui.UIContext';
import window from '@ohos.window';
import { Tip } from '../../components/tip/Tip';
import { TipControl } from '../../components/tip/TipControl';
import { router } from '@kit.ArkUI';

interface SendCodeData {
  email:string
}

interface LoginParams {
  email:string,
  code:string
}

interface LoginResponse {
  userId:Number
}


@Entry
@Component
struct Login {
  @StorageLink('userId') userId:number = 0;
  @State tipControl:TipControl = new TipControl();
  @State step: number = 0;
  @State email: string = '';
  @State code: string = '';
  @State second: number = 60;
  timer:number = 0;

  aboutToAppear(): void {
    if (AppStorage.get('userId') !=0 ) {
      router.replaceUrl({
        url:'pages/Index'
      })
    }
  }

  goCode() {
    if (this.email) {
      this.step = 1;
    } else {
      this.tipControl.fail('请填写邮箱');
    }
  }

  // 发送邮箱
  async sendCode() {

    if (this.second < 60) return;

    this.timer = setInterval(() => {
      if (this.second == 0) {
        this.second = 60;
        clearInterval(this.timer);
      }
      this.second -= 1;
    }, 1000);

    let params:SendCodeData = {
      email: this.email
    };
    let res:ResponseData = await sendCodeApi(params)
    if (res.Code == 200) {
      promptAction.showToast({
        message:'发送验证码成功'
      })
      console.log('发送验证码成功')
    } else {
      promptAction.showToast({
        message:'发送验证码失败'
      })
      console.log('发送验证码失败')
    }
  }

  async onLogin() {
    let params:LoginParams = {
      email:this.email,
      code: this.code
    }
    let res = await onLoginApi(params);
    console.log(JSON.stringify(res))
    if (res.Code == 200) {
      // this.tipControl.fail('登录成功');
      promptAction.showToast({
        message:'登录成功'
      })
      this.userId = (res.Data as LoginResponse).userId as number;

      router.replaceUrl({
        url:'pages/Index'
      })

    } else {
      promptAction.showToast({
        message:'登录失败'
      })
      // this.tipControl.fail('登录失败');
    }
  }

  build() {
    Column() {
      Tip({control: this.tipControl}) {
        Text() {
          Span(this.step == 0 ? '请输入邮箱' : '请输入验证码')
        }
        .fontSize(22)
        .fontWeight(600)
        .lineHeight(70)
        .width('100%')

        if (this.step == 0) {
          TextInput({
            text: this.email,
            placeholder:'请输入邮箱'
          })
            .height(60)
            .fontSize(22)
            .backgroundColor('#ededed')
            .borderRadius(0)
            .border({
              width:{
                bottom:1
              },
              color:'#999'
            })
            .margin({top:20})
            .onChange((value:string) => {
              this.email = value;
            })
        } else {
          Flex({alignItems:ItemAlign.Center}) {
            TextInput({
              text:this.code,
              placeholder:'请输入验证码'
            })
              .height(60)
              .fontSize(22)
              .backgroundColor('#ededed')
              .borderRadius(0)
              .onChange((value:string) => {
                this.code = value;
              })
              .layoutWeight(1)
            Text('|')
              .fontColor('#999')
            Button(this.second == 60 ? '发送验证码' : (this.second + ''))
              .backgroundColor('#ededed')
              .fontColor($r('app.color.primary_color'))
              .width(130)
              .height(60)
              .fontSize(16)
              .borderRadius(0)
              .onClick(() => {
                this.sendCode();
              })
          }
          .border({
            width:{
              bottom:1
            },
            color:'#999'
          })
          .margin({top:20})
        }
        Button(this.step == 0 ? '下一步' : '登录')
          .width('100%')
          .height(40)
          .margin({top:20})
          .backgroundColor($r('app.color.primary_color'))
          .onClick(() => {
            if (this.step == 0) {
              this.goCode()
            } else {
              this.onLogin()
            }
          })
      }
    }
    .width('100%')
    .height('100%')
    .padding({
      left:10,
      right:10
    })
    .backgroundColor('#ededed')
  }
}