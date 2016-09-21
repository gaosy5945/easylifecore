<%@page import="com.amarsoft.app.base.businessobject.BusinessObjectManager"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObject"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
  
<%
	String PG_TITLE = "账户信息管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String businessType = "";
	String projectVersion = "";
	
	//获得页面参数
	String SerialNo = CurPage.getParameter("SerialNo");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	String sStatus = CurPage.getParameter("Status");
	String sAccountIndicator = CurPage.getParameter("AccountIndicator");
	String right=CurPage.getParameter("RightType");
	if(SerialNo == null) SerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sStatus == null) sStatus = "";
	
	//显示模版编号
	String sTempletNo = "BusinessAccountInfo";
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
	if("00".equals(sAccountIndicator) || "01".equals(sAccountIndicator) || !"".equals(SerialNo))
		doTemp.setReadOnly("AccountIndicator",true);
	else if("99".equals(sAccountIndicator))
		doTemp.setDDDWJbo("AccountIndicator", "select itemno,itemname from code_library where codeno = 'AccountIndicator' and itemno in('02','03','04')");
	if("00".equals(sAccountIndicator) || "99".equals(sAccountIndicator) || !"".equals(SerialNo)){
		doTemp.setVisible("PriorityFlag",false);
		doTemp.setDefaultValue("PriorityFlag","1");
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style = "2"; //设置DW风格 1:Grid 2:Freeform
	if("ReadOnly".equals(right)||sObjectType.equals("PutOutApply")){
		dwTemp.ReadOnly = "1";
	}else{
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	}
	dwTemp.genHTMLObjectWindow(SerialNo);
	

	String sButtons[][] = {
			{"true", "", "Button", "保存", "新增一条信息","saveRecord()",""},
			{"true", "", "Button", "返回", "返回","goBack()",""},
	};
	if("ReadOnly".equals(right)||sObjectType.equals("PutOutApply")){
		sButtons[0][1]="false";
	}
%>
	<%@include file="/Frame/resources/include/ui/include_info.jspf"%>

<script language=javascript>
	var coreCheckFlag = false;
	//保存
	function saveRecord(){
		if(bIsInsert){
			beforeInsert();
		}else
		//账户性质 如果为放款账户则为多个可以保存如果为其他账户性质则只能保存一次再次出现则不能保存
		var status = getItemValue(0,getRow(),"Status");
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var returnValue = RunJavaMethodTrans("com.amarsoft.acct.accounting.web.DistinctAccount","getAccountNumber","objectNo="+"<%=sObjectNo%>,objectType=<%=sObjectType%>,accountIndicator="+getItemValue(0,0,'AccountIndicator')+",serialNo="+serialNo);
		if(typeof(returnValue)!="undifined"&& returnValue!="fasle"&&parseInt(returnValue)>=1){
			alert("该账户性质已存在");
			return;
		}else
			as_save("myiframe0","goBack();");
	}
	//返回
	function goBack(){
		OpenPage("/Accounting/LoanDetail/LoanTerm/BusinessAccountList.jsp?Status=<%=sStatus%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","_self","");
	}
	
	/*~[Describe=执行新增操作前初始化流水号;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "ACCT_BUSINESS_ACCOUNT";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀	
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=页面装载时，对OW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"Status","0");
			bIsInsert = true;
			if("<%=sAccountIndicator%>" == "00")
				setItemValue(0,0,"AccountIndicator","00");
			else if("<%=sAccountIndicator%>" == "01")
				setItemValue(0,0,"AccountIndicator","01");
		}else{
			bIsInsert = false;
		}
	}
	//改变账户性质引发其他选项的改变
	function changeAccountIndicator(){
		var sResult = getItemValue(0,getRow(),"AccountIndicator");
		if("00"==sResult){
			setItemDisabled(0,getRow(),"PRI",false);
			return;
		}else{
			setItemValue(0,0,"PRI","1");
			setItemDisabled(0,getRow(),"PRI",true);
			return;
		}
	}
		
</script>

<script language=javascript>
	//初始化
	var bFreeFormMultiCol = true;
	var bIsInsert = true;
	my_load(2,0,'myiframe0');
	initRow();
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>