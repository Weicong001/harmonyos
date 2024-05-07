import { CommentData } from '../../../viewmodel/CommentData';

@Component
export struct CommentInput {

  @State text:string = '';
  @Consume commentData: CommentData

  submit:() => void = () => {}

  build() {
    Flex({alignItems:ItemAlign.Center}) {
      TextInput({text: this.text})
        .onChange((value:string) => {
          this.text = value;
        })
      Button('发送')
        .onClick(() => {
          this.commentData.setCommentText(this.text)
          this.submit()
          this.text = '';
        })
    }
    .width('100%')
    .height(90)
    .backgroundColor('#ededed')
    .padding({left:20, right:20})
  }
}