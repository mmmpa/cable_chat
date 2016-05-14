import * as React from 'react';
import Fa from './fa';

export default class SessionWaiterComponent extends React.Component {
  render() {
    return <div className="session-waiter">
      <div className="panel panel-primary">
        <div className="session-waiter-body panel-body">
          <Fa icon="spinner" animation="pulse"/>
          <p>セッション確認中</p>
        </div>
      </div>
    </div>;
  }
}
