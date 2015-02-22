    function setCookie(key,value,period,path) {
    	var tmp = key + "=" + encodeURI(value) + ";";
    	if (period) {
    		var nowtime = new Date().getTime();
    		var lim = new Date();
    		lim.setTime(nowtime + period);
    		tmp += "expires="+lim.toGMTString()+";";
    	}
    	if (path) {
    	  tmp += "path="+path+";";
    	}
    	document.cookie = tmp;
    };

    function getCookie(key) {
    	var tmp = document.cookie + ";";
    	var len = tmp.length;
    	var x=0;
    	while (x<len) {
    		var y = tmp.indexOf(";",x);
    		var tmp2 = tmp.substring(x,y);
    		while (tmp2.substring(0,1) == ' ') {
    			tmp2 = tmp2.substring(1,tmp2.length);
    		}
    		var x3 = tmp2.indexOf("=");
    		if (tmp2.substring(0,x3) == key) {
    			return decodeURI(tmp2.substring(x3 + 1 , tmp2.length ));
    		}
    		x = y + 1;
    	}
    	return "";
    };

    function escapeHTML2(html) {
    	return jQuery('<div>').text(html).html();
    }
