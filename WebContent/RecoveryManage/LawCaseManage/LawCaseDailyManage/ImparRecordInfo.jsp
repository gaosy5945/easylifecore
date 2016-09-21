<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	//���ҳ�����
	//��¼��ˮ�š�������š���������	
	String sSerialNo = (String)CurPage.getParameter("SerialNo");
	String sObjectNo = (String)CurPage.getParameter("ObjectNo");
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	String sBookType = "090";//ͥ���¼����

	String sTempletNo = "ImparRecordInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sSerialNo+","+sObjectNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","All","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	
	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;			
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
	}

	/*~[Describe=ִ����������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�		
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			//as_add("myiframe0");//������¼
			bIsInsert = true;	
					
			//�����š���������
			setItemValue(0,0,"LAWCASESERIALNO","<%=sObjectNo%>");
			setItemValue(0,0,"BOOKTYPE","<%=sBookType%>");
			//�Ǽ��ˡ��Ǽ������ơ��Ǽǻ������Ǽǻ�������
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			
			//�Ǽ�����						
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{		
		var sTableName = "LAWCASE_BOOK";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
	
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}


	function returnList(){
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/ImparRecordList.jsp","_self","");
	}
</script>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
