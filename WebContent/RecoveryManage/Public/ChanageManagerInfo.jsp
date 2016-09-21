<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sSerialNo = CurPage.getParameter("SerialNo");
	if(sSerialNo == null) sSerialNo = "";

	String sObjectNo = CurPage.getParameter("ObjectNo");//关联流水号：案件信息、抵债资产信息、已核销资产信息
	if(sObjectNo == null) sObjectNo = "";
	String sObjectType = CurPage.getParameter("ObjectType");//关联类型：LIChangeManager、DAChangeManager、PDAChangeManager
	if(sObjectType == null) sObjectType = "";
	String sGoBackType = CurPage.getParameter("GoBackType");//返回页面：1、2、3
	if(sGoBackType == null) sGoBackType = "";
	String sOldManagerUserId = CurPage.getParameter("OldManagerUserId");//原管理人Id
	if(sOldManagerUserId == null) sOldManagerUserId = "";
	String sOldManagerUserName = CurPage.getParameter("OldManagerUserName");//原管理人name
	if(sOldManagerUserName == null) sOldManagerUserName = "";
	String sOldManagerOrgId = CurPage.getParameter("OldManagerOrgId");//原管理机构id
	if(sOldManagerOrgId == null) sOldManagerOrgId = "";
	String sOldManagerOrgName = CurPage.getParameter("OldManagerOrgName");//原管理机构name
	if(sOldManagerOrgName == null) sOldManagerOrgName = "";
	String sDATSerialNo = CurPage.getParameter("DATSerialNo");//\管理人变更信息流水号
	if(sDATSerialNo == null) sDATSerialNo = "";
	String sDAOSerialNo = CurPage.getParameter("DAOSerialNo");//管理人变更流水号
	if(sDAOSerialNo == null) sDAOSerialNo = "";

	String sTempletNo = "ChangeManagerInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sDAOSerialNo+","+sObjectType+","+sObjectNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","返回","返回列表","goBack()","","","",""}
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

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	var bIsInsert = false; //标记DW是否处于“新增状态”
	var bSaveFlag = false; //标记保存成功
	
	initRow();
	//---------------------定义按钮事件------------------------------------

	//标记保存成功
	function getSaveFlag(){
		bSaveFlag = true;
	}
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
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
	//后续事件
	function afterUpdate(){
		//保存成功后续
		var sObjectNo="<%=sObjectNo%>";
		var sObjectType="<%=sObjectType%>";
		var sDAOSerialNo="<%=sDAOSerialNo%>";
		var sDATSerialNo="<%=sDATSerialNo%>";
		
		var sReturn = PopPageAjax("/RecoveryManage/Public/ChangeManagerActionAjax.jsp?ObjectNo="+sObjectNo+"&ObjetType="+sObjectType+"&DAOSerialNo="+sDAOSerialNo+"&DATSerialNo="+sDATSerialNo,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		sReturn = sReturn.split("@");
		var sRatio=sReturn[0];
	}
	//检查变更信息是否插入
	function checkDAT(){
		var sDAOSerialNo="<%=sDAOSerialNo%>";
		var sDATSerialNo="<%=sDATSerialNo%>";
		//String TableName,String ColName,String WhereClause
		var sWhereClause = "SerialNo='"+sDATSerialNo+"'";
		var sReturn=RunMethod("公用方法","GetColValue","npa_debtasset_transaction"+",count(*)"+","+sWhereClause);
		if(sReturn>0){
			var sReturn1=RunMethod("公用方法","GetColValue","npa_debtasset_transaction"+",INPUTUSERID"+","+sWhereClause);
			var sReturn2=RunMethod("公用方法","GetColValue","npa_debtasset_transaction"+",INPUTORGID"+","+sWhereClause);
			if(sReturn1=="" || sReturn1==null || sReturn2=="" || sReturn2==null ){
				alert("请输入现管理人信息……");
			}
			return true;
		}else{
			alert("请输入并保存现管理人信息……");
			return false;
		}
	}
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		//initSerialNo();//初始化流水号字段
		setItemValue(0,0,"SERIALNO","<%=sDAOSerialNo%>");
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		//setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			//as_add("myiframe0");//新增记录
			bIsInsert = true;	

			setItemValue(0,0,"SERIALNO","<%=sDAOSerialNo%>");
			setItemValue(0,0,"OBJECTNO","<%=sObjectNo%>");//关联流水号
			setItemValue(0,0,"OBJECTTYPE","<%=sObjectType%>");
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.getOrgName()%>");	
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
		}
    }

	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		<%-- var sGoBackType = "<%=sGoBackType%>";
		if(sGoBackType == "1"){ //案件管理人
			OpenPage("/RecoveryManage/LawCaseManage/LawCaseManagerChangeList.jsp","right");
		} else if(sGoBackType == "2"){//抵债资产
			OpenPage("/RecoveryManage/PDAManage/PDAManagerChange/RepayAssetList.jsp","right");
		} else if(sGoBackType == "3"){//已核销资产
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/VerifitionAssetChangeList.jsp","right");
		} --%>
		self.close();
	}

	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "npa_debtasset_object";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
</script>
<%/*~END~*/%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
