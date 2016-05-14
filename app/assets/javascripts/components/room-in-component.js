import * as React from 'react';
import Fa from './fa';

export default class RoomInComponent extends React.Component {
  componentWillMount() {
    this.setState({
      name: ''
    })
  }

  knock(e) {
    e.preventDefault();
    this.props.knock(this.state.name)
  }

  renderMessage() {
    if (!this.props.message) {
      return null;
    }

    return <div className="alert alert-danger">
      <ul>{this.props.message.map((m, i)=> <li key={i}>{m}</li>)}</ul>
    </div>
  }

  render() {
    return <div className="room-in">
      <div className="panel panel-primary">
        <form>
          <p className="note">アルファベットか数字で10文字以内</p>
          <input className="room-in-name form-control" type="text" placeholder="チャット内での表示名" maxLength="10" value={this.state.name} onChange={(e) => this.setState({name: e.target.value})}/>
          {this.renderMessage()}
          <button className="room-in-button btn btn-success" onClick={(e) => this.knock(e) }>
            <Fa icon="sign-in"/>
            入室
          </button>
        </form>
      </div>
    </div>;
  }
}
