import * as React from 'react';
import ChatCable from '../models/chat-cable';
import Invisible from '../models/invisible';
import token from '../utils/token';
import {State} from '../constants/state';
import SessionWaiterComponent from '../components/session-waiter-component';
import RoomInComponent from '../components/room-in-component';
import RoomComponent from '../components/room-component';

const request = require('superagent');

export default class ChatContext extends React.Component {
  constructor() {
    super();
    this.intervalIds = [];
  }

  componentWillMount() {
    this.setState({
      cable: new ChatCable(this.cableCallback),
      state: State.Checking,
      invisibles: new Invisible(),
      rawMessages: [],
      messages: [],
      members: [],
      me: {},
      x: -1,
      y: -1
    }, () => this.connect());
  }

  get cableCallback() {
    return {
      connected: ()=> {
        this.setState({
          state: State.Connected
        });
        this.intervalIds.push(setInterval(() => this.checkTimer(), 1000));
      },
      disconnected: ()=> {
        this.setState({
          state: State.Waiting,
          members: [],
          rawMessages: [],
          x: -1,
          y: -1
        });
        this.intervalIds.forEach((id) => clearInterval(id));

      },
      meReceived: (me) => {
        this.setState({me});
      },
      messageReceived: (data)=> {
        this.appendMessage(data);
      },
      memberReceived: (data)=> {
        this.reloadMembers(data);
      }
    };
  }

  get forRoomIn() {
    return {
      message: this.state.message,
      knock: (name) => this.knock(name)
    };
  }

  get forRoom() {
    let {messages, members, invisibles, x, y, me} = this.state;

    return {
      messages, members, invisibles, x, y, me,
      exit: (...args) => this.exit(...args),
      posit: (...args) => this.posit(...args),
      sendMessage: (...args) => this.sendMessage(...args),
      toggleVisibility: (...args) => this.toggleVisibility(...args)
    };
  }

  checkTimer() {
    let messages = this.state.messages.filter((message) => {
      message.die();
      return !message.isDead;
    });

    this.setState({messages});
  }

  exit() {
    this.state.cable.disconnect();
  }

  knock(name) {
    this.setState({state: State.Trying});
    request
      .post('/sessions')
      .set('X-CSRF-Token', token())
      .send({session: {name}})
      .end((err, res)=> {
        if (err) {
          this.setState({state: State.WaitingRetry, message: res.body.message});
        } else {
          this.setState({state: State.Trying}, () => {
            this.connect();
          });
        }
      });
  }

  connect() {
    this.state.cable.connect();
  }

  sendMessage(...args) {
    this.state.cable.sendMessage(...args);
  }

  reloadMembers(members) {
    this.setState({members});
  }

  posit(x, y) {
    this.setState({x, y});
  }

  appendMessage(message) {
    this.setState({rawMessages: this.state.rawMessages.concat(message)}, ()=> this.deliverMessages());
  }

  deliverMessages() {
    let {rawMessages, invisibles} = this.state;
    this.setState({messages: rawMessages.filter(({userKey}) => !invisibles.has(userKey))});
  }

  toggleVisibility(visibility, key) {
    let invisibles = new Invisible(this.state.invisibles);
    visibility ? invisibles.del(key) : invisibles.add(key);
    this.setState({invisibles}, ()=> this.deliverMessages());
  }

  render() {
    switch (this.state.state) {
      case State.Checking:
        return <SessionWaiterComponent/>;
      case State.Waiting:
        return <RoomInComponent {...this.forRoomIn}/>;
      case State.WaitingRetry:
        return <RoomInComponent {...this.forRoomIn}/>;
      case State.Trying:
        return <RoomInComponent {...this.forRoomIn}/>;
      case State.Connected:
        return <RoomComponent {...this.forRoom}/>;
      default:
        return null;
    }
  }
}
