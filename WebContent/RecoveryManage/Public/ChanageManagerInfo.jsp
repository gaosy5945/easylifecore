<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sSerialNo = CurPage.getParameter("SerialNo");
	if(sSerialNo == null) sSerialNo = "";

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

	String sTempletNo = "ChangeManagerInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sDAOSerialNo+","+sObjectType+","+sObjectNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","All","Button","����","�����б�","goBack()","","","",""}
	};
	dwTemp.replaceColumn("CHANAGEMANAGER", "<iframe type='iframe' name=\"frame_list_ChangeManager\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+
			"/RecoveryManage/Public/ChanageManagerInfo1.jsp?"+
			"ObjectType=DAChangeManager&ObjectNo="+sObjectNo+
			"&OldManagerUserId="+sOldManagerUserId+
			"&OldManagerUserName="+sOldManagerUserName+
			"&OldManagerOrgId="+sOldManagerOrgId+
			"&OldManagerOrgName="+sOldManagerOrgName+
			"&DATSerialNo="+sDATSerialNo+
			"&DAOSerialNo="+sDAOSerialNo+
			"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	var bSaveFlag = false; //��Ǳ���ɹ�
	
	initRow();
	//---------------------���尴ť�¼�------------------------------------

	//��Ǳ���ɹ�
	function getSaveFlag(){
		bSaveFlag = true;
	}
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		if(checkDAT()){
			if(bIsInsert)
			{
				beforeInsert();
				bIsInsert = false;
			}

			beforeUpdate();
			as_save("myiframe0");
			//as_save("myiframe0","getSaveFlag()");
			//if(bSaveFlag){
				afterUpdate();
			//}
		}		
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
	//�������Ϣ�Ƿ����
	function checkDAT(){
		var sDAOSerialNo="<%=sDAOSerialNo%>";
		var sDATSerialNo="<%=sDATSerialNo%>";
		//String TableName,String ColName,String WhereClause
		var sWhereClause = "SerialNo='"+sDATSerialNo+"'";
		var sReturn=RunMethod("���÷���","GetColValue","npa_debtasset_transaction"+",count(*)"+","+sWhereClause);
		if(sReturn>0){
			var sReturn1=RunMethod("���÷���","GetColValue","npa_debtasset_transaction"+",INPUTUSERID"+","+sWhereClause);
			var sReturn2=RunMethod("���÷���","GetColValue","npa_debtasset_transaction"+",INPUTORGID"+","+sWhereClause);
			if(sReturn1=="" || sReturn1==null || sReturn2=="" || sReturn2==null ){
				alert("�������ֹ�������Ϣ����");
			}
			return true;
		}else{
			alert("�����벢�����ֹ�������Ϣ����");
			return false;
		}
	}
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		//initSerialNo();//��ʼ����ˮ���ֶ�
		setItemValue(0,0,"SERIALNO","<%=sDAOSerialNo%>");
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

			setItemValue(0,0,"SERIALNO","<%=sDAOSerialNo%>");
			setItemValue(0,0,"OBJECTNO","<%=sObjectNo%>");//������ˮ��
			setItemValue(0,0,"OBJECTTYPE","<%=sObjectType%>");
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.getOrgName()%>");	
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
		}
    }

	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		<%-- var sGoBackType = "<%=sGoBackType%>";
		if(sGoBackType == "1"){ //����������
			OpenPage("/RecoveryManage/LawCaseManage/LawCaseManagerChangeList.jsp","right");
		} else if(sGoBackType == "2"){//��ծ�ʲ�
			OpenPage("/RecoveryManage/PDAManage/PDAManagerChange/RepayAssetList.jsp","right");
		} else if(sGoBackType == "3"){//�Ѻ����ʲ�
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/VerifitionAssetChangeList.jsp","right");
		} --%>
		self.close();
	}

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "npa_debtasset_object";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
</script>
<%/*~END~*/%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
