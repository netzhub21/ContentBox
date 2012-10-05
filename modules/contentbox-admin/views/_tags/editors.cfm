<cfoutput>
<!--- Editor Javascript --->
<script type="text/javascript">
// Load Custom Editor Assets, Functions, etc.
#prc.oEditorDriver.loadAssets()#

// Quick preview for content
function previewContent(){
	// Open the preview window for content
	openRemoteModal( getPreviewSelectorURL(), 
					 { content: getEditorContent(), 
					   layout: $("##layout").val(),
					   title: $("##title").val(),
					   slug: $("##slug").val(),
					   contentType : $("##contentType").val() },
					 "95%",
					 "90%");
}
// Set the actual publishing date to now
function publishNow(){
	var fullDate = new Date();
	$("##publishedDate").val( getToday() );
	$("##publishedHour").val( fullDate.getHours() );
	$("##publishedMinute").val( fullDate.getMinutes() );
}
/**
 * Setup the editors. 
 * TODO: Move this to a more OOish approach, don't like it.
 * @param $theForm The form container for the content
 * @param withExcerpt Using excerpt or not
 */
function setupEditors($theForm, withExcerpt){
	// Setup global editor elements
	$uploaderBarLoader 	= $("##uploadBarLoader");
	$uploaderBarStatus 	= $("##uploadBarLoaderStatus");
	
	// with excerpt
	if( withExcerpt == null ){ withExcerpt = true; }
	
	// Startup the choosen editor
	#prc.oEditorDriver.startup()#

	// Activate Date fields
	$(":date").dateinput();

	// Activate Form Validator
	$theForm.validator({position:'top left',grouped:true,onSuccess:function(e,els){ needConfirmation=false; }});
	// Custom content unique validator
	$.tools.validator.fn($content, function(el, value) {
		if( value.length ){ return true; }
		alert("Please enter some content!");
		return false;
	});
	// Activate blur slugify on titles
	var $title = $theForm.find("##title");
	$title.blur(function(){
		if( $theForm.find("##slug").size() ){
			createPermalink( $title.val() );
		}
	});
	// Editor dirty checks
	window.onbeforeunload = askLeaveConfirmation;
	needConfirmation = true;
}

// Switch Editors
function switchEditor(editorType){
	// destroy the editor
	#prc.oEditorDriver.shutdown()#
	// Call change user editor preference
	$.ajax({
		url : '#event.buildLink(prc.xehAuthorEditorSave)#',
		data : {editor: $("##contentEditorChanger").val()},
		async : false,
		success : function(data){
			// Once changed, reload the page.
			location.reload();
		}
	});
}

// Ask for leave confirmations
function askLeaveConfirmation(){
	if ( checkIsDirty() && needConfirmation ){
   		return "You have unsaved changes.";
   	}
}

// Create Permalinks
function createPermalink(){
	var slugger = $("##sluggerURL").val();
	$slug = $("##slug").fadeOut();
	$.get(slugger,{slug:$("##title").val()},function(data){
		$slug.fadeIn().val($.trim(data));
	} );
}

// Toggle drafts on for saving
function toggleDraft(){
	needConfirmation = false;
	$isPublished.val('false');
}

// Widget Plugin Integration
function getWidgetSelectorURL(){ return '#event.buildLink(prc.cbAdminEntryPoint & ".widgets.editorselector")#';}
// Page Selection Integration
function getPageSelectorURL(){ return '#event.buildLink(prc.cbAdminEntryPoint & ".pages.editorselector")#';}
// Entry Selection Integration
function getEntrySelectorURL(){ return '#event.buildLink(prc.cbAdminEntryPoint & ".entries.editorselector")#';}
// Custom HTML Selection Integration
function getCustomHTMLSelectorURL(){ return '#event.buildLink(prc.cbAdminEntryPoint & ".customHTML.editorselector")#';}
// Preview Integration
function getPreviewSelectorURL(){ return '#event.buildLink(prc.cbAdminEntryPoint & ".content.preview")#';}
// Module Link Building
function getModuleURL(module, event, queryString){
	var returnURL = "";
	$.ajax({
		url : '#event.buildLink(prc.cbAdminEntryPoint & ".modules.buildModuleLink")#',
		data : {module: module, moduleEvent: event, moduleQS: queryString},
		async : false,
		success : function(data){
			returnURL = data;
		}
	});
	return $.trim( returnURL );
}
// Toggle upload/saving bar
function toggleLoaderBar(){
	// Activate Loader
	$uploaderBarStatus.html("Saving...");
	$uploaderBarLoader.slideToggle();
}
</script>
</cfoutput>