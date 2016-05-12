(()=> {
  let mixin = {
    buttonSelector: '[data-behavior~=appear_away]',
    connected: function () {
      console.log('connected');
      this.install();
      this.appear();
    },
    disconnected: function () {
      console.log('disconnected');
      this.uninstall();
    },
    rejected: function () {
      console.log('disconnected');
      this.uninstall();
    },
    appear: function () {
      console.log('appear');
      console.log(this.perform('appear', {
        appearing_on: $('main').data('appearing-on')
      }));
    },
    away: function () {
      console.log('away');
      this.perform('away');
    },
    install: function () {
      $(document).on('page:change.appearance', function () {
        return this.appear();
      });

      $(document).on('click.appearance', this.buttonSelector, function () {
        this.away();
        return false;
      });

      $(this.buttonSelector).show();
    },
    uninstall: function () {
      $(document).off('.appearance');
      return $(this.buttonSelector).hide();
    }
  };

  App.cable.subscriptions.create('AppearanceChannel', mixin);
})();
