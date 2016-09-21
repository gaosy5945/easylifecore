<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "客户情况分析"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null ) sCustomerID = "";
	
	//获得页面参数	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sEditRight = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sSerialNo == null ) sSerialNo = "";
	if(sEditRight == null) sEditRight = "";
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "CustomerAnalyseInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	if(sEditRight.equals("01")){
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{(sEditRight.equals("02")?"true":"false"),"All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回列表页面","goBack()","","","",""}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		//录入数据有效性检查
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		OpenPage("/CustomerManage/EntManage/CustomerAnalyseList.jsp","_self","");
	}
	
	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		OpenPage("/CustomerManage/EntManage/CustomerAnalyseInfo.jsp","_self","");
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"CUSTOMERID","<%=sCustomerID%>");
			setItemValue(0,0,"ANALYSISTYPE","EntAnalysis");
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"USERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"ORGID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"USERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"ORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() {
		var sTableName = "CUSTOMER_ANARECORD";//表名
		var sColumnName = "SERIALNO";//字段名
		var sPrefix = "";//前缀
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>