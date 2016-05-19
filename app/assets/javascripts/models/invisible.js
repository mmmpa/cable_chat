export default class Invisible {
  constructor(store) {
    this.store = {};
    store && console.log(store.store)
    if(store){
      for (let k in store.store) {
        this.store[k] = store[k];
      }
    }
  }


  has(key) {
    return !!this.store[key];
  }

  add(key) {
    this.store[key] = true;
  }

  del(key) {
    this.store[key] = null;
  }
}