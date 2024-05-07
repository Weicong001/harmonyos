import { SongItemModel } from '../../viewmodel/SongItemModel'
import { UserModel } from '../../viewmodel/UserModel'

export interface ResponseData {
  Code:number,
  Message:string,
  Data:object | Array<string | object> | string
}

export interface SocketParams {
  type:string
  value:string | SocketChatParams
}

export interface SocketChatParams {
  songId:number
  user:UserModel
  message:string
}
export interface headerParams {
  'content-type':string
}

export interface MyUserInfoParams {
  userId:number
}
// 修改个人信息参数
export interface UpdateMyInfoParams {
  userId:number,
  picUrl:string,
  nickname:string,
  sex:number,
  phone:number,
}

export interface SongListResponse {
  songs:SongItemModel[],
  users:UserModel[]
}

export interface GroupDetailParams {
  groupId:number,
  userId:number
}

export interface GroupLikeParams {
  flag:boolean,
  songId:number,
  userId:number
}

export interface SongData {
  songId:number,
  songName:string,
  songUrl:string,
  picUrl:string,
  singer:UserModel[] | number[],
  groupIds:number[],
  test:string
}

export interface SongDetailParams {
  id: number
}
// 播放类型
export enum PlayType {
  SINGLE, // 单曲循环
  LIST, // 列表播放
}

/**
 * 长时播放音乐信息
 */
export interface SessionMusicInfo {
  currentIndex: number,
  songList: SongItemModel[],
  isPlaying:boolean,
  totalTime:number,
  currentTime:number,
}

/**
 * 评论
 */

export enum CommentType {
  SONG, // 歌曲
  SHEET, // 歌单
}

// 排序类型
export enum SortType {
  RISE = 1,
  DROP = -1
}

export interface CommentListParams {
  songId?:number,
  groupId?:number,
  type: CommentType,
  sortType:number
}
// 添加评论参数
export interface CommentAddParams {
  commentUserId:number,
  commentText:string,
  parentId:number,
  songId?:number,
  groupId?:number,
  isReply:boolean,
  replyUserId:number
}


// 添加动态参数
export interface MoveCaseAddParams {
  userId:number,
  content:string,
  songId?:number
  imgs?:string[]
}

interface InspectSizeParams {
  width:string,
  height:string
}

export interface InspectParams {
  size:InspectSizeParams
}

