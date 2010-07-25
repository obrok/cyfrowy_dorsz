jQuery.fn.extend({
  recordId: function() {
    return this.attr('id').split('-').pop();
  }
});