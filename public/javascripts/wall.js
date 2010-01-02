// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// http://github.com/madrobby/prototype_helpers
(function() {
    var methods = {
        defaultValueActsAsHint: function(element) {
            element = $(element);
            element._default = element.value;

            return element.observe('focus', function() {
                if (element._default != element.value) return;
                element.removeClassName('hint').value = '';
            }).observe('blur', function() {
                if (element.value.strip() != '') return;
                element.addClassName('hint').value = element._default;
            }).addClassName('hint');
        },
        
        actsAsReplyTextarea: function(element, options) {
            element = $(element);

            element.options = $H({
                'message' : "Escribe tu commentario...",
                'rows'    : 1
            }).update(options);
            element.buttons = element.up("form").select(".button");
            element.avatar = element.up("form").down("div.avatar-tiny");

            element.init_state = function() {
                element.rows = element.options.get('rows');
                element.buttons.map(function(el) {
                    el.hide();
                });
                element.avatar.hide();
            };

            element.default_state = function() {
                element.addClassName('hint').value = element._default;
                element.init_state();
            }

            if (element.present()) element._default = element.value;
            else element._default = element.options.get('message');

            element.init_state();

            return element.observe('focus', function() {
                if (element._default != element.value) return;
                element.buttons.map(function(el) {
                    el.show();
                });
                element.avatar.show();
                element.removeClassName('hint').value = '';
            }).observe('blur', function() {
                if (element.value.strip() != '') return;
                element.default_state();
            }).addClassName('hint');
        }
    };

    $w('input textarea').each(function(tag) {
        Element.addMethods(tag, methods)
    });
})();

Event.addBehavior({
    '#graffities:click' : Event.delegate({
        'a[id^=reply-to-]' : function(event) {//link for reply
            var el = event.element();
            if (el.id.match(/\d{1,}$/) != null) {
                el.up(".graffity").down("textarea.reply").focus();
            }
            event.stop();
        },
        'form.reply input.cancel' : function(event) {
            event.element().up("form").down("textarea.reply").default_state();
            event.stop();
        },
        'div[id^=collapsed] a' : function(event) {
            event.element().up("div").widget.uncollapse();
            event.stop();
        }
    })
});

Event.addBehavior.reassignAfterAjax = true;

document.observe("dom:loaded", function() {
    // I can't do it with low pro behaviors
    //http://wiki.github.com/mislav/will_paginate/ajax-pagination
    var body_container = $(document.body);
    window.spinner = '<span class="prepend-1 loading"><img src="tog_wall/images/spinner.gif" alt="Loading..." title="Loading..." /></span>';

    if (body_container) {
        body_container.observe('click', function(e) {
            var el = e.element();
            if (el.match('div#flow_pagination a')) {
                if (window.spinner) {
                    el.up('#flow_pagination').insert({bottom : window.spinner});
                }
                new Ajax.Request(el.href, { method: 'get' });
                e.stop();
            }
        })
    }
});