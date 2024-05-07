import { CommentAddParams, CommentListParams, CommentType,
  SongDetailParams,
  SortType } from '../common/interface/interface';
import { AddCommentApi, GetCommentListApi, GetSongDetailApi } from '../services';
import { GetUserListApi } from '../services/users';
import { CommentItemModel } from './CommentItemModel'
import { SongItemModel } from './SongItemModel';
import { UserModel } from './UserModel';

// 评论数据
export class CommentData {
  list: CommentItemModel[] = [];
  songData: SongItemModel = new SongItemModel();
  userList: UserModel[] = [];

  commentText:string = '';
  parentId:number = 0;
  userId:number = 0;
  replyUserId:number = 0;
  songId:number = 0;
  type:CommentType = CommentType.SONG;
  sortType:SortType = SortType.DROP;
  isReply:boolean = false;

  // 评论列表
  async getList() {
    let params: CommentListParams = {
      songId: this.songId,
      type: this.type,
      sortType: this.sortType
    }
    let res = await GetCommentListApi(params);
    if (res.Code == 200) {
      this.list = res.Data as CommentItemModel[];
    }

  }

  // 添加评论
  async addComment():Promise<boolean> {
    return new Promise(async(resolve) => {
      let params:CommentAddParams = {
        commentUserId: this.userId,
        commentText: this.commentText,
        parentId: this.parentId,
        songId: this.songId,
        isReply: this.isReply,
        replyUserId: this.replyUserId
      };
      let res = await AddCommentApi(params);
      if (res.Code == 200) {
        this.getList();
        resolve(true)
      }
    })
  }

  // 获取当前歌曲信息
  async getCurrentSongData() {
    await this.getUserList();
    let params:SongDetailParams = {
      id: this.songId
    };
    let res = await GetSongDetailApi(params);
    if (res.Code == 200) {
      let songData = res.Data[0] as SongItemModel;
      let singer = songData.singer as number[];
      let users:UserModel[] = []
      singer.forEach((u:number, index:number) => {
        let user = this.userList.filter(item => item.userId == u) as UserModel[];
        users[index] = user[0];
      });
      songData.singer = users;
      this.songData = songData;
    }
  }


  async getUserList() {
   let res = await GetUserListApi();
    if (res.Code == 200) {
      this.userList = res.Data as UserModel[];
      console.log('用户列表', JSON.stringify(this.userList))
    }
  }

  setReplyUserId(Id:number) {
    this.replyUserId = Id;
  }
  setIsReply(flag:boolean) {
    this.isReply = flag;
  }
  setParentId(parentId:number) {
    this.parentId = parentId;
  }
  setCommentText(text:string) {
    this.commentText = text;
  }
  setUserId(Id:number) {
    this.userId = Id;
  }
  setSongId(Id:number) {
    this.songId = Id
  }
  setType(type:CommentType) {
    this.type = type;
  }

  setSortType(sortType:SortType) {
    this.sortType = sortType;
  }



}