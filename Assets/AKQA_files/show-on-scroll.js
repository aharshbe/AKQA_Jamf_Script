define(['jquery'], function ($) {
    'use strict';

        var stagger = true, // Toggle staggered load animation
            $window = $(window);

        function init() {

            if (($('html').hasClass('no-touch') && 
                $('html').hasClass('csstransitions')) &&
                !$('body').hasClass('page-editor')) {


                //animate visible blocks on page load
                handleAnimation();
                // Limit this to no touch devices using modernizr added no-touch class


                $window.on('scroll resize', function () {
                    handleAnimation();
                });

            } 

        }

        function handleAnimation () {

            var windowTop = $window.scrollTop(),
                $elements = $('[data-show*="on-scroll"]').not('.in-view'),
                delay = 100,
                elem,
                elementTop;

            $elements.each(function () {
                elem = $(this);
                elementTop = parseInt(elem.offset().top, 10);

                if (stagger) {
                    elem.css('transition-delay', delay + 'ms');
                    delay += 100;
                }
                // -140px fix for smaller screens height
                if (elementTop <= (windowTop + $(window).height())) {
                    showItem(elem);
                }

            });

        }

        function showItem (elem)  {
            $(elem).addClass('in-view');
        }


        return {
            handleAnimation: handleAnimation,
            init: init
        };

});
