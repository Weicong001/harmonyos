
import http from '@ohos.net.http';
import { server } from '../../config/config';
import { headerParams, ResponseData } from '../interface/interface';

// const baseUrl:string = 'http://192.168.0.112:3000';
const baseUrl:string = server;



export class Request {

  public static get(url:string, params?:object):Promise<ResponseData> {
    let str = '';
    let keys:string[] = params ? Object.keys(params) : [];
    let values:string[] = params ? Object.values(params) : [];
    if (keys.length) {
      str = '?';
    }
    keys.forEach((item, index) => {
      str += keys[index] + '=' + values[index] + (index == ((keys.length as number) - 1) ? '' : '&&');
    });
    console.log('get请求数据' + str)
    let httpRequest = http.createHttp();
    return new Promise((resolve) => {
      httpRequest.request(baseUrl + url + str, {
        method: http.RequestMethod.GET,
        header:{
          'content-type':'application/json'
        },
        // extraData:params,
        expectDataType:http.HttpDataType.OBJECT
      }, (err: Error, data: http.HttpResponse) => {
        if (!err) {
          resolve(data.result as ResponseData);
          console.info('Result:' + JSON.stringify(data.result));
          httpRequest.destroy();
        } else {
          console.info('error:' + JSON.stringify(err));
        }
      })
    })
  }

  public static  post<T>(url:string, params?:T, header?:headerParams):Promise<ResponseData> {
    let httpRequest = http.createHttp();
    let head:headerParams = {
      'content-type':'application/json'
    }
    let headers = header ? header : head
    return new Promise((resolve) => {
      httpRequest.request(baseUrl + url, {
        method: http.RequestMethod.POST,
        header:headers,
        extraData:params,
        expectDataType:http.HttpDataType.OBJECT,
      }, (err: Error, data: http.HttpResponse) => {
        if (!err) {
          resolve(data.result as ResponseData);
          console.info('--page Result:' + JSON.stringify(data.result));
          httpRequest.destroy();
        } else {
          console.info('--page error:' + JSON.stringify(err));
        }
      })
    })
  }

  public static  uploadFile(url:string, data:string):Promise<ResponseData> {
    let httpRequest = http.createHttp();
    return new Promise((resolve) => {
      httpRequest.request(baseUrl + url, {
        method: http.RequestMethod.POST,
        header:{
          "content-type": "multipart/form-data"
        },
        multiFormDataList:[
          {
            name:'image',
            contentType:'image/png',
            remoteFileName:'image',
            data
          }
        ]
      }, (err: Error, data: http.HttpResponse) => {
        if (!err) {
          resolve(data.result as ResponseData);
          console.info('--page Result:' + JSON.stringify(data.result));
          httpRequest.destroy();
        } else {
          console.info('--page error:' + JSON.stringify(err));
        }
      })
    })
  }


}