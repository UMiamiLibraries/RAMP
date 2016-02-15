/**
 * Created by cbrownroberts on 2/11/16.
 */


function rampEditor() {

    "use strict";

    var myRampEditor = {

        settings : {
        },
        strings : {
        },
        bindUiActions : function() {

            myRampEditor.cookieCheck();
        },
        init : function() {

            myRampEditor.cookieCheck();
        },

        cookieCheck : function() {

            if (myRampEditor.getCookie('ead_file')) {

                if (myRampEditor.getCookie('ead_file') === '""')
                {
                    $('#entity_name').html('Please select a record to edit from the menu.');
                    $('#entity_name').show();
                }
                else
                {
                    console.log(myRampEditor.getCookie('ead_file'));

                    $('#entity_name').html('Now Editing: ' + myRampEditor.getCookie('entity_name'));

                }
            }
        },

        /*
         * getCookie gets values of cookie
         * @method getCookie
         */
         getCookie : function(c_name) {
            var c_value = document.cookie;
            var c_start = c_value.indexOf(" " + c_name + "=");
            if (c_start == -1)
            {
                c_start = c_value.indexOf(c_name + "=");
            }
            if (c_start == -1)
            {
                c_value = null;
            }
            else
            {
                c_start = c_value.indexOf("=", c_start) + 1;
                var c_end = c_value.indexOf(";", c_start);
                if (c_end == -1)
                {
                    c_end = c_value.length;
                }
                c_value = unescape(c_value.substring(c_start,c_end));
            }
            return c_value;
        },

        /*
         * deleteCookie deletes cookie
         * @method deleteCookie
         */
         deleteCookie :function(name) {
            document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:01 GMT;';
        }


};


    return myRampEditor;
}