<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sDAOSerialNo = CurPage.getParameter("ObjectNo");
	if(sDAOSerialNo == null) sDAOSerialNo = "";

	String sTempletNo = "DAOtherFeeInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"true","","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	initRow();
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			//as_add("myiframe0");//������¼
			bIsInsert = true;	
			var sSerialNo = getSerialNo("NPA_FEE_LOG","SerialNo","");
			setItemValue(0,0,"SERIALNO",sSerialNo);
			setItemValue(0,0,"OBJECTNO","<%=sDAOSerialNo%>");
			setItemValue(0,0,"OBJECTTYPE","jbo.preservation.NPA_DEBTASSET_OBJECT");
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");	
		}
	}
	function returnList(){
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/DAOtherFeeList.jsp?DAOSerialNo="+"<%=sDAOSerialNo%>", "_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
