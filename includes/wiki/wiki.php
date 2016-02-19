<script type="text/template" id="wikipedia-template-step-one">
    <div class="form_container">
        <div class="user_help_form">
            <h2>Please choose page to import from Wikipedia:</h2>
            <p class="form_note">Wikipedia&#39;s search index is updated every morning. New pages will take a day to
                show up in the index.</p>
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

        </div>

        <button id="get_chosen_wiki" class="pure-button pure-button-secondary">Use Selected Title</button>
        <button id="get_chosen_wiki_no_match" class="pure-button pure-button-secondary">No Match (Create New)</button>
        <button id="get_chosen_wiki_cancel" class="pure-button pure-button-secondary">Cancel</button>
    </div>
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