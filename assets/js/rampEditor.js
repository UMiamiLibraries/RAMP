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

            myRampEditor.liveValidateXml();

            myRampEditor.setReadOnly();

            myRampEditor.toggleReadOnly();
        },

        cookieCheck : function() {

            if (myRampEditor.getCookie('ead_file')) {

                if (myRampEditor.getCookie('ead_file') === '""')
                {
                    $('#worldcat_search_term_text').hide();
                    $('#worldcat_search_term_text').html('Please select a record to edit from the menu.');
                    $('#worldcat_search_term_text').show();
                }
                else
                {
                    console.log(myRampEditor.getCookie('ead_file'));

                    $('#worldcat_search_term_text').html('Now Editing: ' + myRampEditor.getCookie('entity_name'));
                    $('#wc_name_search_term_input').val( myRampEditor.getCookie('entity_name'));

                    //build the ace editor
                    myRampEditor.buildEditor(myRampEditor.getCookie('ead_file'));

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
        },


        buildEditor : function(eac_xml_file){

            $('#xml_switch_button').css({"background":"gray"});

            $('.main_edit').show();

            // When one of the files is selected...
            var eac_xml_path = eac_xml_file;

            // Check to see if there is already wiki markup. If so, show switcher. --timathom
            $.get('get_wiki.php', {ead_path : eac_xml_path}, function(markup) {

                if ( markup == '')
                {
                    $('#wiki_switch').hide();
                }
                else
                {
                    $('#wiki_switch').show();
                    // Set "saved" cookie. --timathom
                    if ( myRampEditor.getCookie('wiki') != 'present' )
                    {
                        document.cookie = 'wiki=present';
                    }
                }
            });


            //Get the XML

            $.get('get_eac_xml.php?eac=' + eac_xml_path , function (data) {

                // Set up Ace editor
                editor.getSession().setValue(data);
                editor.resize();
                editor.focus();


                // Stick the XML in Ace editor
                var edited_xml = editor.getSession().setUseWrapMode(true); // Set text wrap --timathom
                var edited_xml = editor.getValue();

                //enable ingest buttons
                $('.ingest_button').removeAttr('disabled');

                document.cookie = 'ead_file=""';

                // then validate the XML
                function callback(){};
                myRampEditor.validateXML(callback(), edited_xml);

                // Check to see if there is some existing wiki markup
                // wikiCheck();

            });



        },



        validateXML : function( callback, edited_xml ) {
            // POST some XML to validate.php and get back some JSON that includes either an response that says that it's valid or a JSON document that includes the errrors
            $.post('validate.php', {eac_xml: edited_xml}, function(data) {

                if(typeof callback == 'undefined')
                    callback = function(){};

                if (data.status === "valid") {
                    console.log('valid xml');
                    // Make the little Oxygen-esque square green if valid
                    $('#validation').css({"background-color":"green"});

                    // Make the valdiation text area blank
                    $('#validation_text').html('Valid XML');

                    callback(true);

                } else {
                    var response = data;
                    // Make the Oxygen-esque square red
                    $('#validation').css({"background-color":"red"});

                    // Stick the error message into the validation_text div
                    $('#validation_text').html('<p>Error: ' + response[0].message + '</p><p>Line: ' + response[0].line + '</p>');

                    callback(false);
                }

            },"json").fail(function() {
                $('#validation').css({"background-color":"red"});
                $('#validation_text').html('<p>Your XML is not well-formed or there is an issue with the validation service</p>');

                if(typeof callback == 'undefined')
                    callback = function(){};

                console.log("error");
                callback(false);
            });
        },

        liveValidateXml : function() {
            console.log('live validate');
            function callback(){};
            $('#editor').keyup(myRampEditor.throttle(function() {
                // When the user is typing, validate it
                var edited_xml = editor.getValue();
                myRampEditor.validateXML(callback(), edited_xml);

            }));
        },

        throttle : function(f, delay){
            var timer = null;
            return function(){
                var context = this, args = arguments;
                clearTimeout(timer);
                timer = window.setTimeout(function(){
                        f.apply(context, args);
                    },
                    delay || 500);
            };
        },

        setReadOnly : function() {
            editor.setReadOnly(true);
        },

        toggleReadOnly : function() {
            $('#editor_readonly_button').on('click', function () {

                if($('#editor_readonly_button').data('readonly') === 'on') {

                    editor.setReadOnly(false);
                    $('#editor_readonly_button').data('readonly', 'off');
                    $('#readonly_status').text('XML Editing Enabled');

                } else {

                    editor.setReadOnly(true);
                    $('#editor_readonly_button').data('readonly', 'on');
                    $('#readonly_status').text('XML Editing Disabled');

                }
            });
        }




};


    return myRampEditor;
}