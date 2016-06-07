<script type="text/template" class="template worldcat-step-one-view" id="worldcat-template-step-one">

    <% hideLoadingImage(); %>

    <div class="form_container worldcat-step-one-view">
        <div class="instruction_div">
            <h3 class="instruction">WorldCat Ingest</h3>
            <div class="user_help_form">
                <p class="user_help_text">Choose the best match <a href="docs.php#worldcat1" title="What is this?" target="_blank"><i class="fa fa-question-circle"></i></a></p>
                    <% _.each(lobjPossibleURI, function(lobjPossibleURI) {
                    var lstrTitle = typeof lobjPossibleURI.title == 'undefined' ? '': lobjPossibleURI.title;
                    var lstrURI = typeof lobjPossibleURI.uri == 'undefined' ? '': lobjPossibleURI.uri;
                    var lstrType = typeof lobjPossibleURI.type == 'undefined' ? '': lobjPossibleURI.type;
                    %>

                    <input type="radio" name="chosen_worldcat_uri" value="<%= lstrURI %>" /> 
                        <label class="input-label"><%= lstrTitle %></label>
                        <div class="preview-link"> <i class="fa fa-eye"></i> <a href="<%= lstrURI %>" target="_blank">preview</a></div>
                    <br>

                    <% }); %>

                <button id="ingest_worldcat_chosen_uri" class="pure-button ramp-button ingest-ok">Next</button>
                <button id="ingest_worldcat_chosen_uri_cancel" class="pure-button ramp-button ingest-cancel">Cancel</button>
            </div>
        </div>
    </div>

</script>


<script type="text/template" class="template  worldcat-step-two-view" id="worldcat-template-step-two">

    <% hideLoadingImage(); %>

    <div class="form_container worldcat-step-two-view">
        <div class="instruction_div">
            <h3 class="instruction">WorldCat Ingest</h3>

            <div class="user_help_form">
                <p class="user_help_text">Choose any appropriate subjects related to the entity <a href="docs.php#worldcat2" title="What is this?" target="_blank"><i class="fa fa-question-circle"></i></a></p>

                <input type="checkbox" id="select_all" value=""><span>Select all</span><br />

                <table class="user_help_form_table">

                    <% _.each(lobjPossibleSubjects, function(lobjPossibleSubject, index) { %>
                    <tr>
                       <td><input type="checkbox" name="chosen_subjects" value="<%= index %>" /></td><td>  <%= lobjPossibleSubject.elements.term.elements %> </td>
                       </tr>
                    <% }); %>

                    </table>

                <button id="ingest_worldcat_chosen_subjects" class="pure-button ramp-button ingest-ok">Next</button>
                <button id="skip_worldcat_chosen_subjects" class="pure-button ramp-button">Skip</button>
                <button id="ingest_worldcat_chosen_subjects_cancel" class="pure-button ramp-button ingest-cancel">Cancel</button>
            </div>

        </div>
    </div>

</script>