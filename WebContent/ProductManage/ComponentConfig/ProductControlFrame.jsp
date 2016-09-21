<%@page import="com.amarsoft.awe.dw.datamodel.GroupModel"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObject"%>
<%@page import="com.amarsoft.dict.als.cache.AWEDataWindowCache"%>
<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%
	String PG_TITLE = "更多控制要求"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String objectType = CurPage.getParameter("ObjectType");  //参数或组件流水
	String objectNo = CurPage.getParameter("ObjectNo");  //参数或组件流水
	if(objectType==null || objectType.equals("")){
		out.print("请传入objectType参数!");
		return ;
	}
	if(objectNo==null || objectNo.equals("")){
		out.print("请传入objectNo参数!");
		return ;
	}
	
	String templetNo = "PRD_SPECIFIC_INFO";//模板号
	ASObjectModel doTemp = new ASObjectModel(templetNo);
	doTemp.setVisible("*", false);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	
	com.amarsoft.dict.als.object.Item[] items = CodeManager.getItems("PrdSceneType");
	//分组
	try{
		for(com.amarsoft.dict.als.object.Item item:items){
			GroupModel groupModel = new GroupModel();
			groupModel.setDockId(item.getItemNo());
			groupModel.setSortNo(item.getSortNo());
			groupModel.setDockName(item.getItemName());
			groupModel.setDoNo(dwTemp.getDataObject().getDONO());
			AWEDataWindowCache.getInstance().getCatalogModel(templetNo).getGroupList().add(groupModel);
			int iIndex = doTemp.addColumn("COL_"+item.getItemNo());
			
			doTemp.setColumnAttribute(iIndex, "COLINDEX", iIndex + "");
			doTemp.setColumnAttribute(iIndex, "SORTNO", iIndex + "");
			doTemp.setColumnAttribute(iIndex, "ISINUSE", "1");
			doTemp.setColumnAttribute(iIndex, "COLTYPE", "String");
			doTemp.setColumnAttribute(iIndex, "COLHEADER", item.getItemName());
			doTemp.setColumnAttribute(iIndex, "COLCOLUMNTYPE", "1");
			doTemp.setColumnAttribute(iIndex, "COLCHECKFORMAT", "1");
			doTemp.setColumnAttribute(iIndex, "COLALIGN", "1");
			
			doTemp.setColumnAttribute(iIndex, "COLEDITSTYLE", "Text");
			doTemp.setColumnAttribute(iIndex, "COLLIMIT", "0");
			doTemp.setColumnAttribute(iIndex, "COLVISIBLE", "1");
			doTemp.setColumnAttribute(iIndex, "COLREADONLY", "0"); //为空时非只读
			doTemp.setColumnAttribute(iIndex, "COLREQUIRED", "0");
			doTemp.setColumnAttribute(iIndex, "COLSORTABLE", "0");
			doTemp.setColumnAttribute(iIndex, "ISFILTER", "0");
			doTemp.setColumnAttribute(iIndex, "ISAUTOCOMPLETE", "0");
			doTemp.setColumnAttribute(iIndex, "COLSPAN", "1");
			doTemp.setColumnAttribute(iIndex, "GROUPID", item.getItemNo());
		}
		dwTemp.genHTMLObjectWindow("");
		for(com.amarsoft.dict.als.object.Item item:items){
			dwTemp.replaceColumn("COL_"+item.getItemNo(), "<table width=\"100%\"><tr><td width=\"5%\"></td><td width=\"90%\"><iframe type='iframe' name=\"frame_"+item.getItemNo()+"\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\"\"></iframe></td></tr></table>", CurPage.getObjectWindowOutput());
		}
	}
	catch(Exception e){
		throw e;
	}
	finally{
		AWEDataWindowCache.getInstance().getCatalogModel(templetNo).getGroupList().clear();
	}
	
	//按钮
	String sButtons[][] = {
		{"true","","Button","保存","保存","save()","","","","btn_icon_add",""},
	};
%><%@
include file="/Frame/resources/include/ui/include_info.jspf" %>

<script type="text/javascript">
var my_frames = [];
var frameNum = 0;
<%for(com.amarsoft.dict.als.object.Item item:items){%>
my_frames[frameNum++] = "frame_<%=item.getItemNo()%>";
<%}%>

 
function save(){
	var templ = 0;
	for(var i =0 ; i < my_frames.length ; i ++ ){
		setTime(my_frames[i] , templ);
		templ += 100;
	}
}

function setTime(name , time){
	setTimeout(function(){
		doSave(name);
	},time);
}

function doSave(frameName){
	window.frames[frameName].as_save("0","");
}


<%for(com.amarsoft.dict.als.object.Item item:items){%>
	AsControl.OpenView("/ProductManage/ComponentConfig/ProductControlList.jsp"
		,"ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&SceneType=<%=item.getItemNo()%>"
		,"frame_<%=item.getItemNo()%>");
<%}%>
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>