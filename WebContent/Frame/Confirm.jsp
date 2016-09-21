<%@ page contentType="text/html; charset=GBK"%>
<%@include file="/Frame/resources/include/include_begin.jspf"%>
<%@page import="com.amarsoft.biz.workflow.*" %>
<%@page import="com.amarsoft.app.oci.bean.Message"%>
<%@page import="com.amarsoft.app.oci.bean.OCITransaction"%>
<%@page import="com.amarsoft.app.oci.instance.BPMPInstance"%>
<%@page import="com.amarsoft.dict.als.cache.CodeCache" %>
<%@page import="com.amarsoft.app.workflow.interdata.IData" %>
<%@page import="com.amarsoft.app.workflow.FlowDataHelper" %>
<%@page import="com.amarsoft.app.workflow.FlowHelper" %>
<%@page import="com.amarsoft.app.workflow.FlowConfig" %>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
<%
	/*
		Author: wlzhag 2015-09-01
		Describe: �Զ���Confirm��ʾ��
		Input Param:
			Message����ʾ��Ϣ
			Sure��ȷ����ť����
			Cancel��ȡ����ť����
		Output Param:
	 */
%>
<%/*~END~*/%> 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<% 
	if(CurComp.getTargetWindow() == null) CurComp.setTargetWindow("");
	String Message = CurPage.getParameter("Message");
	if(Message == null) Message = "";
	String Sure = CurPage.getParameter("Sure");
	if(Sure == null || "".equals(Sure)) Sure = "ȷ��";
	String Cancel = CurPage.getParameter("Cancel");
	if(Cancel == null || "".equals(Cancel)) Cancel = "ȡ��";
%>
<HEAD>
</HEAD>
<%/*~END~*/%>	
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=����ѡ���ύ����������;]~*/%>
<style>
	.opinion-style{
		width:100%;
		overflow:hidden;
		display:inline-block;
		margin-bottom:2px;
		outline:none;
	}
	.opinion-style2{
		overflow:hidden;
		display:inline-block;
		margin-bottom:2px;
		outline:none;
	}
	a.opinion-style:hover{
		background-color:A8CAE5;
		outline:none;
	}
	.opinion-focus{
		background-color:A8CAE5;
	}
</style>

<div style="margin-top:10px;margin-left:10px;font-size:12px;border:1px solid lightgray;padding:10px;">
	<%
		out.println(Message);
	%>
</div>
<table>
	<tr>
		<td width="70%" align="right"><%=new Button(Sure,"ȷ��","javascript:sure();","","","").getHtmlText()%></td>	
		<td width="70%" align="center"><%=new Button(Cancel,"ȡ��","javascript:doCancel();","","","").getHtmlText()%></td>
	</tr>
</table>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">		
	function sure(){
		top.returnValue = "true";
		top.close();
	}
	function doCancel(){
		top.returnValue = "false";
		top.close();
	}
</script>
<%/*~END~*/%>
<%@include file="/Frame/resources/include/include_end.jspf"%>