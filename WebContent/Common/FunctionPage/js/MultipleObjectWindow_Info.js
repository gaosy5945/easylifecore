var InfoObjectWindowFunctions={};

InfoObjectWindowFunctions.getResultInfo=function(dwname){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	return aDWResultInfo[tableIndex];
};
InfoObjectWindowFunctions.getResultError=function(dwname){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	return aDWResultError[tableIndex];
};
InfoObjectWindowFunctions.getResultStatus=function(dwname){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	if(aDWResultError[tableIndex]==null || aDWResultError[tableIndex]==undefined || aDWResultError[tableIndex]=='')
		return "success";
	else
		return "fail";
};

InfoObjectWindowFunctions.getItemValue=function(dwname,rowindex,fieldName){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var dwindex = dwname.substring(8);
	
	var result = "";
	var objs = getObjs(dwindex,fieldName);
	if(objs==null||objs == undefined||objs.length<=0) return result;
	var length = objs.length;
	if(objs[0].type.toLowerCase()=="radio"){
		for(var i=0;i<length;i++){
			if(objs[i].checked){
				result = objs[i].value;
				break;
			}
		}
	}
	else if(objs[0].type.toLowerCase()=="checkbox"){
		for(var i=0;i<length;i++){
			if(objs[i].checked){
				if(result=="")result = objs[i].value;
				else result += ","+objs[i].value;
			}
		}
	}
	else{
		if(objs[length-1].getAttribute("initValue")){
			var result0 = objs[length-1].getAttribute("initValue");
			var result1 = objs[length-1].value;
			if(objs[length-1].options.length<=1)
				result = result0;
			else
				result = result1;
		}else{
			if(objs[length-1].getAttribute("alstype")=="KNumber")
				result = objs[length-1].value.replace(/,/g,"");
			else
				result = objs[length-1].value;
		}
	}
	return result;
};

InfoObjectWindowFunctions.setItemValue=function(dwname,rowindex,fieldName,value){
	
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var dwindex = dwname.substring(8);
	
	var sSplit = isMultyInput(dwindex,fieldName);
	if(sSplit!=null){//复合字段的处理
		var objs = getObjs(dwindex,fieldName);//document.getElementsByName(fieldName);
		var length = objs.length;
		var aValue = value.split(sSplit);
		for(var i=0;i<length;i++){
			if(objs[i].type.toLowerCase()=="checkbox"){
				if(isStrInArray(aValue,objs[i].value))
					objs[i].checked = true;
				else
					objs[i].checked = false;
			}else if(objs[i].type.toLowerCase()=="select-multiple"){
				var options = objs[i].options;
				for(var j=0;j<options.length;j++){
					if(isStrInArray(aValue,options[j].value))
						options[j].selected = true;
					else
						options[j].selected = false;
				}
			}else if(objs[i].getAttribute("alstype")=="PictureRadio"){//图片单选框的处理
				var els = document.getElementsByTagName("a");
				for(var j=0;j<els.length;j++){
					if(els[j].getAttribute("radioname")==objs[i].name){
						els[j].value = aValue[i];
						CHANGED=true;
						setPicRaidoCss(els[j].id);
					}
				}
			}else{
				if(aValue[i]){
					
					objs[i].value = aValue[i];
				}
				else
					objs[i].value = "";
			}
		}
	}else{
		var objs = getObjs(dwindex,fieldName);//document.getElementsByName(fieldName);
		if(objs==null) {return;}
		var length = objs.length;
		for(var i=0;i<length;i++){
			if(objs[i].getAttribute("floatMenu")=="true"){//联动菜单的处理
				var fields = getFloatMenuObjNames(dwindex,fieldName);
				var aFieldName = fields.split(",");
				var aValue = value.split(",");
				for(var j=0;j<aFieldName.length;j++){
					aFieldName[j] = aFieldName[j].toUpperCase();
					var input = getObj(dwindex,aFieldName[j]);
					if(input){
						for(var t=0;t<input.options.length;t++){
							if(input.options[t].value == aValue[j]){
								input.options[t].selected = true;
								if(j<aFieldName.length-1){
									eval("(getChildArr_" + aFieldName[j] + "())");
								}
							}
						}
					}
				} 
			}else if(objs[i].getAttribute("alstype")=="MyltyText"){//MyltyText的处理
				var aValue = value.split(objs[i].aplitchar);
				var fobjs = getObjs(dwindex,"f_" + fieldName);//document.getElementsByName("f_" + fieldName);
				if(fobjs){
					
					for(var j=0;j<fobjs.length;j++){
						if(aValue[j])
							fobjs[j].value = aValue[j];
						else
							fobjs[j].value = "";
					}
				}
				getObjs(dwindex,fieldName)[0].value = value;
			}else if(objs[i].getAttribute("alstype")=="KNumber"){//千分位的处理
				objs[i].value=getDWFomatedNumber(value,objs[i].getAttribute("colcheckformat"));
			}else if(objs[i].getAttribute("alstype")=="PictureRadio"){//图片单选框的处理
				var els = document.getElementsByTagName("a");
				if(value==""){
					setPicRaidoCss(els[0].getAttribute("id"),"empty");
				}else{
					for(var j=0;j<els.length;j++){
						if(els[j].getAttribute("radioname")==fieldName && els[j].getAttribute("value")==value){
							CHANGED=true;
							setPicRaidoCss(els[j].getAttribute("id"));
						}
					}
				}
			}else if(objs[i].getAttribute("alstype")=="YearMonth"){//月份选择的处理
				var aValue = value.split("/");
				var el0 = getObjs(dwindex,"Year_" + fieldName)[0].options;
				for(var j=0;j<el0.length;j++){
					if(el0[j].value==aValue[0]){
						el0[j].selected = true;
						break;
					}
				}
				if(value=="")el0[0].selected=true;
				var el1 = getObjs(dwindex,"Month_" + fieldName)[0].options;
				for(var j=0;j<el1.length;j++){
					if(el1[j].value==aValue[1]){
						el1[j].selected = true;
						break;
					}
				}
				if(value=="")el1[0].selected=true;
				objs[i].value = value;
			}else if(objs[i].getAttribute("alstype")=="FlatSelect"){
				objs[i].value = value;
				//alert($(objs[i]).parent().html());
				var flatSelect = $(objs[i]).data("FlatSelect");
				if(flatSelect && typeof flatSelect["setValue"] == "function")
					flatSelect["setValue"](value);
			}else if(objs[i].tagName.toLowerCase()=="select"){//普通选择框的处理
				objs[i].setAttribute("initValue",value);
				var els = objs[i].options;
				for(var j=0;j<els.length;j++){
					if(els[j].value==value){
						els[j].selected = true;
						break;
					}
				}
			}else if(objs[i].type.toLowerCase()=="radio"){//单选框的处理
				//alert(value);
				if(value=="")
					objs[i].checked = false;
				else if(objs[i].value==value){
					objs[i].checked = true;
				}
			}else{
				//alert(value);
				//当为非编辑状态的时候checkbox setItemValue会出现无法选中状态，这里需要特别处理
				if(objs[i].type.toLowerCase()=="checkbox"){
					if(isStrInArray(value.split(objs[i].splitchar),objs[i].value))
						objs[i].checked = true;
					else
						objs[i].checked = false;
				}else
					objs[i].value = value;
			}
		}
	}
};

