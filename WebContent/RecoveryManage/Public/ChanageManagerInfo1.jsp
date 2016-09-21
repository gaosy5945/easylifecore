<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

	String sObjectNo = CurPage.getParameter("ObjectNo");//������ˮ�ţ�������Ϣ����ծ�ʲ���Ϣ���Ѻ����ʲ���Ϣ
	if(sObjectNo == null) sObjectNo = "";
	String sObjectType = CurPage.getParameter("ObjectType");//�������ͣ�LIChangeManager��DAChangeManager��PDAChangeManager
	if(sObjectType == null) sObjectType = "";
	String sGoBackType = CurPage.getParameter("GoBackType");//����ҳ�棺1��2��3
	if(sGoBackType == null) sGoBackType = "";
	String sOldManagerUserId = CurPage.getParameter("OldManagerUserId");//ԭ������Id
	if(sOldManagerUserId == null) sOldManagerUserId = "";
	String sOldManagerUserName = CurPage.getParameter("OldManagerUserName");//ԭ������name
	if(sOldManagerUserName == null) sOldManagerUserName = "";
	String sOldManagerOrgId = CurPage.getParameter("OldManagerOrgId");//ԭ�������id
	if(sOldManagerOrgId == null) sOldManagerOrgId = "";
	String sOldManagerOrgName = CurPage.getParameter("OldManagerOrgName");//ԭ�������name
	if(sOldManagerOrgName == null) sOldManagerOrgName = "";
	String sDATSerialNo = CurPage.getParameter("DATSerialNo");//\�����˱����Ϣ��ˮ��
	if(sDATSerialNo == null) sDATSerialNo = "";
	String sDAOSerialNo = CurPage.getParameter("DAOSerialNo");//�����˱����ˮ��
	if(sDAOSerialNo == null) sDAOSerialNo = "";
	
	String sPrevUrl = CurPage.getParameter("PrevUrl");
		if(sPrevUrl == null) sPrevUrl = "";

	String sTempletNo = "ChangeManagerInfo1";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sDATSerialNo+","+sDAOSerialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
	<script type="text/javascript">

	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	initRow();
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0");
	}
	//�����¼�
	function afterUpdate(){
		//����ɹ�����
		var sObjectNo="<%=sObjectNo%>";
		var sObjectType="<%=sObjectType%>";
		var sDAOSerialNo="<%=sDAOSerialNo%>";
		var sDATSerialNo="<%=sDATSerialNo%>";
		
		var sReturn = PopPageAjax("/RecoveryManage/Public/ChangeManagerActionAjax.jsp?ObjectNo="+sObjectNo+"&ObjetType="+sObjectType+"&DAOSerialNo="+sDAOSerialNo+"&DATSerialNo="+sDATSerialNo,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		sReturn = sReturn.split("@");
		var sRatio=sReturn[0];
	}
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		//initSerialNo();//��ʼ����ˮ���ֶ�
		//setItemValue(0,0,"SERIALNO","<%=sDATSerialNo%>");
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		//setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
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
			setItemValue(0,0,"OPERATEUSERID","<%=sOldManagerUserId%>");
			setItemValue(0,0,"OPERATEUSERNAME","<%=sOldManagerUserName%>");	
			setItemValue(0,0,"OPERATEORGID","<%=sOldManagerOrgId%>");
			setItemValue(0,0,"OPERATEORGNAME","<%=sOldManagerOrgName%>");	
			setItemValue(0,0,"OCCURDATE","<%=StringFunction.getToday()%>");
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
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
