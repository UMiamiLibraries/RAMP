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
    showWorldCatStepTwo: function () {
        viewSwitch.reset();
        $('.worldcat-step-two-view').show();
    },
    showWorldCatStepThree: function () {
        viewSwitch.reset();
        $('.worldcat-step-three-view').show();
    },
    removeWorldCatStepOne: function () {
        $('.form_container.worldcat-step-one-view').remove();
        $('.help_container.worldcat-step-one-view').remove();
    },
    removeWorldCatStepTwo: function () {
        $('.form_container.worldcat-step-two-view').remove();
        $('.help_container.worldcat-step-two-view').remove();
    },
    removeWorldCatStepThree: function () {
        $('.form_container.worldcat-step-three-view').remove();
        $('.help_container.worldcat-step-three-view').remove();
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
    removeViafStepOne: function () {
        $('.form_container.viaf-step-one-view').remove();
        $('.help_container.viaf-step-one-view').remove();
    },
    removeViafStepTwo: function () {
        $('.form_container.viaf-step-two-view').remove();
        $('.help_container.viaf-step-two-view').remove();
    },
    removeViafStepThree: function () {
        $('.form_container.viaf-step-three-view').remove();
        $('.help_container.viaf-step-three-view').remove();
    },
    showWikiStepOne: function () {
        viewSwitch.reset();
        $('.wikipedia-step-one-view').show();
    },
    showWikiStepTwo: function () {
        viewSwitch.reset();
        $('.wikipedia-step-two-view').show();
    },
    showWikiStepThree: function () {
        viewSwitch.reset();
        $('.wikipedia-step-three-view').show();
    },
    removeWikiStepOne: function () {
        $('.form_container.wiki-step-one-view').remove();
        $('.help_container.wiki-step-one-view').remove();
    },
    removeWikiStepTwo: function () {
        $('.form_container.wiki-step-two-view').remove();
        $('.help_container.wiki-step-two-view').remove();
    },
    removeWikiStepThree: function () {
        $('.form_container.wiki-step-three-view').remove();
        $('.help_container.wiki-step-three-view').remove();
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