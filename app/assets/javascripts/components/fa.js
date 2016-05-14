import * as React from 'react';

export default class Fa extends React.Component {
  render() {
    let p = this.props;
    let classes = ['fa'];
    classes.push('fa-' + p.icon);
    p.scale && classes.push('fa-' + p.scale + 'x');
    (p.fixedWidth === undefined || p.fixedWidth === true) && classes.push('fa-fw');
    p.list && classes.push('fa-li');
    p.border && classes.push('fa-border');
    p.pull && classes.push('fa-pull-' + p.pull);
    p.animation && classes.push('fa-' + p.animation);
    p.rotate && classes.push('fa-rotate-' + p.rotate);
    p.flip && classes.push('fa-flip-' + p.flip);

    return <i className={classes.join(' ')}/>;
  }
}

