var viewSwitch = {
    reset: function () {
        $('[class$=-view]').hide();

    },
    showHome: function () {
        viewSwitch.reset();
        $('.home-view').show();
    },
    showWorldCatStepOne: function () {
        viewSwitch.reset();
        $('.worldcat-step-one-view').show();
    },
    removeWorldCatStepOne: function () {
        $('.form_container.worldcat-step-one-view').remove();
        $('.help_container.worldcat-step-one-view').remove();
    },
    removeWorldCatStepTwo: function () {
        $('.form_container.worldcat-step-two-view').remove();
        $('.help_container.worldcat-step-two-view').remove();
    },
    showWorldCatStepTwo: function () {
        viewSwitch.reset();
        $('.worldcat-step-two-view').show();
    },
    showWorldCatStepThree: function () {
        viewSwitch.reset();
        $('.worldcat-step-three-view').show();
    },
    showViafStepOne: function () {
        viewSwitch.reset();
        $('.viaf-step-one-view').show();
    },
    showViafStepTwo: function () {
        viewSwitch.reset();
        $('.viaf-step-two-view').show();

    },
    showViafStepThree: function () {
        viewSwitch.reset();
        $('.viaf-step-three-view').show();

    },
    showWikiStepOne: function () {
        viewSwitch.reset();
        $('.wikipedia-step-one-view').show();
    },
    showAceEditor: function () {
        $('#aceEditor').show();
        $('.main_edit').show();

    },
    hideAceEditor: function () {
        $('#aceEditor').hide();
        $('.main_edit').hide();
    }
};