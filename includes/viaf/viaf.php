<script type="text/template" class="template viaf-step-one-view" id="viaf-template-step-one">
    <div class="pure-g form_container">

        <div class="instruction_div pure-u-1">
            <h2 class="instruction">Authority Control: Ingest from VIAF</h2>

            <div class="user_help_form">

                <p>Choose the best match for this name:</p>
                <% _.each(lobjPossibleViaf, function(possibleViaf) { %>

                <input type="radio" name="chosen_viaf_id" value="<%= possibleViaf.viaf_id %>"/>
                <a href="http://viaf.org/viaf/<%= possibleViaf.viaf_id %>" target="_blank"> <%= possibleViaf.name %></a><br>

                <% }); %>

            </div>

            <button id="ingest_viaf_chosen_viaf" class="pure-button ingest-ok pure-button-secondary" >Use Selected VIAF</button>
            <button id="ingest_viaf_chosen_viaf_cancel" class="pure-button ingest-cancel pure-button-secondary">Cancel</button>
        </div>

    </div>

</script>

<script type="text/template" class="template viaf-step-two-view" id="viaf-template-step-two">
    <div class="form_container pure-g">
        <div class="instruction_div pure-u-1">
            <h2 class="instruction">Named Entity Recognition</h2>

            <div class="user_help_form">
               <p>Please choose names to create &lt;cpfRelation&gt; elements:</p>
                <input type="checkbox" id="select_all" value=""><span>Select all</span><br />

                <table class="user_help_form_table">

                    <% _.each(lobjPossibleNames, function(possibleName) { %>

                    <tr><td><input type="checkbox" class="ner_check" name="chosen_names" value=""/></td>
                        <td><input type="text" class="ner_text" name="modified_names" size="60" value=" <%= possibleName %> "/></td>
                       <td><input type="button" name="add" value="Add New Row" class="ner_empty_add pure-button pure-button-secondary"/></td></tr>
                    <% }); %>

                    </table>
              </div>

            <button id="ingest_viaf_chosen_names_relations" class="pure-button ingest-ok pure-button-secondary">Use Selected Names</button>
            <button id="ingest_viaf_chosen_names_relations_cancel" class="pure-button ingest-cancel pure-button-secondary">Cancel</button>
         </div>
    </div>
</script>


<script type="text/template" class="template viaf-step-three-view" id="viaf-template-step-three">

<div class="form_container">
 <div class="instruction_div"><h2 class="instruction">Named Entity Recognition</h2>


<div class="user_help_form">

<h2>Please choose appropriate matches from VIAF (the original string you searched for appears first, before the colon):</h2>
<input type="checkbox" id="select_all" value=""><span>Select all</span><br />

    <table class="user_help_form_table">
                <% for (var lstrName in lobjViafResults) {
                    var lstrNameViaf = lstrName.match(/viaf/gi);
                    var lstrNamePlain = lstrName.match(/[^(viaf)]/gi);

                if (lstrNameViaf != null) {

                %>
<tr><td><input type="checkbox" class="viaf_check" name="chosen_results" value="<%= lstrName.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;') %>" />
    </td><td><%= lstrName %></td>
</tr>
            <%
                } else // Filter out VIAF results. --timathom
                {
            %>

        <tr>
            <td>

            </td>
        </tr>

        <tr id="user_rel">
            <td></td>
            <td class="message">No appropriate matches from VIAF? Add &lt;cpfRelation&gt; using the original search
                string:
            </td>
        </tr>
        <tr class="user_plain_row">
            <td><input type="checkbox" class="viaf_check" name="chosen_results" value=""/></td>
            <td id="plainText"><span id="textSpan">  <%= lstrName %> </span>
        <span id="select_wrap">
            <select id="ents" name="entities"
                    title="For non-VIAF entries, you must choose an entity type. For VIAF entries (the ones with links), the entity type has been predefined.">
                <option value="">Entity Type</option>
                <option value=""></option>
                <option value="pers">Person</option>
                <option value="corp">CorporateBody</option>
                <option value="fam">Family</option>
            </select>
 <select id="rels" name="relType"
         title="For non-VIAF entries, you may choose among different relation types. If you do not choose a relation type, the default value is 'associative.'">
     <option value="">Relation Type</option>
     <option value=""></option>
     <option value="assoc">associative</option>
     <option value="ident">identity</option>
     <option value="hier">hierarchical</option>
     <option value="hier-par">hierarchical-parent</option>
     <option value="hier-ch">hierarchical-child</option>
     <option value="temp">temporal</option>
     <option value="temp-ear">temporal-earlier</option>
     <option value="temp-lat">temporal-later</option>
     <option value="fam">family</option>
 </select>
        </span>
            </td>
        </tr>

        <%
                }
        }
            %>

</table>

 </div>




<button id="ingest_viaf_add_relations" class="pure-button ingest-ok pure-button-secondary" >Use Selected Results</button>
<button id="ingest_viaf_add_relations_cancel" class="pure-button ingest-cancel pure-button-secondary" >Cancel</button>

 </div>

</div>
</script>
