import { MyUserInfoParams } from '../common/interface/interface';
import { GetUserInfoApi } from '../services/users';

@Observed
export class UserModel {
  nickname: string = '';
  userId: number = 0
  picUrl: string = ''
  email: string = ''
  isFirst: boolean = false;
  sex:number = 0;
  phone:number = 0;
}