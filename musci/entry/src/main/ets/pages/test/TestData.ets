import { Request } from '../../common/tools/Request';

@Observed
class ItemGoods {
  name:string // 商品名称
  price:number // 商品价格

  constructor(name:string, price:number) {
    this.name = name;
    this.price = price;
  }

  updateName(name:string) {
    this.name = name;
  }
}

@Observed
export class ObservedArray<T> extends Array<T> {
  constructor(args: T[]) {
    if (args instanceof Array) {
      super(...args);
    } else {
      super(args)
    }
  }
}



@Entry
@Component
struct TestData {
  @State list:ObservedArray<ItemGoods> = [];

  aboutToAppear(): void {
    this.getGoodsData();
  }
  async getGoodsData() {
    let res = await Request.get('/good/list');
    if (res.Code == 200) {
      this.list = res.Data as ObservedArray<ItemGoods>;
    }
  }

  build() {
    Column() {
      ForEach(this.list, (item:ItemGoods) => {
        // Child({item: item})
        Child({item: new ItemGoods(item.name, item.price)})
      })
    }
  }
}

@Component
struct Child {
  @ObjectLink item:ItemGoods

  build() {
    Column() {
      Text('子数据')
      Button('子修改单个数据')
        .onClick(() => {
          this.item.updateName('888')
        })
      Column() {
        Text(`商品名称：${this.item.name}--商品价格：${this.item.price}`)
      }
    }
  }
}