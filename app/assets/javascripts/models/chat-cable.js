import Member from '../models/member-data'
import Message from '../models/message-data'

export default class ChatCable {
  constructor({connected, disconnected, messageReceived, memberReceived, meReceived}) {
    // デバッグログは見れる
    window.ActionCable.startDebugging();

    // 基本となるConnection
    // this.cable = window.ActionCable.createConsumer();

    // Channel
    this.sessionChannel = null;
    this.messageChannel = null;
    this.memberChannel = null;

    // Reactへのcallback
    this.connected = connected;
    this.disconnected = disconnected;
    this.messageReceived = messageReceived;
    this.memberReceived = memberReceived;
    this.meReceived = meReceived;
  }

  connect() {
    this.cable = window.ActionCable.createConsumer();
    this.cable.subscriptions.create('SessionChannel', this.sessionChannelCallback);
  }

  disconnect() {
    this.sessionChannel && this.sessionChannel.perform('exit');
  }

  sendMessage(message, x, y) {
    this.messageChannel && this.messageChannel.send({message, x, y})
  }

  get sessionChannelCallback() {
    let that = this;
    return {
      connected: function () {
        that.sessionChannel = this;
      },
      received: function (data) {
        if (data.me) {
          that.meReceived(new Member(data.me));
          that.cable.subscriptions.create('MessageChannel', that.messageChannelCallback);
          that.cable.subscriptions.create('MemberChannel', that.memberChannelCallback);

          that.connected();
        } else if (data.exit) {
          this.clear();
        }
      },
      disconnected: function () {
        this.clear();
      },
      rejected: function () {
        this.clear();
      },
      clear: function () {
        this.unsubscribe();
        that.messageChannel && that.messageChannel.unsubscribe();
        that.memberChannel && that.memberChannel.unsubscribe();
        this.consumer.disconnect();

        that.disconnected();
      }
    }
  }

  get messageChannelCallback() {
    let that = this;
    return {
      connected: function () {
        console.log('messageChannelCallback connected');
        that.messageChannel = this;
      },
      received: function (data) {
        that.messageReceived(new Message(data.message));
      },
      disconnected: function () {
        this.clear();
      },
      rejected: function () {
        this.clear();
      },
      clear: function () {
        that.messageChannel = null;
        this.unsubscribe();
      }
    }
  }

  get memberChannelCallback() {
    let that = this;
    return {
      connected: function () {
        console.log('memberChannelCallback connected');
        that.memberChannel = this;
        this.perform('hello');
      },
      received: function (data) {
        console.log(data)
        that.memberReceived(data.members.map((member) => new Member(member)));
      },
      disconnected: function () {
        this.clear();
      },
      rejected: function () {
        this.clear();
      },
      clear: function () {
        that.memberChannel = null;
        this.unsubscribe();
      }
    };
  }
}