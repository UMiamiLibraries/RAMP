/**
 * Created by cbrownroberts on 2/11/16.
 */


/*jslint browser: true*/
/*global $, jQuery, alert*/
function rampSetup() {
    "use strict";

    var myRampSetup = {
        settings : {

        },
        setupFunctions : [worldcatIngest, rampEditor],
        init : function() {

            for (var func in myRampSetup.setupFunctions) {

                var setupFunc = myRampSetup.setupFunctions[func]();
                setupFunc.init();
            }



        }
    }
    return myRampSetup;
}