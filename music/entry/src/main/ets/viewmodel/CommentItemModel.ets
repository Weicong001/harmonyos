import { UserModel } from './UserModel';

export class CommentItemModel {
  commentId:number = 0; // 评论ID
  commentUserId:number = 0; // 评论人
  userData:UserModel = new UserModel();
  commentText:string = ''; // 评论内容
  parentId:number = 0; // 评论父级  只有一层嵌套
  isReply:boolean = false; // 是否是回复评论
  replyUserId:number = 0; // 回复人
  replyUserData: UserModel = new UserModel();
  timestamp:number = 0; // 评论时间
  likeCount:number = 0; // 喜欢数量
  songId:number = 0;
  groupId:number = 0;

  constructor() {
    this.commentId = 0;
    this.commentUserId = 0;
    this.commentText = '';
    this.parentId = 0;
    this.isReply = false;
    this.replyUserId = 0;
    this.timestamp = 0;
    this.likeCount = 0;
  }
}