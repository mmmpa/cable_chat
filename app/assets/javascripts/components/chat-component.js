import * as React from 'react';
import token from 'token'
const request = require('superagent');


const State = {
  Connected: 'Connected',
  Trying: 'Trying',
  Waiting: 'Waiting',
  WaitingRetry: 'WaitingRetry',
};

export default class ChatComponent extends React.Component {
  componentWillMount() {
    this.setState({
      state: State.Waiting,
      cable: null,
      name: ''
    })
  }

  knock(name) {
    this.setState({state: State.Trying});
    request
      .post('/in')
      .set('X-CSRF-Token', token())
      .end((err, res)=> {
        if (err) {
          this.setState({state: State.WaitingRetry});
        } else {
          this.connect(name);
        }
      });
  }

  connect(name) {
    let cable = ActionCable.createConsumer();
    this.setState({cable, name, state: State.Connected});
  }

  get forRoomIn() {
    return {
      state: this.state,
      knock: (name) => this.knock(name)
    }
  }

  render() {
    switch (this.state.state) {
      case State.Waiting:
        return <RoomInComponent {...this.forRoomIn}/>;
      case State.WaitingRetry:
        return <RoomInComponent {...this.forRoomIn}/>;
      case State.Trying:
        return <RoomInComponent {...this.forRoomIn}/>;
      case State.Connected:
        return <RoomInComponent {...this.state}/>
    }
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
  componentWillMount() {
    this.setState({
      channel: App.cable.subscriptions.create('ChatChannel', this.channelCallback),
      messages: [],
      message: ''
    })
  }

  get channelCallback() {
    return {
      connected: function () {
        console.log('chat connected')
      },
      received: function (data) {
        this.appendMessage(data);
      }
    }
  }

  appendMessage(raw) {
    this.setState({messages: this.state.messages.concat(new MessageData(raw))})
  }

  sendMessage() {
    this.state.cable.send({name: this.props.name, message: this.state.message});
    this.setState({message: ''});
  }

  render() {
    return <div>
      <form>
        <input type="text" placeholder="メッセージ" value={this.state.message} onChange={(e) => this.setState({message: e.target.value})}/>
        <button onClick={() => this.sendMessage() }>
          送信
        </button>
      </form>
    </div>
  }
}

class MessageData {
  constructor({name, message}) {
    this.name = name;
    this.message = message;
  }
}