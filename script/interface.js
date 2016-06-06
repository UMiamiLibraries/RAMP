/*
 * Created by pvillanueva on 2/18/16.
 * UI behaviors
 */

$(document).ready(function($) {

    var $window = $(window);

        function checkWidth() {
            windowsize = $window.width();

            //position panels based on viewport for onload and window resize
            if (windowsize < 1000){
                $("#help_viewport_area").insertBefore("#form_viewport_area");
              } 
            else {
                $("#help_viewport_area").insertAfter("#form_viewport_area");
            }
        }

        $(window).resize(checkWidth).resize();

});