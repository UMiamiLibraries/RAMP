<script type="text/template" id="wikipedia-template-step-one">

    <div class="form_container">
        <div class="instruction_div">
            <h3 class="instruction">Search Wikipedia</h3>

            <div class="user_help_form">
                <label for="searchwikipedia">Search</label>
                <input type="text" size="35" name="searchwikipedia" id="manual_search_wikipedia" class="text ui-widget-content ui-corner-all" />
                <button id="searchwikipediabutton" class="pure-button ramp-button">Search</button>

                <p class="user_help_text">Choose the best match <a href="#" title="What is this?"><i class="fa fa-question-circle"></i></a></p>
                <p class="form_note">Wikipedia&#39;s search index is updated every morning. New pages will take a day to show up in the index.</p>
                    <table class="user_help_form_table">
                        <%
                        _.each(lobjTitles,function (lobjTitle) {
                        %>
                        <tr>
                            <td>
                                <input type="radio" name="chosen_title" class="title_chosen" value="<%= lobjTitle.title %>"/>
                                <span> <%= lobjTitle.title %></span>
                                <br/>
                                <dl>
                                    <dd><%= lobjTitle.snippet %></dd>
                                </dl>
                            </td>
                        </tr>
                        <%
                        });
                        %>

                    </table>

                    <button id="get_chosen_wiki" class="pure-button ramp-button">Next</button>
                    <button id="get_chosen_wiki_no_match" class="pure-button ramp-button">No Match (Create New)</button>
                    <button id="get_chosen_wiki_cancel" class="pure-button ramp-button">Cancel</button>
            </div>
        </div>
    </div>
</script>



<script type="text/template" id="wikipedia-template-step-two">

    <div class="pure-g">
        <div class="pure-u-1-2">
            <p>Local Article</p>
            <textarea id="localMarkupEditor" rows="10" cols="30"></textarea>
        </div>


        <div class="pure-u-1-2">
            <p>Wikipedia Article</p>
            <textarea id="remoteMarkupEditor" rows="10" cols="30"></textarea>
        </div>

    </div>

    <button id="post_draft_wiki" class="pure-button ramp-button wiki_edit">Submit to Wikipedia as Draft</button>
    <button id="post_wiki" class="pure-button ramp-button wiki_edit">Submit to Wikipedia</button>

</script>





<script type="text/template" id="wikipedia-template-captcha">
    <div class="form_container_captcha">
        <div class="user_help_form">
            <div id="captcha_div"><h3 class="captcha">Please Solve CAPTCHA</h3><br/>
                <img class="captcha" src="<%= lstrUrl %>"/><br/>
                <input class="captcha" id="captcha_input" name="captcha_ans" type="text"/><br/>
                <button id="try_with_captcha" class="captcha pure-button pure-button-secondary">Try again</button>
            </div>
        </div>
    </div>
</script>
