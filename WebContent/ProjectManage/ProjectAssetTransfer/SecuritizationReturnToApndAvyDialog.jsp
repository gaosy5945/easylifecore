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
		Author: ������ 2014-12-04 
		Tester:
		Describe: ������������ӿڵ��˻�ѡ���
	 */
%>
<%/*~END~*/%> 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<% 
	if(CurComp.getTargetWindow() == null) CurComp.setTargetWindow("");
	//��ȡ������������ˮ��
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");//���ϸ�ҳ��õ������������ˮ��
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
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=����ѡ���ύ����������;]~*/%>
<HEAD>
<title>�˻�</title>
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
			<td width="50%" align="right"><%=new Button("�˻�","ȷ���˻�","javascript:commitAction();","","btn_icon_Submit","").getHtmlText()%></td>	
			<td width="50%" align="center"><%=new Button("����","�����˻�","javascript:doCancel();","","btn_icon_delete","").getHtmlText()%></td>
		</tr>
	</table>
</div> 
<div id="opinionset">
	<div style="margin-top:10px;margin-left:15px;font-size:12px;">
		<font color="#000000"><b>��ѡ����һ�׶��˻ض�����</b></font>
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
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">		
 	<%out.println(sb.toString());%>  
 	var taskSerialNo = "<%=taskSerialNo%>";
	/*~[Describe=ȡ���ύ;InputParam=��;OutPutParam=��;]~*/
	function doCancel(){
		if(confirm("��ȷ��Ҫ�����˴��˻���")){
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
	
	/*~[Describe=�˻�����;InputParam=��;OutPutParam=��;]~*/
	function commitAction(){
		var phaseOpinion = "";
		phaseOpinion = $("input[name='phaseopinion']:checked").val();	
		var avyDfnId = phaseOpinion;
		if(typeof(avyDfnId) == "undefined" || avyDfnId.length == 0)
		{
			alert("��ѡ���˻ؽڵ㣡");
			return;
		}
		if (confirm("ȷ���˻ظ�������")){
			//�����˻ص�ָ����ӿ�
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