/*
* This class handles all adding, creating, deleting, and getting of the EAC XML elements 
* @class eac
*/
function eac()
{
	var objDomDocument;
}

/*
* This class handles all adding, creating, deleting, and getting of the EAD XML elements 
* @class eac
*/
function ead()
{
	var objDomDocument;
}

	/*
	* loadXMLFile loads the passed xml file path and creates and saves a Dom Document based on xml file content
	* @method loadXMLFile
	*/
	eac.prototype.loadXMLFile = function( lstrXMLFile )
	{
        if (window.XMLHttpRequest)
        {
            var xhttp = new XMLHttpRequest();
        }
        else
        {
            xhttp=new ActiveXObject("Microsoft.XMLHTTP");
        }
        xhttp.open("GET",lstrXMLFile,false);
        xhttp.send();
        this.objDomDocument = xhttp.responseXML;
	}

	/*
	* loadXMLFile loads the passed xml file path and creates and saves a Dom Document based on xml file content
	* @method loadXMLFile
	*/
	ead.prototype.loadXMLFile = eac.prototype.loadXMLFile;

	/*
	* loadXMLString loads the passed xml string and creates and saves a Dom Document based on xml string
	* @method loadXMLString
	*/
	eac.prototype.loadXMLString = function( lstrXML )
	{
		lstrXML = lstrXML.replace(/\n|\t|\r/g, " ");

		if(lstrXML.indexOf("&lt;") == -1)
			var decoded = lstrXML;
		else
			var decoded = $('<div/>').html(lstrXML).text();

		if (window.DOMParser)
		{
			parser = new DOMParser();
			this.objDomDocument = parser.parseFromString(decoded,"text/xml");
		}
		else // Internet Explorer
		{
			this.objDomDocument = new ActiveXObject("Microsoft.XMLDOM");
			this.objDomDocument.async=false;
			this.objDomDocument.loadXML(decoded);
		}
	}

	/*
	* loadXMLString loads the passed xml string and creates and saves a Dom Document based on xml string
	* @method loadXMLString
	*/
	ead.prototype.loadXMLString = eac.prototype.loadXMLString;

	/*
	* getXML retrieves the xml string from the DOM document, formats it, and returns the resulting text
	* @method getXML
	*/
    eac.prototype.getXML = function()
	{
    	var xmlText = new XMLSerializer().serializeToString(this.objDomDocument);
    	xmlText = vkbeautify.xml(xmlText);

    	//added to make span elements inline
    	xmlText = xmlText.replace(/[\n][\s]+<span([^\n]*)[\n]/g, "<span$1");
    	return xmlText;
	}

	/*
	* getXML retrieves the xml string from the DOM document, formats it, and returns the resulting text
	* @method getXML
	*/
	ead.prototype.getXML = eac.prototype.getXML;

	/*
	* editRecordId edits the EAC recordId element
	* @method editRecordId
	*/
	eac.prototype.editRecordId = function( lstrValue )
	{
		this.editElement( '//*[local-name()=\'control\']/*[local-name()=\'recordId\']', lstrValue );
	}

	/*
	* addOtherRecordId adds to the EAC a otherRecordId element
	* @method addOtherRecordId
	*/
	eac.prototype.addOtherRecordId = function( lobjOtherRecId )
	{
	   
	    //this.addElement( 'otherRecordId', lstrValue, '//*[local-name()=\'control\']/*[local-name()=\'maintenanceStatus\']', true );
	            
        var lobjAttributes = typeof lobjOtherRecId.attributes != 'undefined' ? lobjOtherRecId.attributes : {};
		var lobjElements = typeof lobjOtherRecId.elements != 'undefined' ? lobjOtherRecId.elements : {};		

		var lobjOtherRecIdNode = this.createElement( 'otherRecordId', lobjAttributes, lobjElements );			

        this.addElement( 'otherRecordId', lobjOtherRecIdNode, '//*[local-name()=\'control\']/*[local-name()=\'maintenanceStatus\']', true );	        
        
	}

	/*
	* editOtherRecordId edits the EAC otherRecordId element with desired index
	* @method editOtherRecordId
	*/
	eac.prototype.editOtherRecordId = function( lintIndex, lstrValue )
	{
		this.editElementList( '//*[local-name()=\'control\']/*[local-name()=\'otherRecordId\']', lintIndex, lstrValue );
	}

	/*
	* deleteOtherRecordId deletes from the EAC the otherRecordId element with desired index
	* @method deleteOtherRecordId
	*/
	eac.prototype.deleteOtherRecordId = function( lintIndex )
	{
		this.deleteElement( '//*[local-name()=\'control\']/*[local-name()=\'otherRecordId\']', lintIndex );
	}

	/*
	* editMaintenanceStatus edits the EAC maintenanceStatus element
	* @method editMaintenanceStatus
	*/
	eac.prototype.editMaintenanceStatus = function( lstrValue )
	{
		this.editElement( '//*[local-name()=\'control\']/*[local-name()=\'maintenanceStatus\']', lstrValue );
	}

	/*
	* addPublicationStatus adds to the EAC a publication status
	* @method addPublicationStatus
	*/
	eac.prototype.addPublicationStatus = function( lstrValue )
	{
		if( !this.doesElementExist('//*[local-name()=\'control\']/*[local-name()=\'publicationStatus\']') )
			this.addElement( 'publicationStatus', lstrValue, '//*[local-name()=\'control\']/*[local-name()=\'maintenanceAgency\']', true );
		else
			throw new Exception( "Cannot have multiple publication statuses" );
	}

	/*
	* editPublicationStatus edits the EAC publicationStatus element
	* @method editPublicationStatus
	*/
	eac.prototype.editPublicationStatus = function( lstrValue )
	{
		this.editElement( '//*[local-name()=\'control\']/*[local-name()=\'publicationStatus\']', lstrValue );
	}

	/*
	* editMaintenanceAgency edits the EAC maintenanceAgency element
	* @method editMaintenanceAgency
	*/
	eac.prototype.editMaintenanceAgency = function( lobjMaintenanceAgency )
	{
		var lobjAttributes = typeof lobjMaintenanceAgency.attributes != 'undefined' ? lobjMaintenanceAgency.attributes : {};
		var lobjElements = typeof lobjMaintenanceAgency.elements != 'undefined' ? lobjMaintenanceAgency.elements : {};

		var lobjMaintenanceAgencyNode = this.createElement( 'maintenanceAgency', lobjAttributes, lobjElements );

		this.editElement( '//*[local-name()=\'control\']/*[local-name()=\'maintenanceAgency\']', lobjMaintenanceAgencyNode );
	}

	/*
	* addMaintenanceEvent adds to the EAC a maintenance event element
	* @method addMaintenanceEvent
	*/
	eac.prototype.addMaintenanceEvent = function( lobjMaintenanceEvent )
	{
		var lobjAttributes = typeof lobjMaintenanceEvent.attributes != 'undefined' ? lobjMaintenanceEvent.attributes : {};
		var lobjElements = typeof lobjMaintenanceEvent.elements != 'undefined' ? lobjMaintenanceEvent.elements : {};

		var lobjMaintenanceEventNode = this.createElement( 'maintenanceEvent', lobjAttributes, lobjElements );

		this.addElement( 'maintenanceEvent', lobjMaintenanceEventNode, '//*[local-name()=\'control\']/*[local-name()=\'maintenanceHistory\']' );
	}

	/*
	* editMaintenanceEvent edits the EAC maintenanceEvent element with desired index
	* @method editMaintenanceEvent
	*/
	eac.prototype.editMaintenanceEvent = function( lintIndex, lobjMaintenanceEvent )
	{
		var lobjAttributes = typeof lobjMaintenanceEvent.attributes != 'undefined' ? lobjMaintenanceEvent.attributes : {};
		var lobjElements = typeof lobjMaintenanceEvent.elements != 'undefined' ? lobjMaintenanceEvent.elements : {};

		var lobjMaintenanceEventNode = this.createElement( 'maintenanceEvent', lobjAttributes, lobjElements );

		this.editElementList( '//*[local-name()=\'control\']/*[local-name()=\'maintenanceHistory\']/*[local-name()=\'maintenanceEvent\']', lintIndex, lobjMaintenanceEventNode );
	}

	/*
	* addEntityId adds to the EAC an entity id
	* @method addEntityId
	*/
	eac.prototype.addEntityId = function( lstrValue )
	{
		this.addElement( 'entityId', lstrValue, '//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'entityType\']', true );
	}

	/*
	* deleteEntityId deletes from the EAC the entityId element with desired index
	* @method deleteEntityId
	*/
	eac.prototype.deleteEntityId = function( lintIndex )
	{
		this.deleteElement( '//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'entityId\']', lintIndex );
	}

	/*
	* editEntityType edits the EAC entityType element
	* @method editEntityType
	*/
	eac.prototype.editEntityType = function( lstrValue )
	{
		this.editElement( '//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'entityType\']', lstrValue );
	}

	/*
	* addNameEntry adds to the EAC a name entry element
	* @method addNameEntry
	*/
	eac.prototype.addNameEntry = function( lobjNameEntry )
	{
		var lobjAttributes = typeof lobjNameEntry.attributes != 'undefined' ? lobjNameEntry.attributes : {};
		var lobjElements = typeof lobjNameEntry.elements != 'undefined' ? lobjNameEntry.elements : {};

		var lobjNameEntryNode = this.createElement( 'nameEntry', lobjAttributes, lobjElements );

		this.addElement( 'nameEntry', lobjNameEntryNode, '//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']' );
	}

    /*
	* addCPFRelation adds to the EAC a cpfRelation element
	* @method addCPFRelation
	*/
	eac.prototype.addCPFRelation = function( lobjCPFRelation )
	{
		var lobjAttributes = typeof lobjCPFRelation.attributes != 'undefined' ? lobjCPFRelation.attributes : {};
		var lobjElements = typeof lobjCPFRelation.elements != 'undefined' ? lobjCPFRelation.elements : {};
											
		var lobjCPFRelationNode = this.createElement( 'cpfRelation', lobjAttributes, lobjElements );		
				
		if( this.doesElementExist('//*[local-name()=\'cpfDescription\']/*[local-name()=\'relations\']/*[local-name()=\'resourceRelation\']') )
			this.addElement( 'cpfRelation', lobjCPFRelationNode, '//*[local-name()=\'cpfDescription\']/*[local-name()=\'relations\']/*[local-name()=\'resourceRelation\']', true );
		else if( this.doesElementExist('//*[local-name()=\'cpfDescription\']/*[local-name()=\'relations\']/*[local-name()=\'functionRelation\']') )
			this.addElement( 'cpfRelation', lobjCPFRelationNode, '//*[local-name()=\'cpfDescription\']/*[local-name()=\'relations\']/*[local-name()=\'functionRelation\']', true );
		else
			this.addElement( 'cpfRelation', lobjCPFRelationNode, '//*[local-name()=\'cpfDescription\']/*[local-name()=\'relations\']' );
	}

	/*
	* addCPFRelationViaf adds to the EAC a cpfRelation element
	* @method addCPFRelationViaf
	*/
	eac.prototype.addCPFRelationViaf = function( lobjCPFRelationViaf )
	{
		var lobjAttributes = typeof lobjCPFRelationViaf.attributes != 'undefined' ? lobjCPFRelationViaf.attributes : {};
		var lobjElements = typeof lobjCPFRelationViaf.elements != 'undefined' ? lobjCPFRelationViaf.elements : {};
											
		var lobjCPFRelationNode = this.createElement( 'cpfRelation', lobjAttributes, lobjElements );		
				
		if( this.doesElementExist('//*[local-name()=\'cpfDescription\']/*[local-name()=\'relations\']/*[local-name()=\'resourceRelation\']') )
			this.addElement( 'cpfRelation', lobjCPFRelationNode, '//*[local-name()=\'cpfDescription\']/*[local-name()=\'relations\']/*[local-name()=\'resourceRelation\']', true );
		else if( this.doesElementExist('//*[local-name()=\'cpfDescription\']/*[local-name()=\'relations\']/*[local-name()=\'functionRelation\']') )
			this.addElement( 'cpfRelation', lobjCPFRelationNode, '//*[local-name()=\'cpfDescription\']/*[local-name()=\'relations\']/*[local-name()=\'functionRelation\']', true );
		else
			this.addElement( 'cpfRelation', lobjCPFRelationNode, '//*[local-name()=\'cpfDescription\']/*[local-name()=\'relations\']' );
	}
	
	/*
	* addCPFRelationCustom adds to the EAC a custom cpfRelation element
	* @method addCPFRelationCustom
	*/
	eac.prototype.addCPFRelationCustom = function( lobjCPFRelationCustom, lobjRoles, lobjRels )
	{
		var lobjAttributes = typeof lobjCPFRelationCustom.attributes != 'undefined' ? lobjCPFRelationCustom.attributes : {};
		var lobjElements = typeof lobjCPFRelationCustom.elements != 'undefined' ? lobjCPFRelationCustom.elements : {};
								
		// Added by timathom to allow user to select entity type and relation type when no good matches from VIAF.
		if ( lobjAttributes["xlink:role"] == '' )
		{		    		   
		    lobjAttributes["xlink:role"] = lobjRoles;		    		        		        		    		    
		}		
		
		if ( lobjAttributes["cpfRelationType"] == '' )
		{		    		   
		    lobjAttributes["cpfRelationType"] = lobjRels;		    		        		        		    		    
		}
		
		var lobjCPFRelationNode = this.createElement( 'cpfRelation', lobjAttributes, lobjElements );		
				
		if( this.doesElementExist('//*[local-name()=\'cpfDescription\']/*[local-name()=\'relations\']/*[local-name()=\'resourceRelation\']') )
			this.addElement( 'cpfRelation', lobjCPFRelationNode, '//*[local-name()=\'cpfDescription\']/*[local-name()=\'relations\']/*[local-name()=\'resourceRelation\']', true );
		else if( this.doesElementExist('//*[local-name()=\'cpfDescription\']/*[local-name()=\'relations\']/*[local-name()=\'functionRelation\']') )
			this.addElement( 'cpfRelation', lobjCPFRelationNode, '//*[local-name()=\'cpfDescription\']/*[local-name()=\'relations\']/*[local-name()=\'functionRelation\']', true );
		else
			this.addElement( 'cpfRelation', lobjCPFRelationNode, '//*[local-name()=\'cpfDescription\']/*[local-name()=\'relations\']' );
	}

	/*
	* addResourceRelation adds to the EAC a resourceRelation element
	* @method addResourceRelation
	*/
	eac.prototype.addResourceRelation = function( lobjResourceRelation )
	{
		var lobjAttributes = typeof lobjResourceRelation.attributes != 'undefined' ? lobjResourceRelation.attributes : {};
		var lobjElements = typeof lobjResourceRelation.elements != 'undefined' ? lobjResourceRelation.elements : {};

		var lobjResourceRelationNode = this.createElement( 'resourceRelation', lobjAttributes, lobjElements );

		if( this.doesElementExist('//*[local-name()=\'cpfDescription\']/*[local-name()=\'relations\']/*[local-name()=\'functionRelation\']') )
			this.addElement( 'resourceRelation', lobjResourceRelationNode, '//*[local-name()=\'cpfDescription\']/*[local-name()=\'relations\']/*[local-name()=\'functionRelation\']', true );
		else
			this.addElement( 'resourceRelation', lobjResourceRelationNode, '//*[local-name()=\'cpfDescription\']/*[local-name()=\'relations\']' );
	}

	/*
	* addSubjectHeading adds to the EAC a subject heading element
	* @method addSubjectHeading
	*/
	eac.prototype.addSubjectHeading = function( lobjSubjectHeading )
	{
		var lobjAttributes = typeof lobjSubjectHeading.attributes != 'undefined' ? lobjSubjectHeading.attributes : {};
		var lobjElements = typeof lobjSubjectHeading.elements != 'undefined' ? lobjSubjectHeading.elements : {};

		var lobjSubjectHeadingNode = this.createElement( 'localDescription', lobjAttributes, lobjElements );

		this.addElement( 'localDescription', lobjSubjectHeadingNode, '//*[local-name()=\'cpfDescription\']/*[local-name()=\'description\']/*[local-name()=\'biogHist\']', true );
	}

	/*
	* deleteSubjectHeading deletes from the EAC a subject heading element with desired index
	* @method deleteSubjectHeading
	*/
	eac.prototype.deleteSubjectHeading = function( lintIndex )
	{
		this.deleteElement( '//*[local-name()=\'cpfDescription\']/*[local-name()=\'description\']/*[local-name()=\'localDescription\']', lintIndex );
	}

	/*
	* addParagraph adds to the EAC a paragraph element to the biographic history element
	* @method addParagraph
	*/
	eac.prototype.addParagraph = function( lstrValue )
	{
		this.addElement( 'p', lstrValue, '//*[local-name()=\'cpfDescription\']/*[local-name()=\'description\']/*[local-name()=\'biogHist\']' );
	}

	/*
	* editParagraph edits the EAC paragraph element with desired index under the biographic history element
	* @method editParagraph
	*/
	eac.prototype.editParagraph = function( lintIndex, lstrValue )
	{
		this.editElementList( '//*[local-name()=\'cpfDescription\']/*[local-name()=\'description\']/*[local-name()=\'biogHist\']/*[local-name()=\'p\']', lintIndex, lstrValue );
	}

	/*
	* deleteParagraph deletes from the EAC a paragraph element with desired index under the biographic history element
	* @method deleteParagraph
	*/
	eac.prototype.deleteParagraph = function( lintIndex )
	{
		this.deleteElement( '//*[local-name()=\'cpfDescription\']/*[local-name()=\'description\']/*[local-name()=\'biogHist\']/*[local-name()=\'p\']', lintIndex );
	}

	/*
	* getParagraph returns from the EAC a list of paragraphs (DOMNode List) elements under the biographic history element
	* @method getParagraph
	*/
	eac.prototype.getParagraph = function()
	{
		return this.getElementList( '//*[local-name()=\'cpfDescription\']/*[local-name()=\'description\']/*[local-name()=\'biogHist\']/*[local-name()=\'p\']' );
	}

	/*
	* addSource adds to the EAC a source element
	* @method addSource
	*/
	eac.prototype.addSource = function( lobjSource )
	{
		var lobjAttributes = typeof lobjSource.attributes != 'undefined' ? lobjSource.attributes : {};
		var lobjElements = typeof lobjSource.elements != 'undefined' ? lobjSource.elements : {};

		var lobjSourceNode = this.createElement( 'source', lobjAttributes, lobjElements );

		//if sources element does not exist, need to create it and append source node and then add to EAC
		if( !this.doesElementExist('//*[local-name()=\'control\']/*[local-name()=\'sources\']') )
		{
			var lobjSourcesNode = this.createElement( 'sources', [], [] );
			lobjSourcesNode.appendChild( lobjSourceNode );

			this.addElement( 'sources', lobjSourcesNode, '//*[local-name()=\'control\']' );
		}else
			this.addElement( 'source', lobjSourceNode, '//*[local-name()=\'control\']/*[local-name()=\'sources\']' );
	}

	/*
	* addElement is the generic xml add element function. Adds an element with an xml element name lstrTag
	* and a value of lmxValue to the referenced xpath. There is an option to prepend it to the referenced
	* xpath
	* @method addElement
	*/
	eac.prototype.addElement = function( lstrTag, lmxValue, lstrReferencexPath, lboolBeforeReference)
	{
		lboolBeforeReference = typeof lboolBeforeReference !== 'undefined' ? lboolBeforeReference : false;

		if( lmxValue instanceof Object )
		{
			//if lmxValue is an object, assume that the node is passed
			var lobjNode = lmxValue;
		}else
		{
			var lobjNode = this.objDomDocument.createElementNS( 'urn:isbn:1-931666-33-4', lstrTag );
			var lobjTextNode = this.objDomDocument.createTextNode(lmxValue);
			lobjNode.appendChild(lobjTextNode);
		}

		var nsResolver = this.objDomDocument.createNSResolver(this.objDomDocument.ownerDocument == null ? this.objDomDocument.documentElement : this.objDomDocument.ownerDocument.documentElement);
		var nodes=this.objDomDocument.evaluate(lstrReferencexPath, this.objDomDocument, nsResolver, XPathResult.ANY_TYPE, null);
		var result=nodes.iterateNext();

		if(result != null)
		{
			if(lboolBeforeReference)
				result.parentNode.insertBefore(lobjNode, result);
			else
				result.appendChild(lobjNode);
		}
	}

	/*
	* editElementList is the generic xml edit element list function. Edits the nth element that matches the xpath query.
	* @method editElementList
	*/
 	eac.prototype.editElementList = function( lstrXPath, lintIndex, lmixValue )
	{
		var lintCounter = 0;

 		var nsResolver = this.objDomDocument.createNSResolver(this.objDomDocument.ownerDocument == null ? this.objDomDocument.documentElement : this.objDomDocument.ownerDocument.documentElement);
 		var nodes=this.objDomDocument.evaluate(lstrXPath, this.objDomDocument, nsResolver, XPathResult.ANY_TYPE, null);
 		var result=nodes.iterateNext();

 		while(result)
 		{
 			if( lintCounter == lintIndex )
 			{
 				if( lmixValue instanceof Object)
 					result.parentNode.replaceChild( lmixValue, result );
 				else
 				{
 					//remove all other children expect first child node so only text node remains
 					while(result.hasChildNodes && result.childNodes.length != 1)
 					{
 						result.removeChild(result.lastChild);
 					}

 					result.childNodes[0].nodeValue = lmixValue;
 				}
 				break;
 			}
 			lintCounter++;
 			result = nodes.iterateNext();
 		}
	}

	/*
	* editElement is the generic xml edit element function. Edits the element that matches the xpath query.
	* @method editElement
	*/
	eac.prototype.editElement = function( lstrXPath, lmixValue )
	{
		var nsResolver = this.objDomDocument.createNSResolver(this.objDomDocument.ownerDocument == null ? this.objDomDocument.documentElement : this.objDomDocument.ownerDocument.documentElement);
		var nodes=this.objDomDocument.evaluate(lstrXPath, this.objDomDocument, nsResolver, XPathResult.ANY_TYPE, null);
		var result=nodes.iterateNext();

		if( lmixValue instanceof Object)
			result.parentNode.replaceChild( lmixValue, result);
		else
		{
			//remove all other children expect first child node so only text node remains
			while(result.hasChildNodes && result.childNodes.length != 1)
			{
				result.removeChild(result.lastChild);
			}

			result.childNodes[0].nodeValue = lmixValue;
		}


	}

	/*
	* deleteElement is the generic xml delete element function. Deletes the nth element that matches the xpath query.
	* @method deleteElement
	*/
	eac.prototype.deleteElement = function( lstrXPath, lintIndex )
	{
		var lintCounter = 0;

		var nsResolver = this.objDomDocument.createNSResolver(this.objDomDocument.ownerDocument == null ? this.objDomDocument.documentElement : this.objDomDocument.ownerDocument.documentElement);
		var nodes=this.objDomDocument.evaluate(lstrXPath, this.objDomDocument, nsResolver, XPathResult.ANY_TYPE, null);
		var result=nodes.iterateNext();

		while(result)
		{
			if( lintCounter == lintIndex )
			{
				result.parentNode.removeChild(result);

				break;
			}
			lintCounter++;
			result = nodes.iterateNext();
		}


	}

	/*
	* doesElementExist returns true or false whether any element in the EAC matches the xpath query.
	* @method doesElementExist
	*/
	eac.prototype.doesElementExist = function( lstrXPath )
	{
		var nsResolver = this.objDomDocument.createNSResolver(this.objDomDocument.ownerDocument == null ? this.objDomDocument.documentElement : this.objDomDocument.ownerDocument.documentElement);
		var nodes=this.objDomDocument.evaluate(lstrXPath, this.objDomDocument, nsResolver, XPathResult.ANY_TYPE, null);

		var result = nodes.iterateNext();

		if( result != null )
		{
			return true;
		}

		return false;
	}

	/*
	* createElement creates an element(DOMNode) with passed attributes and passed elements as children. Recursive function.
	* @method createElement
	*/
	eac.prototype.createElement = function( lstrTag, lobjAttributes, lobjElements )
	{
		var lobjNode = this.objDomDocument.createElementNS( 'urn:isbn:1-931666-33-4', lstrTag );

		//go through list and set attributes with key as the name and array value as attribute value
		for( var lstrkey in lobjAttributes )
		{
			lobjNode.setAttribute( lstrkey, lobjAttributes[lstrkey] );
		}

		var lobjNodeList = [];

		//if passed element variable is an object, assume list of children elements
		if( typeof lobjElements == 'object')
		{
			//go through all element lists
			for( var lstrkey in lobjElements )
			{
				//array is a list of elements with same tags
				if(  lobjElements[lstrkey] instanceof Array )
				{
					var lobjNewNode = this.createElementList( lstrkey, lobjElements[lstrkey] );
				}else if( typeof lobjElements[lstrkey] == 'object' ) //object is another element that need to be created (recursive part)
				{
					var lobjAttributes = typeof lobjElements[lstrkey].attributes != 'undefined' ? lobjElements[lstrkey].attributes : {};
					var lobjInnerElements = typeof lobjElements[lstrkey].elements != 'undefined' ? lobjElements[lstrkey].elements : {};

					 var lobjNewNode = this.createElement( lstrkey, lobjAttributes, lobjInnerElements );
				}else //string to create TextNode with string and append as child
				{
					var lobjNewNode = this.objDomDocument.createElementNS( 'urn:isbn:1-931666-33-4', lstrkey );
					var lobjTextNode = this.objDomDocument.createTextNode(lobjElements[lstrkey]);
					lobjNewNode.appendChild(lobjTextNode);
				}

				//if array, merge lists. If not, push new node to list
				if( lobjNewNode instanceof Array )
				{
					lobjNodeList = lobjNodeList.concat( lobjNewNode );
				}else
				{
					lobjNodeList.push( lobjNewNode );
				}
			}

			//now with final list, append all nodes in list as children
			for( lintIndex in lobjNodeList )
			{
				lobjNode.appendChild(lobjNodeList[lintIndex]);
			}
		}else //passed element object is a string so create TextNode with string and append as child
		{
			lobjTextNode = this.objDomDocument.createTextNode(lobjElements);
			lobjNode.appendChild( lobjTextNode );
		}

		return lobjNode;
	}

	/*
	* createElementList creates an element (DOMNode) list with passed tag name and element object that contains element attributes and children elements.
	* @method createElementList
	*/
	eac.prototype.createElementList = function( lstrTag, lobjElements )
	{
		var lobjNodeList = [];

		for( var lstrkey in lobjElements )
		{
			var lobjAttributes = typeof lobjElements[lstrkey].attributes != 'undefined' ? lobjElements[lstrkey].attributes : {};
			var lobjInnerElements = typeof lobjElements[lstrkey].elements != 'undefined' ? lobjElements[lstrkey].elements : {};

			var lobjNode = this.createElement( lstrTag, lobjAttributes, lobjInnerElements );

			lobjNodeList.push( lobjNode );
		}

		return lobjNodeList;
	}

	/*
	* getElement is the generic xml get element function. Returns first element (DOMNode) that matches the xpath query.
	* @method getElement
	*/
	eac.prototype.getElement = function( lstrXPath )
	{
		var lobjList = null;
		lobjList = this.getElementList( lstrXPath )
		
		if( lobjList[0] != 'undefined' )
		{
			return lobjList[0];
		}

		return '';
	}

	/*
	* getElement is the generic xml get element function. Returns first element (DOMNode) that matches the xpath query.
	* @method getElement
	*/
	ead.prototype.getElement = eac.prototype.getElement;

	/*
	* getElementList is the generic xml get element list function. Returns element (DOMNode) list that matches the xpath query.
	* @method getElementList
	*/
	eac.prototype.getElementList = function( lstrXPath )
	{
		var lobjList = [];

		var nsResolver = this.objDomDocument.createNSResolver(this.objDomDocument.ownerDocument == null ? this.objDomDocument.documentElement : this.objDomDocument.ownerDocument.documentElement);
		var nodes=this.objDomDocument.evaluate(lstrXPath, this.objDomDocument, nsResolver, XPathResult.ANY_TYPE, null);
		var result = nodes.iterateNext();
		
		while(result)
		{
			lobjList.push(result);

			result = nodes.iterateNext();
		}

		return lobjList;
	}

	/*
	* getElementList is the generic xml get element list function. Returns element (DOMNode) list that matches the xpath query.
	* @method getElementList
	*/
	ead.prototype.getElementList = eac.prototype.getElementList;