var SAVE_TMP = false;
var bEditHtml = false; 
var bEditHtmlChange = false;
var bEditHtmlChange2= false;
var oldFormValues = new Array();
var newFormValues = new Array();
var _user_validator;

$().ready(function(){
	try{
		setOldValue();
		//绑定快捷键
		jQuery.initObjectKeyArray();
	}catch(e){}
});



























function iV_allF(){
	var result = true;
	//alert("_user_validator="+ _user_validator);
	if(_user_validator){
		try{
			result = $("#frmFDDataContent").validate(_user_validator).form();
		}
		catch(e){
			alert("校验参数错误：" + e.message);
		}
	}
	return result;
}
function setOldValue(){
	oldFormValues = document.getElementById('frmFDDataContent').innerHTML;
}
function setNewValue(){
	newFormValues = document.getElementById('frmFDDataContent').innerHTML;
}







function fillFormatDoc(docID,objectNo,objectType,excludeDirIds){
	if(excludeDirIds==undefined) excludeDirIds="";
	return AsControl.RunJsp("/AppConfig/FormatDoc/AddData.jsp","DocID="+docID+"&ObjectNo="+objectNo+"&ObjectType="+objectType+"&ExcludeDirIds="+excludeDirIds);
}

function fillFormatDocWithOpen(docID,objectNo,objectType,excludeDirIds){
	if(excludeDirIds==undefined) excludeDirIds="";
	var sReturn = AsControl.RunJsp("/AppConfig/FormatDoc/AddData.jsp","DocID="+docID+"&ObjectNo="+objectNo+"&ObjectType="+objectType+"&ExcludeDirIds="+excludeDirIds);
	if(typeof(sReturn)!='undefined' && sReturn!="" && sReturn =="SUCCESS"){
		AsControl.OpenView("/AppConfig/FormatDoc/FormatDocView.jsp","DocID="+docID+"&ObjectNo="+objectNo+"&ObjectType="+objectType,"_blank",OpenStyle); 
	}
}

function productFormatDoc(docID,objectNo,objectType,excludeDirIds){
	if(excludeDirIds==undefined) excludeDirIds="";
	return AsControl.RunJsp("/AppConfig/FormatDoc/ProduceFile.jsp","DocID="+docID+"&ObjectNo="+objectNo+"&ObjectType="+objectType+"&ExcludeDirIds="+excludeDirIds);
}

function previewFormatDoc(docID,objectNo,objectType,excludeDirIds){
	if(excludeDirIds==undefined) excludeDirIds="";
	AsControl.PopView("/AppConfig/FormatDoc/PreviewFile.jsp","DocID="+docID+"&ObjectNo="+objectNo+"&ObjectType="+objectType+"&ExcludeDirIds="+excludeDirIds+"&rand="+randomNumber(),"");
}

function scoreFormatDoc(docID,objectNo,objectType,excludeDirIds){
	if(excludeDirIds==undefined) excludeDirIds="";
	return AsControl.RunJsp("/AppConfig/FormatDoc/AddData.jsp","Method=7&DocID="+docID+"&ObjectNo="+objectNo+"&ObjectType="+objectType+"&ExcludeDirIds="+excludeDirIds);
}

function checkFormatDoc(docID,objectNo,objectType,excludeDirIds){
	if(excludeDirIds==undefined) excludeDirIds="";
	return AsControl.RunJsp("/AppConfig/FormatDoc/AddData.jsp","Method=8&DocID="+docID+"&ObjectNo="+objectNo+"&ObjectType="+objectType+"&ExcludeDirIds="+excludeDirIds);
}

function refreshFormatDoc(typeNo,objectNo,objectType,usedocid){
	if(usedocid)
		return AsControl.RunJsp("/AppConfig/FormatDoc/RefreshData.jsp","DocID="+typeNo+"&ObjectNo="+objectNo+"&ObjectType="+objectType);
	else
		return AsControl.RunJsp("/AppConfig/FormatDoc/RefreshData.jsp","TypeNo="+typeNo+"&DocID="+typeNo+"&ObjectNo="+objectNo+"&ObjectType="+objectType);
}

function importOfflineFormatDoc(){
	OpenPage('/AppConfig/FormatDoc/SelUploadFile.jsp','','width=400,height=150');
}

function importOfflineModelFormatDoc(){
	OpenPage('/AppConfig/FormatDoc/SelUploadModelFile.jsp','','width=400,height=150');
}

function exportOfflineModelFormatDoc(docID){
	exportOfflineFormatDoc(docID,"999999999","999999999","");
}

function generateIframe(){
	iframeName=randomNumber().toString();
	iframeName = "frame"+iframeName.substring(2);

	//modify in 2008/04/10,2008/02/14 for https
	//var sHTML="<iframe name='"+iframeName+"'  style='display:none'>";
	var sHTML="<iframe name='"+iframeName+"' src='"+sWebRootPath+"/amarsoft.html' style='display:none'>";
	
	document.body.insertAdjacentHTML("afterBegin",sHTML);
	//alert(sHTML);
	return iframeName;
}

