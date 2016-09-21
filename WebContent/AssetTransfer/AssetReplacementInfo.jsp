<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	//资产置换
	//接收参数
	String objectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));

	String sTempletNo = "AssetReplacementInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	///AppMain/Blank.html
	dwTemp.replaceColumn("replace1", "<iframe type='iframe' name=\"frame_list1\" width=\"100%\" height=\"250\" frameborder=\"0\" src=\""+sWebRootPath+"/AppMain/Blank.html\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("replace2", "<iframe type='iframe' name=\"frame_list2\" width=\"100%\" height=\"400\" frameborder=\"0\" src=\""+sWebRootPath+"/AppMain/Blank.html\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
		{"true","All","Button","确定","确定","ok()","","","",""},
		{"true","All","Button","取消","取消","cancel()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	$(document).ready(function(){
		AsControl.OpenView("/AssetTransfer/ProjectAssetRelaList.jsp","","frame_list1","resizable=yes;dialogWidth=800px;dialogHeight=600px;center:yes;status:no;statusbar:no");
		AsControl.OpenView("/AssetTransfer/AssetFilterList.jsp","","frame_list2","resizable=yes;dialogWidth=800px;dialogHeight=600px;center:yes;status:no;statusbar:no");
	});

	function ok(){
		var f1 = window.frames["frame_list1"];
		var f2 = window.frames["frame_list2"];
		
		var checkedRows1 = f1.getCheckedRows(0);//获取勾选的行
		var checkedRows2 = f2.getCheckedRows(0);//获取勾选的行
		
		if(checkedRows1.length == 0){
			alert("请选择被置换的资产");
			return;
		}
		if(checkedRows2.length == 0){
			alert("请选择置换资产");
			return;
		}
		
		var relaSerialNos1 = '';
		var relaSerialNos2 = '';
		
		for(var i = 1;i <= checkedRows1.length;i++){
			var serialNo = f1.getItemValue(0,checkedRows1[i-1],"serialNo");
			relaSerialNos1 += serialNo+"@";
		}
		
		for(var i = 1;i <= checkedRows2.length;i++){
			var serialNo = f2.getItemValue(0,checkedRows2[i-1],"serialNo");
			relaSerialNos2 += serialNo+"@";
		}
		
		//alert("relaSerialNos1 = "+relaSerialNos1);
		//alert("relaSerialNos2 = "+relaSerialNos2);
		
		if(relaSerialNos1.length > 0 && relaSerialNos2.length > 0){
			var sUserId = '<%=CurUser.getUserID()%>';
			var sOrgId = '<%=CurUser.getOrgID()%>';
			var sObjectNo = '<%=objectNo%>';
			//资产置换
			var sJavaClass = "com.amarsoft.app.als.assetTransfer.action.AssetFilterAction";
			var sJavaMethod = "assetReplacement";
			var sParams = "serialNos="+relaSerialNos1+",serialNos2="+relaSerialNos2+",userId="+sUserId+",orgId="+sOrgId+",projectNo="+sObjectNo;
			
			var sResult = RunJavaMethodTrans(sJavaClass,sJavaMethod,sParams);
			cancel();
		}
		
	}
	
	function cancel(){
		self.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
