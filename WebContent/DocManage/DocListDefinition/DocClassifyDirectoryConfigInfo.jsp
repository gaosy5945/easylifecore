<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sViewId = CurPage.getParameter("ViewId");
	if(sViewId == null) sViewId = "";
	String sFolderId = CurPage.getParameter("FolderId");
	if(sFolderId == null) sFolderId = "";
	String sFileId = CurPage.getParameter("FileId");
	if(sFileId == null) sFileId = "";

	String sTempletNo = "DocClassifyDirectoryConfigInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sFileId+","+sFolderId+","+sViewId);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","All","Button","����","�����б�","returnList()","","","",""}
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
		if(bIsInsert){		
			beforeInsert();
		}
	
		beforeUpdate();
		as_save("myiframe0");	
	}
	
	//����ɹ����¼�
	function saveDocView(){
		//ȡֵ
		var sViewId = getItemValue(0,getRow(),"VIEWID");//"<%=sViewId%>"
		var sFolderId = getItemValue(0,getRow(),"FOLDERID");
		var sFolderName = getItemValue(0,getRow(),"FOLDERNAME");
		var sStatus = getItemValue(0,getRow(),"STATUS");
		var sFileId = getItemValue(0,getRow(),"FILEID");
		var sParentFoler = getItemValue(0,getRow(),"PARENTFOLDER");
		
		
		var sReturn=PopPageAjax("/DocManage/DocListDefinition/DocClassifyDirectoryActionAjax.jsp?ViewId="+sViewId+'&FolderId='+sFolderId+'&FolderName='+sFolderName+'&FileId='+sFileId+'&Status='+sStatus+'&ParentFoler='+sParentFoler+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
		if(typeof(sReturn)!="undefined" && sReturn=="true"){
			self.close();
		}
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		saveDocView();
		setItemValue(0,getRow(),"UPDATEDATE","<%=StringFunction.getToday()%>");
	}
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		//initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0) == 0)
		{
			//as_add("myiframe0");//������¼
			setItemValue(0,getRow(),"VIEWID","<%=sViewId%>");
			setItemValue(0,0,"FOLDERID","<%=sFolderId%>");
			setItemValue(0,0,"FILEID","<%=sFileId%>");
			setItemValue(0,getRow(),"UPDATEDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UPDATEUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEORGID","<%=CurUser.getOrgID()%>");
			bIsInsert = true;
		}
		
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "";//����
		var sColumnName = "";//�ֶ���
		var sPrefix = "";//ǰ׺
	
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	
	function returnList(){
		OpenPage("/DocManage/DocListDefinition/DocClassifyDirectoryConfigList.jsp", "_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
