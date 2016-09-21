<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@ include file="/Accounting/include_accounting.jspf"%>
<%
	String PG_TITLE = "台帐信息管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String businessType = "";
	String projectVersion = "";
	
	//获得组件参数	
	
	//获得页面参数
	String sObjectNo = CurPage.getParameter("ObjectNo");
	if(sObjectNo == null) sObjectNo = "";
	
	//显示模版编号
	String sTempletNo = "AcctLoanList";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sObjectNo);
	
	String sButtons[][] = {
			{"true", "", "Button", "详情", "详情","viewRecord()","","","","btn_icon_detail",""},
	};
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>

<script type="text/javascript">
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else 
		{
			OpenComp("AcctLoanView","/Accounting/LoanDetail/AcctLoanView.jsp","ObjectNo="+sSerialNo+"&ObjectType=<%=BUSINESSOBJECT_CONSTANTS.loan%>"+"&RightType=ReadOnly","_blank","");				
		}
	}
</script>


<script language=javascript>
	//初始化
</script>
<%
/*~END~*/
%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
