 <%@page import="com.amarsoft.app.als.sys.function.model.FunctionWebTools"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   cjyu   2014��5��15��17:06:51 
	Content:  ҵ���������
	Input Param:
 
 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = CurPage.getParameter("ComponentName"); // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = CurPage.getParameter("PG_CONTENT_TITLE"); //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%> 

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������
	String functionID = CurPage.getParameter("SYS_FUNCTIONID");
	String parameters=FunctionWebTools.getPageStringParmeters(CurPage);
	parameters+="&SYS_FUNCTIONID="+functionID;
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%
 
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
	
<script type="text/javascript"> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/

	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
 
		
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script type="text/javascript"> 
		myleft.width=1; 
		AsControl.OpenPage("/AppMain/resources/widget/FunctionView.jsp","<%=parameters%>","right");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
	