(()=> {
  let mixin = {
    connected: function () {
      console.log('chat connected')
    },
    received: function (data) {
      console.log(data);
      this.appendLine(data);
    },
    appendLine: function (data) {
      var html = this.createLine(data);
      return $("[data-chat-room='Best Room']").append(html);
    },
    createLine: function (data) {
      return ("<article class=\"chat-line\\\">\\n  <span class=\\\"speaker\\\">" + (data["sent_by"]) + "</span>\\n  <span class=\\\"body\\\">" + (data["body"]) + "</span>\\n</article>");
    }
  };

  App.chatChannel = App.cable.subscriptions.create({
    channel: 'ChatChannel',
    room: 'Best Room'
  }, mixin);

  setTimeout(()=> {
    App.chatChannel.send({sent_by: "Paul", body: "This is a cool chat app."})
  }, 1000);
})();

