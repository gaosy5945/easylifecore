<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	/*
		Describe: �����ϸ��Ϣ;
		Input Param:
			CustomerID����ǰ�ͻ����
			SerialNo:��ˮ��
			EditRight:--Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��   		
	 */
	String PG_TITLE = "�����ϸ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sRecordNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RecordNo"));
	String sReportDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportDate"));
	if(sCustomerID == null) sCustomerID = "";
	if(sRecordNo == null) sRecordNo = "";
	if(sReportDate == null) sReportDate = "";
	//���ҳ�����
	String sSerialNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sEditRight = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sSerialNo == null ) sSerialNo = "";
	if(sEditRight == null) sEditRight = "";
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "EntInventoryInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		//out.println(doTemp.SourceSql);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	if(sEditRight.equals("01")){
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{(sEditRight.equals("02")?"true":"false"),"","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","","Button","����","�����б�ҳ��","goBack()","","","",""}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		//¼��������Ч�Լ��
		if(bIsInsert){		
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		OpenPage("/CustomerManage/EntManage/EntInventoryList.jsp","_self","");
	}
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();//��ʼ����ˮ���ֶ�
		setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
		bIsInsert = false;
	}

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//������¼
			setItemValue(0,0,"UpToDate","<%=sReportDate%>");
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"RecordNo","<%=sRecordNo%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){ 
		var sTableName = "ENT_INVENTORY";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>