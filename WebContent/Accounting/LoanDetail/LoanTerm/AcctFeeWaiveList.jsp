<%@ page contentType="text/html; charset=GBK"%>
<%-- <%@include file="/IncludeBegin.jsp"%> --%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
  
<%
	String PG_TITLE = "费用减免列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String businessType = "";
	String projectVersion = "";
	
	//获得组件参数	
	
	//获得页面参数
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	String status = CurPage.getParameter("Status");//状态
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";

	//显示模版编号
	String sTempletNo = "AcctFeeWaiveList";
	String sTempletFilter = "1=1";
	
	//ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,"");
	//doTemp.WhereClause += " and Status in('"+status.replaceAll("@","','")+"')";
	doTemp.appendJboWhere(" and Status in('"+status.replaceAll("@","','")+"')");
	//ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp, request);
	dwTemp.Style = "1"; //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	//Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sObjectType);
	//for(int i=0;i < vTemp.size();i++)out.print((String) vTemp.get(i));
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);
	

	String sButtons[][] = {
			{"true", "All", "Button", "新增", "新增一条信息","createRecord()",""},
			{"true", "", "Button", "详情", "费用详情","viewFee()",""},
			{"true", "All", "Button", "删除", "删除一条信息","deleteRecord()",""},
	};
%>
<%-- <%@ include file="/Resources/CodeParts/List05.jsp"%> --%>
<%@include file="/Frame/resources/include/ui/include_list.jspf" %>
<script language=javascript>
	/*~[Describe=新增;InputParam=无;OutPutParam=无;]~*/
	function createRecord(){
		OpenPage("/Accounting/LoanDetail/LoanTerm/AcctFeeWaiveInfo.jsp","_self","");
	}
	
	function viewFee(){
		var SerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(SerialNo)=="undefined"||SerialNo.length==0){
			alert("请选择一条记录");
			return;
		}
		OpenPage("/Accounting/LoanDetail/LoanTerm/AcctFeeWaiveInfo.jsp?SerialNo="+SerialNo,"_self","");
	}
	
	/*~[Describe=删除;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		setNoCheckRequired(0);  //先设置所有必输项都不检查
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("确定删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}	
	
	//初始化
	/* AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0'); */
</script>
<%/*~END~*/%>

<%-- <%@include file="/IncludeEnd.jsp"%> --%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>