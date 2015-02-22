(function($){ 
	
	$.mtConnect = function(options) {
		this.clientId = options.clientId;
		this.api = null;
	
		this.doLogin = function(url,account,passwd) {
			var def = new jQuery.Deferred();

			this.api = new MT.DataAPI({
				baseUrl:  url,
				clientId: this.clientId
			});
			DataAPIExtensionTemplates.extendEndPoints(this.api);

			var self = this;
			this.api.authenticate({ username: account, password: passwd }, function(response) {
				if (response.error) {
					var code = response.error.code;
					var msg;
					if (code === 404 ) {
						msg = 'Cannot access to Data API CGI script. Please confirm URL for Data API Scrpt.';	
					} else if (code === 401 ) {
						msg = 'Failed to sign in to Movable Type. Please confirm your Username or Password.';
					} else {
						msg = response.error.message;
					}
					def.reject(msg);
				} else {
					self.api.storeTokenData(response);
					def.resolve();
				}
			});
			return def.promise();
		
		};
		
		this.loadSitelist = function() {
			var def = new jQuery.Deferred();
			var self = this;
			this.api.listBlogsForUser('me', function(response) {
				if (response.error) {
					var msg = self.errorMessage(response.error.code);
					def.reject(msg);
				} else {
					def.resolve(response.items);
				}
			});
			return def.promise();
		};
		
		this.loadTemplates = function(siteId) {
			var def = new jQuery.Deferred();
			var self = this;
	    	this.api.donutListTemplates( siteId , function(response) {
	    		if (response.error) {
					var msg = self.errorMessage(response.error.code);
					def.reject(msg);
	    		} else {
					def.resolve(response.items);
	    		}
    		});
			return def.promise();
		};
		
		this.loadTemplate = function(siteId,tmplId) {
			var def = new jQuery.Deferred();
			var self = this;
	    	this.api.donutTemplate( siteId , tmplId , function(response) { 
	    		if (response.error) {
					var msg = self.errorMessage(response.error.code);
					def.reject(msg);
	    		} else {
//	       			var str = JSON.stringify( response );
					def.resolve(response);
	    		}
	    	});
			return def.promise();
		}

		this.updateTemplate = function(siteId,tmplId,json) {
			var def = new jQuery.Deferred();
			var self = this;
	    	this.api.donutUpdateTemplate( siteId , tmplId , json , function(response) { 
	    		if (response.error) {
					var msg = self.errorMessage(response.error.code);
					def.reject(msg);
	    		} else {
					def.resolve(response);
	    		}
	    	});
			return def.promise();
		}
		
		this.errorMessage = function(code) {
			var msg;
			if (code === 404 ) {
				msg = 'User not found.';
			} else if (code === 403 ) {
				msg = 'You have no permissions.';
			} else {
				msg = code;
			}
			return msg;
		};
		
	};
	
})(jQuery);