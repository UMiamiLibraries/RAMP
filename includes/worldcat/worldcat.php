<script type="text/template" class="template" id="worldcat-template-step-one">

    <% hideLoadingImage(); %>

    <div class="form_container">
        <div class="instruction_div">
            <h2 class="instruction">Ingest from WorldCat Identities</h2>
            <div class="user_help_form">
                <p>Please choose the name that is the best match:</p>
                    <% _.each(lobjPossibleURI, function(lobjPossibleURI) {
                    var lstrTitle = typeof lobjPossibleURI.title == 'undefined' ? '': lobjPossibleURI.title;
                    var lstrURI = typeof lobjPossibleURI.uri == 'undefined' ? '': lobjPossibleURI.uri;
                    var lstrType = typeof lobjPossibleURI.type == 'undefined' ? '': lobjPossibleURI.type;
                    %>

                    <input type="radio" name="chosen_worldcat_uri" value="<%= lstrURI %>" /><a href="<%= lstrURI %>" target="_blank"> <%= lstrTitle %> </a><br>

                    <% }); %>

                <button id="ingest_worldcat_chosen_uri" class="pure-button pure-button-secondary ingest-ok">Next</button>
                <button id="ingest_worldcat_chosen_uri_cancel" class="pure-button pure-button-secondary ingest-cancel">Cancel</button>
            </div>
        </div>
    </div>

</script>


<script type="text/template" class="template" id="worldcat-template-step-two">

    <% hideLoadingImage(); %>

    <div class="form_container">
        <div class="instruction_div">
            <h2 class="instruction">Ingest from WorldCat Identities</h2>

            <div class="user_help_form">
                <p>Please choose any appropriate subjects related to this entity:</p>

                <input type="checkbox" id="select_all" value=""><span>Select all</span><br />

                <table class="user_help_form_table">

                    <% _.each(lobjPossibleSubjects, function(lobjPossibleSubject, index) { %>
                    <tr>
                       <td><input type="checkbox" name="chosen_subjects" value="<%= index %>" /></td><td>  <%= lobjPossibleSubject.elements.term.elements %> </td>
                       </tr>
                    <% }); %>

                    </table>

                <button id="ingest_worldcat_chosen_subjects" class="pure-button pure-button-secondary ingest-ok">Next</button>
                <button id="ingest_worldcat_chosen_subjects_cancel" class="pure-button pure-button-secondary ingest-cancel">Cancel</button>
            </div>

        </div>
    </div>

</script>