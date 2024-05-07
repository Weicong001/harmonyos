

@Observed
export class PreviewData {
  controller:SwiperController = new SwiperController();

  list:string[] = [];

  visible:boolean = false;

  index:number = 0

  show(list:string[], index:number = 0) {
    this.list = list;
    this.index = index;
    this.visible = true;
  }

  hide() {
    this.visible = false;
    this.list = [];
    this.index = 0;
  }

}