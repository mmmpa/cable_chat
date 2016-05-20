import * as React from 'react';
import * as ReactDOM from 'react-dom';
import ChatContext from 'contexts/chat-context';

class Chat {
  static run(dom) {
    ReactDOM.render(<ChatContext/>, dom);
  }
}

window.Chat = Chat;