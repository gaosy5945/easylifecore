<%@page import="com.amarsoft.app.base.businessobject.BusinessObjectManager"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObject"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
  
<%
	String PG_TITLE = "�˻���Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String businessType = "";
	String projectVersion = "";
	
	//���ҳ�����
	String SerialNo = CurPage.getParameter("SerialNo");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	String sStatus = CurPage.getParameter("Status");
	String sAccountIndicator = CurPage.getParameter("AccountIndicator");
	String right=CurPage.getParameter("RightType");
	if(SerialNo == null) SerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sStatus == null) sStatus = "";
	
	//��ʾģ����
	String sTempletNo = "BusinessAccountInfo";
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
	if("00".equals(sAccountIndicator) || "01".equals(sAccountIndicator) || !"".equals(SerialNo))
		doTemp.setReadOnly("AccountIndicator",true);
	else if("99".equals(sAccountIndicator))
		doTemp.setDDDWJbo("AccountIndicator", "select itemno,itemname from code_library where codeno = 'AccountIndicator' and itemno in('02','03','04')");
	if("00".equals(sAccountIndicator) || "99".equals(sAccountIndicator) || !"".equals(SerialNo)){
		doTemp.setVisible("PriorityFlag",false);
		doTemp.setDefaultValue("PriorityFlag","1");
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style = "2"; //����DW��� 1:Grid 2:Freeform
	if("ReadOnly".equals(right)||sObjectType.equals("PutOutApply")){
		dwTemp.ReadOnly = "1";
	}else{
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	}
	dwTemp.genHTMLObjectWindow(SerialNo);
	

	String sButtons[][] = {
			{"true", "", "Button", "����", "����һ����Ϣ","saveRecord()",""},
			{"true", "", "Button", "����", "����","goBack()",""},
	};
	if("ReadOnly".equals(right)||sObjectType.equals("PutOutApply")){
		sButtons[0][1]="false";
	}
%>
	<%@include file="/Frame/resources/include/ui/include_info.jspf"%>

<script language=javascript>
	var coreCheckFlag = false;
	//����
	function saveRecord(){
		if(bIsInsert){
			beforeInsert();
		}else
		//�˻����� ���Ϊ�ſ��˻���Ϊ������Ա������Ϊ�����˻�������ֻ�ܱ���һ���ٴγ������ܱ���
		var status = getItemValue(0,getRow(),"Status");
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var returnValue = RunJavaMethodTrans("com.amarsoft.acct.accounting.web.DistinctAccount","getAccountNumber","objectNo="+"<%=sObjectNo%>,objectType=<%=sObjectType%>,accountIndicator="+getItemValue(0,0,'AccountIndicator')+",serialNo="+serialNo);
		if(typeof(returnValue)!="undifined"&& returnValue!="fasle"&&parseInt(returnValue)>=1){
			alert("���˻������Ѵ���");
			return;
		}else
			as_save("myiframe0","goBack();");
	}
	//����
	function goBack(){
		OpenPage("/Accounting/LoanDetail/LoanTerm/BusinessAccountList.jsp?Status=<%=sStatus%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","_self","");
	}
	
	/*~[Describe=ִ����������ǰ��ʼ����ˮ��;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "ACCT_BUSINESS_ACCOUNT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺	
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=ҳ��װ��ʱ����OW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"Status","0");
			bIsInsert = true;
			if("<%=sAccountIndicator%>" == "00")
				setItemValue(0,0,"AccountIndicator","00");
			else if("<%=sAccountIndicator%>" == "01")
				setItemValue(0,0,"AccountIndicator","01");
		}else{
			bIsInsert = false;
		}
	}
	//�ı��˻�������������ѡ��ĸı�
	function changeAccountIndicator(){
		var sResult = getItemValue(0,getRow(),"AccountIndicator");
		if("00"==sResult){
			setItemDisabled(0,getRow(),"PRI",false);
			return;
		}else{
			setItemValue(0,0,"PRI","1");
			setItemDisabled(0,getRow(),"PRI",true);
			return;
		}
	}
		
</script>

<script language=javascript>
	//��ʼ��
	var bFreeFormMultiCol = true;
	var bIsInsert = true;
	my_load(2,0,'myiframe0');
	initRow();
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>