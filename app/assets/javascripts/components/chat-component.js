import * as React from 'react';
import token from 'token'
const request = require('superagent');

const State = {
  Connected: 'Connected',
  Checking: 'Checking',
  Trying: 'Trying',
  Waiting: 'Waiting',
  WaitingRetry: 'WaitingRetry',
};

export default class ChatComponent extends React.Component {
  componentWillMount() {
    this.setState({
      cable: window.ActionCable.createConsumer(),
      state: State.Checking,
      channel: null,
      messages: [],
      members: []
    }, () => this.connect());
  }

  knock(name) {
    this.setState({state: State.Trying});
    request
      .post('/sessions')
      .set('X-CSRF-Token', token())
      .send({session: {name}})
      .end((err, res)=> {
        if (err) {
          this.setState({state: State.WaitingRetry});
        } else {
          this.setState({state: State.Trying}, () => {
            this.connect();
          });
        }
      });
  }

  connect() {
    this.state.cable.subscriptions.create('ChatChannel', this.chatChannelCallback);
  }

  get chatChannelCallback() {
    let that = this;
    return {
      connected: function () {
        console.log('connected');
        that.setState({
          chatChannel: this,
          state: State.Connected
        });
      },
      received: function (data) {
        that.receive(data);
      },
      disconnected: function () {
        console.log('disconnected');
        this.clear();
      },
      rejected: function () {
        console.log('rejected');
        this.clear();
      },
      clear(){
        that.setState({chatChannel:null, messages: [], state: State.Waiting});
        this.unsubscribe();
        this.consumer.disconnect();
      }
    }
  }

  get forRoomIn() {
    return {
      state: this.state,
      knock: (name) => this.knock(name)
    }
  }

  get forRoom() {
    return {
      sendMessage: (message) => this.sendMessage(message),
      messages: this.state.messages,
      members: this.state.members
    }
  }

  sendMessage(message) {
    this.state.chatChannel.send({message});
  }

  receive(raw){
    console.log(raw)
    switch(true){
      case !!raw.message:
        return this.appendMessage(raw.message);
      case !!raw.members:
        return this.reloadMembers(raw.members);
      default:
        return;
    }
  }

  reloadMembers(members){
    this.setState({members: members.map((member) => new MemberData(member))});
  }

  appendMessage(message) {
    this.setState({messages: this.state.messages.concat(new MessageData(message))});
  }

  render() {
    switch (this.state.state) {
      case State.Checking:
        return <SessionWaiter {...this.forRoomIn}/>;
      case State.Waiting:
        return <RoomInComponent {...this.forRoomIn}/>;
      case State.WaitingRetry:
        return <RoomInComponent {...this.forRoomIn}/>;
      case State.Trying:
        return <RoomInComponent {...this.forRoomIn}/>;
      case State.Connected:
        return <RoomComponent {...this.forRoom}/>
    }
  }
}

class SessionWaiter extends React.Component {
  render() {
    return <div className="session-waiter">セッション確認中</div>;
  }
}

class RoomInComponent extends React.Component {
  componentWillMount() {
    this.setState({
      name: ''
    })
  }

  render() {
    return <section className="room">
      <input type="text" placeholder="表示名" value={this.state.name} onChange={(e) => this.setState({name: e.target.value})}/>
      <button onClick={() => this.props.knock(this.state.name) }>
        入室
      </button>
    </section>;
  }
}

class RoomComponent extends React.Component {
  render() {
    return <div>
      <MemberViewer {...this.props}/>
      <MessageViewer {...this.props}/>
      <MessageSender {...this.props}/>
    </div>
  }
}

class MemberViewer extends React.Component {
  renderMessages() {
    return this.props.members.map(({name, key})=> <div key={key}>
      <h1>{name}</h1>
      <p>{key}</p>
    </div>)
  }

  render() {
    console.log(this.props)
    return <div>{this.renderMessages()}</div>
  }
}

class MessageViewer extends React.Component {
  renderMessages() {
    return this.props.messages.map(({name, message, key})=> <div key={key}>
      <h1>{name}</h1>
      <p>{message}</p>
    </div>)
  }

  render() {
    console.log(this.props)
    return <div>{this.renderMessages()}</div>
  }
}

class MessageSender extends React.Component {
  componentWillMount() {
    this.setState({
      message: ''
    })
  }

  sendMessage(e) {
    e.preventDefault();
    this.props.sendMessage(this.state.message)
  }

  render() {
    return <div>
      <form>
        <input type="text" placeholder="メッセージ" value={this.state.message} onChange={(e) => this.setState({message: e.target.value})}/>
        <button onClick={(e) => this.sendMessage(e) }>
          送信
        </button>
      </form>
    </div>
  }
}

class MessageData {
  constructor({name, message, key}) {
    this.name = name;
    this.message = message;
    this.key = key;
  }
}

class MemberData {
  constructor({name, key}) {
    this.name = name;
    this.key = key;
  }
}