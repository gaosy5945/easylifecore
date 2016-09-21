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
		Author: 张万亮 2014-12-04 
		Tester:
		Describe: 调用流程引擎接口的退回选择框
	 */
%>
<%/*~END~*/%> 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<% 
	if(CurComp.getTargetWindow() == null) CurComp.setTargetWindow("");
	//获取参数：任务流水号
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");//从上个页面得到传入的任务流水号
	String flowSerialNo = CurPage.getParameter("FlowSerialNo");
	String phaseNo = CurPage.getParameter("PhaseNo");
	
	OCITransaction trans = BPMPInstance.AvlRetAvyListQry(taskSerialNo, Sqlca.getConnection());
	Message res = trans.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage();
	List<Message> imessage = res.getFieldByTag("Activities").getFieldArrayValue();
	
	String[] phaseOpinion = null;
	StringBuffer sb = new StringBuffer();
	if(imessage!=null)
	{
		phaseOpinion = new String[imessage.size()];
		sb.append("var phases = new Array();\n");
		for(int i = 0; i < imessage.size() ; i ++)
		{
			Message message = imessage.get(i);
			phaseOpinion[i] = message.getFieldValue("AvyDfnName")+"@"+message.getFieldValue("AvyDfnId")+"@"+message.getFieldValue("AvyDfnType");
		}
	}
	
	if(phaseOpinion == null){
		phaseOpinion = new String[0];
	}
%>
<%/*~END~*/%>	
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义选择提交动作界面风格;]~*/%>
<HEAD>
<title>退回</title>
</HEAD>
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
<div>
	<table>
		<tr>
			<td width="50%" align="right"><%=new Button("退回","确认退回","javascript:commitAction();","","btn_icon_Submit","").getHtmlText()%></td>	
			<td width="50%" align="center"><%=new Button("放弃","放弃退回","javascript:doCancel();","","btn_icon_delete","").getHtmlText()%></td>
		</tr>
	</table>
</div> 
<div id="opinionset">
	<div style="margin-top:10px;margin-left:15px;font-size:12px;">
		<font color="#000000"><b>请选择下一阶段退回动作：</b></font>
	</div>
	<div style="margin-top:10px;margin-left:10px;font-size:12px;border:1px solid lightgray;padding:10px;">
		<%
		for(int i=0;i<phaseOpinion.length;i++){
			if("manual".equals(phaseOpinion[i].split("@")[2])){
				out.println("<a class='opinion-style2' href='javascript:void(0)' onclick='doActionList(this)'><input type='radio' name='phaseopinion' value='"+phaseOpinion[i].split("@")[1]+"' >"+phaseOpinion[i].split("@")[0]+"</input></a>");
			}
		}
		%>
	</div>
</div>
<div id="actionset"></div>
<div>
	<table width="100%" align="center">
	    <tr>
			<td align="center"><b><span id="phaseinfo" style="color: #FF0000" ></span></b></td>
		</tr>
	</table>
</div>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">		
 	<%out.println(sb.toString());%>  
 	var taskSerialNo = "<%=taskSerialNo%>";
	/*~[Describe=取消提交;InputParam=无;OutPutParam=无;]~*/
	function doCancel(){
		if(confirm("您确定要放弃此次退回吗？")){
			top.returnValue = "_CANCEL_";
			top.close();
		}
	}
	
	function doActionList(obj){
		$(obj).siblings().removeClass("opinion-focus");
		$(obj).addClass("opinion-focus");
		var phaseOpinion = $(obj).find("input").val();
		$(obj).find("input").prop("checked","true");
	}
	
	/*~[Describe=退回任务;InputParam=无;OutPutParam=无;]~*/
	function commitAction(){
		var phaseOpinion = "";
		phaseOpinion = $("input[name='phaseopinion']:checked").val();	
		var avyDfnId = phaseOpinion;
		if(typeof(avyDfnId) == "undefined" || avyDfnId.length == 0)
		{
			alert("请选择退回节点！");
			return;
		}
		if (confirm("确定退回该任务吗？")){
			//调用退回到指定活动接口
			AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.ProjectReturnChangeStatus","updateStatus","FlowSerialNo="+'<%=flowSerialNo%>'+",PhaseOpinion="+phaseOpinion);
			var returnValue = AsControl.RunASMethod("WorkFlowEngine","ReturnToApndAvy","<%=taskSerialNo%>,<%=flowSerialNo%>,<%=phaseNo%>,"+avyDfnId+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>");
			if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
			alert(returnValue.split("@")[1]);
			top.returnValue = returnValue;
			top.close();
		}
	}
</script>
<%/*~END~*/%>
<%@include file="/Frame/resources/include/include_end.jspf"%>