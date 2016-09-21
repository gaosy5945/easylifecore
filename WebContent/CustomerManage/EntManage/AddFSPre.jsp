<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	/*
		Describe: 新增财务报表准备信息 本页面仅仅用于报表信息的新增操作
		Input Param:
			--CustomerID：当前客户编号
			--ModelClass: 模式类型
		Output Param:
			--CustomerID：当前客户编号
	 */
	String PG_TITLE = "报表说明"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
    String sCustomerID="";//--客户代码
    String sModelClass = "";//--模式类型
    String sSql = "";//--存放sql语句
    String sPassRight = "true";//--布尔型变量
	//获得组件参数，客户代码、模式类型
	sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID")); 
	sModelClass = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelClass")); 

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "AddFSPre";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//保存后进行财务报表的初始化操作
	dwTemp.setEvent("AfterInsert","!BusinessManage.InitFinanceReport(CustomerFS,#CustomerID,#ReportDate,#ReportScope,#RecordNo,ModelClass^'"+sModelClass+"',,AddNew,"+CurOrg.getOrgID()+","+CurUser.getUserID()+")");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","确定","确定","doCreation()","","","",""}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		//录入数据有效性检查
		sReportDate = getItemValue(0,0,"ReportDate");
		sReportScope = getItemValue(0,0,"ReportScope");
		if(sReportScope == '01')
			sReportScopeName = "合并";
		else if(sReportScope == '02')
			sReportScopeName = "本部";
		else
			sReportScopeName = "汇总";
		//如果需要可以进行保存前的权限判断
		sPassRight = PopPageAjax("/CustomerManage/EntManage/FinanceCanPassAjax.jsp?ReportDate="+sReportDate+"&ReportScope="+sReportScope,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		if(sPassRight=="pass"){
			var sTableName = "CUSTOMER_FSRECORD";//表名
			var sColumnName = "RecordNo";//字段名
			var sPrefix = "CFS";//前缀

			//获取流水号
			var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
			//将流水号置入对应字段
			setItemValue(0,0,"RecordNo",sSerialNo);
			as_save("myiframe0",sPostEvents);
		}else{
			alert(sReportDate +"月份的"+sReportScopeName+"口径财务报表已存在，请重新选择！");
		}
	}

	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function doCreation(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		var recordNo = getItemValue(0,getRow(),"RecordNo");
		var reportDate = getItemValue(0,getRow(),"ReportDate");
		var reportScope = getItemValue(0,getRow(),"ReportScope"); 
		
		top.returnValue= "ok@"+recordNo+"@"+reportDate+"@"+reportScope;  // modified by yzheng 2014-01-17
		top.close();  // modified by yzheng  2013-06-17
	}
	/*~[Describe=日期选择;InputParam=无;OutPutParam=无;]~*/
	function getMonth(sObject){
		sReturnMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=270px;dialogHeight=150px;center:yes;status:no;statusbar:no");
		if(typeof(sReturnMonth) != "undefined"){
			setItemValue(0,0,sObject,sReturnMonth);
		}
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"ReportStatus","01");
			setItemValue(0,0,"UserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>