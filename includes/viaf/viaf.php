<script type="text/template" class="template viaf-step-one-view" id="viaf-template-step-one">

    <% hideLoadingImage(); %>

    <div class="form_container viaf-step-one-view">
        <div class="instruction_div">
            <h3 class="instruction">VIAF Ingest</h3>

            <div class="user_help_form">
                <p class="user_help_text">Choose the best match <a href="#" title="What is this?"><i class="fa fa-question-circle"></i></a></p>
                <% _.each(lobjPossibleViaf, function(possibleViaf) { %>

                <input type="radio" name="chosen_viaf_id" value="<%= possibleViaf.viaf_id %>"/>
                    <label class="input-label"><%= possibleViaf.name %></label>
                    <div class="preview-link"> <i class="fa fa-eye"></i>
                    <a href="http://viaf.org/viaf/<%= possibleViaf.viaf_id %>" target="_blank">preview</a></div>
                <br>

                <% }); %>
            
                <button id="ingest_viaf_chosen_viaf" class="pure-button ramp-button ingest-ok">Next</button>
                <button id="ingest_viaf_chosen_viaf_cancel" class="pure-button ramp-button ingest-cancel">Cancel</button>            
            </div>
        </div>
    </div>

</script>


<script type="text/template" class="template viaf-step-two-view" id="viaf-template-step-two">

    <div class="form_container viaf-step-two-view">
        <div class="instruction_div">
            <h3 class="instruction">VIAF Ingest</h3>

            <div class="user_help_form">
               <p class="user_help_text">Create CPF relation elements <a href="#" title="What is this?"><i class="fa fa-question-circle"></i></a></p>

                <input type="checkbox" id="select_all" value=""><span class="viaf-select-all">Select all</span><br />

                <table class="user_help_form_table">

                    <% _.each(lobjPossibleNames, function(possibleName) { %>

                    <tr><td><input type="checkbox" class="ner_check" name="chosen_names" value=""/></td>
                        <td class="cpf-entry"><input type="text" class="ner_text" name="modified_names" size="60" value=" <%= possibleName %> "/></td></tr>
                    <% }); %>

                    <tr><td colspan="3"><i class="fa fa-plus-square add-row-plus"></i> <input type="button" name="add" value="Add New CPF Relation..." class="pure-button ner_empty_add" /></td></tr>

                </table>             

                <button id="ingest_viaf_chosen_names_relations" class="pure-button ramp-button ingest-ok">Next</button>
                <button id="ingest_viaf_chosen_names_relations_cancel" class="pure-button ramp-button ingest-cancel">Cancel</button>
            </div>
        </div>
    </div>
</script>



<script type="text/template" class="template viaf-step-three-view" id="viaf-template-step-three">

<div class="form_container viaf-step-three-view">
    <div class="instruction_div">
        <h3 class="instruction">VIAF Ingest</h3>
        
        <div class="user_help_form">
            <p class="user_help_text">Create CPF relation elements <a href="#" title="What is this?"><i class="fa fa-question-circle"></i></a></p>

            <input type="checkbox" id="select_all" value=""><span>Select all</span><br />

            <table class="user_help_form_table">
                <% for (var lstrName in lobjViafResults) {
                    var lstrNameViaf = lstrName.match(/viaf/gi);
                    var lstrNamePlain = lstrName.match(/[^(viaf)]/gi);

                if (lstrNameViaf != null) {
                %>
                <tr>
                    <td>
                    <input type="checkbox" class="viaf_check" name="chosen_results" value="<%= lstrName.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;') %>" />

                    </td>
                    <td><%= lstrName %></td>
                </tr>
                <%
                    } else // Filter out VIAF results. --timathom
                    {
                %>        

                <tr id="user_rel">
                    <td>&nbsp;</td>
                    <td class="message">No appropriate matches from VIAF? Add a CPF Relation using the original search string:
                    </td>
                </tr>
        
                <tr class="user_plain_row">
                    <td><input type="checkbox" class="viaf_check" name="chosen_results" value=""/></td>
                    <td id="plainText"><span id="textSpan">  <%= lstrName %> </span>
                        <span id="select_wrap">
                            <select class="inline-select" id="ents" name="entities"
                                    title="For non-VIAF entries, you must choose an entity type. For VIAF entries (the ones with links), the entity type has been predefined.">
                                <option value="">Entity Type</option>
                                <option value=""></option>
                                <option value="pers">Person</option>
                                <option value="corp">CorporateBody</option>
                                <option value="fam">Family</option>
                            </select>
                             <select class="inline-select" id="rels" name="relType"
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

            <button id="ingest_viaf_add_relations" class="pure-button ramp-button ingest-ok">Next</button>
            <button id="ingest_viaf_add_relations_cancel" class="pure-button ramp-button ingest-cancel">Cancel</button>

        </div>
    </div>
</div>
</script>
