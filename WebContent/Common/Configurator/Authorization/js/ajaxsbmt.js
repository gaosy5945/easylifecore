function getquerystring(formname) {
    var form = document.forms[formname];	var qstr = "";    function GetElemValue(name, value) {
    	qstr += (qstr.length > 0 ? "&" : "") + name + "=" + encodeURI(encodeURI(value ? value : ""));
    }
    function GetHiddenElemValue(name, value) {
    	//由于组件id需要取原值,因此将hidden暂设为不加密
    	if(name=="CompClientID" || name=="PageClientID" || name=="ToDestroyPageClientID"){
    		qstr += (qstr.length > 0 ? "&" : "") + name + "=" + (name.value ? name.value : "");
    	}else{
    		GetElemValue(name, value);
    	}
    }
	var elemArray = form.elements;    for (var i = 0; i < elemArray.length; i++) {        var element = elemArray[i];        var elemType = element.type.toUpperCase();        var elemName = element.name;        if (elemName) {            if (elemType == "TEXT"                    || elemType == "TEXTAREA"                    || elemType == "PASSWORD"					//|| elemType == "BUTTON"					|| elemType == "RESET"					|| elemType == "SUBMIT"					|| elemType == "FILE"					|| elemType == "IMAGE")                GetElemValue(elemName, element.value);
            else if (elemType == "HIDDEN" )			//由于组件id需要取原值,因此将hidden暂设为不加密
            	GetHiddenElemValue(elemName, element.value);            else if (elemType == "CHECKBOX" && element.checked)                GetElemValue(elemName,                     element.value ? element.value : "On");            else if (elemType == "RADIO" && element.checked)                GetElemValue(elemName, element.value);            else if (elemType.indexOf("SELECT") != -1)                for (var j = 0; j < element.options.length; j++) {                    var option = element.options[j];                    if (option.selected)                        GetElemValue(elemName,                            option.value ? option.value : option.text);                }        }    }    return qstr;}