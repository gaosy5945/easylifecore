var AsDebug = {
	URL:"",
	_isWindowOpen:false,
	_isReportWindowOpen:false,
	toggleWindow:function() {
		if (this._isWindowOpen) {
			this.hideWindow();
		} else {
			this.showWindow();
		}
	},
	showWindow:function() {
		if (!this._isWindowOpen) {
			var topDiv = $("#debugTool");
			topDiv.show();
			var obj = $("#debugTool_subdiv");//var obj = topDiv.children(".datawindow_overdiv_subdiv");
			obj.show();
			var iLeft = (topDiv[0].offsetWidth-obj[0].offsetWidth)/2;//100 + document.body.scrollLeft;
			var iTop = (topDiv[0].offsetHeight-obj[0].offsetHeight)/2;//100 + document.body.scrollTop;
			obj.css({left:iLeft,top:iTop});
			document.getElementById('sp_debug_overdiv_top').style.display= 'inline';
			this._isWindowOpen = true;
		}
	},
	hideWindow:function() {
		if (this._isWindowOpen) {
			this._isWindowOpen = false;
			$("#debugTool_subdiv").hide();
			$("#debugTool").hide();
		}
	},
	getURL:function() {
		if (typeof(AsDebug_URL) != "undefined")
			this.URL = AsDebug_URL;
		if (this.URL != "")	return this.URL.substring(this.URL.lastIndexOf(sWebRootPath)+sWebRootPath.length);
		return document.URL;
	},
	getPage:function() {
		if (typeof(AsDebug_URL) != "undefined")
			this.URL = AsDebug_URL;
		if (this.URL != "")	return this.URL.substring(this.URL.lastIndexOf("/")+1);
		return document.URL;
	},
	reloadAREService:function(serviceId){
		if (typeof(serviceId) == "undefined" || serviceId.length == 0) serviceId = "JBO";
		var sReturn = RunJavaMethod("com.amarsoft.app.util.ReloadServiceAction","reloadService","ServiceId="+serviceId);
		if(sReturn=="SUCCESS") alert("重载ARE服务成功！");
		else alert("重载ARE服务失败！");
	},
	reloadCacheAll:function(){
		var sReturn = RunJavaMethod("com.amarsoft.app.util.ReloadCacheConfigAction","reloadCacheAll","");
		if(sReturn=="SUCCESS") alert("重载参数缓存成功！");
		else alert("重载参数缓存失败！");
	},
	reloadCache:function(CacheType){
		var sReturn = RunJavaMethod("com.amarsoft.app.util.ReloadCacheConfigAction","reloadCache","ConfigName="+CacheType);
		if(sReturn=="SUCCESS") alert("刷新参数缓存成功！");
		else alert("刷新参数缓存失败！");
	},
	reloadFixSkins:function(){
		var sReturn = PopPageAjax("/AppConfig/OrgUserManage/ReloadSkin.jsp?ReloadType=FixSkins");
		if(sReturn=="SUCCESS")  alert("重载定制皮肤成功！");
		else alert("重载定制皮肤失败！");
	},
	reloadConfigFile:function(){
		var sReturn = PopPageAjax("/AppConfig/ControlCenter/ClearConfigFileCache.jsp","","");
		if(sReturn=="SUCCESS") alert("重载配置文件成功！");
		else alert("重载配置文件失败！");
	},
	openControlCenter:function() {
		this.hideWindow();
		popComp("ControlCenter","/AppConfig/ControlCenter/ControlCenterTab.jsp","","","");
	},
	displayHTML:function(oBody) {
		showModalDialog(sWebRootPath+"/Frame/page/debug/tools/viewsource.htm", oBody,"status:no;resizable:yes;center:yes;dialogHeight:688px;dialogWidth:968px;");
	},
	displayBodyHTML:function() {
		this.hideWindow();
		this.displayHTML(document.body);
	},
	viewCompDetail:function() {
		this.hideWindow();
		popComp("CompDetail","/Frame/page/debug/tools/CompDetail.jsp","ToShowClientID="+sCompClientID,"","");
	},
	displayDwInfo:function() {
		this.hideWindow();
		try{
			var sUrl = "/Frame/page/dw/DisplayDWInfo.jsp";
			if(!window.WindowType) sUrl = "/Frame/page/ow/DisplayOWInfo.jsp";
			//displayHTML(myiframe0.document.body);
			window.open(sWebRootPath + sUrl+ "?dono="+DisplayDONO+"&url="+this.getURL(),"","status:no,resizable:yes,scrollbars=yes,height:688,width:968");
		}catch(e){
			alert("No DWInfo");
		}
	},
	displayURL:function displayURL() {	
		prompt("URLName                                                         ",this.getURL());
	},
	displayPageName:function() {	
		prompt("PageName                                       ",this.getPage());
	},
	displayURLnPara:function() {	
		prompt("URL",document.URL);
	},
	showOnlineUserList:function(){
		OpenPage("/AppConfig/ControlCenter/OnlineUserList.jsp?rand="+randomNumber());
	},
	editDW:function(){
		if(typeof(DisplayDONO)=="undefined" || DisplayDONO.length == 0){
			alert("No DWInfo");
			return;
		}
		if(typeof(WindowType) !="undefined" && WindowType.length != 0){
			AsControl.PopView("/AppConfig/PageMode/DWConfig/DataObjectStrip.jsp","DONO="+DisplayDONO+"&RightType=All","","");
		}else{
			AsControl.PopView("/AppConfig/PageMode/DWConfig/ObjectModelStrip.jsp","DONO="+DisplayDONO+"&RightType=All","","");
		}
	}
};






function keydownAction(event){
	if(event.altKey && event.keyCode == 49){ //alt+1
		AsDebug.toggleWindow();
		return true;
	}else if(event.altKey && event.keyCode == 50){ //alt+2
		if(typeof OverrideAlt2 == 'function') OverrideAlt2();
		else AsDebug.editDW();
		return true;
	}else if(event.altKey && event.keyCode == 51){ //alt+3
		AsDebug.reloadCacheAll();
		return true;
	}else if(event.altKey && event.keyCode == 52){ //alt+4
		AsDebug.reloadAREService();
		return true;
	}else if(event.keyCode == "27"){ //esc
		AsDebug.hideWindow();
		return true;
	}else if(event.altKey && event.keyCode==123 && window.as_defaultExport){//F2导出excel
		as_defaultExport();
		return true;
	}else if(event.keyCode==8){ // backspace
		var target = $(event.target);
		// 可以取到值、为可编辑的表单、不为按钮/下拉选择/勾选/只读等允许使用backspace键
		return !!target.val() && target.is(":input:enabled") && !target.is(":button,:selected,:checked,[readonly]");
	}
}
$(document).keydown(keydownAction);