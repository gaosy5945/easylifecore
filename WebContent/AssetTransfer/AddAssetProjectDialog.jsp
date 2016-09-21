<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

	String sTempletNo = "AddAssetProjectInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(CurPage.getParameter(""));
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord(0)","","","",""},
		{"true","All","Button","返回","返回列表","goBack()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function goBack(){
		self.close();
	}

	function saveRecord(){
		as_save(0,"afterEvent()");
	}
	
	function afterEvent(){
		var serialNo = getItemValue(0,getRow(),"SerialNO");
		var sAssetProjectType = getItemValue(0,getRow(),"ProjectType");
	 	//paramString = "ObjectNo=" + serialNo + "&ObjectType=AssetProject&AssetProjectType="+sAssetProjectType;
    	//AsControl.OpenObjectTab(paramString);
    	AsControl.OpenObject("AssetProject", serialNo, "" , "");

    	self.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
