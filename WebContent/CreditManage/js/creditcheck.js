//页面上核查意见下拉框点击事件   校验是否选择意见
function selectValidate(obj){
	var flag = false;
	var selectID = obj.id;
	var isRequired = obj.getAttribute("required");
	var groupId = obj.getAttribute("groupId");
	var itemId = obj.getAttribute("itemId");
	var selectedValue = obj.options[obj.options.selectedIndex].value;
	var OpinionDivObj = document.getElementById("OpinionDiv_"+groupId+"_"+itemId);
	if(isRequired == "true" && ( selectedValue== "" || typeof(selectedValue) == "undefined")){
		flag = false;
		if( OpinionDivObj == null || typeof(OpinionDivObj) == "undefined" || OpinionDivObj.length == 0){
			return flag;
		}
		OpinionDivObj.style.display="";
	}else{
		flag = true;
		if( OpinionDivObj == null || typeof(OpinionDivObj) == "undefined" || OpinionDivObj.length == 0){
			return flag;
		}
		OpinionDivObj.style.display="none";
	}
	return flag;
}

function textValidate(obj){
	var flag = false;
	var isRequired = obj.getAttribute("required");
	var groupId = obj.getAttribute("groupId");
	var itemId = obj.getAttribute("itemId");
	var placeholder = obj.getAttribute("placeholder");
	var selectedValue = obj.value;
	var OpinionTextObj = document.getElementById("OpinionText_"+groupId+"_"+itemId);
	if(isRequired == "true" && ( selectedValue== "" || selectedValue== placeholder || typeof(selectedValue) == "undefined")){
		flag = false;
		if( OpinionTextObj != null && typeof(OpinionTextObj) != "undefined"){
			OpinionTextObj.style.display="";
		}
	}else{
		flag = true;
		if( OpinionTextObj != null && typeof(OpinionTextObj) != "undefined"){
			OpinionTextObj.style.display="none";
		}
	}
	return flag;
}

function saveInfo(){
	saveInfoDiv.style.display="";
}

function radioValidate(obj){
	var flag = false;
	var isRequired = obj.getAttribute("required");
	var groupId = obj.getAttribute("groupId");
	var itemId = obj.getAttribute("itemId");
	var objRadioGroup = document.getElementsByName("Opinion_" + groupId + "_" + itemId);
	var selectedValue = "";
	var OpinionDivObj = document.getElementById("OpinionDiv_"+groupId+"_"+itemId);
	//用于控制当横向单选框选择不一致时   填写备注
	var OpinionTextObj = document.getElementById("OpinionText_"+groupId+"_"+itemId);
	var RemarkObj = document.getElementById("Remark_"+groupId+"_"+itemId);
	for(var radioj=0; radioj<objRadioGroup.length;radioj++){
		if(objRadioGroup[radioj].checked){ 
			selectedValue = objRadioGroup[radioj].value; 
			break;
		}
	}
	if (isRequired == "true" && (selectedValue == "" || typeof (selectedValue) == "undefined")) {
		flag = false;
		if( OpinionDivObj != null && typeof(OpinionDivObj) != "undefined"){
			OpinionDivObj.style.display="";
		}
	} else {
		flag = true;
		if( OpinionDivObj != null && typeof(OpinionDivObj) != "undefined"){
			OpinionDivObj.style.display = "none";
		}
	}
	return flag;
}

function telCheckRadioChange(obj){
	var groupId = obj.getAttribute("groupId");
	var itemId = obj.getAttribute("itemId");
	var selectedValue = obj.value; 
	//用于控制当横向单选框选择不一致时   填写备注
	var OpinionTextObj = document.getElementById("OpinionText_"+groupId+"_"+itemId);
	var RemarkObj = document.getElementById("Remark_"+groupId+"_"+itemId);
	//当横向单选框选择不一致时   需要填写备注
	if(selectedValue == "0002" && !(RemarkObj == null)){ 
		RemarkObj.setAttribute("required","true");
		RemarkObj.removeAttribute("disabled"); 
		var Remark = RemarkObj.value;
		var RemarkPlaceholder = RemarkObj.getAttribute("placeholder");
		if(OpinionTextObj != null && (typeof(Remark) == "undefined" || Remark.length == 0 || Remark == "" || Remark == RemarkPlaceholder)){
			OpinionTextObj.style.display = "";
		}
	}else if(!(RemarkObj == null)){
		RemarkObj.setAttribute("required","false");
		RemarkObj.setAttribute("disabled","true"); 
		RemarkObj.value = ""; 
		if(OpinionTextObj != null){
			OpinionTextObj.style.display = "none";
		}
	}
}

