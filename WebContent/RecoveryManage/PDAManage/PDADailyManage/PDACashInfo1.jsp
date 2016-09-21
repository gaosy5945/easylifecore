<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sDATSerialNo = CurPage.getParameter("DATSerialNo");
	if(sDATSerialNo == null) sDATSerialNo = "";
	String sDAOSerialNo = CurPage.getParameter("DAOSerialNo");
	if(sDAOSerialNo == null) sDAOSerialNo = "";
	String sTransctionType = CurPage.getParameter("TransctionType");
	if(sTransctionType == null) sTransctionType = "";

	String sTempletNo = "PDACashInfo1";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sDATSerialNo+","+sDAOSerialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert = false;
	initRow();
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert)
		{
			//beforeInsert();
			setItemValue(0,0,"SERIALNO","<%=sDATSerialNo%>");
			
			bIsInsert = false;
		}
	
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
	}
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			//as_add("myiframe0");//������¼
			bIsInsert = true;	

			setItemValue(0,0,"SERIALNO","<%=sDATSerialNo%>");
			setItemValue(0,0,"DEBTASSETSERIALNO","<%=sDAOSerialNo%>");
			setItemValue(0,0,"AMOUNT","0.00");			
			setItemValue(0,0,"OPERATEUSERID","<%=CurUser.getUserID()%>");			
			setItemValue(0,0,"OPERATEUSERNAME","<%=CurUser.getUserName()%>");			
			setItemValue(0,0,"OPERATEORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"OPERATEORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.getOrgName()%>");	
		}
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "npa_debtasset_transaction";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
	
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}	

	function returnList(){
		OpenPage("<%=sPrevUrl%>", "_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
