import * as React from 'react';

export default class MessageSenderComponent extends React.Component {
  componentWillMount() {
    this.setState({
      message: ''
    });
  }

  sendMessage(e) {
    e.preventDefault();
    let {x, y} = this.props;
    this.props.sendMessage(this.state.message, x, y);
    this.props.posit(-1, -1);
    this.setState({message: ''});
  }

  get css() {
    return {
      top: this.props.y,
      left: this.props.x
    };
  }

  render() {
    let {x, y} = this.props;
    let {name, key} = this.props.me;

    if (this.props.x < 0) {
      return null;
    }

    return <div className="message-box" style={{top: y, left: x}}>
      <div className="name-container">
        <h1>{name}</h1>
        <h2>[{key}]</h2>
      </div>
      <div className="message-container">
        <textarea type="text" maxLength="140" placeholder="メッセージ（140文字まで）" value={this.state.message} onChange={(e) => this.setState({message: e.target.value})}/>
        <button className="btn btn-success" onClick={(e) => this.sendMessage(e) }>
          送信
        </button>
      </div>
    </div>;
  }
}

