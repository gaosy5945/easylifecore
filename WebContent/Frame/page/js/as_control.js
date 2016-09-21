



String.prototype.trim = function(){return this.replace(/(^[\s]*)|([\s]*$)/g, "");};




String.prototype.lTrim = function(){return this.replace(/(^[\s]*)/g, "");};




String.prototype.rTrim = function(){return this.replace(/([\s]*$)/g, "");};

if(typeof Array.indexOf != "function")






Array.prototype.indexOf = function(arg, n){
	var i = isNaN(n) || n < 0 ? 0 : n;
	for(; i < this.length; i++) if(this[i] == arg) return i;
	return -1;
};




var AsControl = {






	_getDefaultOpenStyle:function() {
		return "width="+screen.availWidth+"px,height="+screen.availHeight+"px,top=0,left=0,toolbar=no,scrollbars=yes,resizable=yes,status=no,menubar=no";
	},






	_getDefaultDialogStyle:function() {
		return "dialogWidth:"+screen.availWidth+"px;dialogHeight:"+screen.availHeight+"px;resizable:yes;maximize:yes;help:no;status:no;";
	},






	_getDialogStyle:function(sStyle) {
		if(typeof(sStyle)=="undefined" || sStyle=="") 
			return this._getDefaultDialogStyle();
		else 
			return sStyle;
	},





	_getParaString:function(sPara) {
		if(typeof(sPara)=="undefined" || sPara=="") {
			return "";
		}
		else if (sPara.substring(0,1)=="&") {
			return encodeURI(encodeURI(sPara));
		}
		else {
			return "&"+encodeURI(encodeURI(sPara));
		}
	},





	randomNumber:function() {
		return Math.abs(Math.sin(new Date().getTime())).toString().substr(2);
	}
};

AsControl.OpenObjectTab = function(sPara){
	if(sPara.indexOf("ObjectType=")<0){
		alert("参数串必须有ObjectType定义！");
		return;
	}
	if(sPara.indexOf("ObjectNo=")<0){
		alert("参数串必须有ObjectNo定义！");
		return;
	}
	/*if(sPara.indexOf("ViewID=")<0){
		alert("参数串必须有ViewID定义！");
		return;
	}*/
	this.PopView("/Frame/ObjectTab.jsp", sPara);
};
AsControl.OpenObject = function(sObjectType,sObjectNo,sViewID,sStyle){
	return OpenObject(sObjectType,sObjectNo,sViewID,sStyle); //
};
AsControl.PopObject = function(sObjectType,sObjectNo,sViewID,sDialogStyle,sDialogParas){
	return PopObject(sObjectType,sObjectNo,sViewID,sDialogStyle,sDialogParas); //
};








AsControl.OpenPage = function(sURL,sPara,sTargetWindow,sStyle) {
	if(typeof(sURL)=="undefined" || sURL=="") { alert("URL不能为空！"); return false; }
	if(sURL.indexOf("?")>=0){ alert("URL中存在\"?\"！"); return false; }
	if(sTargetWindow=="_blank") { alert("弹出的页面不能使用OpenPage函数！"); return false; }
	sTargetWindow = Layout.getRegionName(sTargetWindow);
	
	var sWindowToUnload;
	if(sTargetWindow==null || sTargetWindow=="_self"){
		sWindowToUnload="self";
	}else if(sTargetWindow=="_top"){
		sWindowToUnload="top";
	}else if(sTargetWindow=="_blank"){
		sWindowToUnload="";
	}else if(sTargetWindow=="_parent"){
		sWindowToUnload="parent";
	}else sWindowToUnload=sTargetWindow;
	try{
		oWindow = eval(sWindowToUnload);
	}catch(e){
	}
	
	if(window.checkOpenUrlModified != false){
		try{
			oWindow = eval(sWindowToUnload);
			if(!oWindow.checkModified()) return;
		}catch(e){
			try{if(!parent.frames[sWindowToUnload].checkModified()) return;}catch(e2){}
		}
	}

	var sPageURL=sWebRootPath+sURL; if(sURL.indexOf("?")<0) {sPageURL = sPageURL+"?"; } else if (sURL.substr(sURL.length-1)!="?"){sPageURL = sPageURL+"&";}
	sPageURL = sPageURL + "CompClientID="+sCompClientID+this._getParaString(sPara)+"&randp="+this.randomNumber();
	try{
		this.switchDiv(sTargetWindow);
	}catch(e)
	{
		return;
	}
	window.open(sPageURL,sTargetWindow,sStyle);
};







