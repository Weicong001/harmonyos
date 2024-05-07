import { Header } from '../../components/header/Header'
import { CommentList } from './components/CommentList'
import { CommentSongInfo } from './components/CommentSongInfo'
import router from '@ohos.router'
import { CommentType, SortType } from '../../common/interface/interface'
import { CommentItemModel } from '../../viewmodel/CommentItemModel'
import { CommentData } from '../../viewmodel/CommentData'

interface ParamsData {
  songId:number,
  type:CommentType
}

@Entry
@Component
struct MusicComment {
  // 评论页面
  @State songId:number = (router.getParams() as ParamsData).songId;
  @State type:CommentType = (router.getParams() as ParamsData).type;
  @StorageLink('userId') userId:number = 0;

  // @StorageLink('userId') userId:number = 108038244;
  // @State songId:number = 2;
  // @State type:CommentType = CommentType.SONG;

  @Provide commentData:CommentData = new CommentData(); // 评论数据模型

  aboutToAppear(): void {
    this.init();
  }

  init() {
    this.commentData.setUserId(this.userId);
    this.commentData.setSongId(this.songId);
    this.commentData.setType(this.type);
    this.commentData.setSortType(SortType.DROP);
    this.commentData.getCurrentSongData();
    this.commentData.getList();
  }

  // commentUserId: this.userId,
  // commentText: this.commentText,
  // parentId: this.parentId,
  // songId: this.songId,
  // isReply: this.isReply,
  // replyUserId: this.replyUserId

  // 提交评论
  async submit() {
    let flag = await this.commentData.addComment();
    this.commentData.setCommentText('');
    this.commentData.setParentId(0);
    this.commentData.setReplyUserId(0);
    this.commentData.setIsReply(false);
  }

  build() {
    Column() {
      Header({label:'评论'}) {
        // Text(`歌曲id：${this.commentData.songId}-- 类型：${this.commentData.type} -- 评论数量 ${this.commentData.list.length}`)
        CommentSongInfo()
        CommentList({submit: this.submit})
          .padding({bottom:100})
      }
    }
    .width('100%')
    .height('100%')
  }
}