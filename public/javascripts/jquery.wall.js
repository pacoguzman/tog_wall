(function($) {

    // http://github.com/mathiasbynens/Placeholder-jQuery-Plugin
    $.fn.hints = function(options) {
        var opts = $.extend({}, $.fn.hints.defaults, options);

        return this.map(function(){
                    jQuery(this).data("_default", jQuery(this).val());
                    return this;
                })
                .bind('focusin', function(){
                  element = $(this);
                  if (element.data("_default") != element.val()) return;
                  element.removeClass('hint').val('');
                })
                .bind('focusout', function(){
                  element = $(this);
                  if (element.val().strip() != '') return;
                  element.addClass('hint').val(element.data("_default"));
                })
                .addClass('hint');
    };

    $.fn.hints.defaults = {
        className: "hint"
    };

    $.fn.hintReplies = function(options) {
        var opts = $.extend({}, $.fn.hintReplies.defaults, options);

        return this.map(function(){
                    jQuery(this).data("_default", jQuery(this).val());
                    jQuery(this).data("_opts", opts);
                    return this;
                })
                .bind('focusin', function(){
                  element = $(this);
                  if (element.data("_default") != element.val()) return;
                  element
                     .closest("form")
                        .find(":button").show()
                        .end()
                        .find(":submit").show()
                        .end()
                        .find("div.avatar-tiny").show()
                        .end()
                     .end()
                     .removeClass('hint').val('');
                })
                .bind('focusout', function(){
                  element = $(this);
                  if (element.val().strip() != '') return;
                  element.addClass('hint').val(element.data("_default")).attr("rows", opts.rows)
                      .closest("form")
                         .find(":button").hide()
                         .end()
                         .find(":submit").hide()
                         .end() 
                         .find("div.avatar-tiny").hide()
                         .end()
                       .end();
                })          
                .addClass('hint');
    };

    $.fn.hintReplies.defaults = {
        className: "hint",
        message: "Escribe tu commentario...",
        rows: 1
    };

    $(document).ready(function() {
        $.fn.ajaxSubmit.debug

        $("#graffity_form").ajaxForm({
          beforeSubmit : function(formData) {
              formData.push({name: 'format', value: 'js'});
          },
          clearForm : true,
          success : function(){
              $(this).find("textarea").val('').trigger('focusout');
              // placeholder for the recent added textarea
             $("textarea.reply:first",$("#graffities")).placeholder();
          }
        });

        $("textarea", $("#graffity_form")).placeholder();

        $("form.reply", $("#graffities").get(0)).live('submit', function(){
          $form = $(this);
          $(this).ajaxSubmit({
              beforeSubmit : function(formData) {
                formData.push({name: 'format', value: 'js'});
              },
              clearForm : true,
              success : function(){
                  $form.find("textarea.reply").val('').trigger('focusout');
              }
          });

          return false;
        });

        $("textarea.reply", $("#graffities")).placeholder();


        $('a[id^="reply-to-"]', $("#graffities").get(0)).live('click', function(){
            $(this).closest(".graffity").find("textarea.reply").focus();
        });

        $('form.reply input.cancel', $("#graffities").get(0)).live('click', function(){
            $element = $(this).closest("form").find("textarea.reply");
            //TODO set rows default
            $element.val($element.attr("placeholder")).trigger("focusout");
        });

        $("a.like", $("#graffities").get(0)).live('click', function(event){
            event.preventDefault();
            $.get(this.href,{},function(){}, "script");
        });

        $("div[id^=collapsed] a", $("#graffities").get(0)).live('click', function(event){
           event.preventDefault();
           $(this).closest("div").get(0).widget.uncollapse(); 
        });

        // Show more ajaxify link
        $("#show_more_button a").live('click', function(event){
           event.preventDefault();
           $.get(this.href,{},function(){}, "script")
        });
    });
})(jQuery);

if (window.Widget == undefined) window.Widget = {};

// For collapsing some replies to display later if the user wants
Widget.Collapsable = Class.create({
    initialize: function(comment, collapsed, options)
    {
        this.comment   = $(comment);
        this.collapsed = $(collapsed);
        this.options   = $H({
            'collapse_since'  : 4, //4 children
            'children_showed' : 2 //2 children showed always
        }).update(options);

        this.replies = this.comment.select("div[id^=reply]");
        this.total_replies = this.replies.size();
        if (this.collapsed)
            this.collapsed.widget = this;
        this.init_state();
    },

    init_state: function()
    {
        if (this.total_replies > this.options.get('collapse_since')){
          this.collapse();
          this.collapsed.show();
        }
        return true;
    },

    collapse: function()
    {
        // Se muestran solo los últimos children_showed, los primeros se ocultan
        var hide_first = this.total_replies - this.options.get('children_showed');
        this.replies.each(function(el,i){
            if (i < hide_first) { el.hide(); };
        });
        return true;
    },

    uncollapse: function()
    {
        var hide_first = this.total_replies - this.options.get('children_showed');
        this.replies.each(function(el,i){
            if (i < hide_first) { el.show(); };
        });
        this.collapsed.hide(); // we can't use this.collapsed.addClassName("hide"); in IE6
        return true;
    }
});

CollapsableReplies = Behavior.create({
    initialize : function(options) {
        this.options = $H({
            'selector_for_collapsed'  : "div[id^=collapsed]",
            'collapse_since' : 4,
            'children_showed': 2
        }).update(options);
        var collapsed = this.element.down(this.options.get('selector_for_collapsed'));
        if (collapsed)
          new Widget.Collapsable(this.element, collapsed, this.options);
    }
});