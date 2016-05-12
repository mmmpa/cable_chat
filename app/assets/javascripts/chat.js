import * as React from 'react';
import * as ReactDOM from 'react-dom';
import ChatComponent from 'components/chat-component'

class Chat {
  static run(dom) {
    ReactDOM.render(<ChatComponent/>, dom)
  }
}

window.Chat = Chat;