


var AsDebug = {




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




	reloadConfigFile:function(){
		var sReturn = PopPageAjax("/AppConfig/ControlCenter/ClearConfigFileCache.jsp","","");
		if(sReturn=="SUCCESS") alert("重载配置文件成功！");
		else alert("重载配置文件失败！");
	}
};






function keydownAction(event){
	if(event.altKey && event.keyCode == 51){ //alt+3
		AsDebug.reloadCacheAll();
		return true;
	}else if(event.keyCode==8){ // backspace
		var target = $(event.target);
		// 可以取到值、为可编辑的表单、不为按钮/下拉选择/勾选/只读等允许使用backspace键
		return !!target.val() && target.is(":input:enabled") && !target.is(":button,:selected,:checked,[readonly]");
	}
}
$(document).keydown(keydownAction);