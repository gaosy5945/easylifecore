<%@ page contentType="text/html; charset=GBK"%>
<%@include file="/Frame/resources/include/include_begin.jspf"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
<%
	/*
		Author: bhxiao 
		Tester:
		Describe: 产品参数比较
		Input Param:
			SerialNo：任务流水号
		Output Param:
		
			
	 */
%>
<%/*~END~*/%> 


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<% 
	//获取参数：任务流水号
	String compareType = CurPage.getParameter("CompareType");//从上个页面得到传入的任务流水号
	String productIDList = CurPage.getParameter("ProductIDList");
	String versionIDList = CurPage.getParameter("VersionIDList");
	String productID = CurPage.getParameter("ProductID");
	
	String productid1="",productid2="",versionserialno1="",versionserialno2="";
	if("Product".equals(compareType))
	{
		String [] productlist = productIDList.split("@", -1);
		productid1=productlist[0];
		productid2=productlist[1];
		
		versionserialno1 = Sqlca.getString("select serialno from prd_specific_library  where productid='"+productid1+"' and status='1'");
		versionserialno2 = Sqlca.getString("select serialno from prd_specific_library  where productid='"+productid2+"' and status='1'");
		
	}else if("Version".equals(compareType))
	{
		String [] versionlist = versionIDList.split("@", -1);
		versionserialno1=versionlist[0];
		versionserialno2=versionlist[1];
	}
%>
<%/*~END~*/%>	


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义选择提交动作界面风格;]~*/%>

	<table width=1000px height=800px>
		<tr width="100%" height="100%">
			<td width="50%" height="100%"><div id="left" width="100%" height="100%"></div></td>	
			<td width="50%" height="100%"><div id="right" width="100%" height="100%"></div></td>
		</tr>
	</table>


<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">
if("Product"=="<%=compareType%>")
{
	productid1 = "<%=productid1%>";
	productid2 = "<%=productid2%>";
	versionserialno1 = "<%=versionserialno1%>";
	versionserialno2 = "<%=versionserialno2%>";
	//left.innerHTML="<iframe width='100%' height='100%' src='"+sWebRootPath +"/Redirector?OpenerClientID=&ComponentURL=/AppMain/resources/widget/FunctionView.jsp&SYS_FUNCTIONID=PRD_ProductView_BySFSerialNo&ProductID="+productid1 +"&SpecificSerialNo="+versionserialno1 +"&AlwaysShowFlag=1&PageStyle=&RightType=ReadOnly' frameboder='no'>";//只比较参数
	//right.innerHTML="<iframe width='100%' height='100%' src='"+sWebRootPath +"/Redirector?OpenerClientID=&ComponentURL=/AppMain/resources/widget/FunctionView.jsp&SYS_FUNCTIONID=PRD_ProductView_BySFSerialNo&ProductID="+productid2 +"&SpecificSerialNo="+versionserialno2 +"&AlwaysShowFlag=1&PageStyle=&RightType=ReadOnly' frameboder='no'>";//只比较参数
	left.innerHTML="<iframe width='100%' height='100%' src='"+sWebRootPath +"/Redirector?OpenerClientID=&ComponentURL=/AppMain/resources/widget/FunctionView.jsp&ProductID="+productid1 +"&SYS_FUNCTIONID=PRD_CompareProductView&RightType=ReadOnly' frameboder='no'>";//比较产品基本信息
	right.innerHTML="<iframe width='100%' height='100%' src='"+sWebRootPath +"/Redirector?OpenerClientID=&ComponentURL=/AppMain/resources/widget/FunctionView.jsp&ProductID="+productid2 +"&SYS_FUNCTIONID=PRD_CompareProductView&RightType=ReadOnly' frameboder='no'>";//比较产品基本信息

}
else if("Version"=="<%=compareType%>")
{
	productid = "<%=productID%>";
	versionserialno1 = "<%=versionserialno1%>";
	versionserialno2 = "<%=versionserialno2%>";
	left.innerHTML="<iframe width='100%' height='100%' src='"+sWebRootPath +"/Redirector?OpenerClientID=&ComponentURL=/AppMain/resources/widget/FunctionView.jsp&SYS_FUNCTIONID=PRD_ProductView_BySFSerialNo&ProductID="+productid +"&SpecificSerialNo="+versionserialno1 +"&AlwaysShowFlag=1&PageStyle=&RightType=ReadOnly' frameboder='no'>";
	right.innerHTML="<iframe width='100%' height='100%' src='"+sWebRootPath +"/Redirector?OpenerClientID=&ComponentURL=/AppMain/resources/widget/FunctionView.jsp&SYS_FUNCTIONID=PRD_ProductView_BySFSerialNo&ProductID="+productid +"&SpecificSerialNo="+versionserialno2 +"&AlwaysShowFlag=1&PageStyle=&RightType=ReadOnly' frameboder='no'>";
}

</script>
<%/*~END~*/%>
<%@include file="/Frame/resources/include/include_end.jspf"%>