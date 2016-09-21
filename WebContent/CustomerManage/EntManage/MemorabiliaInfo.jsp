<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "�ͻ����¼�"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String sTempletNo = "CustomerMemoInfo";//--ģ������
	//�������������ͻ�����
	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	
	//���ҳ�����	����ǰ��ˮ�š��༭Ȩ��
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sEditRight   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sSerialNo == null ) sSerialNo = "";

	//���ݿͻ���Ż�ȡ�ͻ�����
	String sCustomerType = Sqlca.getString(new SqlObject("select CustomerType from CUSTOMER_INFO where CustomerID = :CustomerID").setParameter("CustomerID",sCustomerID));
	if(sCustomerType == null) sCustomerType = "";
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//�����¼�����
	if(sCustomerType.substring(0,2).equals("01")) //��˾�ͻ�
		doTemp.setDDDWSql("EventType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'EventType' and ItemNo like '01%' and length(ItemNo)>2 and isinuse = '1'");
	else//����
		doTemp.setDDDWSql("EventType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'EventType' and ItemNo like '02%' and length(ItemNo)>2 and isinuse = '1'");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	if(sEditRight.equals("01")){
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{(sEditRight.equals("02")?"true":"false"),"All","Button","����","���������޸�","saveRecord()","","","",""},
		{(sEditRight.equals("02")?"true":"false"),"All","Button","���沢����","���������޸Ĳ�����","saveAndNewRecord()","","","",""},
		{"true","","Button","����","�����б�ҳ��","goBack()","","","",""}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	var isSuccess=false;//��Ǳ���ɹ�
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0","saveSuccess()");	
	}
	
	function saveSuccess(){
		isSuccess=true;
	}
	function saveAndNewRecord(){
		saveRecord();
		if(isSuccess){
			OpenPage("/CustomerManage/EntManage/MemorabiliaInfo.jsp?EditRight=02","_self","");
		}
	}
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		OpenPage("/CustomerManage/EntManage/MemorabiliaList.jsp","_self","");
	}
	
	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		OpenPage("/CustomerManage/EntManage/MemorabiliaInfo.jsp","_self","");
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();
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
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() {
		var sTableName = "CUSTOMER_MEMO";//--����
		var sColumnName = "SerialNo";//--�ֶ���
		var sPrefix = "";//--ǰ׺
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