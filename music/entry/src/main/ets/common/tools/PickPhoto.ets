import { picker } from '@kit.CoreFileKit';
import fs from '@ohos.file.fs';
import request from '@ohos.request';
import { BusinessError } from '@kit.BasicServicesKit';
import { buffer, util } from '@kit.ArkTS';
import { uploadApi } from '../../services';
import { headerParams, ResponseData } from '../interface/interface';
import { common } from '@kit.AbilityKit';
import { PublicMethod } from './PublicMethod';
import { server } from '../../config/config';

interface UploadResponseData {
  headers:object,
  body: string
}

export class PickPhoto {


  public async pickImage():Promise<string[]> {
    let photoPicker = new picker.PhotoViewPicker();
    return new Promise((resolve) => {
      photoPicker.select({}).then((photoSelectResult: picker.PhotoSelectResult) => {
      console.log(JSON.stringify(photoSelectResult))
      let filePaths = photoSelectResult.photoUris; // 有多个
        resolve(filePaths)
      })
    })
  }

  public async getFileUrl(filePath:string):Promise<string> {
    console.log('获取路径')
    let context = getContext(this) as common.UIAbilityContext;
    let cacheDir = context.cacheDir; // 缓存路径
    let file = fs.openSync (filePath, fs.OpenMode.READ_ONLY);
    let type = 'jpg'
    let filename = PublicMethod.getTimeStamp() + '.' + type;
    fs.copyFileSync(file.fd, cacheDir + `/${filename}`);
    console.log('上传')
    let uploadConfig: request.UploadConfig = {
      url: server + '/upload', //需要手动替换为真实服务器地址
      header: {
        'content-type': 'multipart/form-data'
      },
      method: "POST",
      files: [{
        filename:filename,
        name: 'image',
        uri: 'internal://cache/' + filename,
        type: type
      }],
      data: [],
    };
    return new Promise(async (resolve) => {
      console.log('准备')
      let uploadTask:request.UploadTask = await request.uploadFile(context, uploadConfig);
      console.log('上传完成')
      uploadTask.on('headerReceive', (header: object) => {
        console.log('收到信息')
        let res = header as UploadResponseData;
        let data:ResponseData = JSON.parse(res.body as string) as ResponseData;
        console.log('返回信息', JSON.stringify(data))
        console.log('返回信息', JSON.stringify(data.Data))
        resolve(data.Data as string);
      })
    })
  }

  // public async getBase64Url(filePath:string) {
  //   try {
  //     console.log('获取链接')
  //     // 打开文件，拿到对应数据
  //     let file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
  //     let info = fs.statSync(file.fd);
  //
  //
  //     let buff = new ArrayBuffer(info.size);
  //
  //     fs.readSync(file.fd, buff);
  //
  //     let base64 = new util.Base64Helper();
  //     const str = base64.encodeToStringSync(new Uint8Array(buff))
  //
  //     console.log('字符串', str)
  //
  //     fs.closeSync(file);
  //   } catch(err) {
  //     console.log('报错', JSON.stringify(err))
  //   }
  // }
}