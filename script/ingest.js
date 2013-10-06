    $(document).ready(function()        
    		  {    		          		          		     
    		      //register click event that will start viaf ingest
    		      $('#ingest_viaf').on('click', function()    					  
    					   {
    					       $('.main_edit').hide();
    					       $('#wiki_switch').hide();    
    					       $('#entity_name').hide();
    					       
    					       document.cookie = "onWiki="; // Unset "onWiki" cookie. --timathom
    					       					       
    					       // $('#main_content').prepend('<img id="loading-image" src="style/images/loading.gif" alt="loading"/>');
    
    					       var lstrXML = editor.getValue();
    
    					       //cannot start ingestion without XML being loaded
    					       if( lstrXML == '' )
    					       {
    						   $('body').append("<div id=\"dialog\"><p>Must load EAC first!</p></div>");
    						   makeDialog('#dialog', 'Error!'); //display error
    
    						   $('#loading-image').remove();
    						   $('.ingest_button').show();
    						   $('#entity_name').show();
    						   $('.main_edit').show();
    						   return;
    					       }
    
    					       validateXML(function(lboolValid){
    
    						   //xml must be valid in order for viaf ingestion to begin
    						   if(lboolValid)
    						   {    						       
    						       var lobjeac = new eac();
    						       lobjeac.loadXMLString( lstrXML );
    
    						       //get first name entry part element in order to get name to search viaf
    						       var lobjNameEntryPart = lobjeac.getElement('//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'nameEntry\']/*[local-name()=\'part\']');
    						       var eac_name = typeof lobjNameEntryPart.childNodes[0] == 'undefined' ? "" : lobjNameEntryPart.childNodes[0].nodeValue;
    						       eac_name = eac_name.trim();
    						       eac_name = encode_utf8(eac_name);
    
    						       ingest_viaf_NameEntry_Sources( lobjeac, eac_name, function( )
    										      {    										          										      
    											  
    											  ingest_viaf_Relations(lobjeac, function( lstrMessage ){
    											      $('body').append("<div id=\"dialog_main\"><p>" + lstrMessage + "</p></div>");
    											      makeDialog('#dialog_main', 'Response'); //display response
    
    											      //    $('#loading-image').remove();
    											      //commented out by dgonzalez because ingest can be done multiple times
    											      //$('#ingest_viaf').attr("disabled", "disabled");
    											    
    											      $('.ingest_button').show();
    											      //$('#entity_name').show();
    											  });
    										      });
    						   }
    						   else
    						   {
    						       //display error when xml is not valid
    						       $('body').append("<div id=\"dialog\"><p>XML must be valid!</p></div>");
    						       makeDialog('#dialog', 'Error!');
    
    						       $('#loading-image').remove();
    						       $('.main_edit').show();
    						       $('.ingest_button').show();
    						       $('#entity_name').show();
    						   }
    					       });
    					   });
    
    		      //register click event that will start worlcat ingestion
    		      $('#ingest_worldcat').on('click', function()
    
    					       {                              
    						   $('.main_edit').hide();    						   
    						   $('#wiki_switch').hide();    
    						   $('#entity_name').hide();    						       						  
    						   document.cookie = "onWiki="; // Unset "onWiki" cookie. --timathom
    						   //$('#main_content').prepend('<img id="loading-image" src="style/images/loading.gif" alt="loading"/>');
    						   
    						   var lstrXML = editor.getValue();
    
    						   //cannot start ingestion without XML being loaded
    						   if( lstrXML == '' )
    						   {
    						       $('body').append("<div id=\"dialog\"><p>Must load EAC first!</p></div>");
    						       makeDialog('#dialog', 'Error!'); //display error
    
    						       $('#loading-image').remove();
    						       $('.main_edit').show();
    						       $('#entity_name').show();
    						       
    						       return;
    						   }
    
    						   validateXML(function(lboolValid){
    
    						       //xml must be valid in order for worlcat ingestion to begin
    						       if(lboolValid)
    						       {    							   
    							   var lobjeac = new eac();
    							   lobjeac.loadXMLString( lstrXML );
    
    							   //get first name entry part element in order to get name to search WorldCat
    							   var lobjNameEntryPart = lobjeac.getElement('//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'nameEntry\']/*[local-name()=\'part\']');
    							   var eac_name = typeof lobjNameEntryPart.childNodes[0] == 'undefined' ? "" : lobjNameEntryPart.childNodes[0].nodeValue;
    							   eac_name = eac_name.trim();
    							   eac_name = encode_utf8(eac_name);
    
    							   ingest_worldcat_elements( lobjeac, eac_name, function(lstrMessage)
    										     {
    											 if( typeof lstrMessage != 'undefined' && lstrMessage != '' )
    											 {
    											     $('body').append("<div id=\"dialog_main\"><p>" + lstrMessage + "</p></div>");
    											     makeDialog('#dialog_main', 'Response'); //display response
    											 }
    
    											 $('#loading-image').remove();
    											 $('.ingest_button').show();
    											 $('.main_edit').show();
    											 $('#entity_name').show();
    										     });
    						       }else
    						       {
    							   //display error when xml is not valid
    							   $('body').append("<div id=\"dialog\"><p>XML must be valid!</p></div>");
    							   makeDialog('#dialog', 'Error!');
    
    							   $('#loading-image').remove();
    							   $('.main_edit').show();
    							   $('#entity_name').show();
    						       }
    						   });
    					       });
    		  });
    
    /*
     * ingest_viaf_NameEntry_Sources ingest name entries and sources from viaf using API into passed EAC DOM Document. Using passed name to search Viaf.
     * @method ingest_viaf_NameEntry_Sources
     */
    function ingest_viaf_NameEntry_Sources( lobjEac, lstrName, callback )
    {
        //dialog form to confirm search string to use to search viaf
        $('body').append("<div id=\"dialog-form\" title=\"Viaf Search\"> \
    <p class=\"validate-prompt\">Please choose or click Cancel!</p> \
    <form> \
    <fieldset> \
    <label for=\"name\">Name</label> \
    <input type=\"text\" size=\"35\" name=\"name\" id=\"name\" class=\"text ui-widget-content ui-corner-all\" value=\"" + decode_utf8(lstrName) + "\"/> \
    </fieldset> \
    </form></div>");
    
        $('#loading-image').remove();
                
        makePromptDialog('#dialog-form', 'VIAF Name Search', function(dialog)
    		     {
    			 var lstrName = $('input[name="name"]').val();
    
            		 if(lstrName == '')
            		 {
            		     //need name to continue
            		     $('.validate-prompt').show();
            		 }
            		 else
            		 {
            		     //close dialog
            		     $(dialog).dialog("close");
    			         $(dialog).remove();
    			         			      			    
    			     $('#main_content').prepend('<img id="loading-image" src="style/images/loading.gif" alt="loading"/>');
    
    			     lstrName = encode_utf8(lstrName);
    
    			     //post to ajax viaf ingestor controller to search viaf
            		     $.post( 'ajax/viaf_ingest_api.php', { 'action' : 'search', 'name' : lstrName }, function(response)
    				     {
    					 try
    					 {
    					     var lobjData = JSON.parse(response);      					     
    					 }
    					 catch(e) //response should be JSON so if not, throw error
    					 {    					     
    					     callback();
    					     $('body').append("<div id=\"dialog\"><p>No results found in VIAF for " + lstrName + ".</p></div>");
    						 makeDialog('#dialog', 'Response'); //display response   
    					     return;
    					 }
    
    					 display_possible_viaf_form( lobjData, function( lstrChosenViaf )
    								     {
    									     									 
    									 //post to ajax viaf ingestor controller to get source and name entry nodes from viaf record of chosen result
    									 $.post( 'ajax/viaf_ingest_api.php', { 'action' : 'source_and_name_entry', 'viaf_id' : lstrChosenViaf }, function(response)
    										 {
    										     try
    										     {
    											     var lobjData = JSON.parse(response);  
    											     //console.log(lobjData);
        											     
    										     }
    										     catch(e) //response should be JSON so if not, throw error
    										     {
    											 
    											 callback();
    											 return;
    											 
    										     }
    
    										     var lobjNameEntryList = typeof lobjData.name_entry_list == 'undefined' ? [] : lobjData.name_entry_list;
    										     var lobjSource = typeof lobjData.source == 'undefined' ? [] : lobjData.source;
    										     
    										     
    										     if ( lobjNameEntryList.length != 0 ) 
    										     {    										            										         										     	
         										     for( var i = 0; i < lobjNameEntryList.length; i++ )
         										     {
         											 var NameEntry = lobjNameEntryList[i];
         											 lobjEac.addNameEntry(NameEntry);
         										     }
         
         										     lobjEac.addSource( lobjSource );
         										     
         										     $('body').append("<div id=\"dialog\"><p>&lt;source&gt; and &lt;nameEntry&gt; elements added!</p></div>");
         					                         makeDialog('#dialog', 'Results'); // display results    

                                                     //set ace editor value to new xml from EAC Dom Document with ingested source and name entries
                                                     editor.getSession().setValue(lobjEac.getXML());					                             					                         
         					                         
         										     $('.form_container').remove();
         						                     $('.viaf_arrow').html("&#10003;");   

                                                     // Results notification added by timathom      
                                                     callback();
    						                     }    						                     
    						                     else
    						                     {
    						                         jQuery('html,body').animate({scrollTop:0},0); //scroll to top to view form correctly
    						                         
    						                         callback('');
    						                         $('body').append("<div id=\"dialog\"><p>Skipped VIAF ingest.</p></div>");
         					                         makeDialog('#dialog', 'Results'); // display results
    											     return;    
    						                     }
    						                     
    										 });
    								     });
        				     });
    			 }
    		     });
    }
    
    /*
     * display_possible_viaf_form displays a form for the editor to choose which viaf results is the correct one from the passed viaf results list
     * @method display_possible_viaf_form
     */
    function display_possible_viaf_form( lobjPossibleViaf, callback )
    {
        var lstrHTML = "<div class=\"form_container\">";
          
        lstrHTML += "<div class=\"instruction_div\"><h2 class=\"instruction\" style=\"font-weight:800; font-size:1.5em;\">Authority Control: Ingest from VIAF</h2><p class=\"instruction\">The purpose of this step is to get a unique identifier from the Virtual International Authority File (<a href=\"http://viaf.org\" title=\"Link to the Virtual International Authority File\" target=\"_blank\">VIAF</a>) for the entity you are working with, and then do Named Entity Recognition on the text of the entity's bio or finding aid in order to encode relationships.</p><p class=\"instruction\">The list on the right was retrieved from VIAF. Please examine the name(s) to see whether there is an appropriate match for the entity you are working with.</p><p class=\"instruction\">If you click on a name, you will be taken to its VIAF page, which may include additional information that will help you decide whether it is an appropriate match.</p><p class=\"instruction\">If there is not a good match, click \"Cancel\" to proceed to the next step (Named Entity Recognition).</p></div>";
    
        lstrHTML += "<button id=\"ingest_viaf_chosen_viaf\" class=\"pure-button ingest-ok pure-button-secondary\">Use Selected VIAF</button>";
        lstrHTML += "&nbsp;<button id=\"ingest_viaf_chosen_viaf_cancel\" class=\"pure-button ingest-cancel pure-button-secondary\">Cancel</button>";
    
    
        lstrHTML += "<div class=\"user_help_form\">";
        lstrHTML += "<h2>Choose the best match for this name:</h2>";
    
        //go through list and display results as radio buttons for editor to choose
        for(var i = 0; i < lobjPossibleViaf.length; i++)
        {
    	var lstrViafID = typeof lobjPossibleViaf[i].viaf_id == 'undefined' ? '' : lobjPossibleViaf[i].viaf_id;
    	var lstrName = typeof lobjPossibleViaf[i].name == 'undefined' ? '' : lobjPossibleViaf[i].name;	    	
    	lstrHTML += "<input type=\"radio\" name=\"chosen_viaf_id\" value=\"";
    	lstrHTML += lstrViafID + "\" /><a href=\"http://viaf.org/viaf/" + lstrViafID + "\" target=\"_blank\">" + lstrName + "</a><br />";
        }        
            
        lstrHTML += "</div></div>";
    
        $('body').append(lstrHTML);
        jQuery('html,body').animate({scrollTop:0},0); //scroll to top to view form correctly
    
        //register click event to continue process once user chosesviaf results
        $('#ingest_viaf_chosen_viaf').on('click', function()
    				     {
    					 var lstrChosenViaf = $('input[name="chosen_viaf_id"]:checked').val();
    
    					 if( typeof lstrChosenViaf == 'undefined')
    					 {
    					     $('body').append("<div id=\"dialog\"><p>Please choose or click Cancel!</p></div>");
    					     makeDialog('#dialog', 'Error!'); // display error
    					 }else
    					 {
    					     callback(lstrChosenViaf);
    					     $('.form_container').remove();
    					     $('.main_edit').hide();         					     
    					 }
    				     });
    
        //register click event to cancel process
        $('#ingest_viaf_chosen_viaf_cancel').on('click', function()
    					    {    					        					   
    					    
    					    callback('');       	    					        					   
    						//$('.form_container').remove();
                            //$('#loading-image').remove();
                            //$('.viaf_arrow').html("&#10003;");   
                            //$('#entity_name').show();
                            //$('.main_edit').show();
                            
                            // Check to see if there is already wiki markup. If so, show switcher. --timathom
                            /*
                            if ( getCookie('wiki') == 'present' )   
                            {
                                $('#wiki_switch').show();    	                           	
                            }
                            else
                            {
                                $('#wiki_switch').hide();
                            }
                            */
                             
    					    });
    }
    
    /*
     * ingest_viaf_Relations ingest relations from viaf using API into passed EAC DOM Document.
     * @method ingest_viaf_Relations
     */
    function ingest_viaf_Relations( lobjEac, callback )
    {
        //need to get ead to get possible names and titles list
        $.post( 'ajax/get_ead.php', { 'ead' : getCookie('ead_file_last') }, function(lstrXML)
    	    {
    		var lobjead = new ead();
    		lobjead.loadXMLString( lstrXML );
    
            var PossibleNameList = [];
    		var PossibleNameListBio = [];
    		var PossibleNameListUnit = [];
            var PossibleNameListIngest = [];

    		var lobjParagraphList = lobjEac.getParagraph();
    		var lobjUnitTitleList = lobjead.getElementList('//*[local-name()=\'unittitle\']');
    		var lobjIngestList = lobjEac.getElementList('//*[local-name()=\'resourceRelation\'][@resourceRelationType=\'creatorOf\']/*[local-name()=\'relationEntry\'][1] | //*[local-name()=\'resourceRelation\'][not(@resourceRelationType)]/*[local-name()=\'relationEntry\'][1] | //*[local-name()=\'resourceRelation\'][@resourceRelationType=\'subjectOf\']/*[local-name()=\'relationEntry\'][@localType=\'creator\'] | //*[local-name()=\'resourceRelation\'][@resourceRelationType=\'subjectOf\']/*[local-name()=\'relationEntry\'][1]');    		    		 
    		
    		// XPath for getting things wrapped in <span> tags:
    		//var lobjSpanList = lobjead.getElementList('//*[local-name()=\'unittitle\']/*[local-name()=\'span\']');
    		//lobjSpanList = lobjSpanList.concat(lobjEac.getElementList('//*[local-name()=\'cpfDescription\']/*[local-name()=\'description\']/*[local-name()=\'biogHist\']/*[local-name()=\'p\']//*[local-name()=\'span\']'));    		       
                
    		for(var i = 0; i < lobjParagraphList.length; i++)
    		{
    		    if( typeof lobjParagraphList[i].childNodes[0] == 'undefined' )
    			continue;
    
    		    var lstrParagraph = lobjParagraphList[i].childNodes[0].nodeValue;
    
    		    if( lstrParagraph == null || lstrParagraph == '' )
    			continue;
    
    		    //apply regex to elements to find all possible names to search viaf for relations
    		    //lobjPossibleTitles = lstrParagraph.match(/["\u201D\u201C]([^"\u201D\u201C]+)["\u201D\u201C]/g);
    		    //lstrParagraph = lstrParagraph.replace(/["\u201D\u201C]([^"\u201D\u201C]+)["\u201D\u201C]/g, "");
    		    var lobjPossibleNamesBio = lstrParagraph.match(/((\sde\s)*?[A-Z\u00C0\u00C1\u00C3\u00C7\u00C9\u00CA\u00CD\u00D3\u00DA\u00DC\u00D4\u00D5\u00D6][a-z\u00E0\u00E1\u00E3\u00E7\u00E9\u00EA\u00ED\u00F0\u00F3\u00F4\u00F5\u00FA\u00FC\u00F1\u0026\-']+((\s?[0-9][0-9])*(\s?[0-9][0-9])*([-])*)*([,]*?)(\s\u0026|\sof|\sf\u00FCr|\sdes|\set|\sde\sla|\sde\s|\sdel|\sde)?\s*([A-Z\u00C1\u00C9\u00CD\u00D3\u00DA\u00DC\u00D6][.]\s*)*(e\s|y\s|of\s|f\u00FCr\s|des\s|et\s|y\sdel\s|y\sde\sla\s|de\sla\s|del\s|de\slos\s|de\s|do\s|da\s|dos\s|das\s)?){2,9}/g);
     		    //lstrParagraph.match(/((\sde\s)*?[A-Z\u002E\u00DC\u0300\u0301\u0302\u0303\u0304\u0305\u0306\u0307\u0308\u00C0\u00C1\u00C3\u00C7\u00C9\u00CA\u00CD\u00D3\u00DA\u00DC\u00D4\u00D5\u00D6][a-z\u002E\u00FC\u0300\u0301\u0303\u0308\u030B\u030E\u00E0\u00E1\u00E3\u00E7\u00E9\u00EA\u00ED\u00F0\u00F3\u00F4\u00F5\u00FA\u00FC\u00F1\-']+(\s[0-9][0-9])?([,]*?)(\sof|\sfu\u0308r|\sdes|\set|\sde\sla|\sde\s|\sdel|\sde|\svon|\svan)?\s*([A-Z\u002E\u00C1\u00C9\u00CD\u00D3\u00DA\u00DC\u00D6][.]\s*)*(of\s|fu\u0308r\s|des\s|et\s|y\sdel\s|y\sde\sla\s|de\sla\s|del\s|de\slos\s|e\s|y\s|de\s|von\s|van\s)?){2,8}/g);    		                               
    		                               
    		    // Attempt to get substring before/after regex match. In development. --timathom
    		    //var NameIndex = []; 
    		    //var NameIndexList = [];
    		    
    		    if( lobjPossibleNamesBio == null || lobjPossibleNamesBio.length == 0 )
    		    {
         			continue;    			         			
    		    }
    		    else
    		    {
    		        for( var j = 0; j < lobjPossibleNamesBio.length; j++ )
         			{         			             			             	         			        	        	  
         			             			             			  
         			    var lstrPossibleNameBio = lobjPossibleNamesBio[j];         			             			    
         			    
         			    lstrPossibleNameBio = lstrPossibleNameBio.trim();
    			            			                         
         			    PossibleNameListBio.push( lstrPossibleNameBio );
         			    
         			    //Attempt to get substring before/after regex match. In development. --timathom
         			    
         			    //lstrNameMatch = lstrParagraph.indexOf(lstrPossibleNameBio);
         			    
         			    //NameIndex.push(lstrNameMatch);
         			    
         			    /* 
         			    for (var y = 0; y < NameIndex.length; y++)
                   	    {
                   	       
                   	       var lstrBeforeName = lstrParagraph.substring(NameIndex[y]-50, NameIndex[y])
                   	       var lstrAfterName = lstrParagraph.substring(NameIndex[y],NameIndex[y]+50)
                   	       
                   	       NameIndexList.push(lstrBeforeName);
                   	       NameIndexList.push(lstrPossibleNameBio);
                   	       NameIndexList.push(lstrAfterName);
                   	        
                   	    }
                   	    */
         			    
         			}     
    		    }    		   
      		}
      		for(var i = 0; i < lobjUnitTitleList.length; i++)
    		{
    		    if( typeof lobjUnitTitleList[i].childNodes[0] == 'undefined' )
    			continue;
    
    		    var lstrUnitTitle = lobjUnitTitleList[i].childNodes[0].nodeValue;
    
    		    if( lstrUnitTitle == null || lstrUnitTitle == '' )
    			continue;
    			
    			var lobjPossibleNamesUnit = lstrUnitTitle.match(/((\sde\s)*?[A-Z\u00DC\u0300\u0301\u0302\u0303\u0304\u0305\u0306\u0307\u0308\u00C0\u00C1\u00C3\u00C7\u00C9\u00CA\u00CD\u00D3\u00DA\u00DC\u00D4\u00D5\u00D6][a-z\u00FC\u0026\u0300\u0301\u0303\u0308\u030B\u030E\u00E0\u00E1\u00E3\u00E7\u00E9\u00EA\u00ED\u00F0\u00F3\u00F4\u00F5\u00FA\u00FC\u00F1\-'\.]+((\s?[0-9][0-9])*(\s?[0-9][0-9])*([-])*)*([,])*?(\s\u0026|\sof|\sf\u00FCr|\sdes|\set|\sde\sla|\sde\s|\sdel|\sde|\svon|\svan)?\s*([A-Z\u00C1\u00C9\u00CD\u00D3\u00DA\u00DC\u00D6][.]\s*)*(of\s|f\u00FCr\s|des\s|et\s|y\sdel\s|y\sde\sla\s|de\sla\s|del\s|de\slos\s|e\s|y\s|de\s|von\s|van\s|[,]\s)?){2,9}/g);    			                            
    			if ( lobjPossibleNamesUnit == null || lobjPossibleNamesUnit.length == 0 )
    			{
    			    continue;   		
    			}
    			else
    			{
    			    for( var j = 0; j < lobjPossibleNamesUnit.length; j++ )
    			    {
    			        var lstrPossibleNameUnit = lobjPossibleNamesUnit[j];
         			    lstrPossibleNameUnit = lstrPossibleNameUnit.trim();
    			    
        			    // Strip any trailing commas. --timathom
         			    var lstrLastChar = lstrPossibleNameUnit.substr( lstrPossibleNameUnit.length - 1 );
         			    
         			    if( lstrLastChar == "," )
    			        {
    				        lstrPossibleNameUnit = lstrPossibleNameUnit.slice(0, -1);
    			        }                                
         			    PossibleNameListUnit.push( lstrPossibleNameUnit );
         			}      
    			}    			
    	    }
    	    
    	    for(var i = 0; i < lobjIngestList.length; i++)
    		{
    		    if( typeof lobjIngestList[i].childNodes == 'undefined' )
    			continue;
    
    		    var lstrIngest = lobjIngestList[i].childNodes[0].nodeValue;
    
    		    if( lstrIngest == null || lstrIngest == '' )
    			continue;
    			
    			var lobjPossibleNamesIngest = lstrIngest.match(/((\sde\s)*?[A-Z\u00DC\u0300\u0301\u0302\u0303\u0304\u0305\u0306\u0307\u0308\u00C0\u00C1\u00C3\u00C7\u00C9\u00CA\u00CD\u00D3\u00DA\u00DC\u00D4\u00D5\u00D6][a-z\u00B4\u00FC\u0026\u0300\u0301\u0303\u0308\u030B\u030E\u00E0\u00E1\u00E3\u00E7\u00E9\u00EA\u00ED\u00F0\u00F3\u00F4\u00F5\u00FA\u00FC\u00F1\-',\.]+((\s?[0-9][0-9])*(\s?[0-9][0-9])*([-])*)*(\s\u0026|\sof|\sfu\u0308r|\sdes|\set|\sde\sla|\sde\s|\sdel|\sde|\svon|\svan)?\s*([A-Z\u00C1\u00C9\u00CD\u00D3\u00DA\u00DC\u00D6][.]\s*)*(e\s|y\s|of\s|fu\u0308r\s|des\s|et\s|y\sdel\s|y\sde\sla\s|de\sla\s|del\s|de\slos\s|de\s|von\s|van\s)?){2,9}/g);
    			
    			if ( lobjPossibleNamesIngest == null || lobjPossibleNamesIngest.length == 0 )
    			{
    			    continue; 		
    			}
    			else
    			{
    			    for( var j = 0; j < lobjPossibleNamesIngest.length; j++ )
    			    {
    			        var lstrPossibleNameIngest = lobjPossibleNamesIngest[j];
         			    lstrPossibleNameIngest = lstrPossibleNameIngest.trim();
         			    
         			    // Strip any trailing commas. --timathom
         			    var lstrLastChar = lstrPossibleNameIngest.substr( lstrPossibleNameIngest.length - 1 );
         			    
         			    if( lstrLastChar == "," )
    			        {
    				        lstrPossibleNameIngest = lstrPossibleNameIngest.slice(0, -1);
    			        }     
    			            			                               
         			    PossibleNameListIngest.push( lstrPossibleNameIngest );
         			}        
    			}    			
    	    }
    	    
    	    
    	    //console.log(NameIndexList);
    	    PossibleNameList = PossibleNameListBio.concat(PossibleNameListUnit).concat(PossibleNameListIngest);
    		PossibleNameList = unique(PossibleNameList);
    		PossibleNameList.sort();    		    		
    	
    		if( PossibleNameList.length == 0 )
		    {			    
		    
		        jQuery('html,body').animate({scrollTop:0},0); //scroll to top to view form correctly
		        
		        callback( 'No matches for Named Entity Recognition.' );
		        //$('body').append("<div id=\"dialog\"><p>Canceled!</p></div>");
                //makeDialog('#dialog', 'Results'); // display results
			    $('#loading-image').remove();
                $('.form_container').remove();
                $('.main_edit').show();

                //set ace editor value to new xml from EAC Dom Document with ingested source and name entries
                //added to show changes immediately
                editor.getSession().setValue(lobjEac.getXML());    
                    			        
    			$('#entity_name').show();    			    			

			    return;
		    }		            	                                         
    
    		//display all possible names for editor to choose correct/desired names to search viaf and create relations
    		display_possible_name_form(PossibleNameList, function( lobjChosenNames )
    					   {        					   
    					       if( lobjChosenNames.length == 0 )
    					       {    					
    					       
    					           jQuery('html,body').animate({scrollTop:0},0); //scroll to top to view form correctly
    					      
    					           callback("Canceled!"); //done if no names where chosen
    					           
        					       if ( getCookie('wiki') == 'present' )   
                                   {
                                     $('#wiki_switch').show();    	                           	
                                   }
                                   else
                                   {
                                     $('#wiki_switch').hide();
                                   }
        						   $('.viaf_arrow').html("&#10003;");
        						   $('#loading-image').remove();
        						   $('.main_edit').show();    

                                   //added to show changes immediately
                                   editor.getSession().setValue(lobjEac.getXML());     	
                                   					   
        						   return;
    					       }    					           					       
    					       
    
    					       var ljsonChosenNames = JSON.stringify(lobjChosenNames);
    
    					       //post to ajax viaf ingestor controller to get relation nodes from viaf based on posted lists
    					       $.post( 'ajax/viaf_ingest_api.php', { 'action' : 'relations', 'chosen_names' : ljsonChosenNames }, function(response)					       
    						       {						       						       
    							   try
    							   {							         							       
    							       var lobjOrigNames = JSON.parse(ljsonChosenNames); // Keep the original name strings, in case there's no VIAF match.
    							       var lobjData = JSON.parse(response);		
    							       //console.log(response);
    							       if(lobjData.length == 0)
                              	       {                                                    	           
                              	           callback('');
                              	           $('.viaf_arrow').html("&#10003;");
        							       $('#loading-image').remove(); 
        							       $('.form_container').remove();
        							       $('.main_edit').show();
        							       // Check to see if there is already wiki markup. If so, show switcher. --timathom
                                           if ( getCookie('wiki') == 'present' )   
                                           {
                                             $('#wiki_switch').show();    	                           	
                                           }
                                           else
                                           {
                                             $('#wiki_switch').hide();
                                           }	
                                 	       return;                                                                                                                    
                              	       }                                                   	                                 	                                	       
    							   }
    							   catch(e) //response should be JSON so if not, throw error
    							   {    							       
    							       //$('#loading-image').remove();
    							       //commented out by dgonzalez because ingest can be done multiple times
    							       //$('#ingest_viaf').attr("disabled", "disabled");
    							       //  $('.ingest_button').show();
    							       //$('.viaf_arrow').html("&#10003;");
    							       // Check to see if there is already wiki markup. If so, show switcher. --timathom
                                       /*
                                       if ( getCookie('wiki') == 'present' )   
                                       {
                                           $('#wiki_switch').show();    	                           	
                                       }
                                       else
                                       {
                                           $('#wiki_switch').hide();
                                       }	
    							       */						       
    							       return;
    							   }		
    							  
                              	    
                              	   //display results from viaf relation nodes search so editor can choose which relations they want to ingest
    							   display_viaf_results_form( lobjData, function( lobjResultsChosen ) 
    										     {    						    										     
    											 if( typeof lobjResultsChosen['names'] == 'undefined' || typeof lobjResultsChosen['names']['entity']['all'] == 'undefined' || lobjResultsChosen['names']['entity']['all'].length == 0 )    											 
    											 {    			
    											 
    											     jQuery('html,body').animate({scrollTop:0},0); //scroll to top to view form correctly
    											 
    											     callback("Canceled!"); //finish process if no results chosen
    											     $('.viaf_arrow').html("&#10003;");
    											     $('#loading-image').remove(); 
    											     $('.main_edit').show();                                                     
    											     
    											     // Check to see if there is already wiki markup. If so, show switcher. --timathom
                                                     if ( getCookie('wiki') == 'present' )   
                                                     {
                                                         $('#wiki_switch').show();    	                           	
                                                     }
                                                     else
                                                     {
                                                         $('#wiki_switch').hide();
                                                     }	                                                     
    											     return;
    											 }   
    											 else
    											 {    											    											         											   
    											 //ingest into EAC all chosen results from viaf
    											 for(var i = 0; i < lobjResultsChosen['names']['entity']['viaf'].length; i++)
    											 {
    											     var chosen_result_viaf = lobjResultsChosen['names']['entity']['viaf'][i];
    											     
    											     //console.log(chosen_result_viaf);
    											     
    											     lobjEac.addCPFRelationViaf(lobjData[chosen_result_viaf]);    											     
    											         									
    											     /* Attempting to dedupe cpfRelations... Needs more work. --timathom
                                     			     var colon = chosen_result_viaf.indexOf(':');
                                     			                                         			     
                                				     lstrResultTest = chosen_result_viaf.substring(0,colon);
                                			         console.log(lstrResultTest);
                                			         
                                			         var lstrCpfTest = lobjEac.getElement('//*[local-name()=\'cpfRelation\']/*[local-name()=\'relationEntry\'][1]');                                			        
                                			         
                                			         if ( lstrResultTest != lstrCpfTest )
                                			         {
                                			             lobjEac.addCPFRelationViaf(lobjData[chosen_result_viaf]);
                                			             console.log(lstrResultTest);
                                			         }                                			             											     
                                			         */
    											 }    											     											 
    											 
    											 for(var i = 0; i < lobjResultsChosen['names']['entity']['custom'].length; i++)
    											 {
    											     var chosen_result_custom = lobjResultsChosen['names']['entity']['custom'][i];    											         											     
    											     var chosen_roles = lobjResultsChosen['names']['roles'][i];        											                                                         
    											     var chosen_rels = lobjResultsChosen['names']['rels'][i];
    											     lobjEac.addCPFRelationCustom(lobjData[chosen_result_custom], chosen_roles, chosen_rels);
    											 }    											     		    											     											
    											 
    											 editor.getSession().setValue(lobjEac.getXML());
    											 
    											 jQuery('html,body').animate({scrollTop:0},0); //scroll to top to view form correctly
    
    											 callback('&lt;cpfRelation&gt; elements added!'); // Notify that <cpfRelation> elements have been added. --timathom    											    											 
    											 $('.viaf_arrow').html("&#10003;");    											 
    											 $('#loading-image').remove();
    											 $('.main_edit').show();
    											 
    											 
    											 }
    										 });                          	      
    							   
    						       });
    					   });
    	    });
    }
    
    /*
     * display_possible_name_form displays a form for the editor to choose which names to search viaf to create realtions.
     * @method display_possible_name_form
     */
    function display_possible_name_form( lobjPossibleNames, callback )
    {
        var lstrHTML = "<div class=\"form_container\">";
     
        lstrHTML += "<div class=\"instruction_div\"><h2 class=\"instruction\" style=\"font-weight:800; font-size:1.5em;\">Named Entity Recognition</h2><p class=\"instruction\">These names have been extracted from this entity\'s finding aid or biography. Select names that you would like to look up in VIAF.</p><p class=\"instruction\">In the next step, you will be able to make a final selection to create &lt;cpfRelation&gt; elements, with associated VIAF IDs, in the EAC-CPF record.</p><p class=\"instruction\">Each name can be edited to improve the search query, if appropriate. When editing, it is best to put names in inverted order (Last Name, First Name).</p><p class=\"instruction\">If names need to be split, or if you have additional names to add, you may click \"Add New Row\" to input appropriate data.</p><p class=\"instruction\">Note that geographical places are not included in VIAF and so should be ignored at present.</p><p class=\"instruction\" style=\"font-style:italic\">Please note that if you select several names to look up in VIAF, your query may take some time to run.</p></div>";
    
    
        lstrHTML += "<button id=\"ingest_viaf_chosen_names_relations\" class=\"pure-button ingest-ok pure-button-secondary\">Use Selected Names</button>";
        lstrHTML += "&nbsp;<button id=\"ingest_viaf_chosen_names_relations_cancel\" class=\"pure-button ingest-cancel pure-button-secondary\">Cancel</button>";
    
    
        lstrHTML += "<div class=\"user_help_form\">";
    
        lstrHTML += "<h2>Please choose names to create &lt;cpfRelation&gt; elements:</h2>";
        lstrHTML += "<input type=\"checkbox\" id=\"select_all\" value=\"\"><span style=\"font-weight:500; margin-left:4px;\">Select all</span><br />";
    
         // HTML modified by timathom to allow users to edit Named Entity Recognition results.
        lstrHTML += "<table class=\"user_help_form_table\">";
        
        for(var i = 0; i < lobjPossibleNames.length; i++)
        {               
        	lstrHTML += "<tr><td><input type=\"checkbox\" class=\"ner_check\" name=\"chosen_names\" value=\"\"/></td>";
        	lstrHTML += "<td><input type=\"text\" class=\"ner_text\" name=\"modified_names\" size=\"60\" value=\"" + lobjPossibleNames[i] + "\"/></td>";
            lstrHTML += "<td><input type=\"button\" name=\"add\" value=\"Add New Row\" class=\"ner_empty_add pure-button pure-button-secondary\"/></td></tr>";            
        }
        
    
        lstrHTML += "</table>"
    
        lstrHTML += "</div></div>";
    
        $('body').append(lstrHTML);
    
        // jQuery added by timathom to include "Add New Row" and "Delete Row" buttons and functionality.
     			    $("input.ner_empty_add").on('click', function() {        
     			        var tr = "<tr><td><input type=\"checkbox\" class=\"ner_check\" name=\"chosen_names\" value=\"\" checked/></td><td><input type=\"text\" class=\"ner_text\" name=\"modified_names\" size=\"60\" value=\"\" /></td><td><input type=\"button\" name=\"rm\" value=\"Delete Row\" class=\"ner_empty_rm pure-button pure-button-secondary\"/></td></tr>";         
     			        $(this).closest("tr").after(tr);
     			        
     			        $("input.ner_empty_rm").on('click', function() {        
     			            $(this).closest("tr").remove();
     		            });        
     			    });
    
        setupSelectAll('input#select_all'); //able to select all checkboxes
        jQuery('html,body').animate({scrollTop:0},0); //scroll to top to view form correctly
    
        //register click event to continue process once user choses names
        $('#ingest_viaf_chosen_names_relations').on('click', function()
    						{
    						    var lobjChosenNames = [];
    						    
    						    $('#main_content').append('<div id="viaf_load">Searching VIAF for matches. Depending on the number of queries, this may take some time.</div>');
    
    						    $('input.ner_check').each(function () {
    							if(this.checked)
         							{
         					           lobjChosenNames.push(encode_utf8($(this).closest('td').next('td').children('input').val())); 
         							}        	     							
    						    });				
    						    // Display/notification logic added by timathom
    						    if ( lobjChosenNames.length == 0 )
    						    {
    						        $('body').append("<div id=\"dialog\"><p>Please choose or click Cancel!</p></div>");
    					            makeDialog('#dialog', 'Error!'); // display error
    						        //$('.main_edit').hide();   
    						    }
    						    else
    						    {						              						        
          						    callback(lobjChosenNames);	
          						    $('.form_container').remove();          						    
          						    $('.main_edit').hide();
          						    $('#entity_name').hide();
          						       						                                                 						   
    						    }						   						    											    			
    						});
    
        //register click event to cancel process
        $('#ingest_viaf_chosen_names_relations_cancel').on('click', function()
    						       {
    							   var lobjChosenNames = [];    
    							   callback(lobjChosenNames); 
    							   // Check to see if there is already wiki markup. If so, show switcher. --timathom
                                   if ( getCookie('wiki') == 'present' )   
                                   {
                                     $('#wiki_switch').show();    	                           	
                                   }
                                   else
                                   {
                                     $('#wiki_switch').hide();
                                   }	
    							   $('.form_container').remove();
    							   $('#viaf_load').remove();
    							   $('.main_edit').show();
          						   $('#entity_name').show();          						       							      							  
    						       });
    }
    
    /*
     * display_viaf_results_form displays a form for the editor to choose which viaf results that editor wants to ingest as relations
     * @method display_viaf_results_form
     */
    function display_viaf_results_form( lobjViafResults, callback )
    {
        var lstrHTML = "<div class=\"form_container\">";
        lstrHTML += "<div class=\"instruction_div\"><h2 class=\"instruction\" style=\"font-weight:800; font-size:1.5em;\">Named Entity Recognition</h2><p class=\"instruction\">Based on your selections, these are the possible matches (if any) that we were able to retrieve from VIAF. Results are sorted by the number of library holdings associated with each name in the VIAF database.</p><p class=\"instruction\">Please note that when there are several possibilities, you may need to look at each one before choosing.</p><p class=\"instruction\">Some results are obviously unrelated, but others may be harder to differentiate. Be aware that even if a name seems to match your original selection, it may be a false hit.</p><p class=\"instruction\">When in doubt, please click on a name to visit its VIAF page and look for additional information. If a name already has a corresponding Wikipedia article (there may be a link from the VIAF page), check there to see which VIAF ID has been used, and then select the name that corresponds to that VIAF ID.</p><p class=\"instruction\">If there are no appropriate matches from VIAF, you may add a custom &lt;cpfRelation&gt; using the original search string.</p></div>";
       
        lstrHTML += "<button id=\"ingest_viaf_add_relations\" class=\"pure-button ingest-ok pure-button-secondary\">Use Selected Results</button>";
        lstrHTML += "&nbsp;<button id=\"ingest_viaf_add_relations_cancel\" class=\"pure-button ingest-cancel pure-button-secondary\">Cancel</button>";
    
        lstrHTML += "<div class=\"user_help_form\">";
    
        lstrHTML += "<h2>Please choose appropriate matches from VIAF (the original string you searched for appears first, before the colon):</h2>";
        lstrHTML += "<input type=\"checkbox\" id=\"select_all\" value=\"\"><span style=\"font-weight:500; margin-left:4px;\">Select all</span><br />";
    
        // Modified to include original name string and entity type selector along with VIAF results. --timathom
        
        lstrHTML += "<table class=\"user_help_form_table\">";

        /*
        for( var lstrFirstResult in lobjViafResults )
        {
            var colon = lstrFirstResult.indexOf(':');
            lstrHTML += "<tr class=\"user_viaf_row\"><td></td><td>Matches from VIAF:</td></tr>";
            //for \"" + lstrFirstResult.substr(0,colon) + "\": </td></tr>";
            break;
        }
        */                        
        
        for( var lstrName in lobjViafResults )                
        {                
            var lstrNameViaf = lstrName.match(/viaf/gi);
            var lstrNamePlain = lstrName.match(/[^(viaf)]/gi);
            
            if ( lstrNameViaf != null )
            {                                             
               lstrHTML += "<tr><td><input type=\"checkbox\" class=\"viaf_check\" name=\"chosen_results\" value=\"";		
    	       lstrHTML += lstrName.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;') + "\" /></td><td>" + lstrName + "</td>";
    	       lstrHTML += "</tr>";
            }    	    	
            else // Filter out VIAF results. --timathom
            {   
                lstrHTML += "<tr><td></td></tr>";
                lstrHTML += "<tr id=\"user_rel\"><td></td><td class=\"message\">No appropriate matches from VIAF? Add &lt;cpfRelation&gt; using the original search string: </td></tr>";
                lstrHTML += "<tr class=\"user_plain_row\"><td><input type=\"checkbox\" class=\"viaf_check\" name=\"chosen_results\" value=\"";		
    	        lstrHTML += "\"/></td><td id=\"plainText\"><span id=\"textSpan\">" + lstrName;                
                lstrHTML += "</span><span id=\"select_wrap\"><select id=\"ents\" name=\"entities\" title=\"For non-VIAF entries, you must choose an entity type. For VIAF entries (the ones with links), the entity type has been predefined.\"><option value=\"\">Entity Type</option><option value=\"\"></option><option value=\"pers\">Person</option><option value=\"corp\">CorporateBody</option><option value=\"fam\">Family</option></select>";
                lstrHTML += "<select id=\"rels\" name=\"relType\" title=\"For non-VIAF entries, you may choose one of two relation types. If you do not choose a relation type, the default value is 'associatedWith'\"><option value=\"\">Relation Type</option><option value=\"\"></option><option value=\"assoc\">associatedWith</option><option value=\"corresp\">correspondedWith</option></select></span></td>";
                lstrHTML += "</tr>";
                //lstrHTML += "<tr class=\"user_viaf_row\"><td></td><td>Matches from VIAF:</td></tr>";
            }                               
        }                     
        
    	lstrHTML += "</table>"
    	
        lstrHTML += "</div></div>";
    
        $('body').append(lstrHTML);
        setupSelectAll('input#select_all'); //functionality to select all checkboxes
        jQuery('html,body').animate({scrollTop:0},0); //scroll to top to view form correctly                                       
    
        //register click event to continue process once user choses results
        $('#ingest_viaf_add_relations').on('click', function()        
    				       {
    				      				       				       
    					   var lobjChosenResults = [];	
    					   lobjChosenResults['names'] = [];    					   
    					   lobjChosenResults['names']['entity'] = [];
    					   lobjChosenResults['names']['entity']['all'] = [];
    					   lobjChosenResults['names']['entity']['viaf'] = [];
    					   lobjChosenResults['names']['entity']['custom'] = [];
    					   lobjChosenResults['names']['rels'] = [];
    					   lobjChosenResults['names']['roles'] = [];
    					   //var lobjChosenResultsTest = [];
    					   //lobjChosenResultsTest['names'] = [];
    					   //lobjChosenResultsTest['names']['entity'] = [];    					       					  
    					                                                  
    					   $('input.viaf_check').each(function () {
    					       if ( this.checked )
    					       {					     
    					           if ($(this).val() != "")
    					           {
    					               lobjChosenResults['names']['entity']['viaf'].push($(this).val());
    					               lobjChosenResults['names']['entity']['all'].push($(this).val());  
    					           }    					           
    					           else  					              					          
    					           {    					                					                                                 
                                       //lobjChosenResultsTest['names']['entity']['custom'].push($(this).closest('td').siblings('#plainText').children('#textSpan').text());
                                       //console.log($(this).closest('td').siblings('#plainText').children('#textSpan').text()); 
                                       
                                        lobjChosenResults['names']['entity']['all'].push($(this).closest('td').siblings('#plainText').children('#textSpan').text());
                                        lobjChosenResults['names']['entity']['custom'].push($(this).closest('td').siblings('#plainText').children('#textSpan').text());
                                       
                                        if ($(this).closest('td').siblings('#plainText').children('#select_wrap').children('#ents').children('option:selected').val() != '')
    					                {    					                        					                   
    					                    lobjChosenResults['names']['roles'].push( "http://rdvocab.info/uri/schema/FRBRentitiesRDA/" + $(this).closest('td').siblings('#plainText').children('#select_wrap').children('#ents').children('option:selected').text() );    					                    
    					                }
                                        
                                        if ($(this).closest('td').siblings('#plainText').children('#select_wrap').children('#rels').children('option:selected').val() != '')
    					                {    					                    
    					                    lobjChosenResults['names']['rels'].push( $(this).closest('td').siblings('#plainText').children('#select_wrap').children('#rels').children('option:selected').text() );
    					                }    				    					                
    					                else //( lobjChosenResults['names']['rels'].length == 0 )
    					                {    					                    
    					                    lobjChosenResults['names']['rels'].push( "associatedWith" );
    					                }    					               					                    
    					           }    					               					          					               					      
    					       }					       
    					   });					   					 					 
    					   
    					   // Display/notification logic added by timathom
    					   if ( lobjChosenResults['names']['entity']['custom'].length != 0 && ( lobjChosenResults['names']['roles'].length == 0 || lobjChosenResults['names']['roles'] == '' ) )
    					   {    					    
    		                   $('body').append("<div id=\"dialog\"><p>Please select an Entity Type.</p></div>");
    	                       makeDialog('#dialog', 'Error!'); // display error    					     
    					   }
    					   
    					   else if ( lobjChosenResults['names']['entity']['all'].length == 0 )
    					   {
    					       $('body').append("<div id=\"dialog\"><p>Please choose or click Cancel!</p></div>");
    				           makeDialog('#dialog', 'Error!'); // display error    					     
    					   }    					   
    					        					  
    					   else
    					   {						      
    					      callback(lobjChosenResults);
          					  $('.form_container').remove();  
          					  $('#viaf_load').remove();
          					  // Check to see if there is already wiki markup. If so, show switcher. --timathom
                              if ( getCookie('wiki') == 'present' )   
                           	  {
                                  $('#wiki_switch').show();    	                           	
                           	  }
                           	  else
                           	  {
                           	      $('#wiki_switch').hide();
                           	  }    				              				              				        
    					   }					   
    				       });
    
        //register click event to cancel process
        $('#ingest_viaf_add_relations_cancel').on('click', function()
    					      {
    						  var lobjChosenResults = [];
    						  
    						  callback(lobjChosenResults);   
    						  $('.form_container').remove();
    						  $('#viaf_load').remove();        						     						  
    						  $('.main_edit').show();    						  
    					      });
    }
    
    /*
     * ingest_worldcat_elements ingest subject headings and relationships from worldcat using API into passed EAC DOM Document.
     * @method ingest_worldcat_elements
     */
    function ingest_worldcat_elements( lobjEac, lstrName, callback )
    {
        $('body').append("<div id=\"dialog-form\" title=\"WorldCat search\"> \
    <p class=\"validate-prompt\">Please choose or click Cancel!</p> \
    <form> \
    <fieldset> \
    <label for=\"name\">Name</label> \
    <input type=\"text\" size=\"35\" name=\"name\" id=\"name\" class=\"text ui-widget-content ui-corner-all\" value=\"" + decode_utf8(lstrName) + "\"/> \
    </fieldset> \
    </form></div>");
    
        $('#loading-image').remove();
        $('.ingest_button').show();
    
        //prompt user to enter search string for WorldCat search
        makePromptDialog('#dialog-form', 'WorldCat Name Search', function(dialog)
    		     {
    			 var lstrName = $('input[name="name"]').val();
    
            		 if(lstrName == '')
            		 {
            		     $('.validate-prompt').show();
            		 }
            		 else
            		 {            		     
    			     
    			     $('#main_content').prepend('<img id="loading-image" src="style/images/loading.gif" alt="loading"/>');
    			     $(dialog).dialog("close");
    			    
    			     lstrName = encode_utf8(lstrName);
    
    			     //post to ajax WorldCat ingestor controller to search worldcat and get results
            		     $.post( 'ajax/worldcat_ingest_api.php', { 'action' : 'search', 'name' : lstrName }, function(response)
    				     {
    					 try
    					 {
    					     var lobjData = JSON.parse(response);
    					 }
    					 catch(e) //response should be JSON so if not, throw error
    					 {    					     
    					     callback(response);
    					                                	    					        					  
    					     return;
    					 }
    
    					 //display form for editor to choose which WorldCat result is the correct result
    					 display_possible_worldcat_form( lobjData, function( lstrChosenURI )
    									 {
    									     //if cancelled because no WorldCat results matched
    									     if( lstrChosenURI == '' )
    									     {    
    									     
    									     jQuery('html,body').animate({scrollTop:0},0); //scroll to top to view form correctly
    									     
    									     callback('Canceled!');
    										 $('.worldcat_arrow').html("&#10003;");    										 
    										 return;
    									     }
    
    									     //post to ajax WorldCat ingestor controller to search worldcat and get results
    									     $.post( 'ajax/worldcat_ingest_api.php', { 'action' : 'get_element_list', 'uri' : lstrChosenURI }, function(response)
    										     {
    											 try
    											 {
    											     var lobjData = JSON.parse(response);                                                          											    
    											 }
    											 catch(e) //response should be JSON so if not, throw error
    											 {    											     
    											     callback();    											     
    											     
    											     return;
    											 }
    											     											 
    											 var lobjSourceList = typeof lobjData.source == 'undefined' ? [] : lobjData.source;    
    											 var lobjOtherRecList = typeof lobjData.otherRecordId == 'undefined' ? [] : lobjData.otherRecordId;
    											 var lobjCpfRelationList = typeof lobjData.cpfRelation == 'undefined' ? [] : lobjData.cpfRelation;
    											 var lobjResourceRelationList = typeof lobjData.resourceRelation == 'undefined' ? [] : lobjData.resourceRelation;
    											 var lobjSubjectList = typeof lobjData.subject == 'undefined' ? [] : lobjData.subject;
    											 
    											 for( var i = 0; i < lobjOtherRecList.length; i++ )
    											 {
    											     var OtherRecs = lobjOtherRecList[i];
    											     lobjEac.addOtherRecordId(OtherRecs);    											     
    											     editor.getSession().setValue(lobjEac.getXML()); // added by timathom
    											 }
    											 
    											 for( var i = 0; i < lobjSourceList.length; i++ )
    											 {
    											     var Sources = lobjSourceList[i];
    											     lobjEac.addSource(Sources);
    											     editor.getSession().setValue(lobjEac.getXML()); // added by timathom
    											 }
    
    											 for( var i = 0; i < lobjCpfRelationList.length; i++ )
    											 {
    											     var CpfRelation = lobjCpfRelationList[i];    											     
    											     lobjEac.addCPFRelation(CpfRelation);
    											     editor.getSession().setValue(lobjEac.getXML()); // added by timathom
    											 }
    
    											 for( i = 0; i < lobjResourceRelationList.length; i++ )
    											 {
    											     var ResourceRelation = lobjResourceRelationList[i];
    											     lobjEac.addResourceRelation(ResourceRelation);
    											     editor.getSession().setValue(lobjEac.getXML()); // added by timathom
    											 }    											     											 										     											     											     											     											    										
    											 
    											 // Result text added by timathom.    
    											 var lstrOtherRecId;
    											 var lstrSources;
    											 var lstrCpfResults;
    											 var lstrResourceResults;
    											 
    											 if ( lobjOtherRecList.length == 0 )
    											 {
    											     lstrOtherRecId = '';
    											 }
    											 else 
    											 {
    											     lstrOtherRecId = "<p>&lt;otherRecordId&gt; element(s) added.</p><br/>";
    											 }
    											 
    											 if ( lobjSourceList.length == 0 )
    											 {
    											     lstrSources = '';
    											 }
    											 else 
    											 {
    											     lstrSources = "<p>&lt;source&gt; element added.</p><br/>";
    											 }
    											 
    											 if ( lobjCpfRelationList.length == 0 )
    											 {
    											     lstrCpfResults = '';
    											 }
    											 else
    											 {
    											     lstrCpfResults = "<p>&lt;cpfRelation&gt; element(s) added.</p><br/>";											     
    											 }
    											 if ( lobjResourceRelationList.length == 0 )
    											 {
    											     lstrResourceResults = '';
    											 }
    											 else
    											 {
    											     lstrResourceResults = "<p>&lt;resourceRelation&gt; element(s) added.</p><br/>";											     
    											 }
    											     											 
    											 
    											 // Notification logic added by timathom.
    											 if(lobjSubjectList.length == 0)
                                                 {                                                    
                                                     $('body').append("<div id=\"dialog\"><p>No matching subjects.</p><br/>" + lstrOtherRecId + lstrSources + lstrCpfResults + lstrResourceResults + "</div>");
    					                             makeDialog('#dialog', 'Results'); // display results
                                                     $('.worldcat_arrow').html("&#10003;");
                                      		         $('#loading-image').remove(); 
                                      		         $('.form_container').remove();
                                      		         $('.main_edit').show();   
                                      		         $('#entity_name').show();
                                      		         // Check to see if there is already wiki markup. If so, show switcher. --timathom
                                                     if ( getCookie('wiki') == 'present' )   
                                                     {
                                                         $('#wiki_switch').show();    	                           	
                                                     }
                                                     else
                                                     {
                                                         $('#wiki_switch').hide();
                                                     }
                                                     return;
                                                 } 
                                                 else
                                                 {
                                                                                 
    											 //display form for editor to chose which subject headings to ingest
    											 display_possible_worldcat_subjects( lobjSubjectList, function( lobjChosenSubjects )
    															     {
    															     															    
    																 for( i = 0; i < lobjChosenSubjects.length; i++ )
    																 {
    																     var Subject = lobjSubjectList[lobjChosenSubjects[i]];
    																     lobjEac.addSubjectHeading(Subject);
    																     editor.getSession().setValue(lobjEac.getXML());
    																 }
    																 
    																 if(lobjChosenSubjects.length == 0)
                                                                     {                                                                                                     
                                                                         $('body').append("<div id=\"dialog\"><p>No subjects added.</p><br/>" + lstrOtherRecId + lstrSources + lstrCpfResults + lstrResourceResults + "</div>");
                       					                                 makeDialog('#dialog', 'Results'); // display results
                                                                         $('.worldcat_arrow').html("&#10003;");
                                                         		         $('#loading-image').remove(); 
                                                         		         $('.form_container').remove();
                                                         		         $('.main_edit').show();
                                                         		         $('#entity_name').show();
                                                         		         // Check to see if there is already wiki markup. If so, show switcher. --timathom
                                                                       	 if ( getCookie('wiki') == 'present' )   
                                                                      	 {
                                                                            $('#wiki_switch').show();    	                           	
                                                                      	 }
                                                                      	 else
                                                                      	 {
                                                                      	     $('#wiki_switch').hide();
                                                                      	 }
                                                         		         //editor.getSession().setValue(lobjEac.getXML());                                                         
                                                                         return;
                                                                    } 
                                                                    else
                                                                    {        																     
           																 $('body').append("<div id=\"dialog\"><p>&lt;localDescription&gt; element(s) added with chosen subject(s).</p><br/>" + lstrOtherRecId + lstrSources + lstrCpfResults + lstrResourceResults + "</div>");
           					                                             makeDialog('#dialog', 'Results'); // display results    																 
           																 $('#loading-image').remove();
           																 $('.worldcat_arrow').html("&#10003;");    																        															    																 
           																 $('.main_edit').show();
           																 $('#entity_name').show();
           																 // Check to see if there is already wiki markup. If so, show switcher. --timathom
                                                                       	 if ( getCookie('wiki') == 'present' )   
                                                                      	 {
                                                                            $('#wiki_switch').show();    	                           	
                                                                      	 }
                                                                      	 else
                                                                      	 {
                                                                      	     $('#wiki_switch').hide();
                                                                      	 }
                                                                      	 //editor.getSession().setValue(lobjEac.getXML());
                                                                      	 return;                                                                      	 
    																 }
    																 
    															     });
    											 }
    										     });
    									 });    									     	        		
        				     });
    			 }
    		     });
    }
    
    /*
     * display_possible_worldcat_form displays a form for the editor to choose which worldcat results that editor wants to ingest
     * @method display_possible_worldcat_form
     */
    function display_possible_worldcat_form( lobjPossibleURI, callback )
    {
        var lstrHTML = "<div class=\"form_container\">";
    
     lstrHTML += "<div class=\"instruction_div\"><h2 class=\"instruction\" style=\"font-weight:800; font-size:1.5em;\">Ingest from WorldCat Identities</h2><p class=\"instruction\">This step draws on <a href=\"http://worldcat.org/identities/\" title=\"Link to WorldCat Identities\" target=\"_blank\">WorldCat Identities</a> to pull in a variety of data (works by, works about, related entities, and subject headings) associated with the entity you are working with.</p><p class=\"instruction\">The list on the right presents possible matches from WorldCat Identities. Please examine them to select the best match for the current entity.</p><p class=\"instruction\">If you click on a name, you will be taken to its WorldCat Identities page, which may include additional information that will help you decide whether it is an appropriate match. In general, the page with the most information will be the best match.</p><p class=\"instruction\">If there is no appropriate match, click \"Cancel\" to return to the edit screen.</p></div>";
    
    
        lstrHTML += "<button id=\"ingest_worldcat_chosen_uri\" class=\"pure-button ingest-ok pure-button-secondary\">Use Selected WorldCat Identity</button>";
        lstrHTML += "&nbsp;<button id=\"ingest_worldcat_chosen_uri_cancel\" class=\"pure-button ingest-cancel pure-button-secondary\">Cancel</button>";
    
        lstrHTML += "<div class=\"user_help_form\">";
    
        lstrHTML += "<h2>Please choose the name that is the best match:</h2>";
    
        for(var i = 0; i < lobjPossibleURI.length; i++)
        {
    	var lstrTitle = typeof lobjPossibleURI[i].title == 'undefined' ? '' : lobjPossibleURI[i].title;
    	var lstrURI = typeof lobjPossibleURI[i].uri == 'undefined' ? '' : lobjPossibleURI[i].uri;
    	var lstrType = typeof lobjPossibleURI[i].type == 'undefined' ? '' : lobjPossibleURI[i].type;
    
    	lstrHTML += "<input type=\"radio\" name=\"chosen_worldcat_uri\" value=\"";
    	lstrHTML += lstrURI + "\" /><a href=\"" + lstrURI + "\" target=\"_blank\">" + lstrTitle + "</a><br />";
        }
    
    
        lstrHTML += "</div></div>";
    
        $('body').append(lstrHTML);
        jQuery('html,body').animate({scrollTop:0},0); //scroll to top to view form correctly
    
        //register click event to continue process once user choses result
        $('#ingest_worldcat_chosen_uri').on('click', function()
    					{
    					    var lstrChosenURI = $('input[name="chosen_worldcat_uri"]:checked').val();
    
    					    if( typeof lstrChosenURI == 'undefined')
    					    {
    						$('body').append("<div id=\"dialog\"><p>Please choose or click Cancel!</p></div>");
    						makeDialog('#dialog', 'Error!');
    					    }else
    					    {
    						$('.form_container').remove();    						    						    						 
    
    						callback(lstrChosenURI);
    					    }
    					});
    
        //register click event to cencel process
        $('#ingest_worldcat_chosen_uri_cancel').on('click', function()
    					       {
    					       //callback('');
    						   $('.form_container').remove();
    						   $('#loading-image').remove();
    						   $('#entity_name').show();
    						   $('.main_edit').show();
    						   
          					   // Check to see if there is already wiki markup. If so, show switcher. --timathom
                               if ( getCookie('wiki') == 'present' )   
                           	   {
                                   $('#wiki_switch').show();    	                           	
                           	   }
                           	   else
                           	   {
                           	       $('#wiki_switch').hide();
                           	   }
                           	   
                           	   jQuery('html,body').animate({scrollTop:0},0); //scroll to top to view form correctly
                           	   
                           	   $('body').append("<div id=\"dialog\"><p>Canceled!</p></div>");
                               makeDialog('#dialog', 'Results'); // display results
                               $('.worldcat_arrow').html("&#10003;");
                                                              
    						   
    					       });
    }
    
    /*
     * display_possible_worldcat_subjects displays a form for the editor to choose which worldcat subject headings that editor wants to ingest
     * @method display_possible_worldcat_subjects
     */
    function display_possible_worldcat_subjects( lobjPossibleSubjects, callback )
    {
        var lstrHTML = "<div class=\"form_container\">";
        lstrHTML += "<div class=\"instruction_div\"><h2 class=\"instruction\" style=\"font-weight:800; font-size:1.5em;\">Ingest from WorldCat Identities</h2><p class=\"instruction\">Here is a list of FAST subject headings from this entity's WorldCat Identities page. Select appropriate headings to add to your EAC-CPF record.</p><p class=\"instruction\">These headings will be transformed to wiki markup and, when publishing to Wikipedia, should be replaced with appropriate Wikipedia categories (using the HotCat tool).</p><p class=\"instruction\">If there are no appropriate matches, click \"Cancel\" to return to the edit screen.</p></div>";
     
        lstrHTML += "<button id=\"ingest_worldcat_chosen_subjects\" class=\"pure-button pure-button-secondary\">Use Selected Subjects</button>";
    
        lstrHTML += "&nbsp;<button id=\"ingest_worldcat_chosen_subjects_cancel\" class=\"pure-button pure-button-secondary\">Cancel</button>";  
    
        lstrHTML += "<div class=\"user_help_form\">";
    
        lstrHTML += "<h2>Please choose any appropriate subjects related to this entity:</h2>";               
        
        lstrHTML += "<input type=\"checkbox\" id=\"select_all\" value=\"\"><span style=\"font-weight:500; margin-left:4px;\">Select all</span><br />";

        lstrHTML += "<table class=\"user_help_form_table\">";

        for(var i = 0; i < lobjPossibleSubjects.length; i++)
        {
    	lstrHTML += "<tr>";
    	lstrHTML += "<td><input type=\"checkbox\" name=\"chosen_subjects\" value=\"";
    	lstrHTML += i + "\" /></td><td>" + lobjPossibleSubjects[i].elements.term.elements + "</td>";
        lstrHTML += "</tr>";
        }
    
        lstrHTML += "</table>";
    
        lstrHTML += "</div></div></div>";
    
        $('body').append(lstrHTML);
        setupSelectAll('input#select_all'); //setup to select all checkboxes
        jQuery('html,body').animate({scrollTop:0},0); //scroll to top to view form correctly
    
        //register click event to continue process once user choses subjects
        $('#ingest_worldcat_chosen_subjects').on('click', function()
    					 {
    						 var lobjChosenSubjects = [];
    
    						 $('input[name="chosen_subjects"]').each(function () {
    						     if(this.checked)
    						     {
    							 lobjChosenSubjects.push($(this).val());
    						     }
    						 });
    						 
    						 // Display/notification logic added by timathom
    						 if ( lobjChosenSubjects.length == 0 )
    						 {
    						     $('body').append("<div id=\"dialog\"><p>Please choose or click Cancel!</p></div>");
    					         makeDialog('#dialog', 'Error!'); // display error
    						     //$('.main_edit').hide();   
    						 }
    						 else
    						 {						                                                					     
          						 callback(lobjChosenSubjects);
          						 $('.form_container').remove();
          						 $('.main_edit').show();
          						 // Check to see if there is already wiki markup. If so, show switcher. --timathom
                                 if ( getCookie('wiki') == 'present' )   
                              	 {
                                    $('#wiki_switch').show();    	                           	
                              	 }
                              	 else
                              	 {
                              	     $('#wiki_switch').hide();
                              	 }
             						 
       						 }								 					
    					 });
    
        //register click event to cancel process
        $('#ingest_worldcat_chosen_subjects_cancel').on('click', function()
    						    {
    							var lobjChosenSubjects = [];
    							
    							callback(lobjChosenSubjects);    
    							$('.form_container').remove();
    							$('.main_edit').show();
    							$('#entity_name').show();
    							// Check to see if there is already wiki markup. If so, show switcher. --timathom
                                if ( getCookie('wiki') == 'present' )   
                           	    {
                                    $('#wiki_switch').show();    	                           	
                           	    }
                           	    else
                           	    {
                           	        $('#wiki_switch').hide();
                           	    }    							
    							return;
    						    });
    }
    
    /*
     * setupSelectAll registers passed element selector's change event in order to have check all visible checkboxes functionality.
     * @method setupSelectAll
     */
    function setupSelectAll( lstrSelector )
    {
        $(lstrSelector ).change( function()
    			     {
    				 if( $(lstrSelector).prop("checked") == true )
    				     $('input[type="checkbox"]:visible').prop('checked', true);
    				 else
    				     $('input[type="checkbox"]:visible').prop('checked', false);
    			     })
    }
