function getquerystring(formname) {
    var form = document.forms[formname];
    	qstr += (qstr.length > 0 ? "&" : "") + name + "=" + encodeURI(encodeURI(value ? value : ""));
    }
    function GetHiddenElemValue(name, value) {
    	//�������id��Ҫȡԭֵ,��˽�hidden����Ϊ������
    	if(name=="CompClientID" || name=="PageClientID" || name=="ToDestroyPageClientID"){
    		qstr += (qstr.length > 0 ? "&" : "") + name + "=" + (name.value ? name.value : "");
    	}else{
    		GetElemValue(name, value);
    	}
    }
	var elemArray = form.elements;
            else if (elemType == "HIDDEN" )			//�������id��Ҫȡԭֵ,��˽�hidden����Ϊ������
            	GetHiddenElemValue(elemName, element.value);