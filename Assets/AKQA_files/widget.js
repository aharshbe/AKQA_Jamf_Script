define(['jquery'], function ($) {
    'use strict';

    var $widget,
        $window = $(window),
        heightSetting,
        breakpointMid = 768,
        breakpointWide = 1024,
        breakpointComfy = 1280;

    /**
    * Run initialisation code
    */
    function init() {

        $widget = $('.widget');
        setBoxHeights($widget);
        attachEventHandlers();

        // Monitor the creation of new widgets and apply the appropriate box height
        if ($('.page-editor').length) {
            require(['insertionQuery'], function() {

                insertionQ('.cta.widget').every(function(newWidget) {

                    newWidget = $(newWidget);
                    newWidget.addClass('show-on-scroll');

                    if (newWidget.parent().attr('data-module') === 'popularLinks') {
                        newWidget.addClass('smallheight');
                    }

                    setBoxHeights(newWidget);
                });
            });
        }
    }

    /**
    * Run initialisation code
    */
    function attachEventHandlers() {

        $window.resize(function() {
            setBoxHeights($widget);
        });

    }

    //Sets box heights relative to their responsive width. 
    function setBoxHeights(itemSet){


        itemSet.each(function(){

            //Default: full height/square
            heightSetting = 1;

            if($(this).hasClass('fullheight')){

                heightSetting = 1;

            }else if ($(this).parent().hasClass('half')){

                heightSetting = 0.5;

            }else if ($(this).hasClass('smallheight')){

                heightSetting = 0.375;

            }

            boxResize($(this), heightSetting);
        });

    }


    //Sets box heights relative to their responsive width. 
    function boxResize(current_widget, heightSetting) {

        var newheight = current_widget.width()*heightSetting;

        //For half height boxes set the row margin to be the same as the column margins        
        if(heightSetting === 0.5){
            newheight = setRowMargin(current_widget, newheight);
        }

        // Despite being 50% wide, smallheight boxes have differing widths which result in differing heights and a broken layout at certain breakpoints
        // Height will be based on the first sibling...
        if (heightSetting === 0.375) {
            newheight = $('.widget.smallheight').not('code').eq(0).width() * heightSetting;
        }

        current_widget.height(newheight);
    }

    //Sets margin between half height widgets
    function setRowMargin(current_widget, newBoxHeight){

        //Set the height
        newBoxHeight = newBoxHeight - 5;
        //Set the margin
        current_widget.css('margin-bottom', 10);

        return newBoxHeight;
    }


    return {
        init: init,
        setBoxHeights: setBoxHeights
    };

});
