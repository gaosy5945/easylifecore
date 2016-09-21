<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:文档基本信息
		Input Param:
		     ObjectNo: 对象编号
             ObjectType: 对象类型
             DocNo: 文档编号
	 */
	String PG_TITLE = "文档基本信息";
	//定义变量
	String sObjectNo = "";//--对象编号
	//获得组件参数
	String sObjectType = CurPage.getParameter("ObjectType");
	String sRightType = CurPage.getParameter("RightType");//权限
	if(sRightType == null) sRightType = "";
	if(sObjectType == null) sObjectType = "";
	if(sObjectType.equals("Customer"))
	 	sObjectNo = CurPage.getParameter("CustomerID");
	else
		sObjectNo=  CurPage.getParameter("ObjectNo");
	if(sObjectNo == null) sObjectNo = "";
	//获得页面参数，文档编号和文档录入人ID
	String sDocNo = CurPage.getParameter("DocNo");
	String sUserID = CurPage.getParameter("UserID");
	if(sDocNo == null) sDocNo = "";
	if(sUserID == null) sUserID = "";

	ASDataObject doTemp = new ASDataObject("DocumentInfo",Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	//dwTemp.setEvent("AfterInsert","!DocumentManage.InsertDocRelative(#DocNo,"+sObjectType+","+sObjectNo+")");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDocNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{(CurUser.getUserID().equals(sUserID)?"true":"false"),"","Button","保存","保存所有修改","saveRecord()","","","",""},
		{(CurUser.getUserID().equals(sUserID)?"true":"false"),"","Button","查看/修改附件","查看/修改选中文档相关的所有附件","viewAndEdit_attachment()","","","",""},
		{"true","","Button","返回","返回列表页面","goBack()","","","",""}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	function saveRecord(sPostEvents){
		//录入数据有效性检查
		if (!ValidityCheck()) return;
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	<%/*~[Describe=查看附件详情;]~*/%>
	function viewAndEdit_attachment(){
		var sDocNo = getItemValue(0,getRow(),"DocNo");
		var sUserID = getItemValue(0,getRow(),"UserID");//取录入人ID
		var sRightType="<%=sRightType%>";
		if (typeof(sDocNo)=="undefined" || sDocNo.length==0){
        	alert("请先保存文档内容，再上传附件！");  //请选择一条记录！
			return;
    	}else{
    		//popComp("AttachmentList","/AppConfig/Document/AttachmentList.jsp","DocNo="+sDocNo+"&UserID="+sUserID+"&RightType="+sRightType);
			AsControl.PopView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo+"&UserID="+sUserID+"&RightType="+sRightType, "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    		reloadSelf();
		}
	}

	function goBack(){
		OpenPage("/RecoveryManage/Common/Document/DocumentList.jsp","_self","");
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		setItemValue(0,getRow(),"DocNo",getSerialNo("DOC_LIBRARY","DocNo"));
		bIsInsert = false;
	}

	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=有效性检查;通过true,否则false;]~*/
	function ValidityCheck(){
		//校验编制日期是否大于当前日期
		var sDocDate = getItemValue(0,0,"DocDate");//编制日期
		sToday = "<%=StringFunction.getToday()%>";//当前日期
		if(typeof(sDocDate) != "undefined" && sDocDate != "" ){
			if(sDocDate > sToday){
				alert(getBusinessMessage('161'));//编制日期必须早于当前日期！
				return false;
			}
		}
		return true;
	}

	function initRow(){
		if (getRowCount(0) == 0){
			as_add("myiframe0");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"DocImportance","01");
			setItemValue(0,0,"DocDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>