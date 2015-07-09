//= require jquery

$(document).ready(function(){
  $.extend({
    getUrlVars: function(){
      var vars = [], hash;
      var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
      for(var i = 0; i < hashes.length; i++) {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
      }
      return vars;
    },
    getUrlVar: function(name){
      return $.getUrlVars()[name];
    }
  });

  var ua = navigator.userAgent.toLowerCase();
  if (ua.indexOf('android') > -1) {
    document.location = "http://a.app.qq.com/o/simple.jsp?pkgname=cn.com.zcty.ILovegolf.activity";
  } else if (ua.indexOf('iphone') > -1) {
    document.location = "http://a.app.qq.com/o/simple.jsp?pkgname=cn.com.zcty.ILovegolf.activity";
  } else if (ua.indexOf('ipad') > -1) {
    document.location = "http://a.app.qq.com/o/simple.jsp?pkgname=cn.com.zcty.ILovegolf.activity";
  } else {
    document.location = "http://ilovegolfclub.com";
  }
});
