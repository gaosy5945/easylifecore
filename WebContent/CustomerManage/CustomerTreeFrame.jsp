<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
<%
/*
	Author:  --jqcao 2013.11
	Tester:
	Content: --�ͻ�������ͼ����
	Input Param:
		  ObjectNo  ��--�ͻ���
	Output param:
		               
	History Log: 
	
 */
%>
<%/*~END~*/%>
<%
	 //���ҳ�����
	 String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
%>


<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	mytoptd.height=500;
	var param = "ObjectNo=<%=sObjectNo%>";
	AsControl.OpenView("/CustomerManage/CustomerInfoTreeFrame.jsp", param, "rightup","");
	AsControl.OpenView("/CustomerManage/CustomerImageTreeFrame.jsp", param, "rightdown","");
</script>	
<%@ include file="/IncludeEnd.jsp"%>
