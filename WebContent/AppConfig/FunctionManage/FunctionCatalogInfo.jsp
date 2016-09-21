<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String functionId = CurPage.getParameter("FunctionID");
	if(functionId == null) functionId = "";

	String menuID = CurPage.getParameter("MenuID");
	if(menuID == null) menuID = "";

	String templetNo = "SysFunctionCatalogInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(templetNo);
	doTemp.setDefaultValue("menuID", menuID);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.setParameter("FUNCTIONID",functionId);
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("List", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"450\" frameborder=\"0\" src=\""+sWebRootPath+"/AppMain/Blank.html?CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0,'afterSave()')","","","",""},
	};
	sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
	}

	var isOpen=false;
	function afterSave(){
		if(!isOpen){
			$("#A_Group_0020").show();
			functionId=getItemValue(0,getRow(),"FunctionID");
			AsControl.OpenPage("/AppConfig/FunctionManage/SysFunctionLibraryList.jsp","FunctionID="+functionId,"frame_list");
		}else{
			window.frames["frame_list"].saveRecord();
		}
	}

	$(function(){
		functionId="<%=functionId%>";
		if(functionId!=""){
			afterSave();
		}else{
			$("#A_Group_0020").hide();
		}
	})
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>