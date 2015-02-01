(function() {
  var root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.AppController = (function() {
    function AppController() {}

    AppController.activate = function() {
      try {
        return $('[data-toggle="tooltip"]').tooltip({
          container: 'body'
        });
      } catch (_error) {}
    };

    return AppController;

  })();

  jQuery(function() {
    return new root.AppController.activate();
  });

}).call(this);