InfoObjectWindowFunctions.updateSuccess=function(msg,postevents){
	if(getResultStatus(0)=="success"){
		resetDWDialog(msg,true);
		//alert(postevents.substring(postevents.length-1,postevents.length) == ";");
		CHANGED = false;
		if(postevents==undefined || postevents=="" || postevents=="undefined")
			return;
		else if(postevents.substring(postevents.length-1,postevents.length) == ";")
			eval(postevents);
		else
			eval("("+ postevents +")");
	}else{
		resetDWDialog(msg,false);
	}
};

InfoObjectWindowFunctions.as_isPageChanged=function(){
	return isUserChanged();
};

InfoObjectWindowFunctions.change_height_after=function(colcount){
	if(colcount<=1){
		try {
			if(parent.document.getElementById("wizard-body")) {
				var oClass = $(".info_td_left");
				var i = 0;
				for(i=0;i<oClass.length;i++)	
						try { oClass[i].style.width = (document.body.offsetWidth - 190)/2;}catch(e) {}
				var oClassEven = $(".info_td_left_even");
				i = 0;
				for(i=0;i<oClassEven.length;i++)	
						try { oClassEven[i].style.width = (document.body.offsetWidth - 190)/2;}catch(e) {}
			}
		}catch(e) {}	
	}
};

InfoObjectWindowFunctions.as_createFormDatas=function (){
	var result = new Object();
	result.type="info";
	result.serializedJbo=document.getElementById("SERIALIZED_JBO").value;
	result.serializedAsd=document.getElementById("SERIALIZED_ASD").value;
	result.action=document.getElementById("SYS_ACTION").value;
	var sUpdatedFields = document.getElementById("UPDATED_FIELD").value;
	if(sUpdatedFields.length>0){
		result.updatedFields=sUpdatedFields.split(",");
		result.fieldValues = new Object();
		for(var i=0;i<result.updatedFields.length;i++){
			result.fieldValues[result.updatedFields[i]]= getItemValue(0,0,result.updatedFields[i]);
		}
	}else
		result.updatedFields=[];
	//载入所有数据
	result.allFieldNames =DisplayFields[0];
	if(DisplayFields[0]){
		result.allFieldValues = new Object();
		for(var i=0;i<DisplayFields[0].length;i++){
			result.allFieldValues[DisplayFields[0][i]]= getItemValue(0,0,DisplayFields[0][i]);
			//alert("result.allFieldValues["+DisplayFields[0]+"]=" + "=" + result.allFieldValues[DisplayFields[0]]);
		}
	}
	//result.updatedFields=document.getElementById("UPDATED_FIELD").value;
	return result;
};