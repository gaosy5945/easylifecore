<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	String sSerialNo=CurPage.getParameter("SerialNo");
	if(sSerialNo == null) sSerialNo = "";
	String sDAOSerialNo=CurPage.getParameter("DAOSerialNo");
	if(sDAOSerialNo == null) sDAOSerialNo = "";
	String sDASerialNo=CurPage.getParameter("DASerialNo");
	if(sDASerialNo == null) sDASerialNo = "";
	String sTransactionCode=CurPage.getParameter("TransactionCode");
	if(sTransactionCode == null) sTransactionCode = "";
	
	String sTempletNo = "PDADisposal01Info";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sSerialNo+","+sDAOSerialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","����","�����б�","returnList()","","","",""}
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
			var sSerialNo = getSerialNo("NPA_DEBTASSET_TRANSACTION","SerialNo","");
			setItemValue(0,0,"SERIALNO",sSerialNo);
			//setItemValue(0,0,"DebtAssetSerialno","<%=sDASerialNo%>");
			setItemValue(0,0,"DebtAssetSerialno","<%=sDAOSerialNo%>");
			setItemValue(0,0,"TRANSACTIONCODE","<%=sTransactionCode%>");
			//setItemValue(0,0,"OBJECTTYPE","jbo.preservation.NPA_DEBTASSET_OBJECT");
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"OPERATEUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"OPERATEUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"OPERATEORGID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"OPERATEORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"OCCURDATE","<%=StringFunction.getToday()%>");	
			setItemValue(0,0,"ACCOUNTINGDATE","<%=StringFunction.getToday()%>");	
		}
	}
	function returnList(){
		OpenPage("<%=sPrevUrl%>", "_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
