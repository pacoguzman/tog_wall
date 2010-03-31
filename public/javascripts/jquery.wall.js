(function($) {

    var app_wall = {

       setupGraffityForm: function(){
           $("#graffity_form").ajaxForm({
               beforeSubmit : function(formData) {
                   if ($(this).data('beenSubmited')) {
                       return false;
                   }
                   $(this).data('beenSubmited', true);
                   formData.push({name: 'format', value: 'js'});
               },
               clearForm : true,
               complete : function() {
                   $(this).data('beenSubmited', false);
               },
               success : function() {
                   // #TODO desde aquí o desde la respuesta de la aplicación creo que aquí  mejor
                   $(this).find("textarea").val('').trigger('focusout');
                   // placeholder for the recent added textarea
                   $("textarea.reply:first", $("#graffities")).placeholder();
               }
           });
       },

       setupReplyForms: function(graffities) {
            graffities.delegate("form.reply", 'submit', function() {
                $form = $(this);
                $form.ajaxSubmit({
                    beforeSubmit : function(formData) {
                        if ($form.data('beenSubmited')) {
                            return false;
                        }
                        $form.data('beenSubmited', true);
                        formData.push({name: 'format', value: 'js'});
                    },
                    clearForm : true,
                    complete : function() {
                        $form.data('beenSubmited', false);
                    },
                    success : function() {
                        $form.find("textarea.reply").val('').trigger('focusout');
                    }
                });

                return false;
            });
        }

    };

    $(document).ready(function() {
        $.fn.ajaxSubmit.debug

        $graffities = $("#graffities").get(0); // Used many times

        app_wall.setupGraffityForm();

        app_wall.setupReplyForms($graffities);

        $("textarea.placeholder", graffities).placeholder();

        $graffities.delegate('a[id^="reply-to-"]', 'click', function(){
            $(this).closest(".graffity").find("textarea.reply").focus();
        });

        $graffities.delegate('form.reply input.cancel', 'click', function(){
            $element = $(this).closest("form").find("textarea.reply");
            //TODO set rows default
            $element.val($element.attr("placeholder")).trigger("focusout");
        });

        $graffities.delegate("a.like", 'click', function(event){
            event.preventDefault();
            $.getScript(this.href,function(){});
        });

        $graffities.delegate("div[id^=collapsed] a", 'click', function(event){
           event.preventDefault();
           //TODO review the uncollapse code
           $(this).closest("div").get(0).widget.uncollapse();
        });

        // Show more ajaxify link
        $("#show_more_button a").live('click', function(event){
           event.preventDefault();
           $.getScript(this.href,function(){});
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