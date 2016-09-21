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


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
<%
	/*
		Author: wlzhag 2015-09-01
		Describe: 自定义Confirm提示框
		Input Param:
			Message：提示信息
			Sure：确定按钮名称
			Cancel：取消按钮名称
		Output Param:
	 */
%>
<%/*~END~*/%> 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<% 
	if(CurComp.getTargetWindow() == null) CurComp.setTargetWindow("");
	String Message = CurPage.getParameter("Message");
	if(Message == null) Message = "";
	String Sure = CurPage.getParameter("Sure");
	if(Sure == null || "".equals(Sure)) Sure = "确定";
	String Cancel = CurPage.getParameter("Cancel");
	if(Cancel == null || "".equals(Cancel)) Cancel = "取消";
%>
<HEAD>
</HEAD>
<%/*~END~*/%>	
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义选择提交动作界面风格;]~*/%>
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
		<td width="70%" align="right"><%=new Button(Sure,"确认","javascript:sure();","","","").getHtmlText()%></td>	
		<td width="70%" align="center"><%=new Button(Cancel,"取消","javascript:doCancel();","","","").getHtmlText()%></td>
	</tr>
</table>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
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