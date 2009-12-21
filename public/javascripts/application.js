jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
}

/* not used atm? */
jQuery.fn.ajaxLink = function() {
    this.bind('click',function(event){
        event.preventDefault();
        $.get(this.href, null, null, "script")
    })
}

$(document).ready(function() {
    $("#new_comment").submitWithAjax();
});