﻿<cfoutput>
<!--- Main Content Goes Here --->
<div class="left">
	<!--- top gap --->
	<div class="post-top-gap"></div>
	
	<!--- BlogBoxEvent --->
	#bb.event("bbui_preArchivesDisplay")#
	
	<!--- Title --->
	<h1>Blog Archives - #prc.entriesCount# Record(s)</h1>
	
	<!--- Archives --->
	<cfif rc.year NEQ 0>
		<div class="buttonBar">
			<button class="button2" onclick="return to('#bb.linkHome()#')" title="Remove filter and view all entries">Remove Filter</button>
		</div>
		<div class="infoBar">
			Year: '#rc.year#'
			<cfif rc.month NEQ 0>- Month: '#rc.month#'</cfif>
			<cfif rc.day NEQ 0>- Day: '#rc.day#'</cfif>
		</div>
		<br/>
	</cfif>
		
	<!--- 
		Display Entries using BlogBox collection template rendering
		The default convention for the template is "entry.cfm" you can change it via the quickEntries() 'template' argument.
		I could have done it manually, but why?
	 --->
	#bb.quickEntries()#
		
	<!--- Paging via BlogBox via quick HTML, again I could have done it manually, but why? --->
	<cfif prc.entriesCount>
		<div class="contentBar">#bb.quickPaging()#</div>
	</cfif>
	
	<!--- BlogBoxEvent --->
	#bb.event("bbui_postArchivesDisplay")#
	
</div> 

<!--- SideBar: That's right, I can render any layout views by using quickView() or coldbo'x render methods --->
<div class="right">#bb.quickView(view='sidebar')#</div> 	

<!--- Separator --->
<div class="clr"></div>
</cfoutput>