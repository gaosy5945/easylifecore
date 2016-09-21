<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPTISerialNo = (String)CurPage.getParameter("PTISerialNo");
	if(null==sPTISerialNo) sPTISerialNo="";
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	String sTempletNo = "Doc2TranferTaskInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sPTISerialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	initRow();
	
	function initRow(){
		if(getRowCount(0) == 0){
			setItemValue(0,getRow(),"SERIALNO","<%=sPTISerialNo%>");
			setItemValue(0,getRow(),"STATUS","01");//待移库
			setItemValue(0,getRow(),"OPERATEDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"OPERATEUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"OPERATEORGID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"OPERATEUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"OPERATEORGNAME","<%=CurUser.getOrgName()%>");
		}
	}


	function returnList(){
		OpenPage("<%=sPrevUrl%>", "_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
