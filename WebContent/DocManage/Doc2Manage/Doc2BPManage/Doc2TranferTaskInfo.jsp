<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPTISerialNo = (String)CurPage.getParameter("PTISerialNo");
	if(null==sPTISerialNo) sPTISerialNo="";
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	String sTempletNo = "Doc2TranferTaskInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sPTISerialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	initRow();
	
	function initRow(){
		if(getRowCount(0) == 0){
			setItemValue(0,getRow(),"SERIALNO","<%=sPTISerialNo%>");
			setItemValue(0,getRow(),"STATUS","01");//���ƿ�
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
