window.validateXML = function( callback, eacXml ) {


    // POST some XML to validate.php and get back some JSON that includes either an response that says that it's valid or a JSON document that includes the errrors
    $.post('ajax/validate.php', {eac_xml: eacXml}, function(data) {

        console.log(data);
        if(typeof callback == 'undefined')
            callback = function(){};

        if (data.status === "valid") {

            // Make the little Oxygen-esque square green if valid
            $('#validation').css({"background-color":"green"});

            // Make the valdiation text area blank
            $('#validation_text').html('Valid XML');

            //enable save xml button
            $('#save_eac').removeAttr('disabled');

            callback(true);

        } else {
            response = data;
            // Make the Oxygen-esque square red
            $('#validation').css({"background-color":"red"});

            // Stick the error message into the validation_text div
            $('#validation_text').html('<p>Error: ' + response[0].message + '</p><p>Line: ' + response[0].line + '</p>');

            callback(false);
        }

    },"json").fail(function() {
        $('#validation').css({"background-color":"red"});
        $('#validation_text').html('<p>Your XML is not well-formed or there is an issue with the validation service</p>');

        //disable save xml button
        $('#save_eac').attr('disabled', 'disabled');

        if(typeof callback == 'undefined')
            callback = function(){};

        console.log("error");
        callback(false);
    });
}