AsControl.OpenCompNewWin = function(sURL,sPara,sStyle) {
	if(sURL.indexOf("?")>=0) { alert("URL中存在\"?\"！"); return false; }
	
	var sCompPara = sPara;
	while(sCompPara.indexOf("&")>=0) sCompPara = sCompPara.replace("&","$[and]");
	var sPageURL = sWebRootPath+"/RedirectorDialog?&TargetWindow=_blank&DiaglogURL=/Frame/page/control/OpenCompDialog.jsp&ComponentURL="+sURL+this._getParaString("CompPara="+sCompPara);
	window.open(sPageURL,"_blank",this._getDefaultOpenStyle());
};








AsControl.OpenComp = function(sURL,sPara,sTargetWindow,sStyle) {
	if(sURL.indexOf("?")>=0) { alert("URL中存在\"?\"！"); return false; }
	sTargetWindow = Layout.getRegionName(sTargetWindow);

	var sToDestroyClientID="";
	var sWindowToUnload = sTargetWindow;
	if(sTargetWindow=="_blank") {
		return this.PopComp(sURL,sPara);
	}else{
		if(sTargetWindow==null || sTargetWindow=="_self") sWindowToUnload="self";
		else if(sTargetWindow=="_top") sWindowToUnload="top";

		try{
			oWindow = eval(sWindowToUnload);
			sToDestroyClientID = oWindow.sCompClientID;
			if (sWindowToUnload !="self" && sWindowToUnload !="top" && sToDestroyClientID==sCompClientID) sToDestroyClientID = "";
		}catch(e){
			sToDestroyClientID = "";
		}
		if(window.checkOpenUrlModified != false){
			try{if(!oWindow.checkModified()) return;}catch(e1){
				try{if(!parent.frames[sWindowToUnload].checkModified()) return;}catch(e2){}
			}
		}
	}
	if(typeof(sToDestroyClientID)=="undefined" || sToDestroyClientID=="") {sToDestroyClientID="&TargetWindow="+sTargetWindow;} else {sToDestroyClientID="&TargetWindow="+sTargetWindow+"&ToDestroyClientID="+sToDestroyClientID;}
	var sPageURL = sWebRootPath + "/Redirector?OpenerClientID="+sCompClientID+sToDestroyClientID+"&ComponentURL="+sURL+this._getParaString(sPara);
	try{
		this.switchDiv(sTargetWindow);
	}catch(e)
	{
		return;
	}
	window.open(sPageURL,sTargetWindow,sStyle);
};












AsControl.switchDiv = function(sTargetWindow) {
    if(typeof sTargetWindow !== "string") return;
    var frame = null;
    if(sTargetWindow === "_top"){
    	frame = top;
    }else if(sTargetWindow === "_self"){
    	frame = window;
    }else{
	    var win = window;
	    while(true){
	    	frame = win.frames[sTargetWindow];
	    	if(frame) break;
	    	if(win.parent === win) break;
	    	win = win.parent;
	    }
	    if(!frame) return;
    }
    var doc = frame.document;
    if(!doc || !doc.body) return;
    if($("#switch_page_mask", doc).length == 1) return;
    var width = Math.max(doc.body.scrollWidth, doc.documentElement.scrollWidth)-20;
    var height = Math.max(doc.body.scrollHeight, doc.documentElement.scrollHeight)-20;
    var board = $("<div id='switch_page_mask' style='position:absolute;left:0;top:0;width:"+width+"px;height:"+height+"px;text-align:center;z-index:9999;'>"+
    		"<div style='position:absolute;left:0;top:0;width:100%;height:100%;background:#e8e8e8;filter:alpha(opacity=60);opacity:0.6;z-index:-1;'></div>"+
    		"<span style='color:#772200;display:block;margin-top:80px;font-size:14px;display:none;'>页面切换中，请等待......<span></span></span>"+
      "</div>", doc).appendTo(doc.body);
    setTimeout(function(){
    	try{
	    	var span = $(">span", board).show().find(">span");
	    	setInterval(function(){
	    		try{
	    			var time = parseInt(span.text(), 10);
	    			if(isNaN(time)) time = 0;
	    			span.text(++time);
	    		}catch(e){}
	    	}, 1000);
    	}catch(e){}
    }, 500);
} ;









