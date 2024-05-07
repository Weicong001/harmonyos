import { common, UIAbility } from '@kit.AbilityKit';

export class PublicMethod {

  public static timestampToDate(timestamp:number):string {
    let date = new Date(timestamp);
    let year = date.getFullYear();
    let month = (date.getMonth() + 1) > 10 ? (date.getMonth() + 1) : '0' + (date.getMonth() + 1);
    let day = date.getDate() > 10 ? date.getDate() : '0' + date.getDate();

    let hour = date.getHours() > 10 ? date.getHours() : '0' + date.getHours();
    let minute = date.getMinutes() > 10 ? date.getMinutes() : '0' + date.getMinutes();
    let second = date.getSeconds() > 10 ? date.getSeconds() : '0' + date.getSeconds();
    return `${year}-${month}-${day} ${hour}:${minute}:${second}`;
  }

  public static getTimeStamp():number {
    return Date.now();
  }
}