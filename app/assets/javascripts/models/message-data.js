import {lifespan, offspan} from '../constants/lifespan';

export default class Message {
  constructor({name, message, key, user_key, x, y}) {
    this.name = name;
    this.message = message;
    this.key = key;
    this.userKey = user_key;
    this.x = x;
    this.y = y;
    this.createdAt = this.now;
    this.isKilled = false;
    this.diedAt = 0;
  }

  die() {
    if(!this.isDying || this.isKilled){
      return;
    }

    this.isKilled = true;
    this.diedAt = this.now;
  }

  get now(){
    return new Date().getTime();
  }
  
  get isDying() {
    return this.now - this.createdAt > lifespan;
  }

  get isDead(){
    return this.isKilled && this.now - this.diedAt > offspan;
  }
}
