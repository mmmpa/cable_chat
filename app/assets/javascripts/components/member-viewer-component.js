import * as React from 'react';
import Fa from './fa';

export default class MemberViewerComponent extends React.Component {
  componentWillMount() {
    this.setState({
      height: 0
    });
  }

  shouldComponentUpdate(props) {
    return this.props.invisibles !== props.invisibles || this.props.members !== props.members;
  }

  toddleVisible(visibility, key) {
    this.props.toggleVisibility(visibility, key)
  }

  renderIcon(key) {
    let visibility = !this.props.invisibles.has(key);
    return visibility
      ? <Fa icon="eye"/>
      : <Fa icon="eye-slash"/>
  }

  renderMessages() {
    return this.props.members.map(({name, key})=> <li className="member" key={key}>
      <label>
        <div className="input">
          <div className="wrapper">
            {this.renderIcon(key)}
            <input type="checkbox" checked={this.props.invisibles.has(key)} onChange={(e)=> this.toddleVisible(!e.target.checked, key)}/></div>
        </div>
        <span className="name">{name}</span>
      </label>
    </li>);
  }

  exit(e) {
    e.preventDefault();
    this.props.exit();
  }

  get css() {
    return {
      height: this.state.height
    };
  }

  render() {
    console.log('render member');
    return <div className="room-member">
      <ul className="wrapper">{this.renderMessages()}</ul>
      <div className="button-area">
        <button className="btn btn-danger" onClick={(e) => this.exit(e)}>
          <Fa icon="sign-out"/>
          退室
        </button>
      </div>
    </div>
  }
}

