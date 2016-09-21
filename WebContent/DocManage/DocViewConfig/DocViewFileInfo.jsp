<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sViewId = CurPage.getParameter("ViewId");
	if(sViewId == null) sViewId = " ";
	String sFolderId = CurPage.getParameter("FolderId");
	if(sFolderId == null) sFolderId = " ";
	String sFileId = CurPage.getParameter("FileId");
	if(sFileId == null) sFileId = " ";
	String sTempletNo = "DocViewFileInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sViewId+","+sFolderId+","+sFileId);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	
	initRow();
	
	function returnList(){
		self.close();
	}	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		if(bIsInsert){		
			beforeInsert();
		}
	
		beforeUpdate();
		as_save("myiframe0");
		
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		saveDocView();
		
		setItemValue(0,getRow(),"UPDATEDATE","<%=StringFunction.getToday()%>");
	}
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		//initSerialNo();//初始化流水号字段
		bIsInsert = false;
	}

	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "";//表名
		var sColumnName = "";//字段名
		var sPrefix = "";//前缀
	
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	
	//保存成功后事件
	function saveDocView(){
		//取值
		var sViewId = getItemValue(0,getRow(),"VIEWID");//"<%=sViewId%>"
		var sFolderId = getItemValue(0,getRow(),"FOLDERID");
		var sFolderName = getItemValue(0,getRow(),"FOLDERNAME");
		var sStatus = getItemValue(0,getRow(),"STATUS");
		var sFileId = getItemValue(0,getRow(),"FILEID");
		var sParentFoler = getItemValue(0,getRow(),"PARENTFOLDER");
		
		
		var sReturn=PopPageAjax("/DocManage/DocViewConfig/DocViewFileActionAjax.jsp?ViewId="+sViewId+'&FolderId='+sFolderId+'&FolderName='+sFolderName+'&FileId='+sFileId+'&Status='+sStatus+'&ParentFoler='+sParentFoler+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
		if(typeof(sReturn)!="undefined" && sReturn=="true"){
			//self.close();
		}
	}
	function initRow(){
		if(getRowCount(0)==0){
			setItemValue(0,getRow(),"VIEWID","<%=sViewId%>");
			setItemValue(0,0,"FOLDERID","<%=sFolderId%>");
			setItemValue(0,0,"FILEID","<%=sFileId%>");
			setItemValue(0,getRow(),"UPDATEDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UPDATEUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEORGID","<%=CurUser.getOrgID()%>");
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
