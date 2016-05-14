import Member from '../models/member-data'
import Message from '../models/message-data'

export default class ChatCable {
  constructor({connected, disconnected, messageReceived, memberReceived, meReceived}) {
    this.cable = window.ActionCable.createConsumer();
    this.connected = connected;
    this.disconnected = disconnected;
    this.messageReceived = messageReceived;
    this.memberReceived = memberReceived;
    this.meReceived = meReceived;

    this.chatChannel = null;
    this.memberChannel = null;
  }

  connect() {
    this.cable.subscriptions.create('ChatChannel', this.chatChannelCallback);
  }

  disconnect(){
    this.chatChannel && this.chatChannel.perform('exit');
  }

  sendMessage(message, x, y) {
    this.chatChannel && this.chatChannel.send({message, x, y})
  }

  get chatChannelCallback() {
    let that = this;
    return {
      connected: function () {
        console.log('connected');
        that.chatChannel = this;
      },
      received: function (data) {
        if(data.me){
          that.meReceived(new Member(data.me));
          that.cable.subscriptions.create('MemberChannel', that.memberChannelCallback);
          return;
        }
        that.messageReceived(new Message(data.message));
      },
      disconnected: function () {
        console.log('disconnected');
        this.clear();
      },
      rejected: function () {
        console.log('rejected');
        this.clear();
      },
      clear: function () {
        that.disconnected();
        that.memberChannel && that.memberChannel.unsubscribe();
        this.unsubscribe();
        this.consumer.disconnect();

        that.chatChannel = null;
        that.memberChannel = null;
      }
    }
  }
  
  get memberChannelCallback() {
    let that = this;
    return {
      connected: function () {
        console.log('member connected');
        that.memberChannel = this;
        that.connected();
      },
      received: function (data) {
        console.log('member received');
        that.memberReceived(data.members.map((member) => new Member(member)));
      }
    };
  }
}