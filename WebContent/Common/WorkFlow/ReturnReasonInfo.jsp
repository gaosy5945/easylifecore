<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	String objectNo = CurPage.getParameter("ObjectNo");
	String sTempletNo = "ReturnReasonInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.setParameter("TaskSerialNo", taskSerialNo);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.genHTMLObjectWindow(taskSerialNo+","+objectNo);
	String sButtons[][] = {
		{"true","All","Button","确定","保存所有修改","save()","","","",""},
		{"true","All","Button","取消","返回","returnList()","","","",""},
	};
	sButtonPosition = "south";
%>
<title>请选择退回原因</title>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function save(){
		setItemValue(0, getRow(0), "ObjectNo", "<%=objectNo%>");
		setItemValue(0, getRow(0), "TaskSerialNo", "<%=taskSerialNo%>");
		setItemValue(0, getRow(0), "ObjectType", "jbo.flow.FLOW_OBJECT");
		setItemValue(0, getRow(0), "InputUserID", "<%=CurUser.getUserID()%>");
		setItemValue(0, getRow(0), "InputOrgID", "<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(0),"InputTime","<%=com.amarsoft.app.base.util.DateHelper.getBusinessTime()%>");
		setItemValue(0,getRow(0),"Status","01");
		var CheckItemName = getItemValue(0, getRow(0), "CheckItemName");
		if(typeof(CheckItemName) == "undefined" || CheckItemName.length == 0){
			return;
		}
		var Remark = getItemValue(0, getRow(0), "Remark");
		if(typeof(Remark) != "undefined" && Remark.length != 0){
			setItemValue(0,getRow(0),"CheckItemName",CheckItemName+","+Remark);
			setItemValue(0,getRow(0),"Remark","");
		}
		as_save(0,"sure()");
		//window.setTimeout("sure();", 10);
	}
	function sure(){
		top.returnValue = "true";
		top.close();
	}
	function SelectReason(){
			var codeNo = "ReturnReasons";
			AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","myiframe0",getRow(),"CheckItemNo","CheckItemName");
	}
	function returnList(){
		top.returnValue = "false";
		top.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
