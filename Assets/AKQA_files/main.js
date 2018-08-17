// Load modules and use them
define(['jquery'], function($){

    Array.prototype.contains = function(v) {
        for (var i = 0; i < this.length; i++) {
            if (this[i] === v) return true;
        }
        return false;
    };

    Array.prototype.unique = function() {
        var arr = [];
        for (var i = 0; i < this.length; i++) {
            if (!arr.contains(this[i])) {
                arr.push(this[i]);
            }
        }
        return arr; 
    }

    function loadAllModules(){
        var $moduleElems = $('[data-module]'),
            modules = [],
            i;

        $moduleElems.each(function(){
            var moduleNames = $(this).data('module').split(" ");
            $.each(moduleNames, function(i, val){
                modules.push(val);
            })
        });

        //Remove duplicates
        modules = modules.unique();

        for(i=0; i< modules.length; i++){
            /*jshint -W083 */
            require( [ modules[i] ], function ( mod ) {
                mod.init();
            });
            /*jshint +W083 */
        }
    }

    $('document').ready(function(){
        loadAllModules();
    });

});
