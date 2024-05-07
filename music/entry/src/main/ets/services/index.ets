import { headerParams, ResponseData } from '../common/interface/interface'
import { Request } from '../common/tools/Request'

// 获取歌曲
export const GetSongListApi:() => Promise<ResponseData> = () => {
  return Request.get('/song/list')
}
// 歌曲详情
export const GetSongDetailApi:(params:object) => Promise<ResponseData> = (params) => {
  return Request.get('/song/detail', params)
}


// 歌单详情
export const GetSongGroupApi:(params:object) => Promise<ResponseData> = (params) => {
  return Request.get('/song/group', params)
}

// 改变歌曲喜欢状态
export const SetSongLikeApi:(params:object) => Promise<ResponseData> = (params) => {
  return Request.post('/song/like', params)
}


// 评论列表
export const GetCommentListApi:(params:object) => Promise<ResponseData> = (params) => {
  return Request.get('/comment/list', params)
}

// 添加评论
export const AddCommentApi:(params:object) => Promise<ResponseData> = (params) => {
  return Request.post('/comment/add', params)
}


// 上传图片
export const uploadApi:(params:string) => Promise<ResponseData> = (params) => {
  return Request.uploadFile('/upload', params)
}
// 获取图片链接
export const getUploadApi = () => {
  return Request.get('/getUpload')
}

// 添加动态
export const AddMoveCase:<T>(params:T) => Promise<ResponseData> = (params) => {
  return Request.post('/moveCase/add', params)
}
// 动态列表
export const getMoveCaseListApi = () => {
  return Request.get('/moveCase/list')
}



