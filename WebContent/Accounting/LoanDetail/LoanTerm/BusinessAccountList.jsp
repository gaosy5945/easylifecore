<%@page import="com.amarsoft.app.base.businessobject.BusinessObjectManager"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObject"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
  
<%
	String PG_TITLE = "账户信息管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String businessType = "";
	String projectVersion = "";
	
	//获得组件参数	
	
	//获得页面参数
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	String status = CurPage.getParameter("Status");
	String right=CurPage.getParameter("RightType");
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(status == null) status = "";
	
	//显示模版编号
	String sTempletNo = "BusinessAccountList";
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	String statusStr = status.replaceAll("@","','");
	doTemp.appendJboWhere(" and Status in('"+statusStr+"')");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style = "1"; //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);
	
	

	String sButtons[][] = {
			{"true", "All", "Button", "新增放款帐号", "新增一条放款帐号信息","createRecord('00')",""},
			{"true", "All", "Button", "新增还款帐号", "新增一条还款帐号信息","createRecord('01')",""},
			{"true", "All", "Button", "新增其他帐号", "新增一条其他帐号信息","createRecord('99')",""},
			{"true", "", "Button", "详情", "账号详情","viewRecord()",""},
			{"true", "All", "Button", "删除", "删除一条信息","deleteRecord()",""},
	};
	if("ReadOnly".equals(right)||sObjectType.equals("PutOutApply")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
		sButtons[4][0]="false";
	}
	if(sObjectType.equals("jbo.acct.ACCT_LOAN_CHANGE" )){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script language=javascript>
	/*~[Describe=新增;InputParam=无;OutPutParam=无;]~*/
	function createRecord(AccountIndicator){
		OpenPage("/Accounting/LoanDetail/LoanTerm/BusinessAccountInfo.jsp?Status=<%=status%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&AccountIndicator="+AccountIndicator,"_self","");
		//reloadSelf();
		}
	
	function viewRecord(){
		var SerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(SerialNo)=="undefined"||SerialNo.length==0){
			alert("请选择一条记录");
			return;
		}
		OpenPage("/Accounting/LoanDetail/LoanTerm/BusinessAccountInfo.jsp?Status=<%=status%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&SerialNo="+SerialNo,"_self","");
	}
	
	/*~[Describe=删除;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		if(confirm("确定删除该信息吗？")){
			as_delete("myiframe0");
		}
	}
	//初始化
// 	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>