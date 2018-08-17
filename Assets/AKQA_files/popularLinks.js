define(['jquery', 'widget'], function ($, widget) {
    'use strict';

    var $links,
        $window = $(window);

    /**
    * Run initialisation code
    */
    function init() {

        $links = $('.link-banner').children();
        addHeightClasses($links);
        widget.setBoxHeights($links);
        attachEventHandlers();
    }


    function attachEventHandlers() {

        $window.resize(function() {
            widget.setBoxHeights($links);
        });

    }


    function addHeightClasses() {

        $links.each(function(){
            $(this).removeClass().addClass('smallheight cta widget in-view');
        });

    }

    return {
        init: init
    };

});
