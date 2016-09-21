<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  gfTang 20140429 ALS743升级
		Tester:
		Content: 为了兼容als6.5及以下,不使用als6.6+中的tabCompent
		Input Param:
		Output param:
	页面说明： 通过数组定义生成Tab框架页面示例
	//获取页面参数
	 */
	%>
<%/*~END~*/%>


		<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
<script type="text/javascript">
		//定义tab数组：
		var tabstrip = new Array();
	//参数：0.是否显示, 1.标题，2.URL，3，参数串
	<%
	String serialNo = CurPage.getParameter("SerialNo");//项目流水号
	String customerID = CurPage.getParameter("CustomerID");//客户编号
	String isShow = CurPage.getParameter("isShow");//客户详情TAB页是否显示
	String sTabStrip[][] = {
		{"true", "业务详情", "doTabAction('ViewInfo')"},
		{"true", "授信额度项下业务", "doTabAction('ViewSub')"},
		{"true", "额度使用查询", "doTabAction('ViewUse')"},
		{isShow, "客户详情", "doTabAction('ViewCust')"}
	};
		
	//根据定义组生成 tab
	out.println(HTMLTab.genTabArray(sTabStrip,"tab_AuthorInfo","document.all('tabtd')"));
	
	String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
	String sTabHeadStyle = "";
	String sTabHeadText = "<br>";
	String sTopRight = "";
	String sTabID = "tabtd";
	String sIframeName = "TabContentFrame";
	String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=正在打开页面，请稍候";
	String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=yes";

	%>

</script>
<%/*~END~*/%>
<%-- <%@ include file="/Resources/CodeParts/Tab01.jsp"%> --%>
<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
<script type="text/javascript">

	function doTabAction(sparam)
  	{
		if(sparam=="ViewInfo")
			OpenComp("ObjectViewer","/Frame/ObjectViewer.jsp","ObjectType=BusinessContract&ObjectNo=<%=serialNo%>&ViewID=002","<%=sIframeName%>");
		else if(sparam=="ViewSub")
			OpenComp("lineSubList","/CreditManage/CreditLine/lineSubList.jsp","LineNo=<%=serialNo%>","<%=sIframeName%>");
		else if(sparam=="ViewUse")
			OpenComp("CreditLineUseList","/CreditManage/CreditLine/CreditLineUseList.jsp","SerialNo=<%=serialNo%>","<%=sIframeName%>");
		else if(sparam=="ViewCust")
			OpenComp("ObjectViewer","/Frame/ObjectViewer.jsp","ObjectType=Customer&ObjectNo=<%=customerID%>&ViewID=001","<%=sIframeName%>");
  	}
</script>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面]~*/%>
<html>
<head>
<title></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
		<tr>
  			<td valign="top" id="mymiddleShadow" class="mymiddleShadow"></td>
		</tr>
   		<tr>
			<td valign="top" bgcolor="#E0ECFF">
				<%@include file="/Resources/CodeParts/Tab04.jsp"%>
			</td>
		</tr>
	</table>
</body>
</html>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
<script type="text/javascript">
	//参数依次为： tab的ID,tab定义数组,默认显示第几项,目标单元格
	hc_drawTabToTable("tab_AuthorInfo",tabstrip,"1",document.all('<%=sTabID%>'));
	//设定默认页面
	<%=sTabStrip[0][2]%>	
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>