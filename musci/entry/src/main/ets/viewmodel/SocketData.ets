import { SocketItemModel } from './SocketItemModel'


@Observed
export class SocketData {
  list: ObservedArray<SocketItemModel> = []


  add(data:SocketItemModel) {
    let list = this.list;
    list.push(new SocketItemModel(data.user, data.message));
    this.list = [...list];
  }

  clear() {
    this.list = [];
  }

}



@Observed
export class ObservedArray<T> extends Array<T> {
  constructor(args: T[]) {
    console.log(`ObservedArray: ${JSON.stringify(args)} `)
    if (args instanceof Array) {
      super(...args);
    } else {
      super(args)
    }
  }
}
