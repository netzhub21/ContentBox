/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
Update for 1.1.0 release

Start Commit Hash: 2397a39
End Commit Hash: c4c67e7

*/
component implements="contentbox.model.updates.IUpdate"{

	// DI
	property name="settingService"			inject="id:settingService@cb";
	property name="permissionService" 		inject="permissionService@cb";
	property name="roleService" 			inject="roleService@cb";
	property name="securityRuleService"		inject="securityRuleService@cb";
	property name="pageService"				inject="pageService@cb";
	property name="coldbox"					inject="coldbox";
	property name="fileUtils"				inject="coldbox:plugin:FileUtils";
	property name="log"						inject="logbox:logger:{this}";

	function init(){
		version = "1.1.0";
		return this;
	}

	/**
	* pre installation
	*/
	function preInstallation(){

		try{
			transaction{

				log.info("About to beggin #version# patching");
				
				// update settings
				updatePermissions();
				// update AdminR Role
				updateAdmin();
				// update Editor Role
				updateEditor();
				
				log.info("Finalized #version# patching");
			}
		}
		catch(Any e){
			ORMClearSession();
			log.error("Error doing #version# patch preInstallation. #e.message# #e.detail#", e);
			rethrow;
		}

	}

	/**
	* post installation
	*/
	function postInstallation(){
		try{
			transaction{

			}
		}
		catch(Any e){
			ORMClearSession();
			log.error("Error doing #version# patch postInstallation. #e.message# #e.detail#", e);
			rethrow;
		}
	}
	
	function updateAdmin(){
		var oRole = roleService.findWhere({role="Administrator"});
		// Add in new permissions
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_DISPLAY_OPTIONS"}) );
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_MODIFIERS"}) );
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_CACHING"}) );
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_CATEGORIES"}) );
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_HTML_ATTRIBUTES"}) );
		// save role
		roleService.save(entity=oRole,transactional=false);

		return oRole;
	}
	
	function updateEditor(){
		var oRole = roleService.findWhere({role="Editor"});
		// Add in new permissions
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_DISPLAY_OPTIONS"}) );
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_MODIFIERS"}) );
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_CACHING"}) );
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_CATEGORIES"}) );
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_HTML_ATTRIBUTES"}) );
		// save role
		roleService.save(entity=oRole,transactional=false);

		return oRole;
	}
	
	function updatePermissions(){
		var perms = {
			"EDITORS_DISPLAY_OPTIONS" = "Ability to view the content display options panel",
			"EDITORS_MODIFIERS" = "Ability to view the content modifiers panel",
			"EDITORS_CACHING" = "Ability to view the content caching panel",
			"EDITORS_CATEGORIES" = "Ability to view the content categories panel",
			"EDITORS_HTML_ATTRIBUTES" = "Ability to view the content HTML attributes panel"
		};

		var allperms = [];
		for(var key in perms){
			var props = {permission=key, description=perms[key]};

			if( isNull( permissionService.findWhere({permission=props.permission}) ) ){
				permissions[ key ] = permissionService.new(properties=props);
				arrayAppend(allPerms, permissions[ key ] );
			}
		}
		permissionService.saveAll(entities=allPerms,transactional=false);
	}


}