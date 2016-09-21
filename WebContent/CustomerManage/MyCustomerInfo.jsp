<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "MyCustomerAdd";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	doTemp.setDefaultValue("SUBSCRIBERName", CurUser.getUserName());
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","返回","保存所有修改","reloadSelf()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		as_save(0,'reloadSelf()');
	}
	function reloadSelf(){
		var flag = "<%=serialNo%>";
		if(flag == ""){
			AsControl.OpenView("/CustomerManage/MyCustomerTree.jsp", "", "frameleft", "");
			AsControl.OpenView("/Blank.jsp","TextToShow=请在左侧选择一项","frameright","");
		}else{
			AsControl.OpenView("/CustomerManage/MyCustomerTree.jsp", "", "frameleft", "");
			OpenPage("/CustomerManage/MyCustomerTagList.jsp?SerialNo="+"<%=serialNo%>", "frameright"); 
		}
	}
	function initRow(){
		setItemValue(0,0,"SUBSCRIBERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"CREATEDATE","<%=StringFunction.getToday()%>");
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
