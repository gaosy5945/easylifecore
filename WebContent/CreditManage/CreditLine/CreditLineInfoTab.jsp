<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  gfTang 20140429 ALS743����
		Tester:
		Content: Ϊ�˼���als6.5������,��ʹ��als6.6+�е�tabCompent
		Input Param:
		Output param:
	ҳ��˵���� ͨ�����鶨������Tab���ҳ��ʾ��
	//��ȡҳ�����
	 */
	%>
<%/*~END~*/%>


		<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
<script type="text/javascript">
		//����tab���飺
		var tabstrip = new Array();
	//������0.�Ƿ���ʾ, 1.���⣬2.URL��3��������
	<%
	String serialNo = CurPage.getParameter("SerialNo");//��Ŀ��ˮ��
	String customerID = CurPage.getParameter("CustomerID");//�ͻ����
	String isShow = CurPage.getParameter("isShow");//�ͻ�����TABҳ�Ƿ���ʾ
	String sTabStrip[][] = {
		{"true", "ҵ������", "doTabAction('ViewInfo')"},
		{"true", "���Ŷ������ҵ��", "doTabAction('ViewSub')"},
		{"true", "���ʹ�ò�ѯ", "doTabAction('ViewUse')"},
		{isShow, "�ͻ�����", "doTabAction('ViewCust')"}
	};
		
	//���ݶ��������� tab
	out.println(HTMLTab.genTabArray(sTabStrip,"tab_AuthorInfo","document.all('tabtd')"));
	
	String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
	String sTabHeadStyle = "";
	String sTabHeadText = "<br>";
	String sTopRight = "";
	String sTabID = "tabtd";
	String sIframeName = "TabContentFrame";
	String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=���ڴ�ҳ�棬���Ժ�";
	String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=yes";

	%>

</script>
<%/*~END~*/%>
<%-- <%@ include file="/Resources/CodeParts/Tab01.jsp"%> --%>
<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
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

<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��]~*/%>
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
<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
<script type="text/javascript">
	//��������Ϊ�� tab��ID,tab��������,Ĭ����ʾ�ڼ���,Ŀ�굥Ԫ��
	hc_drawTabToTable("tab_AuthorInfo",tabstrip,"1",document.all('<%=sTabID%>'));
	//�趨Ĭ��ҳ��
	<%=sTabStrip[0][2]%>	
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>