function accompanyvalidate(obj){
	var groupId = obj.getAttribute("groupId");
	var itemId = obj.getAttribute("itemId");
	var selectedValue = obj.value;
	if(itemId == "0023"){
		var objRadioGroup = document.getElementsByName("Opinion_" + groupId + "_0024");
		if(selectedValue == "0001"){
			for(var j=0; j<objRadioGroup.length;j++)    {
				objRadioGroup[j].setAttribute("required","false"); 
				objRadioGroup[j].checked = false;
				objRadioGroup[j].setAttribute("disabled","true"); 
			}
			document.getElementById("Remark_" + groupId + "_0025").setAttribute("required","false");
			document.getElementById("Remark_" + groupId + "_0026").setAttribute("required","false");
			document.getElementById("Remark_" + groupId + "_0025").value = ""; 
			document.getElementById("Remark_" + groupId + "_0026").value = ""; 
			document.getElementById("Remark_" + groupId + "_0025").setAttribute("disabled","true"); 
			document.getElementById("Remark_" + groupId + "_0026").setAttribute("disabled","true"); 
			document.getElementById("OpinionDiv_" + groupId + "_0024").style.display = "none";
			document.getElementById("OpinionDiv_" + groupId + "_0025").style.display = "none";
			document.getElementById("OpinionDiv_" + groupId + "_0026").style.display = "none";
			document.getElementById("OpinionRequiredSign_" + groupId + "_0024").style.display = "none";
			document.getElementById("OpinionRequiredSign_" + groupId + "_0025").style.display = "none";
			document.getElementById("OpinionRequiredSign_" + groupId + "_0026").style.display = "none";
			
		}
		else{
			for(var j=0; j<objRadioGroup.length;j++)    {
				objRadioGroup[j].setAttribute("required","true"); 
				objRadioGroup[j].removeAttribute("disabled"); 
			}
			document.getElementById("Remark_" + groupId + "_0025").setAttribute("required","true");
			document.getElementById("Remark_" + groupId + "_0026").setAttribute("required","true");
			document.getElementById("Remark_" + groupId + "_0025").removeAttribute("disabled"); 
			document.getElementById("Remark_" + groupId + "_0026").removeAttribute("disabled"); 
			document.getElementById("OpinionRequiredSign_" + groupId + "_0024").style.display = "";
			document.getElementById("OpinionRequiredSign_" + groupId + "_0025").style.display = "";
			document.getElementById("OpinionRequiredSign_" + groupId + "_0026").style.display = "";
		}
	}
	else if(itemId == "0024"){
		if(selectedValue == "0002"){
			document.getElementById("Remark_" + groupId + "_0025").setAttribute("required","false");
			document.getElementById("Remark_" + groupId + "_0026").setAttribute("required","false");
			document.getElementById("Remark_" + groupId + "_0025").value = ""; 
			document.getElementById("Remark_" + groupId + "_0026").value = ""; 
			document.getElementById("Remark_" + groupId + "_0025").setAttribute("disabled","true"); 
			document.getElementById("Remark_" + groupId + "_0026").setAttribute("disabled","true"); 
			document.getElementById("OpinionDiv_" + groupId + "_0025").style.display = "none";
			document.getElementById("OpinionDiv_" + groupId + "_0026").style.display = "none";
			document.getElementById("OpinionRequiredSign_" + groupId + "_0025").style.display = "none";
			document.getElementById("OpinionRequiredSign_" + groupId + "_0026").style.display = "none";
		}
		else{
			document.getElementById("Remark_" + groupId + "_0025").setAttribute("required","true");
			document.getElementById("Remark_" + groupId + "_0026").setAttribute("required","true");
			document.getElementById("Remark_" + groupId + "_0025").removeAttribute("disabled"); 
			document.getElementById("Remark_" + groupId + "_0026").removeAttribute("disabled"); 
			document.getElementById("OpinionRequiredSign_" + groupId + "_0025").style.display = "";
			document.getElementById("OpinionRequiredSign_" + groupId + "_0026").style.display = "";
		}
	}
}

function pageValidate(groupId,itemId,validateType){
	var validateFlag = true;
	var inputObject = document.getElementsByTagName("input");
	var selects = document.getElementsByTagName("Select");
	for(var ii=0;ii<inputObject.length;ii++){
		 if ("text" == inputObject[ii].type){
			 validateFlag = (textValidate(inputObject[ii]) && validateFlag);
		 }
		 else if("radio" == inputObject[ii].type){
			 validateFlag = (radioValidate(inputObject[ii]) && validateFlag);
		 }
	}
	for(var si=0;si<selects.length;si++){
		validateFlag = (selectValidate(selects[si]) && validateFlag);
	}
	if(validateFlag == false){
		alert("请检查必查项的核查意见是否选择!");
		return false;
	}
	return validateFlag;
}

