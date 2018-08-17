define(['jquery'], function ($) {
    'use strict';

    var $expander,
        $target,
        alttext;
    /**
    * Run initialisation code
    */
    function init() {
        $expander = $('.expander');
        $target = $($expander.data('target'));
        alttext = $expander.data('alt-text');

        attachEventHandlers();
    }

    function attachEventHandlers() {

        $expander.on('click', function(e){
            e.preventDefault();
            toggleExpander();            
        });
        $expander.on('keydown', function(e){
            var code = e.which;
            // 13 = Return
            if ((code === 13)){
                e.preventDefault();
                toggleExpander();
            }          
        });

    }

    function toggleExpander(){

        toggleText();
        toggleContainer();

    }

    function toggleText(){
        
        var currenttext = $expander.text();
        alttext = $expander.data('alt-text');
        $expander.text(alttext);
        $expander.data('alt-text', currenttext);

    }

    function toggleContainer(){

        var $items = $($expander.data('items')),
            $newswidget = $('.news-widget');

            //Set current height to animate from
            $newswidget.height($newswidget.height());

        if (!$target.hasClass('expanded')){           

            //Sets all news items to display via css
            $target.addClass('expanded');

            $target.children().each(function(){
                $(this).fadeIn(100);
            });

            setTimeout(function(){

                //use height of inner container after all news items have been made visible
                var finalheight = $newswidget[0].scrollHeight + 40;
                $newswidget.css('height',finalheight);

            },100);


        }else{

            //Hides all except 1st row via CSS
            $target.removeClass('expanded');      

            setTimeout(function(){

                //Set height to height of one (row of) news item
                $newswidget.css('height', $items.outerHeight(true));

            },100);
        }

    }

    return {
        init: init
    };

});