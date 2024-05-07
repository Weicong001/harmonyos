import { ResponseData } from '../common/interface/interface'
import { Request } from '../common/tools/Request'

// 发送验证码
export const sendCodeApi:(params:object) => Promise<ResponseData> = (params) => {
  return Request.post('/users/sendCode', params)
}

// 登录
export const onLoginApi:(params:object) => Promise<ResponseData> = (params) => {
  return Request.post('/users/login', params)
}


// 我的用户信息
export const GetUserInfoApi:<T>(params:T) => Promise<ResponseData> = (params) => {
  return Request.post('/users/user/info', params)
}

// 修改我的用户信息
export const modifyUserInfoApi:<T>(params:T) => Promise<ResponseData> = (params) => {
  return Request.post('/users/user/modify', params)
}

// 用户列表
export const GetUserListApi:() => Promise<ResponseData> = () => {
  return Request.get('/users/user/list')
}