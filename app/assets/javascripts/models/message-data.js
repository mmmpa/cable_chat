export default class Message {
  constructor({name, message, key, user_key, x, y}) {
    this.name = name;
    this.message = message;
    this.key = key;
    this.userKey = user_key;
    this.x = x;
    this.y = y;
  }
}