AsControl.PopPage = function(sURL,sPara,sStyle,dialogArgs){
	if(sURL.indexOf("?")>=0){
		alert("错误：页面URL中存在\"?\"。请将页面参数在第二个参数中传入！");
		return false;
	}
	var sDialogStyle = this._getDialogStyle(sStyle);
	var sPageURL = sWebRootPath+"/RedirectorDialog?DiaglogURL="+sURL+"&OpenerClientID="+sCompClientID+"&ComponentURL="+sURL+this._getParaString(sPara);
	return window.showModalDialog(sPageURL,dialogArgs,sDialogStyle);
};

AsControl.PopPageEx = function(sURL,sPara,oTarget,sStyle){
	if(sURL.indexOf("?")>=0){
		alert("错误：页面URL中存在\"?\"。请将页面参数在第二个参数中传入！");
		return false;
	}
	var sDialogStyle = this._getDialogStyle(sStyle);
	var sPageURL = sWebRootPath+"/RedirectorDialog?DiaglogURL="+sURL+"&OpenerClientID="+sCompClientID+"&ComponentURL="+sURL+this._getParaString(sPara);
	return window.showModalDialog(sPageURL,oTarget,sDialogStyle);
};









AsControl.PopComp = function(sURL,sPara,sStyle,dialogArgs){
	if(sURL.indexOf("?")>=0) { alert("URL中存在\"?\"！"); return false; }
	var sDialogStyle = this._getDialogStyle(sStyle);

	var sCompPara = sPara;
	while(sCompPara.indexOf("&")>=0) sCompPara = sCompPara.replace("&","$[and]");
	
	var sPageURL = sWebRootPath+"/RedirectorDialog?DiaglogURL=/Frame/page/control/OpenCompDialog.jsp&OpenerClientID="+sCompClientID+"&ComponentURL="+sURL+this._getParaString("CompPara="+sCompPara);
	return window.showModalDialog(sPageURL,dialogArgs,sDialogStyle);
};

AsControl.OpenPageOld = function(sURL,sTargetWindow,sStyle) {
	if(sTargetWindow=="_blank") { alert("弹出的页面不能使用OpenPage函数！");}
	
	var sPageURL=sURL; 
	var sPara = "";
	if(sURL.indexOf("?")>0) {
		sPageURL = sURL.substring(0,sURL.indexOf("?"));
		sPara = sURL.substring(sURL.indexOf("?")+1);
	}
	this.OpenPage(sPageURL, sPara, sTargetWindow,sStyle);
};

AsControl.PopPageOld = function(sURL,sStyle){
	var sPageURL=sURL; 
	var sPara = "";
	if(sURL.indexOf("?")>0) {
		sPageURL = sURL.substring(0,sURL.indexOf("?"));
		sPara = sURL.substring(sURL.indexOf("?")+1);
	}
	return this.PopPage(sPageURL, sPara, sStyle);
};

AsControl.OpenView = function(sURL,sPara,sTargetWindow,sStyle){ return this.OpenComp(sURL,sPara,sTargetWindow,sStyle);};
AsControl.PopView = function(sURL, sPara, sStyle, dialogArgs){	return this.PopComp(sURL, sPara, sStyle, dialogArgs);};

AsControl.DestroyComp = function (ToDestroyClientID) {
	$.ajax({url: sWebRootPath+"/Frame/page/control/DestroyCompAction.jsp?ToDestroyClientID="+ToDestroyClientID,async: false});
};








