var menuField = {};
initField(window.parent.menus);

function initField(menus){
	if(!menus) return;
	for(var i = 0; i < menus.length; i++){
		menuField[menus[i]["id"]] = menus[i];
		initField(menus[i]["children"]);
	}
}

function quickMenu(sQuickId, menuId){
	if(!menuField[menuId]){
		if(!confirm("此快捷链接对应的菜单无权限，是否删除此快捷链接？")) return;
		deleteQuick(sQuickId);
	}else{
		if(!menuField[menuId]["url"]){
			alert("此快捷链接对应的菜单["+menuField[menuId]["name"]+"]功能缺失，请联系管理员！");
			return;
		}
		var sParas =menuField[menuId]["param"]+ "&_SYSTEM_MENU_FALG=0";
		sParas = sParas.replace("ToDestroyAllComponent=Y", "");
		AsControl.OpenComp(menuField[menuId]["url"], sParas, "FunctionPage");
		//eval(menuField[menuId]["script"].replace("openMenu(", "parent.openMenu("));
	}
}

function selectMenu(){
	var sParam = "SelectDialogUrl=/AppMain/SelectMenuDialog.jsp&SelectDialogTitle=菜单选择窗口";
	var sReturn = AsControl.PopPage("/Frame/page/tools/SelectDialog.jsp", sParam, "dialogWidth:350px;dialogHeight:400px;resizable:no;maximize:no;help:no;menubar:no;status:no;");
	if(!sReturn || sReturn == "_CLEAR_") return;
	sReturn = sReturn.split("@");
	var quick = editMenuQuick("MenuID="+sReturn[0]+"&MenuName="+sReturn[1]);
	if(!quick) return;
	$("#panel0 .container >div:eq(0)").append(quick);
}
function moreEdit(){
	AsControl.PopView("/AppConfig/BoardManage/BoardList.jsp","RightType=ReadOnly","");
}
function moreFile(){
	AsControl.PopView("/AppMain/FileDownloadList.jsp","RightType=ReadOnly","");
}
function editMenuQuick(sParam){
	var sReturn = AsControl.PopPage("/AppMain/QuickMenuInfo.jsp", sParam, "dialogWidth=400px;dialogHeight=260px;resizable=yes;maximize=no;help=no;menubar=no;status=no;");
	if(!sReturn || sReturn.indexOf("@") < 0) return;
	sReturn = sReturn.split("@");

	var sQuickId = sReturn[0];
	if(!sQuickId) return;
	var sQuickName = sReturn[1];
	if(!sQuickName) return;
	var sMenuId = sReturn[2];
	if(!sMenuId) return;
	var sRemark = sReturn[3];
	if(!sRemark) sRemark = "";
	
	return $("<span id=\""+sQuickId+"\" onmousedown=\"if($('#panel0').hasClass('edit')){moveQuick(this, event);}\" title=\""+sRemark+"\" >" +
				"<a class=\"quick\" href=\"javascript:void(0);\" onclick=\"if(!$('#panel0').hasClass('edit')){quickMenu('"+sQuickId+"', '"+sMenuId+"');}return false;\" hidefocus >"+sQuickName+"</a>" +
				"<a class=\"close edit\" href=\"javascript:void(0);\" onmousedown=\"AsLink.stopEvent(event);\" onclick=\"deleteQuick('"+sQuickId+"','"+sQuickName+"');return false;\" hidefocus >&nbsp;</a>" +
				"<a class=\"change edit\" href=\"javascript:void(0);\" onmousedown=\"AsLink.stopEvent(event);\" onclick=\"editQuick('01', '"+sQuickId+"');return false;\" hidefocus >&nbsp;</a>" +
			"</span>");
}

