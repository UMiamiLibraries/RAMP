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

            //bestmatch actions
            myWorldcatIngest.call_bestmatch_index();
            myWorldcatIngest.call_bestmatch_next_button();
            myWorldcatIngest.call_bestmatch_cancel_button();

            //subjects actions
            myWorldcatIngest.call_wc_subjects_next_button();
            myWorldcatIngest.call_wc_subjects_cancel_button();

            //editor actions
            myWorldcatIngest.call_wc_editor_next_button();
            myWorldcatIngest.call_wc_subjects_cancel_button();
        },
        init : function() {

            //bindUiActions
            myWorldcatIngest.bindUiActions();

            //hide index pages initially
            myWorldcatIngest.hide_by_div_id('wc_bestmatch_index_wrapper');
            myWorldcatIngest.hide_by_div_id('wc_subjects_index_wrapper');
            myWorldcatIngest.hide_by_div_id('wc_editor_index_wrapper');


        },

        hide_by_div_id : function(id) {
            $('#' + id).hide();
        },

        show_by_div_id : function(id) {
            $('#' + id).show();
        },

        call_bestmatch_index : function() {

            //show the bestmatch index viewport
            $('#worldcat_search_button').on('click', function () {
                myWorldcatIngest.show_by_div_id('wc_bestmatch_index_wrapper');
            });
        },

        call_bestmatch_next_button : function() {

            //hide the bestmatch index viewport & show subjects index viewport
            $('#wc_bestmatch_next_button').on('click', function () {

                myWorldcatIngest.hide_by_div_id('worldcat_search_term_form');
                myWorldcatIngest.hide_by_div_id('wc_bestmatch_index_wrapper');

                myWorldcatIngest.show_by_div_id('wc_subjects_index_wrapper');
            });

        },

        call_bestmatch_cancel_button : function () {

        },

        call_wc_subjects_next_button : function() {

            //hide the subjects viewport & show editor index viewport
            $('#wc_subjects_next_button').on('click', function () {
                myWorldcatIngest.hide_by_div_id('wc_subjects_index_wrapper');

                myWorldcatIngest.show_by_div_id('wc_editor_index_wrapper');
            });
        },

        call_wc_subjects_cancel_button : function() {

        },

        call_wc_editor_next_button : function() {

            //hide the editor index viewport & show
            $('#wc_editor_next_button').on('click', function () {
                myWorldcatIngest.hide_by_div_id('wc_subjects_index_wrapper');


            });
        },

        call_wc_editor_cancel_button : function() {

        }

    };

    return myWorldcatIngest;
}