function initAccompanyGroup(){
	try{
		var objRadioGroup23 = document.getElementsByName("Opinion_0016_0023");
		var objRadioGroup24 = document.getElementsByName("Opinion_0016_0024");
		if(objRadioGroup23 == null || typeof(objRadioGroup23) == "undefined") return;
		if(objRadioGroup24 == null || typeof(objRadioGroup24) == "undefined") return;
		var groupId = "0016";
		var itemId = "0023";
		var selectedValue23 = "";
		var selectedValue24 = "";
		for(var radioj=0; radioj<objRadioGroup23.length;radioj++)    {
			if(objRadioGroup23[radioj].checked)    { 
				selectedValue23 = objRadioGroup23[radioj].value; 
				break;
			}
		}
		for(var radioj=0; radioj<objRadioGroup24.length;radioj++)    {
			if(objRadioGroup24[radioj].checked)    { 
				selectedValue24 = objRadioGroup24[radioj].value; 
				break;
			}
		}
		if(selectedValue23 == "0001"){
			for(var j=0; j<objRadioGroup24.length;j++)    {
				objRadioGroup24[j].setAttribute("required","false"); 
				objRadioGroup24[j].checked = false;
				objRadioGroup24[j].setAttribute("disabled","true"); 
			}
			document.getElementById("Remark_" + groupId + "_0025").setAttribute("required","false");
			document.getElementById("Remark_" + groupId + "_0026").setAttribute("required","false");
			document.getElementById("Remark_" + groupId + "_0025").setAttribute("disabled","true"); 
			document.getElementById("Remark_" + groupId + "_0026").setAttribute("disabled","true"); 
			document.getElementById("OpinionRequiredSign_" + groupId + "_0024").style.display = "none";
			document.getElementById("OpinionRequiredSign_" + groupId + "_0025").style.display = "none";
			document.getElementById("OpinionRequiredSign_" + groupId + "_0026").style.display = "none";
		}
		else{
			for(var j=0; j<objRadioGroup24.length;j++)    {
				objRadioGroup24[j].setAttribute("required","true"); 
			}
			document.getElementById("Remark_" + groupId + "_0025").setAttribute("required","true");
			document.getElementById("Remark_" + groupId + "_0026").setAttribute("required","true");
			document.getElementById("OpinionRequiredSign_" + groupId + "_0024").style.display = "";
			document.getElementById("OpinionRequiredSign_" + groupId + "_0025").style.display = "";
			document.getElementById("OpinionRequiredSign_" + groupId + "_0026").style.display = "";
		}

		if(selectedValue24 == "0002"){
			document.getElementById("Remark_" + groupId + "_0025").setAttribute("required","false");
			document.getElementById("Remark_" + groupId + "_0026").setAttribute("required","false");
			document.getElementById("Remark_" + groupId + "_0025").setAttribute("disabled","true"); 
			document.getElementById("Remark_" + groupId + "_0026").setAttribute("disabled","true"); 
			document.getElementById("OpinionRequiredSign_" + groupId + "_0025").style.display = "none";
			document.getElementById("OpinionRequiredSign_" + groupId + "_0026").style.display = "none";
		}
		else if(selectedValue24 == "0001"){
			document.getElementById("Remark_" + groupId + "_0025").setAttribute("required","true");
			document.getElementById("Remark_" + groupId + "_0026").setAttribute("required","true");
			document.getElementById("OpinionRequiredSign_" + groupId + "_0025").style.display = "";
			document.getElementById("OpinionRequiredSign_" + groupId + "_0026").style.display = "";
		}
	}catch(e){
	}
}

//控制inputtext 默认值
var funPlaceholder = function(element) {
	var placeholder = '';
	if (element && !("placeholder" in document.createElement("input")) && (placeholder = element.getAttribute("placeholder"))) {
		element.onfocus = function() {
			if (this.value === placeholder) {
				this.value = "";
			}
			this.style.color = '';
		};
//		element.attachEvent("onBlur",function() {
//			if (this.value === "") {
//				this.value = placeholder;
//				this.style.color = 'graytext';
//			}
//		});

		//样式初始化
		if (element.value === "") {
			element.value = placeholder;
			element.style.color = 'graytext';
		}
	}
};