function moveQuick(quick, e){
	quick = $(quick);
	var siblings = quick.siblings("span");
	var offset = quick.position();
	//alert([offset.left, offset.top]);
	var span = $(">span.seat", quick.parent());
	if(span.length != 1) span = $("<span class='seat' ></span>");
	span.insertBefore(quick).show();
	
	quick.css({
		"position" : "absolute",
		"left" : offset.left,
		"top" : getTop(),
		"z-index" : -1
	});
	$(document).bind("mousemove", move).bind("mouseup", up);
	
	var x = e.clientX, y = e.clientY;
	function move(e2){
		quick.css({
			"left" : offset.left+e2.clientX-x,
			"top" : getTop()+e2.clientY-y
		});
		
		var target = $(e2.target).parent();
		if(target.is(siblings)){
			if(span.index() < target.index()){
				span.insertAfter(target);
			}else{
				span.insertBefore(target);
			}
		}
		return false;
	}
	
	function getTop(){
		var top0 = offset.top;
		var top1 = quick.parent().scrollTop();
		if(top1 <= 0) return top0;
		if(navigator.appName=="Microsoft Internet Explorer") return top0+top1;
		else return top0;
	}
	
	function up(){
		$(document).unbind("mousemove", move).unbind("mouseup", up);
		span.replaceWith(quick);
		quick.css({
			"position" : "",
			"left" : "",
			"top" : "",
			"z-index" : ""
		});
		saveQuickSort();
	}
	
	return false;
}

function saveQuickSort(){
	var sQuicks = "";
	var first = true;
	$("#panel0 .container >div:eq(0) >span").each(function(){
		if(first) first = false;
		sQuicks += "@";
		sQuicks += this.id;
	});
	return AsControl.RunJavaMethodTrans("com.amarsoft.app.awe.config.menu.action.QuickHrefAction", "saveSort", "QuickId="+sQuicks);
}

function editQuick(sQuickType, sQuickId){
	var quick = document.getElementById(sQuickId);
	if(!quick) return;
	
	if(sQuickType == "01"){
		var $quick = editMenuQuick("QuickId="+sQuickId);
		if(!$quick) return;
		$(quick).replaceWith($quick);
	}else{
		// TODO 其他快捷 实现快捷链接
	}
}

function deleteQuick(sQuickId, sQuickName){
	var quick = document.getElementById(sQuickId);
	if(!quick) return;
	if(sQuickName && !confirm("确定删除快捷链接["+sQuickName+"]吗？")) return;
	var sResult = AsControl.RunJavaMethodTrans("com.amarsoft.app.awe.config.menu.action.QuickHrefAction", "deleteQuick", "QuickId="+sQuickId);
	if(sResult == "SUCCESS") $(quick).remove();
	else alert(sResult);
}

var aem = {};
(function(){
	var body = $("body");
	var panel0 = $("#panel0");
	var panel1 = $("#panel1");
	var panel2 = $("#panel2");
	var panel3 = $("#panel3");
	var gap = panel0.offset().top;
	var width1 = panel0.width();
	var panels = panel0.add(panel1).add(panel2).add(panel3).css("margin", gap+"px 0 0 "+gap+"px");
	
	/*$(".title >div >a >span", panel1).each(function(i){
		var sUrlParams = this.getAttribute("UrlParams");
		var name = self.name+escape($(this).text()).replace(/[^A-z0-9]/g, "");
		var flag = false;
		aem[name] = $("em", this);
		if(this.getAttribute("Init") != null) setTimeout(init,100);
		
		$(this).mouseover(function(){
			$(this).parent().animate({
				"background-position":i*$(this).width()+"px"
			}, 200, function(){
				var frame = init();
				frame.siblings().hide();
				frame.show();
			});
		});
		if(i == 0) $(this).mouseover();
		
		function init(){
			var frame = $(".container iframe[name='"+name+"']", panel1);
			if(frame.length != 1)
				frame = $("<iframe name=\""+name+"\" width=\"100%\" height=\"100%\" frameborder=\"0\" allowtransparency ></iframe>").appendTo($(".container", panel1));
			if(!flag){
				var aUrlParams = sUrlParams.split("@");
				AsControl.OpenView(aUrlParams[0], aUrlParams[1], name);
				flag = true;
			}
			return frame;
		}
	});*/
	
	$(window).resize(function(){
		var height = body.height();
		var width = body.width();
		if(navigator.appVersion.indexOf("MSIE 6")>-1) width -= 2*gap;
		
		panel0.height(height-2*gap);
		panel1.width(width-3*gap-width1).height((height-3*gap)*1000/1618);
		panel2.width((width-4*gap-width1)/2).height((height-3*gap)*618/1618);
		panel3.width((width-4*gap-width1)/2).height((height-3*gap)*618/1618);
		
		panels.each(function(){
			$(">div:eq(1)",this).height($(this).height()-$(">div:eq(0)",this).height());
		});
		//panel0.find(">div:eq(1) >div:eq(0)").height(panel0.find(">div:eq(1)").height()-panel0.find(">div:eq(1) >div:eq(1)").height());
	}).resize();
})();