AsControl.RunJavaMethod = function (ClassName,MethodName,Args) {
	return AsControl.GetJavaMethodReturn(AsControl.CallJavaMethod(ClassName,MethodName,Args,""),ClassName);
};








AsControl.RunJavaMethodSqlca = function (ClassName,MethodName,Args) {
	return AsControl.GetJavaMethodReturn(AsControl.CallJavaMethod(ClassName,MethodName,Args,"&ArgsObject=Sqlca"),ClassName);
};








AsControl.RunJavaMethodTrans = function (ClassName,MethodName,Args) {
	return AsControl.GetJavaMethodReturn(AsControl.CallJavaMethod(ClassName,MethodName,Args,"&ArgsObject=Trans"),ClassName);
};









AsControl.ExportFinanceReport = function(sObjectType, sObjectNo, sReportScope, sReportDate){
	var sParam;
	if(arguments.length == 1) sParam = "ReportNo="+arguments[0];
	else sParam = "ObjectType="+ObjectType+",ObjectNo="+sObjectNo+",ReportScope="+sReportScope+",ReportDate="+sReportDate;
	var sReportExcelPath = AsControl.RunJavaMethodSqlca("com.amarsoft.biz.finance.ExportExcel", "run", sParam);
	if(!sReportExcelPath) return;
	if(!frames["exportfsframe"]) $("<iframe name='exportfsframe' style='display:none;'></iframe>").appendTo("body");
	window.open(sWebRootPath+"/servlet/view/file?CompClientID="+sCompClientID+"&filename="+sReportExcelPath+"&viewtype=download", "exportfsframe");
};

AsControl.CallJavaMethodJSP = function (ClassName,MethodName,Args,ArgsObjectText) {
	return $.ajax({
		  url: sWebRootPath+"/Frame/page/sys/tools/RunJavaMethod.jsp?ClassName="+ClassName+"&MethodName="+MethodName+this._getParaString("Args="+Args)+ArgsObjectText,
		  async: false
		 }).responseText.trim();
};

AsControl.CallJavaMethod = function (ClassName,MethodName,Args,ArgsObjectText) {
	return $.ajax({
		type: "POST",
		url: sWebRootPath+"/servlet/run?1=1"+ArgsObjectText,
		data : {
			"ClassName":ClassName,
			"MethodName":MethodName,
			// FIXME 加号替换，请修改为特殊字符，见com.amarsoft.awe.control.RunJavaMethodServlet.doGet
			"Args":encodeURI(Args.replace(/\+/g, 'Ж').replace(/\%/g, 'ё'))
		},
		async: false
	}).responseText.trim();
};

AsControl.GetJavaMethodReturn = function (sReturnText,ClassName) {
	window.onerror = function(msg, url, line) {
	    alert("运行异常: " + msg + "\n");
	    //alert("JS异常: " + msg + "\n" + goUrlName(sWebRootPath,url) + ":" + line);
	    return true;
	};
	if (typeof(sReturnText)=='undefined' || sReturnText.length<8) {
		throw new Error("【AWES0007】后台服务调用出错！\n【"+ClassName+"】");
	}
	var rCode = sReturnText.substring(0,8);
	if (rCode != '00000000') {
		throw new Error("【"+rCode+"】"+sReturnText.substring(8)+"\n【"+ClassName+"】");
	}
	
	sReturnText = sReturnText.substring(8);
	if(sReturnText.length>0 && sReturnText.substring(0,1)=="{")
		return eval("("+ sReturnText +")");
	else
		return sReturnText;
};






AsControl.RunJsp = function(sURL,sPara,fun) {
	if(sURL.indexOf("?")>=0){
		alert("错误：页面URL中存在\"?\"。请将页面参数在第二个参数中传入！");
		return false;
	}
	var sPageURL = sWebRootPath+sURL+"?CompClientID="+sCompClientID+this._getParaString(sPara);
	if(typeof fun == "function"){
		return $.ajax({url:sPageURL,type:"POST",processData:false,async:true,success:fun});
	}else{
		return $.ajax({url:sPageURL,async:false}).responseText.trim();
	}
};

