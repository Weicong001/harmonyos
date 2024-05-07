


@Observed
export class TipControl {
  label:string = '';
  show:boolean = false;
  type:string = '';

  constructor() {
    this.label = '';
    this.show = false;
    this.type = 'success';
  }

  fail(label:string):Promise<boolean> {
    return new Promise((resolve) => {
      this.label = label;
      this.show = true
      this.type = 'fail';
      let promise:Promise<boolean> = new Promise((resolve) => {
        setTimeout(() => {
          this.clear();
          resolve(true)
        }, 1000)
      })
    })
  }
  success(label:string) {
    this.label = label;
    this.show = true;
    this.type = 'success';
    let promise:Promise<boolean> = new Promise((resolve) => {
      setTimeout(() => {
        this.clear();
        resolve(true)
      }, 1000)
    })
  }

  clear() {
    this.show = false;
    this.type = '';
    this.label = '';
  }
}