<?php
/**
 * Created by PhpStorm.
 * User: cbrownroberts
 * Date: 2/11/16
 * Time: 10:13 AM
 */

?>

<form class="pure-form">
    <label for="option-one" class="pure-checkbox">
        <input id="option-one" type="checkbox" value="">
        Here's option one.
    </label>

    <label for="option-two" class="pure-radio">
        <input id="option-two" type="radio" name="optionsRadios" value="option1" checked>
        Here's a radio button. You can choose this one..
    </label>

    <label for="option-three" class="pure-radio">
        <input id="option-three" type="radio" name="optionsRadios" value="option2">
        ..Or this one!
    </label>
    <button type="submit" class="pure-button">Next</button>
    <button type="submit" class="pure-button">Cancel</button>
</form>
