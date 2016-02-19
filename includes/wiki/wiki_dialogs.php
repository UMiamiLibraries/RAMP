<div class="wikipedia-dialog" id="dialog-form-confirm" title="Confirm">
    <form> 
        <fieldset> 
            <button class="update_button pure-button pure-button-primary value="Yes"/> 
        </fieldset> 
        <fieldset> 
            <button class="update_button pure-button pure-button-primary value="No"/> 
        </fieldset> 
    </form></div>

<div class="wikipedia-dialog" id="dialog-form-login" title="Please log in to Wikipedia.">
<p class="validate-prompt">Cannot be blank!</p> 
<form> 
    <fieldset> 
        <label for="username">Username</label> 
        <input type="input" size="35" name="username" id="username" class="text ui-widget-content ui-corner-all" value=""/> 
    </fieldset> 
    <fieldset> 
        <label for="password">Password</label> 
        <input type="password" size="35" name="password" id="password" class="text ui-widget-content ui-corner-all" value=""/> 
    </fieldset> 
</form></div>

<div class="wikipedia-dialog" id="dialog-form-search" title="Search Wikipedia">
<p class="validate-prompt">Cannot be blank!</p> 
<form> 
    <fieldset> 
        <label for="search">Search</label> 
        <input type="text" size="35" name="search" id="search" class="text ui-widget-content ui-corner-all" value="" + decode_utf8(lstrSearch) + ""/> 
    </fieldset> 
</form></div>

<div class="wikipedia-dialog" id="dialog-form-title" title="Wiki Title">
<p class="validate-prompt">Cannot be blank!</p> 
<form> 
    <fieldset> 
        <label for="title">Title</label> 
        <input type="text" size="35" name="title" id="title" class="text ui-widget-content ui-corner-all" value="" + decode_utf8(eac_name) + ""/> 
    </fieldset> 
</form></div>

<div class="wikipedia-dialog" id="dialog-form-comment" title="Wikipedia Comment">
<p class="validate-prompt">Cannot be blank!</p> 
<form> 
    <fieldset> 
        <label for="title">Edit summary</label> 
        <input name="comments" id="comments" size="100" maxlength="300" value="... using the [[Wikipedia:Tools/RAMP_editor|RAMP editor]]." /> 
    </fieldset> 
</form></div>