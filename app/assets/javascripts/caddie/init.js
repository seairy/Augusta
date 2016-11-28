$(document).ready(function() {
  toastr.options = {
    "closeButton": false,
    "debug": false,
    "newestOnTop": false,
    "positionClass": "toast-top-center",
    "preventDuplicates": true,
    "onclick": null,
    "showDuration": "300",
    "hideDuration": "500",
    "timeOut": "2500",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
  }

  $.jscroll = {
    defaults: {
      debug: false,
      autoTrigger: true,
      autoTriggerUntil: false,
      loadingHtml: '<div class="loading">加载中...</div>',
      padding: 0,
      nextSelector: 'a:last',
      contentSelector: '',
      pagingSelector: '',
      callback: false
    }
  };

  FastClick.attach(document.body);

  $("img.lazy").lazyload();
});