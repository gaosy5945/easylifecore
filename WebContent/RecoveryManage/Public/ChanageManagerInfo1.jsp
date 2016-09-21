<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

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
	
	String sPrevUrl = CurPage.getParameter("PrevUrl");
		if(sPrevUrl == null) sPrevUrl = "";

	String sTempletNo = "ChangeManagerInfo1";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sDATSerialNo+","+sDAOSerialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
	<script type="text/javascript">

	var bIsInsert = false; //标记DW是否处于“新增状态”

	initRow();
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
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
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		//initSerialNo();//初始化流水号字段
		//setItemValue(0,0,"SERIALNO","<%=sDATSerialNo%>");
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

			setItemValue(0,0,"SERIALNO","<%=sDATSerialNo%>");
			setItemValue(0,0,"DEBTASSETSERIALNO","<%=sDAOSerialNo%>");	
			setItemValue(0,0,"OPERATEUSERID","<%=sOldManagerUserId%>");
			setItemValue(0,0,"OPERATEUSERNAME","<%=sOldManagerUserName%>");	
			setItemValue(0,0,"OPERATEORGID","<%=sOldManagerOrgId%>");
			setItemValue(0,0,"OPERATEORGNAME","<%=sOldManagerOrgName%>");	
			setItemValue(0,0,"OCCURDATE","<%=StringFunction.getToday()%>");
		}
		
    }

	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "npa_debtasset_transaction";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
