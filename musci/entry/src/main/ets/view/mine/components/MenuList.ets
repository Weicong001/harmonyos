import { router } from '@kit.ArkUI';

interface TabBarData {
  label:string,
  icon: Resource,
  router?:string
}

@Component
export struct MenuList {
  @State list:TabBarData[] = [
    {
      label:'收藏',
      icon: $r('app.media.like'),
      router:'pages/musicDetailList/MusicDetailList'
    },
    // {
    //   label:'歌单',
    //   icon: $r('app.media.like'),
    //   router:'pages/songGroups/SongGroups'
    // },
    {
      label:'动态',
      icon: $r('app.media.like'),
      router:'pages/moveCase/MoveCase'
    }
  ];
  goPage(path:string) {
    router.pushUrl({
      url: path
    })
  }

  build() {
    Flex({justifyContent:FlexAlign.SpaceBetween}) {
      ForEach(this.list, (item:TabBarData) => {
        Column() {
          Image(item.icon)
            .width(30)
          Text(item.label)
            .fontSize(18)
            .padding({top:10})
        }
        .width((100 / this.list.length) + '%')
        .alignItems(HorizontalAlign.Center)
        .onClick(() => {
          this.goPage(item.router as string)
        })
      })
    }
    .margin({top:20})
  }
}