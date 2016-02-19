var viewSwitch = {
    reset : function() {
        $('[class$=-view]').hide();
    },
    showWorldCatStepOne : function() {
        viewSwitch.reset();
        $('.worldcat-step-one-view').show();
    },
    showWorldCatStepTwo : function() {
        viewSwitch.reset();
        $('.worldcat-step-two-view').show();
    },
    showWorldCatStepThree : function() {
        viewSwitch.reset();
        $('.worldcat-step-three-view').show();
    },
    showViafStepOne : function() {
        viewSwitch.reset();
        $('.viaf-step-one-view').show();
    },
    showViafStepTwo : function() {
        viewSwitch.reset();
        $('.viaf-step-two-view').show();

    },
    showViafStepThree : function() {
        viewSwitch.reset();
        $('.viaf-step-three-view').show();

    },
    showWikiStepOne : function() {
        viewSwitch.reset();
        $('.wikipedia-step-one-view').show();
    }
};