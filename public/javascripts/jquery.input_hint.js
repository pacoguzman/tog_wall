// Based in http://github.com/robv/input-hint
// removed color specification for the hint
(function($) {

    $.fn.input_hint = function(params) {

        // merge default and user parameters
        params = $.extend({attribute: 'title'}, params);

        // traverse all nodes
        return this.each(function() {

            var $this = $(this);

            if ($this.attr('value') == '')
                $this.attr('value', $this.attr(params.attribute));

            $this._default = $this.attr('value'); 

            $this.focus(function() {
                if ($this._default != $this.value) return;
                $this.removeClass('hint').attr('value', '');
            }).blur(function() {
                if ($this.attr('value') != '') return;
                $this.addClass('hint').attr('value', $this._default);
            }).parents('form').submit(function() {
                if ($this.attr('value') == $this._default)
                    $this.attr('value', '');
            });

        });

        // allow jQuery chaining
        return this;
    };

})(jQuery);