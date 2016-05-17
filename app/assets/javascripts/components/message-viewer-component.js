import * as React from 'react';

export default class MessageViewerComponent extends React.Component {
  shouldComponentUpdate(props) {
    return this.props.messages !== props.messages;
  }

  classes(isKilled) {
    return isKilled ? 'message-box killed' : 'message-box';
  }

  renderMessages() {
    return this.props.messages.map(({name, message, userKey, key, x, y, isKilled})=> <div className={this.classes(isKilled)} key={key} style={{top: y, left: x - 200}}>
      <div className="name-container">
        <h1>{name}</h1>
        <h2>[{userKey}]</h2>
      </div>
      <div className="message-container">
        {message}
      </div>
    </div>);
  }

  posit(e) {
    this.props.posit(e.pageX, e.pageY);
  }

  render() {
    console.log('render messages');
    return <div className="room-message" onClick={(e)=> this.posit(e)}>
      <div className="help">
        <p>この背景色のいずれかの場所をクリックすると入力画面が出現します。</p>
        <p>メッセージを入力し、送信すると、その位置にメッセージが表示されます。</p>
        <p>左のメンバー画面から、特定のメッセージの表示非表示の切り替えが行えます。</p>
      </div>
      {this.renderMessages()}
    </div>;
  }
}

