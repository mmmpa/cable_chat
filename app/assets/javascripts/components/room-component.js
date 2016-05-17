import * as React from 'react';
import MemberViewer from './member-viewer-component';
import MessageViewer from './message-viewer-component';
import MessageSender from './message-sender-component';

export default class RoomComponent extends React.Component {
  render() {
    return <div className="room">
      <MemberViewer {...this.props}/>
      <MessageViewer {...this.props}/>
      <MessageSender {...this.props}/>
    </div>;
  }
}

