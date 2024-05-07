import { UserModel } from './UserModel'

@Observed
export class SocketItemModel {
  user:UserModel = new UserModel()
  message:string = ''

  constructor(user:UserModel, message:string) {
    this.user = user;
    this.message = message;
  }

}