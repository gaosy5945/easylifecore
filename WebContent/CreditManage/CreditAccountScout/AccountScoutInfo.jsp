<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String PG_TITLE = "�˻��������"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������:�˺�
	String sAccount =  CurComp.getParameter("Account");
	String sCustomerID =  CurComp.getParameter("CustomerID");
	String sSerialNo    = CurPage.getParameter("SerialNo");
	if(sAccount==null ) sAccount = "";
	if(sCustomerID == null ) sCustomerID = "";
	if(sSerialNo == null ) sSerialNo = "";

	String sCustomerName =  Sqlca.getString(new SqlObject("select CustomerName from ACCOUNT_INFO where CustomerID=:CustomerID").setParameter("CustomerID", sCustomerID));
	if(sCustomerName == null ) sCustomerName = "";

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "AccountScoutInfo"; //ģ����
	String sTempletFilter = "1=1"; //�й�������ע�ⲻҪ�����ݹ�������
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,sTempletFilter);
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","","Button","����","�����б�ҳ��","goBack()","","","",""}
    };
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(){
		if(bIsInsert){
			beforeInsert();
		}else
			beforeUpdate();
		
	    as_save("myiframe0");
	}

    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function goBack(){
        self.close();
	}
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//������¼
			setItemValue(0,0,"Account","<%=sAccount%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"DataLeadMode","010");		
			bIsInsert = true;
		}
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "ACCOUNT_WASTEBOOK";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>