<%@page import="com.amarsoft.app.base.util.StringHelper"%>
<%@page import="com.amarsoft.app.base.businessobject.*"%>
<%@page import="com.amarsoft.app.als.ui.function.FunctionWebTools"%>
<%@page import="com.amarsoft.app.als.sys.function.model.FunctionInstance"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	FunctionInstance functionInstance=FunctionInstance.getFunctionInstance(CurPage, CurUser);
	String functionID = functionInstance.getFunction().getKeyString();
	String functionItemID =functionInstance.getCurFunctionItemID();
	
	String alwaysShowFlag = CurPage.getParameter("AlwaysShowFlag");
	if(StringX.isEmpty(alwaysShowFlag)) alwaysShowFlag = CurPage.getParameter("AlwaysShowFlag".toUpperCase());
	if(!"1".equals(alwaysShowFlag)) alwaysShowFlag = "0";
	String needClose = CurPage.getParameter("NeedClose");
	if(!"true".equals(needClose)) needClose = "false";
	
	String sButtons[][] = FunctionWebTools.genButtons(functionInstance, functionItemID);
	if(sButtons == null || "ReadOnly".equalsIgnoreCase(CurPage.getParameter("RightType"))) sButtons = new String[0][6];
	for(String[] button : sButtons){
		if(!"Button".equalsIgnoreCase(button[6]))
			button[0] = "false";
	}
%>
<html>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/strip.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/tabs.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%><%=sSkinPath%>/css/tabs.css">
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/tabstrip-1.0.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden;height:100%;width:100%;">
<div class='div_button' >
	<%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%>
</div> 
<div id="window1" style="vertical-align:middle;padding:0;border:0px solid #F00;height:100%;width: 100%; overflow:hidden">
</div>
<div id="messageBox" class="info_error_edoc" style="display:none;">
	<div class="ow_righttop_close" onclick="$(this).parent().hide();" ></div>
    <div class="info_error_rt" onmousedown="AsLink.moveBoxOnDown(event, this.parentNode)"></div>
    <div class="info_error_eline"></div>
    <div class="info_error_txt">
       	<ul class="info_error_ulstyle" id="ul_error_0">
		</ul>
	</div>
	<div class="info_error_txt" id="showpart">
		<ul class="info_error_ulstyle" id="ul_error_1">
		</ul>
	</div>
	<button class="info_error_mobtn" id="mobtn" name="btn">显示更多</button>
    <button class="info_error_mobtn" id="hidbtn" name="btn">收起</button>
</div>
</body>
</html>

<script type="text/javascript">
	var tabCompent = new TabStrip("T01", "单个TabStrip组", "tab", "#window1");
	tabCompent.init();
	tabCompent.setCloseCallback(closeTab);//设置关闭tab调用函数
	var closeFunctions={};
	
	function createTab(){
	<%
		String defaultTabID = functionInstance.getDefaultFunctionItemID();
		
		List<BusinessObject> tabList = functionInstance.getFunctionItemList(functionItemID, FunctionInstance.FUNCTION_ITEM_TYPE_TAB);
		for(BusinessObject tab:tabList){
			String tabID = tab.getString("FunctionItemID");
			if(defaultTabID.isEmpty())defaultTabID=tabID;
			String tabName = tab.getString("FunctionItemName");
			String clickURL = FunctionWebTools.getFunctionURL(functionInstance, tab);
			String clickParameters=FunctionWebTools.getFunctionWebParameters(functionInstance,tab);
			String clickScript = "AsControl.OpenComp('"+clickURL+"', '"+clickParameters+"', 'TabContentFrame')";
			
			String closeScript = "";
			List<BusinessObject> closeButtonList = functionInstance.getFunctionItemList(tabID, FunctionInstance.FUNCTION_ITEM_TYPE_BUTTON);
			if(closeButtonList!=null&&!closeButtonList.isEmpty()){
				
				for(BusinessObject closeButton:closeButtonList)
				{
					if(closeButton.getString("FunctionItemID").toUpperCase().indexOf("CLOSE") > -1)
					{
						closeScript=closeButton.getString("URL");
					}
				}
			}
	%>
			addTab("<%=tabID%>", "<%=tabName%>", "<%=clickScript%>", "<%=closeScript%>",false);
	<%
		}
	%>
		var tabSize="<%=tabList.size()%>";
		$("#tabs_button_T01").find("li").first().click();
		if(tabSize==1&&<%=alwaysShowFlag%>!=1){
			$("#tabs_button_T01").remove();
		}
		setTimeout(function(){prove()}, 500);
	}
	function addTab(id ,title, clickScript, closeScript,autoOpenFlag){
		if(autoOpenFlag != false) autoOpenFlag = true;
		var closeFlag=false;
		if(!closeScript)closeScript="";
		closeFunctions[id]=closeScript;
		if(closeScript!="") closeFlag=true;
		tabCompent.addItem(id, title, clickScript, false, closeFlag, autoOpenFlag);
	}

	function closeTab(tabID,tabName){
		var closeFunctionScript = closeFunctions[tabID];
		
		if(closeFunctionScript&&closeFunctionScript!=""){
			var result = eval(closeFunctionScript);
			if(result){
				tabCompent.deleteTabItem(tabID);
			}
			else return false;
		}
	}
	
	function addButtonFront(button){
		$(".div_button").show();
		$(".btn_d").css("top",$(".div_button").css("height"));
		$(".div_button").html( button +  $(".div_button").html() );
		 prove();
	}
	
	function addButtonBack(button){
		$(".div_button").show();
		$(".btn_d").css("top",$(".div_button").css("height"));
		$(".div_button").html(  $(".div_button").html() + button);
		 prove();
	}
	
	function clickTab(id){
		$("#handle_" + id).click();
	}
	function prove(){
		var temp1 = $("#window1").css("height");
		temp1 = temp1.replace("px","");
		var temp2 = $(".div_button").css("height");
		temp2 = temp2.replace("px","");
		$("#tabs_content_T01").css("height",temp1 - temp2*2 + "px");
	}
	
	
	$(function(){
		$(window).resize(function(){
			$(".tabs_content").height($("body").height()-$(".tabs_button").height()-7);
		}).resize();
	});

	$(document).ready(function(){ 
		createTab();
		
		var btn_div = $('<div class="btn_d"></div>').insertBefore($("#window1"));
		<%
			for(String[] so : sButtons){
				if("TabButton".equalsIgnoreCase(so[6]))
					out.println("$(\"<a class='addBtn inline_button' style=''><span style='display:none;''></span><span class='left'>&nbsp;</span><span class='center'>"+so[3]+"</span><span class='right'>&nbsp;</span></a>\").appendTo(btn_div).click(function(){"+so[5]+"});");
			}
		%>
		$(".btn_d").css("top",$(".div_button").css("height"));
		$(".div_button").insertBefore(btn_div); 
		if($(".div_button").children().length == 0){
			$(".div_button").hide();
			$(".btn_d").css("top",'0px');	
		}

	});
	
</script>

<style type="text/css">
.addBtn{
	z-index:9999;
	margin-right: 2px;
}
.btn_d{
	position: absolute;
	right: 10px;
	top: 0px;
	z-index: 9999;
}
.div_button{
	width:100%;
}
</style>
<%@include file="/Common/FunctionPage/jspf/FunctionScript.jspf" %>
<%@ include file="/IncludeEnd.jsp"%>