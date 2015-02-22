var DataAPIExtensionTemplates = {};

DataAPIExtensionTemplates.extendEndPoints = function(api) {
	api.generateEndpointMethods( [ {
	  "id" : "donut_list_templates",
	  "route" : "/sites/:site_id/donut/templates",
	  "verb" : "GET",
	  "resources" : null
	} , {
	  "id" : "donut_template",
	  "route" : "/sites/:site_id/donut/template/:template_id",
	  "verb" : "GET",
	  "resources" : null
	} , {
	  "id" : "donut_update_template",
	  "route" : "/sites/:site_id/donut/template/:template_id",
	  "verb" : "PUT",
	  "resources" : [ "template" ]
	}
	] );
};


