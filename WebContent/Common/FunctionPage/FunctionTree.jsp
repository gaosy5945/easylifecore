<%@page import="com.amarsoft.awe.dw.ASObjectWindow"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObject"%>
<%@page import="com.amarsoft.app.als.sys.function.config.SysFunctionCache"%>
<%@page import="com.amarsoft.app.als.sys.function.model.FunctionInstance"%>
<%@page import="com.amarsoft.app.als.ui.function.FunctionWebTools"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 


<%
	String PG_TITLE = ""; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = CurPage.getParameter("PG_CONTENT_TITLE"); //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	
	String showTitleFlag = CurPage.getParameter("ShowTitleFlag");
	if("".equals(showTitleFlag)||showTitleFlag==null) showTitleFlag = "0";
	FunctionInstance functionInstance=FunctionInstance.getFunctionInstance(CurPage, CurUser);
	String functionID = functionInstance.getFunction().getKeyString();
	String functionItemID =functionInstance.getCurFunctionItemID();

	String defaultClickItemId="";
	if(PG_TITLE==null||PG_TITLE.length()==0){
		PG_TITLE = functionInstance.getFunction().getString("FunctionName");
	}
	
	if(PG_CONTENT_TITLE==null   || PG_CONTENT_TITLE.equalsIgnoreCase("hide")){
		PG_CONTENT_TITLE=null;
		PG_TITLE=null;
	}
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,PG_TITLE,"right");
    tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	
    //如果树图只有一个选项则默认不显示树图
    //if(functionInstance.getFunctionItemList() != null && functionInstance.getFunctionItemList().size() <= 1) PG_LEFT_WIDTH = "1";
    
    FunctionWebTools.genHTMLTreeView(tviTemp, functionInstance, functionItemID);
	ArrayList<TreeViewItem> lst=tviTemp.Items;
	for(TreeViewItem treeItem:lst){
		if(treeItem.getType().equalsIgnoreCase("page") && defaultClickItemId.equals("")){
			defaultClickItemId=treeItem.getId();
			break;
		} 
	}
	
	String sButtons[][] = FunctionWebTools.genButtons(functionInstance, functionItemID);
	if(sButtons == null)
		sButtons = new String[0][6];
	for(String[] button : sButtons){
		if(!"Button".equalsIgnoreCase(button[6]))
			button[0] = "false";
	}
	
	//if("0".equals(showTitleFlag)){
	if(sButtons.length==0){
		PG_TITLE = null;
		PG_CONTENT_TITLE = null;
	}
	
	List<BusinessObject> dwList = functionInstance.getAllFunctionItemList(functionItemID, FunctionInstance.FUNCTION_ITEM_TYPE_INFO);
	if(dwList!=null&&!dwList.isEmpty()){
%>
<!-- Info 必须的资源-->
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/jquery/plugins/jquery.validate.min-1.8.1.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/jquery/plugins/jquery.validate.extend.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/as_contextmenu.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/as_webcalendar.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/ow/as_dw_autocomplete.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/ow/as_dw_common.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/ow/as_dw_info.js"></script>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/date.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/ow/autocomplete.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/ow/info.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/ow/info_pradio.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%><%=sSkinPath%>/css/ow/info.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%><%=sSkinPath%>/css/ow/info_pradio.css">
<!-- Info 必须的资源-->
<div style="width: 100%;height: 100%;background-color: #CCC;display: none"  id="TreeItemEdit_DIV">
	<div style="width: 70%;height: 70%;left: 15%;top:15%;position: relative;background-color: white">
		<table class="info_data_tablecommon" id="InfoTable">
			<tr id="DWTR">
				<td valign=top class="infodw_top_area" id="DWTD">
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
					<div id="0" style="overflow:auto;margin:0px;">
						<form name="myiframe0" id="myiframe0" style="margin:0px;">
							<%=FunctionWebTools.getObjectWindowHTML(functionInstance,dwList.get(0).getString("FunctionItemID")
									,CurPage,request)%>
						</form>
					</div>
				</td>
			</tr>
			<tr>
				<td align="center">
					<input id = "EditTreeItem_SUBMIT_BUTTON" type="button" value="确认"  onclick="" >&nbsp;
					<input type="button" value="取消"  onclick='$("#TreeItemEdit_DIV").hide();' >
				</td>
			</tr>
		</table>
	</div>
</div>
<%
	}
%>
<%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
var PG_TITLE="<%=PG_TITLE%>";
var PG_CONTENT_TITLE="<%=PG_CONTENT_TITLE%>";

var showTitleFlag="<%=showTitleFlag%>";

	function openChildComp(sURL,sParameterString){
		AsControl.OpenComp(sURL,sParameterString,"right");
	}
	
	<%/*treeview单击选中事件*/%>
	function TreeViewOnClick(){
		var url = getCurTVItem().value; 
		sDescribe=url.split("@");
		url=sDescribe[0];
		sParameter=sDescribe[1];
		
		 if(url == "null" || url == "root" || url == ""){
			return ;
		 }
		sParaStringTmp =sParameter;
		openChildComp(url,sParaStringTmp); 
		if(PG_TITLE!="null"){
			setTitle(getCurTVItem().name);
		}
	}

	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItem('<%=defaultClickItemId%>');
		
	}

	initTreeView();
	
	$(document).ready(function(){
		<%if(sButtons.length>0){%>
			_draw_tree_Button();
		<%}%>
	});
	
	function _draw_tree_Button(){
		$(".left_content_title").contents().remove();
		var buttonarray = $("<span></span>").appendTo($(".left_content_title"));
		//var buttonarray = $("<span></span>").insertBefore($("iframe[name='FirstFrame_operFramePRD_ProductCatalogTree']").contents().find("#tabTreeview"));
		<%
		for(String[] temp : sButtons){
		%>
		$("<a class=\"pt9white\" style=\"font-size: 12px;cursor: pointer;text-decoration: none;margin-left: 5px;height: 20px;widows: 40px;display: inline-block;\"><%=temp[3]%></a>").appendTo(buttonarray).click(function(){
			<%=temp[5]%>
		});
		<%
		}
		%>
	}
</script>
<%@include file="/Common/FunctionPage/jspf/FunctionScript.jspf" %>
<%@ include file="/IncludeEnd.jsp"%>