AsControl.RunJspOne = function(sURL) {
	var sPageURL=sURL; 
	var sPara = "";
	if(sURL.indexOf("?")>0) {
		sPageURL = sURL.substring(0,sURL.indexOf("?"));
		sPara = sURL.substring(sURL.indexOf("?")+1);
	}
	return this.RunJsp(sPageURL, sPara);
};

AsControl.RunASMethod = function(ClassName,MethodName,Args) {
	return this.RunJsp("/Common/ToolsB/RunMethodAJAX.jsp","ClassName="+ClassName+"&MethodName="+MethodName+"&Args="+Args);
};

AsControl.getErrMsg = function (MsgNo) {
	var ClassName="com.amarsoft.awe.res.ErrMsgManager";
	var MethodName="getText";
	var Args="MsgNo="+MsgNo;
	return AsControl.GetJavaMethodReturn(AsControl.CallJavaMethod(ClassName,MethodName,Args,""),ClassName);
};

var OpenStyle=AsControl._getDefaultOpenStyle();
function randomNumber() { return AsControl.randomNumber();}
function OpenComp(sCompID,sCompURL,sPara,sTargetWindow,sStyle) {return AsControl.OpenComp(sCompURL,sPara,sTargetWindow,sStyle);}
function openComp(sCompID,sCompURL,sPara,sTargetWindow,sStyle) {return AsControl.OpenComp(sCompURL,sPara,sTargetWindow,sStyle);}
function PopComp(sComponentID,sComponentURL,sParaString,sStyle) {return AsControl.PopComp(sComponentURL,sParaString,sStyle);}
function popComp(sComponentID,sComponentURL,sParaString,sStyle) {return AsControl.PopComp(sComponentURL,sParaString,sStyle);}
function PopPage(sURL,sTargetWindow,sStyle) {return AsControl.PopPageOld(sURL,sStyle);}
function OpenPage(sURL,sTargetWindow,sStyle) {return AsControl.OpenPageOld(sURL,sTargetWindow,sStyle);}
function RunJavaMethod(ClassName,MethodName,Args) {return AsControl.RunJavaMethod(ClassName,MethodName,Args);}
function RunJavaMethodSqlca(ClassName,MethodName,Args) {return AsControl.RunJavaMethodSqlca(ClassName,MethodName,Args);}
function RunJavaMethodTrans(ClassName,MethodName,Args) {return AsControl.RunJavaMethodTrans(ClassName,MethodName,Args);}
function PopPageAjax(sURL,sTargetWindow,sStyle){return AsControl.RunJspOne(sURL);}
function RunJspAjax(sURL,sTargetWindow,sStyle){return AsControl.RunJspOne(sURL);}
function RunMethod(ClassName,MethodName,Args){return AsControl.RunASMethod(ClassName,MethodName,Args);	}

function getMessageText(iNo) { return AsControl.getErrMsg(iNo);}

function openObjectInFrame(sObjectType,sObjectNo,sViewID,sFrameID){
	AsControl.OpenComp("/Frame/ObjectViewer.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID="+sViewID,sFrameID,"");
}

function openObject(sObjectType,sObjectNo,sViewID,sStyle){
	AsControl.PopComp("/Frame/ObjectViewer.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID="+sViewID,sStyle);
}

function openObjectNewWin(sObjectType,sObjectNo,sViewID,sStyle){
	AsControl.OpenCompNewWin("/Frame/ObjectViewer.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID="+sViewID,sStyle);
}

function OpenObject(sObjectType,sObjectNo,sViewID,sStyle){
	openObject(sObjectType,sObjectNo,sViewID,sStyle);
}

function popObject(sObjectType,sObjectNo,sViewID,sDialogStyle){
	AsControl.PopComp("/Frame/ObjectViewer.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID="+sViewID,sDialogStyle);
}

function PopObject(sObjectType,sObjectNo,sViewID,sDialogStyle){
	popObject(sObjectType,sObjectNo,sViewID,sDialogStyle);
}

function setWindowTitle(sTitle) {
	top.document.title=sTitle+"　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　";
}

