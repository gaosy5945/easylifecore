<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sDOSerialNo = CurPage.getParameter("DOSerialNo");
	if(sDOSerialNo == null) sDOSerialNo = "";

	String sTempletNo = "DocAddChoseInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	doTemp.setHtmlEvent("OBJECTTYPE", "onChange", "selectDocType");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sDOSerialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","取消","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "south";
	
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var sSaveFlag = "false";
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		if(checkRecord()){
			beforeInsert();
			//beforeUpdate();//暂时不考虑 ？？？
			as_save("myiframe0","SaveFlag()");
			alert(sSaveFlag);
			if(sSaveFla){
				//返回变量：
				self.returnValue ="111";// sDOSerialNo + "@" + sObjectType + "@" + sObjectNo;
				self.close();
			}
			OpenPage("/DocManage/Doc2Manage/Doc2BPManage/Doc2BeforPigeonholeManageList.jsp", "_self");
		}
	}
	//检查输入
	function checkRecord(){
		var sObjectNo =  "";
		var sMsg = "请输入关联编号！";
		var sObjectType =  getItemValue(0,getRow(),"OBJECTTYPE");
		if(sObjectType == "1"){
			sObjectNo = getItemValue(0,getRow(),"OBJECTNO1");
			sMsg = "请输入关联额度编号！";
		} else if(sObjectType == "2"){
			sObjectNo = getItemValue(0,getRow(),"OBJECTNO2");
			sMsg = "请输入关联贷款编号！";
		} else if(sObjectType == "3"){
			sObjectNo = getItemValue(0,getRow(),"OBJECTNO3");
			sMsg = "请输入关联合作项目！";
		}
		if(sObjectNo == "" || sObjectNo == "null"){
			alert(sMsg);
			return ;
		} else {
			return true;
		}
	}
	//成功标识
	function SaveFlag(){
		sSaveFlag = "true";
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		saveDocView();
		
		setItemValue(0,getRow(),"OPERATEDATE","<%=StringFunction.getToday()%>");
	}
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		//bIsInsert = false;//只有新增
	}

	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "DOC_OPERATION";//表名
		var sColumnName = "SERIALNO";//字段名
		var sPrefix = "";//前缀
	
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	//保存成功后事件
	function saveDocView(){
		//取值
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
	/*~[Describe=初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if(getRowCount(0)==0){
			setItemValue(0,0,"OPERATEDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"OPERATEUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
		}
	}
	
	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function returnList(){
		var sObjectNo =  "";
		var sMsg = "请输入关联编号！";
		var sObjectType =  getItemValue(0,getRow(),"OBJECTTYPE");
		if(sObjectType == "1"){
			sObjectNo = getItemValue(0,getRow(),"OBJECTNO1");
			//sMsg = "请输入关联额度编号！";
		} else if(sObjectType == "2"){
			sObjectNo = getItemValue(0,getRow(),"OBJECTNO2");
			//sMsg = "请输入关联贷款编号！";
		} else if(sObjectType == "3"){
			sObjectNo = getItemValue(0,getRow(),"OBJECTNO3");
			//sMsg = "请输入关联合作项目！";
		}
		/* if(sObjectNo == "" || sObjectNo == "null"){
			alert(sMsg);
			return ;
		} */
		var sDOSerialNo = getItemValue(0,getRow(),"SERIALNO");
		//返回变量：
		self.returnValue = sDOSerialNo + "@" + sObjectType + "@" + sObjectNo;
		self.close();
		OpenPage("/DocManage/Doc2Manage/Doc2BPManage/Doc2BeforPigeonholeManageList.jsp", "_self");
	}
	//选择响应
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
	
	//选择关联流水号
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
		//获得客户编号、客户名称
        var sColName = "CustomerID@CustomerName";
		sTableName = "Business_apply";
		var sWhereClause = "String@SERIALNO@"+sObjectNo;
		
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		
		var sSql = "select customername from " + sTableName + "  where serialNo='"+sSerialNo+"'";
		var sReturnValue = RunMethod("PublicMethod","RunSql",sSql);
		if(sReturn != 1){
			alert("查询失败！");
		}else{
			document.getElementById("customerName").value = sReturnValue;
		}
		var sDocType = trim(document.getElementById("DocType").value);
		alert(sDocType);
	}
	//返回变量：
	//self.returnValue = sDocCL + "@" + sDocType + "@";
	//self.close();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
