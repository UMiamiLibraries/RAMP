/**
 * Created by cbrownroberts on 2/11/16.
 */


/*jslint browser: true*/
/*global $, jQuery, alert*/
function worldcatIngest() {
    "use strict";

    var myWorldcatIngest = {

        settings : {
        },
        strings : {
        },
        bindUiActions : function() {
        },
        init : function() {

            //hide index pages initially
            myWorldcatIngest.hide_index_wrapper('bestmatch_index_wrapper');

            myWorldcatIngest.hide_index_wrapper('subjects_index_wrapper');

            myWorldcatIngest.hide_index_wrapper('wc_editor_index_wrapper');


        },

        hide_index_wrapper : function(id) {
            $('#' + id).hide();
        },

        show_index_wrapper : function(id) {
            $('#' + id).show();
        }

    };

    return myWorldcatIngest;
}