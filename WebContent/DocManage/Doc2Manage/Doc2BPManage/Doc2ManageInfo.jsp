<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
/**  1、二类业务资料预归档提交操作。
*/

	String serialNo = (String)CurPage.getParameter("SerialNo");

	String sApplyType = (String)CurPage.getParameter("ApplyType");
    String sObjectType = (String)CurPage.getParameter("ObjectType"); 
	String sTransactionCode = (String)CurPage.getParameter("TransactionCode"); 	
	if(sTransactionCode==null){sTransactionCode="";}
	String sObjectNo = "";
	String sTempletNo = "";
	if(!"".equals(sObjectType)&&sObjectType!=null&&"jbo.prj.PRJ_BASIC_INFO".equals(sObjectType)){
		sTempletNo ="CooperAtionObject";//当业务资料归属类型为"合作项目"时显示该模板
	}else{
		sTempletNo = "Doc2ManageInfo";//当业务资料归属类型为"额度"或"贷款"时显示该模板
	}
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//当操作类型不是"预归档管理"时，不显示"架位"要素的后缀提示信息
	if(!"".equals(sTransactionCode)&&!"0000".equals(sTransactionCode)){
		doTemp.setUnit("POSITION", "");
		doTemp.setHeader("SERIALNO", "入库编号");
	}else{
		doTemp.setHeader("SERIALNO", "预归档编号");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "0";//只读模式
	//dwTemp.replaceColumn("ADDRESSINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/DocManage/Doc2Manage/Doc2BPManage/DocFileList.jsp?DOSerialNo="+serialNo+"&DOObjectType="+sObjectType+"&DOObjectNo="+sObjectNo+"\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"true","All","Button","提交","预归档提交","submitRecord()","","","",""},
	};

	sButtonPosition = "north";
	//已入库时 隐藏按钮
	if("03".equals(sApplyType)){
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
	}
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	//预归档
	function submitRecord(){
		if(as_isPageChanged()){
			alert("提交前请先保存！");
			return;
		}
		var serialNo = "<%=serialNo%>"; 
		var transactionCode = getItemValue(0,getRow(),"TransactionCode");
		var opStatus = getItemValue(0,getRow(),"STATUS");
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc2ManageAction","commit","SerialNo="+serialNo+",TransactionCode="+transactionCode+",Status="+opStatus);
		alert(returnValue);
		top.close();
	}
	
</script>
		
<%@ include file="/Frame/resources/include/include_end.jspf"%>