function exportOfflineFormatDoc(docID,objectNo,objectType,excludeDirIds){
	if(excludeDirIds==undefined) excludeDirIds="";
	var sReturn = AsControl.RunJsp("/AppConfig/FormatDoc/ProductOfflineFile.jsp","DocID="+docID+"&ObjectNo="+objectNo+"&ObjectType="+objectType+"&ExcludeDirIds="+excludeDirIds);
	if(typeof(sReturn)!='undefined' && sReturn!="" && sReturn!="FAILED"){
		//alert("已生成离线文件:"+ sReturn);
		var sFormName="form"+randomNumber();
		var targetFrameName=generateIframe();
		var sHTML = "";
		sHTML+="<form method='post' name='"+sFormName+"' id='"+sFormName+"' target='"+targetFrameName+"' action="+sWebRootPath+"/servlet/view/file?CompClientID="+sCompClientID+" > ";
		sHTML+="<div style='display:none'>";
		sHTML+="<input name=filename value='"+sReturn+"' >";
		sHTML+="<input name=contenttype value='unknown'>";
		sHTML+="<input name=viewtype value='save'>";
		sHTML+="</div>";
		sHTML+="</form>";
		document.body.insertAdjacentHTML("afterBegin",sHTML);
		var oForm = document.forms[sFormName];
		oForm.submit();
	}
}

function exportToPdf(docID,objectNo,objectType,excludeDirIds){
	if(excludeDirIds==undefined) excludeDirIds="";
	var sReturn = AsControl.RunJsp("/AppConfig/FormatDoc/ProducePdf.jsp","DocID="+docID+"&ObjectNo="+objectNo+"&ObjectType="+objectType+"&ExcludeDirIds="+excludeDirIds);
	if(typeof(sReturn)!='undefined' && sReturn!="" && sReturn!="FAILED"){
		//alert("已生成pdf:"+ sReturn);
		var sFormName="form"+randomNumber();
		var targetFrameName=generateIframe();
		var sHTML = "";
		sHTML+="<form method='post' name='"+sFormName+"' id='"+sFormName+"' target='"+targetFrameName+"' action="+sWebRootPath+"/servlet/view/file?CompClientID="+sCompClientID+" > ";
		sHTML+="<div style='display:none'>";
		sHTML+="<input name=filename value='"+sReturn+"' >";
		sHTML+="<input name=contenttype value='application/pdf'>";
		sHTML+="<input name=viewtype value='save'>";
		sHTML+="</div>";
		sHTML+="</form>";
		document.body.insertAdjacentHTML("afterBegin",sHTML);
		var oForm = document.forms[sFormName];
		oForm.submit();		
	}else{
		alert("报告还未生成，请确认已填写报告！");
	}
}
function amarCopy(){
	try {
		var sel = parent.frames["ObjectList"].document.body.createTextRange();
		var oTblExport = parent.frames["ObjectList"].document.getElementById('als7fdall'); 
		if (oTblExport != null) { 
			sel.moveToElementText(oTblExport);
			sel.execCommand('Copy'); 
		}
	} catch (e) { }
}
function autoCopy(){
	amarCopy();
	alert("已经复制到粘贴板!");
}
function exportToWord(){
	var oWD = new ActiveXObject('Word.Application');
	oWD.Application.Visible = true;
	var oDC =oWD.Documents.Add('',0,1);
	var oRange =oDC.Range(0,1);
	amarCopy();
	oRange.Paste(); 
}

function ckeditor_generate(textarea_name){
	CKEDITOR.replace(textarea_name, {
		"toolbar_Full":
		[
		    {items : ['Cut','Copy','Paste','-','Undo','Redo','-','Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat','-','NumberedList','BulletedList','-','Outdent','Indent','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','Source']},
		    {items : ['Styles','Format','Font','FontSize','-','TextColor','BGColor','-','Image','-','Table','Maximize'] },
		    //{items : ['About']}
		],
		//"toolbarCanCollapse":false, // 隐藏收起工具栏按钮
		//"toolbarStartupExpanded":false, // 初始收起工具栏
		//"htmlEncodeOutput":true, // “(”，“)”，“+”未处理
		//"autoUpdateElement":false,
		"resize_enabled":false,
		"removePlugins":"elementspath",
		"image_previewText":"&nbsp;",
		"filebrowserImageUploadUrl":sWebRootPath+"/Frame/page/resources/ckeditor/ckextend/uploadfile.jsp?CompClientID="+sCompClientID,
		//"filebrowserFlashUploadUrl":sWebRootPath+"/tool/ckextend/uploadfile.jsp",
		"width":"100%"
	});
}

function setTextArea(){
	for(var instance in CKEDITOR.instances){
		var data = CKEDITOR.instances[instance].getData();
		if(!data) data = "";
		// 只在预览时反向处理com.amarsoft.biz.formatdoc.tagconvertor.PreViewTextareaConvertor.convert
		CKEDITOR.instances[instance].element.setValue(data.replace(/\(/g, "&#40;").replace(/\)/g, "&#41;").replace(/\</g, "&#60;").replace(/\>/g, "&#62;").replace(/\+/g, "&#43;"));
	}
}