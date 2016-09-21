<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sDOSerialNo = CurPage.getParameter("DOSerialNo");
	if(sDOSerialNo == null) sDOSerialNo = "";

	String sTempletNo = "DocAddChoseInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	doTemp.setHtmlEvent("OBJECTTYPE", "onChange", "selectDocType");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sDOSerialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","All","Button","ȡ��","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "south";
	
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var sSaveFlag = "false";
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		if(checkRecord()){
			beforeInsert();
			//beforeUpdate();//��ʱ������ ������
			as_save("myiframe0","SaveFlag()");
			alert(sSaveFlag);
			if(sSaveFla){
				//���ر�����
				self.returnValue ="111";// sDOSerialNo + "@" + sObjectType + "@" + sObjectNo;
				self.close();
			}
			OpenPage("/DocManage/Doc2Manage/Doc2BPManage/Doc2BeforPigeonholeManageList.jsp", "_self");
		}
	}
	//�������
	function checkRecord(){
		var sObjectNo =  "";
		var sMsg = "�����������ţ�";
		var sObjectType =  getItemValue(0,getRow(),"OBJECTTYPE");
		if(sObjectType == "1"){
			sObjectNo = getItemValue(0,getRow(),"OBJECTNO1");
			sMsg = "�����������ȱ�ţ�";
		} else if(sObjectType == "2"){
			sObjectNo = getItemValue(0,getRow(),"OBJECTNO2");
			sMsg = "��������������ţ�";
		} else if(sObjectType == "3"){
			sObjectNo = getItemValue(0,getRow(),"OBJECTNO3");
			sMsg = "���������������Ŀ��";
		}
		if(sObjectNo == "" || sObjectNo == "null"){
			alert(sMsg);
			return ;
		} else {
			return true;
		}
	}
	//�ɹ���ʶ
	function SaveFlag(){
		sSaveFlag = "true";
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		saveDocView();
		
		setItemValue(0,getRow(),"OPERATEDATE","<%=StringFunction.getToday()%>");
	}
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		//bIsInsert = false;//ֻ������
	}

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "DOC_OPERATION";//����
		var sColumnName = "SERIALNO";//�ֶ���
		var sPrefix = "";//ǰ׺
	
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	//����ɹ����¼�
	function saveDocView(){
		//ȡֵ
		var sViewId = getItemValue(0,getRow(),"VIEWID");
		var sFolderId = getItemValue(0,getRow(),"FOLDERID");
		var sFolderName = getItemValue(0,getRow(),"FOLDERNAME");
		var sStatus = getItemValue(0,getRow(),"STATUS");
		var sFileId = getItemValue(0,getRow(),"FILEID");
		var sParentFoler = getItemValue(0,getRow(),"PARENTFOLDER");
		
		
		var sReturn=PopPageAjax("/DocManage/DocViewConfig/DocViewFileActionAjax.jsp?ViewId="+sViewId+'&FolderId='+sFolderId+'&FolderName='+sFolderName+'&FileId='+sFileId+'&Status='+sStatus+'&ParentFoler='+sParentFoler+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
		if(typeof(sReturn)!="undefined" && sReturn=="true"){
			self.close();
		}
	}
	/*~[Describe=��ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if(getRowCount(0)==0){
			setItemValue(0,0,"OPERATEDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"OPERATEUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
		}
	}
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function returnList(){
		var sObjectNo =  "";
		var sMsg = "�����������ţ�";
		var sObjectType =  getItemValue(0,getRow(),"OBJECTTYPE");
		if(sObjectType == "1"){
			sObjectNo = getItemValue(0,getRow(),"OBJECTNO1");
			//sMsg = "�����������ȱ�ţ�";
		} else if(sObjectType == "2"){
			sObjectNo = getItemValue(0,getRow(),"OBJECTNO2");
			//sMsg = "��������������ţ�";
		} else if(sObjectType == "3"){
			sObjectNo = getItemValue(0,getRow(),"OBJECTNO3");
			//sMsg = "���������������Ŀ��";
		}
		/* if(sObjectNo == "" || sObjectNo == "null"){
			alert(sMsg);
			return ;
		} */
		var sDOSerialNo = getItemValue(0,getRow(),"SERIALNO");
		//���ر�����
		self.returnValue = sDOSerialNo + "@" + sObjectType + "@" + sObjectNo;
		self.close();
		OpenPage("/DocManage/Doc2Manage/Doc2BPManage/Doc2BeforPigeonholeManageList.jsp", "_self");
	}
	//ѡ����Ӧ
	function selectDocType(){
		alert(1123);
		var sObjectType =  getItemValue(0,getRow(),"OBJECTTYPE");
		if(sObjectType == "1"){
			setItemReadOnly(0,0,"OBJECTNO1",false);
		} else if(sObjectType == "2"){
			setItemReadOnly(0,0,"OBJECTNO2",false);
		} else if(sObjectType == "3"){
			setItemReadOnly(0,0,"OBJECTNO2",false);
		}
	}	
	
	//ѡ�������ˮ��
	function selectSerialNo(args){
		if(args == "1"){
			
		} else if(args == "2"){
			alert(2);
		} else if(args == "3"){
			alert(3);
		}
	}
	
	function setCustomerName(){ 
		var sDocType = trim(document.getElementById("DocType").value);
		var sParaID = "";
		var sTableName = "";
		if(sDocType == "1"){
			sParaId = "crmSerialNo";
			sTableName = "1";
		} else if(sDocType == "2"){
			sParaId = "busiSerialNo";
			sTableName = "2";
		} else if(sDocType == "3"){
			sParaId = "togSerialNo";
			sTableName = "3";
		}
		
		var sObjectType =  getItemValue(0,getRow(),"OBJECTTYPE");
		//��ÿͻ���š��ͻ�����
        var sColName = "CustomerID@CustomerName";
		sTableName = "Business_apply";
		var sWhereClause = "String@SERIALNO@"+sObjectNo;
		
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		
		var sSql = "select customername from " + sTableName + "  where serialNo='"+sSerialNo+"'";
		var sReturnValue = RunMethod("PublicMethod","RunSql",sSql);
		if(sReturn != 1){
			alert("��ѯʧ�ܣ�");
		}else{
			document.getElementById("customerName").value = sReturnValue;
		}
		var sDocType = trim(document.getElementById("DocType").value);
		alert(sDocType);
	}
	//���ر�����
	//self.returnValue = sDocCL + "@" + sDocType + "@";
	//self.close();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
