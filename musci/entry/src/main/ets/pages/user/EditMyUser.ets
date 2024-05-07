import { Header } from '../../components/header/Header';
import { MyUserData } from '../../viewmodel/MyUserData';
import { picker } from '@kit.CoreFileKit';
import fs from '@ohos.file.fs';
import { buffer } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { PickPhoto } from '../../common/tools/PickPhoto';
import { getUploadApi } from '../../services';
import { UpdateMyInfoParams } from '../../common/interface/interface';
import { UserModel } from '../../viewmodel/UserModel';
import { modifyUserInfoApi } from '../../services/users';
import { router } from '@kit.ArkUI';

@Observed
class ItemData {
  label:string = ''
  value:string|number = ''
  type?:string = ''

  constructor(label:string, value:string|number, type?:string) {
    this.label = label;
    this.value = value;
    this.type = type || 'text';
  }

  updateValue(value:string|number) {
    this.value = value
  }
}

@Entry
@Component
struct EditMyUser {
  @StorageLink('userId') userId:number = 0;
  @State myUserData:MyUserData = new MyUserData(); // 数据

  @State list:ItemData[] = []

  async aboutToAppear(): Promise<void> {
    await this.myUserData.getUserDetail(this.userId);
    this.list = [
      new ItemData('头像', this.myUserData.user.picUrl, 'pic'),
      new ItemData('昵称', this.myUserData.user.nickname),
      new ItemData('性别', this.myUserData.user.sex, 'radio'),
      new ItemData('手机号', this.myUserData.user.phone),
    ]
  }

  // 修改个人信息
  async submit() {
    let params:UpdateMyInfoParams = {
      userId:this.userId,
      picUrl:(this.list[0].value as string) ?? '' ,
      nickname:(this.list[1].value as string) ?? '',
      sex:Number(this.list[2].value) ?? 0,
      phone:Number(this.list[3].value) ?? 0
    };
    let res = await modifyUserInfoApi(params);
    if (res.Code == 200) {
      router.back();
    }
  }


  build() {
    Column() {
      Header({label:'个人资料'}) {
        Column() {
          ForEach(this.list, (item:ItemData) => {
            ItemComponent({item: item})
          })
        }
        Button('提交')
          .onClick(() => {
            this.submit()
          })
      }
    }
  }
}

@Component
struct ItemComponent {
  pickPhoto:PickPhoto = new PickPhoto();
  @ObjectLink item: ItemData

  editDialogController: CustomDialogController = new CustomDialogController({
    builder: EditInfoDialog({type: this!.item.type, label:this!.item.label,value:this!.item.value,  submit:(value:string | number) => {this.submit(value)}}),
    alignment:DialogAlignment.Center,
  });

  aboutToAppear(): void {

  }

  // 弹窗的提交
  submit(value:string | number) {
    this.item.updateValue(value);
    this.editDialogController.close()
  }

  async click() {
    if (this.item.type == 'pic') {
      let paths = await this.pickPhoto.pickImage();
      let url = await this.pickPhoto.getFileUrl(paths[0]);
      let res = await getUploadApi();
      console.log(JSON.stringify(res))
      this.item.updateValue(res.Data as string);
      // console.log('上传图片路径', JSON.stringify(res.Data));
      // if (res.Code == 200) {
      //
      // }
      return;
    }
    this.editDialogController.open()
  }

  build() {
    Flex({justifyContent:FlexAlign.SpaceBetween, alignItems:ItemAlign.Center}) {
      Text(this.item.label)
      Row() {
        if (this.item.type == 'text') {
          Text(this.item.value ? `${this.item.value}` : '')
        } else if (this.item.type == 'pic') {
          Image(`${this.item.value}`)
            .width(50)
            .height(50)
        } else if (this.item.type == 'radio') {
          Text(this.item.value ? `${this.item.value == 1 ? '男' : (this.item.value == 2 ? '女' : '保密')}` : '保密')
        }
        Text('>')
          .fontSize(20)
          .padding({left:10, right:10})
      }
    }
    .height(60)
    .padding({left:20, right:20})
    .onClick(() => {
      this.click()
    })
  }
}


@CustomDialog
struct EditInfoDialog {
  control: CustomDialogController
  type:string = 'text'
  label:string = ''
  @Prop value:string | number = 0
  submit:(value:string | number) => void = () => {}

  @State text:string|number = this.value;

  aboutToAppear(): void {
    this.text = this.value;
  }

  build() {
    Column() {
      Text('修改' + this.label)
        .fontSize(18)
        .padding({top:30, bottom:30})
      if (this.type == 'text') {
        TextInput({
          text: `${this.value}`
        }).onChange((value:string) => {
          this.text = value;
        })
      } else if (this.type == 'radio') {
        Row() {
          Row() {
            Text('男')
            Radio({value:'1', group:'sex'}).checked(this.text == 1)
              .height(25)
              .width(25)
              .onChange((isChecked:boolean) => {
                if (isChecked) {
                  this.text = 1;
                }
              })
          }
          Row() {
            Text('女')
            Radio({value:'2', group:'sex'}).checked(this.text == 2)
              .height(25)
              .width(25)
              .onChange((isChecked:boolean) => {
                if (isChecked) {
                  this.text = 2;
                }
              })
          }
          Row() {
            Text('保密')
            Radio({value:'0', group:'sex'}).checked(this.text == 0)
              .height(25)
              .width(25)
              .onChange((isChecked:boolean) => {
                if (isChecked) {
                  this.text = 0;
                }
              })
          }
        }
      }
      Button('确定')
        .onClick(() => {
          this.submit(this.text);
          this.text = '';
        })
    }
    .width('100%')
    .height('50%')
  }

}