function setDialogTitle(sTitle) {
	var tempWindow = self;
	do{
		if(typeof tempWindow.setTopTitle == "function"){
			tempWindow.setTopTitle(sTitle);
			break;
		}
		if(tempWindow == tempWindow.parent) break;
		tempWindow = tempWindow.parent;
	}while(true);
}
function getDialogTitle(){
	var tempWindow = self;
	do{
		if(typeof tempWindow.getTopTitle == "function"){
			return tempWindow.getTopTitle();
		}
		if(tempWindow == tempWindow.parent) break;
		tempWindow = tempWindow.parent;
	}while(true);
}




var AsDialog = {








	OpenSelector : function(sObjectType,sParaString,sStyle){
		return selectObjectValue(sObjectType,sParaString,sStyle); //使用在SELECT_CATALOG中自定义查询选择信息
	},











	SelectGridValue : function(sDoNo, sArgs, sFields, aSelected, isMulti, sStyle,setFlag,manualQueryFlag){
		if(!sStyle) sStyle = "dialogWidth:620px;dialogHeight:500px;resizable:no;maximize:yes;help:no;status:no;";
		if(sFields.indexOf("=") > -1){
			return this.SetGridValue(sDoNo, sArgs, sFields, aSelected, sStyle,manualQueryFlag);
		}
		var sPageURL = sWebRootPath+"/RedirectorDialog?DiaglogURL=/Frame/page/control/OpenCompDialog.jsp&OpenerClientID="+sCompClientID+"&ComponentURL=/Frame/page/tools/SelectDialog.jsp"+AsControl._getParaString("CompPara=SelectDialogUrl=/Frame/page/tools/SelectGridDialog.jsp&ManualQueryFlag="+manualQueryFlag+"&DoNo="+sDoNo+"&Parameters="+sArgs+"&Fields="+sFields+"&SetFlag="+setFlag+"&IsMulti="+isMulti);
		return window.showModalDialog(sPageURL,aSelected,sStyle);
	},









	SetGridValue : function(sDoNo, sArgs, sFieldValues, aSelected, sStyle,manualQueryFlag){
		if(sFieldValues.indexOf("=") < 0){
			return this.SelectGridValue(sDoNo, sArgs, sFieldValues, aSelected, false, sStyle,"Y",manualQueryFlag);
		}
		var fieldValues = sFieldValues.split("@");
		var fields = "";
		var terminis = new Array();
		var keyValue;
		for(var i = 0; i < fieldValues.length; i++){
			if(fieldValues[i].indexOf("=") < 0) continue;
			keyValue = fieldValues[i].split("=");
			if(keyValue.length < 2 || keyValue[0] == "" || keyValue[1] == "") continue;
			terminis[terminis.length] = keyValue[0];
			if(fields != "") fields += "@";
			fields += keyValue[1];
		}
		
		var sReturn = this.SelectGridValue(sDoNo, sArgs, fields, aSelected, false,"","Y",manualQueryFlag);
		if(!sReturn) return;
		if(sReturn == "_CLEAR_"){
			if(typeof setItemValue == "function" && typeof getRow == "function"){
				for(var i = 0; i < terminis.length; i++){
					setItemValue(0, getRow(), terminis[i], "");
				}
			}
		}else{
			if(typeof setItemValue == "function" && typeof getRow == "function"){
				var values = sReturn.split("@");
				for(var i = 0; i < terminis.length; i++){
					setItemValue(0, getRow(), terminis[i], values[i]);
				}
			}
		}
		return sReturn;
	},











	OpenCalender : function(obj,strFormat,startDate,endDate,postEvent,x,y){
		if(typeof obj == "string") obj = document.getElementById(obj);
		if(!obj) return;
		var today = new Date();//.format(strFormat);
		//alert([getDate(startDate),getDate(endDate)]);
		SelectDate(obj,strFormat,getDate(startDate),getDate(endDate),postEvent,x,y);
		
		function getDate(sDate){
			if(typeof sDate == "string" && sDate.toUpperCase() == "TODAY")
				return today;
			if(typeof sDate == "number"){
				return new Date(today.getFullYear(), today.getMonth(), today.getDate()+parseInt(sDate, 10));
			}
			return sDate;
		}
	}
};