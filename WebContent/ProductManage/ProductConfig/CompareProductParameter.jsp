<%@ page contentType="text/html; charset=GBK"%>
<%@include file="/Frame/resources/include/include_begin.jspf"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
<%
	/*
		Author: bhxiao 
		Tester:
		Describe: ��Ʒ�����Ƚ�
		Input Param:
			SerialNo��������ˮ��
		Output Param:
		
			
	 */
%>
<%/*~END~*/%> 


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<% 
	//��ȡ������������ˮ��
	String compareType = CurPage.getParameter("CompareType");//���ϸ�ҳ��õ������������ˮ��
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


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=����ѡ���ύ����������;]~*/%>

	<table width=1000px height=800px>
		<tr width="100%" height="100%">
			<td width="50%" height="100%"><div id="left" width="100%" height="100%"></div></td>	
			<td width="50%" height="100%"><div id="right" width="100%" height="100%"></div></td>
		</tr>
	</table>


<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
if("Product"=="<%=compareType%>")
{
	productid1 = "<%=productid1%>";
	productid2 = "<%=productid2%>";
	versionserialno1 = "<%=versionserialno1%>";
	versionserialno2 = "<%=versionserialno2%>";
	//left.innerHTML="<iframe width='100%' height='100%' src='"+sWebRootPath +"/Redirector?OpenerClientID=&ComponentURL=/AppMain/resources/widget/FunctionView.jsp&SYS_FUNCTIONID=PRD_ProductView_BySFSerialNo&ProductID="+productid1 +"&SpecificSerialNo="+versionserialno1 +"&AlwaysShowFlag=1&PageStyle=&RightType=ReadOnly' frameboder='no'>";//ֻ�Ƚϲ���
	//right.innerHTML="<iframe width='100%' height='100%' src='"+sWebRootPath +"/Redirector?OpenerClientID=&ComponentURL=/AppMain/resources/widget/FunctionView.jsp&SYS_FUNCTIONID=PRD_ProductView_BySFSerialNo&ProductID="+productid2 +"&SpecificSerialNo="+versionserialno2 +"&AlwaysShowFlag=1&PageStyle=&RightType=ReadOnly' frameboder='no'>";//ֻ�Ƚϲ���
	left.innerHTML="<iframe width='100%' height='100%' src='"+sWebRootPath +"/Redirector?OpenerClientID=&ComponentURL=/AppMain/resources/widget/FunctionView.jsp&ProductID="+productid1 +"&SYS_FUNCTIONID=PRD_CompareProductView&RightType=ReadOnly' frameboder='no'>";//�Ƚϲ�Ʒ������Ϣ
	right.innerHTML="<iframe width='100%' height='100%' src='"+sWebRootPath +"/Redirector?OpenerClientID=&ComponentURL=/AppMain/resources/widget/FunctionView.jsp&ProductID="+productid2 +"&SYS_FUNCTIONID=PRD_CompareProductView&RightType=ReadOnly' frameboder='no'>";//�Ƚϲ�Ʒ������Ϣ

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