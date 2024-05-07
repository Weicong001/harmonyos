import { MyUserInfoParams } from '../common/interface/interface';
import { GetUserInfoApi } from '../services/users';
import { UserModel } from './UserModel'

export class MyUserData {
  user: UserModel = new UserModel();

  setUser(user:UserModel) {
    this.user = user;
  }

  // 获取用户信息详情
  async getUserDetail(userId:number) {
    let params:MyUserInfoParams = {
      userId: userId
    }
    let res = await GetUserInfoApi(params);
    if (res.Code == 200) {
      let data = res.Data as UserModel;
      this.user = data;
    }
  }

}