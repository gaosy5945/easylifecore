<%@ page contentType="text/html; charset=GBK"%>
<%@include file="/Frame/resources/include/include_begin.jspf"%>
<%@page import="com.amarsoft.dict.als.cache.CodeCache" %>
<%@page import="com.amarsoft.app.workflow.interdata.IData" %>
<%@page import="com.amarsoft.app.workflow.util.FlowHelper" %>
<%@page import="com.amarsoft.app.workflow.config.FlowConfig" %>
<%@page import="com.amarsoft.app.workflow.manager.FlowManager" %>
<%@page import="com.amarsoft.app.workflow.manager.impl.ALSFlowManager" %>


<% 
	//获取参数：任务流水号
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");//从上个页面得到传入的任务流水号
	String flowSerialNo = CurPage.getParameter("FlowSerialNo");
	String phaseNo = CurPage.getParameter("PhaseNo");
	
	
	
	List<BusinessObject> phaseOpinion = null;
	String ipmessage;
	String json="var json=";
	JBOTransaction tx = null;
	try{
		
		tx = JBOFactory.createJBOTransaction();
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		FlowManager fm = FlowManager.getFlowManager(bomanager);
		BusinessObject fi = fm.preSubmitTask(taskSerialNo, CurUser.getUserID(), CurUser.getOrgID());
		phaseOpinion = fi.getBusinessObjects("NextPhase");
		//获取下阶段任务
		json += fi.toJSONString();
		
	}catch(Exception e)
	{
		if(tx != null) tx.rollback();
		throw e;
	}finally{
		if(tx != null) tx.commit();
	}
	
	
%>
<HEAD>
<title>提交</title>
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
			<td width="50%" align="right"><%=new Button("提交","确认提交","javascript:commitAction();","","btn_icon_Submit","").getHtmlText()%></td>	
			<td width="50%" align="center"><%=new Button("放弃","放弃提交","javascript:doCancel();","","btn_icon_delete","").getHtmlText()%></td>
		</tr>
	</table>
</div> 
<div id="opinionset">
	<div style="margin-top:10px;margin-left:15px;font-size:12px;">
		<font color="#000000"><b>请选择下一阶段提交动作：</b></font>
	</div>
	<div style="margin-top:10px;margin-left:10px;font-size:12px;border:1px solid lightgray;padding:10px;">
		<%
		for(int i=0;i<phaseOpinion.size();i++){
			String check = "";
			if(phaseOpinion.size() == 1) check = "checked";
			out.println("<a class='opinion-style2' href='javascript:void(0)' onclick='doActionList(this)'><input type='radio' name='phaseopinion' value='"+phaseOpinion.get(i).getString("ID")+"@"+phaseOpinion.get(i).getString("Name")+"' "+check+" >"+phaseOpinion.get(i).getString("Name")+"</input></a>");
		}
		%>
	</div>
</div>
<div id="actionset">
		<%
		if(phaseOpinion.size() == 1)
		{
			List<BusinessObject> phases = phaseOpinion.get(0).getBusinessObjects("Phase");
			int i = 0;
			for(BusinessObject phase:phases)
			{
				int count = 1;
				String sCount = phase.getString("Count");
				try{count = phase.getInt("Count");}catch(Exception ex){}
				List<BusinessObject> phaseUsers = phase.getBusinessObjects("jbo.sys.USER_INFO");
				String str = "";
				
				String check = "";
				if(phaseUsers.size() == count)
				{
					check = "checked";
				}
				for(int j = 0; j < phaseUsers.size(); j ++)
				{
					if(count > 1 || "X".equalsIgnoreCase(sCount)) //多人审批
					{
						str += "<a class='opinion-style' href='javascript:void(0)' onclick='getNextPhaseInfo(this)'><input type='checkbox' onclick='return false;' "+check+" onmouseup='this.checked=!this.checked;' name='"+phase.getString("ID")+j+"' value='"+phaseUsers.get(j).getString("UserID")+"$"+phaseUsers.get(j).getString("BelongOrg")+"'>"+phaseUsers.get(j).getString("UserName")+"（"+phaseUsers.get(j).getString("UserID")+"）"+"</input></a>";
					}else
					{
						str += "<a class='opinion-style' href='javascript:void(0)' onclick='getNextPhaseInfo(this)'><input type='radio' onclick='return false;' "+check+" onmouseup='this.checked=!this.checked;' name='"+phase.getString("ID")+"' value='"+phaseUsers.get(j).getString("UserID")+"$"+phaseUsers.get(j).getString("BelongOrg")+"'>"+phaseUsers.get(j).getString("UserName")+"（"+phaseUsers.get(j).getString("UserID")+"）"+"</input></a>";
					}
				}
				
				i++;
				
				out.print("<div style='margin-top:10px;margin-left:15px;font-size:12px;'><font color='#000000'><b>请选择"+phase.getString("Name")+"用户：</b></font></div><div id='"+phase.getString("ID")+"action' style='margin-top:10px;margin-left:10px;font-size:12px;border:1px solid lightgray;padding:5px;'>"+str+"</div>");
			}
		}
		%>
</div>
<div>
	<table width="100%" align="center">
	    <tr>
			<td align="center"><b><span id="phaseinfo" style="color: #FF0000" ></span></b></td>
		</tr>
	</table>
</div>
<script type="text/javascript">		
 	<%out.println(json);%>
 	
 	var taskSerialNo = "<%=taskSerialNo%>";
	var actionSet = $("#actionset");
	var phaseInfoSet = $("#phaseinfo");
	var bActionReqiured = true;	//是否需要选择动作（如果为退回一类的，就不需要选择下一步Action了)
	window.onload = function(){
		initPage();
	}
	/*~[Describe=页面加载后，初始化操作;InputParam=无;OutPutParam=无;]~*/
	function initPage(){
		//actionSet.empty().hide();//隐藏动作选择框
	}
	
	/*~[Describe=取消提交;InputParam=无;OutPutParam=无;]~*/
	function doCancel(){
		if(confirm("您确定要放弃此次提交吗？")){
			top.returnValue = "_CANCEL_";
			top.close();
		}
	}
	
	/*~[Describe=多选框显示;InputParam=无;OutPutParam=无;]~*/
	function showItemTips(obj){
		var $obj = $(obj);
		while(!$obj.is("td")){
			$obj = $obj.parent();
		}
		$(".info_tips:not(:empty):hidden", $obj).stop(true, true).slideDown();
	}
	/*~[Describe=多选框隐藏;InputParam=无;OutPutParam=无;]~*/
	function hideItemTips(obj){
		var $obj = $(obj);
		while(!$obj.is("td")){
			$obj = $obj.parent();
		}
		$(".info_tips:not(:empty):visible", $obj).stop(true, true).slideUp();
	}

	/*~[Describe=控制动作选择窗口;InputParam=无;OutPutParam=无;]~*/
	function doActionList(obj){
		
		$(obj).siblings().removeClass("opinion-focus");
		$(obj).addClass("opinion-focus");
		var phaseOpinion = $(obj).find("input").val();
		$(obj).find("input").prop("checked","true");
		if(!phaseOpinion){
			actionSet.empty().hide();
			phaseInfoSet.text("请先选择下一阶段提交动作。");
			return;
		}else{
			actionSet.empty().show();
			
			for(var np = 0; np < json["jbo.flow.FLOW_INSTANCE"]["NextPhase"].length ; np ++)
			{
				var nextPhase = json["jbo.flow.FLOW_INSTANCE"]["NextPhase"][np]["jbo.sample.NextPhase"];
				if(nextPhase["ID"] == phaseOpinion.split("@")[0])
				{
					for(var p = 0 ; p < nextPhase["Phase"].length ; p ++)
					{
						var phase = nextPhase["Phase"][p]["jbo.sample.Phase"];
						var cnt = phase["Count"];
						var id = phase["ID"];
						var name = phase["Name"];
						actionSet.append("<div style='margin-top:10px;margin-left:15px;font-size:12px;'><font color='#000000'><b>请选择"+name+"用户：</b></font></div><div id='"+id+"action' style='margin-top:10px;margin-left:10px;font-size:12px;border:1px solid lightgray;padding:5px;'></div>");
						var phaseAction = $("#"+id+"action");
						if(cnt == "X" || cnt == "x" || cnt > 1 )//多节点 X表示通过前端选择控制
						{
							for(var j=0;j < phase["jbo.sys.USER_INFO"].length; j ++)
							{
								var u = phase["jbo.sys.USER_INFO"][j]["jbo.sys.USER_INFO"];
								phaseAction.append("<a class='opinion-style' href='javascript:void(0)' onclick='getNextPhaseInfo(this)'><input type='checkbox' onclick='return false;' onmouseup='this.checked=!this.checked;' name='"+id+""+j+"' value='"+u["USERID"]+"$"+u["BELONGORG"]+"'>"+u["USERNAME"]+"（"+u["USERID"]+"）"+"</input></a>");
							}
						}
						else
						{
							for(var j=0;j < phase["jbo.sys.USER_INFO"].length; j ++)
							{
								
								var u = phase["jbo.sys.USER_INFO"][j]["jbo.sys.USER_INFO"];
								var check = "";
								if(phase["jbo.sys.USER_INFO"].length == 1)
									check = "checked";
								phaseAction.append("<a class='opinion-style' href='javascript:void(0)' onclick='getNextPhaseInfo(this)'><input type='radio' onclick='return false;' "+check+" onmouseup='this.checked=!this.checked;' name='"+id+"' value='"+u["USERID"]+"$"+u["BELONGORG"]+"'>"+u["USERNAME"]+"（"+u["USERID"]+"）"+"</input></a>");
							}
						}
					}
				}
			}
		}
	}
	
	//获取下一阶段动作
	function getNextPhaseInfo(obj){
		var phaseOpinion = $("input[name='phaseopinion']:checked").val();
		$(obj).siblings().removeClass("opinion-focus");
		$(obj).addClass("opinion-focus");
		if(!($(obj).find("input").is(":checked")))
		{
			$(obj).find("input").prop("checked","true");
		}
		else
		{
			var input = $(obj).find(":input").get();
			if(input[0].type == "checkbox")
				$(obj).find("input").prop("checked","");
			else
				$(obj).find("input").prop("checked","false");
		}
		
		return checkData(true);
	}
	
	function checkData(flag){
		var phaseOpinion = $("input[name='phaseopinion']:checked").val();
		if(typeof(phaseOpinion) == "undefined" || phaseOpinion.length == 0){				
			phaseInfoSet.text("请先选择下一阶段提交动作。");
			return false;
		}
		
		for(var np = 0; np < json["jbo.flow.FLOW_INSTANCE"]["NextPhase"].length ; np ++)
		{
			var nextPhase = json["jbo.flow.FLOW_INSTANCE"]["NextPhase"][np]["jbo.sample.NextPhase"];
			if(nextPhase["ID"] == phaseOpinion.split("@")[0])
			{
				for(var p = 0 ; p < nextPhase["Phase"].length ; p ++)
				{
					var phase = nextPhase["Phase"][p]["jbo.sample.Phase"];
					var cnt = phase["Count"];
					var id = phase["ID"];
					if(cnt == "X" || cnt == "x")//如果Count为X，表示通过前端选择确定处理人数
					{
						return true;
					}
					else if(cnt > 1)//多节点
					{
						var n = 0;
						for(var j=0;j < phase["jbo.sys.USER_INFO"].length; j ++)
						{
							var ck = $("input[name='"+id+""+j+"']:checked").val();
							if(typeof(ck) != "undefined" && ck.length != 0 && ck != null)
							{
								flag = true;
								n++;
							}
						}
						
						if(cnt > n && flag){
							phaseInfoSet.text("请为"+phase["Name"]+"再选择 "+(cnt - n)+" 位用户。");
							return false;
						}else if(cnt < n && flag)
						{
							phaseInfoSet.text(""+phase["Name"]+"只需要选择 "+cnt+" 位用户，请取消 "+(n - cnt)+" 位用户。");
							return false;
						}
					}
					else
					{
						var ck = $("input[name='"+id+"']:checked").val();
						if((typeof(ck) == "undefined" || ck.length == 0 || ck == null) && flag)
						{
							phaseInfoSet.text("请为"+phase["Name"]+"再选择(1)位用户。");
							return false;
						}
						
						if(typeof(ck) != "undefined" && ck.length != 0 && ck != null)
						{
							flag = true;
						}
					}
				}
			}
		}
		
		phaseInfoSet.text("下一阶段："+phaseOpinion.split("@")[1]);
		return true;
	}
	
	

	/*~[Describe=提交任务;InputParam=无;OutPutParam=无;]~*/
	function commitAction(){
		var phaseOpinion = $("input[name='phaseopinion']:checked").val();
		
		if(!checkData(false)) return;
		
		if (confirm("下一阶段："+phaseOpinion.split("@")[1]+"\r\n你确定提交吗？")){
			var users = "";
			for(var np = 0; np < json["jbo.flow.FLOW_INSTANCE"]["NextPhase"].length ; np ++)
			{
				var nextPhase = json["jbo.flow.FLOW_INSTANCE"]["NextPhase"][np]["jbo.sample.NextPhase"];
				if(nextPhase["ID"] == phaseOpinion.split("@")[0])
				{
					for(var p = 0 ; p < nextPhase["Phase"].length ; p ++)
					{
						var phase = nextPhase["Phase"][p]["jbo.sample.Phase"];
						var cnt = phase["Count"];
						var id = phase["ID"];
						
						if(cnt == "X" || cnt == "x" || cnt > 1)//多节点
						{
							var n = 0;
							var str = "";
							for(var j=0;j < phase["jbo.sys.USER_INFO"].length; j ++)
							{
								var ck = $("input[name='"+id+""+j+"']:checked").val();
								if(typeof(ck) != "undefined" && ck.length != 0 && ck != null)
								{
									str += ck+"@";
									n++;
								}
							}
							users+=id+":"+n+":"+str;
						}
						else
						{
							users+=id+":"+cnt+":";
							var ck = $("input[name='"+id+"']:checked").val();
							if(typeof(ck) != "undefined" && ck.length != 0 && ck != null)
							{
								users += ck+"@";
							}
						}
						users+="#";
					}
				}
			}
			
			//调用提交任务并返回后继任务列表接口
			var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.SubmitTask","run","FlowSerialNo=<%=flowSerialNo%>,TaskSerialNo=<%=taskSerialNo%>,PhaseOpinion="+phaseOpinion.split("@")[0]+",PhaseUsers="+users+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
			if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue == null) return;
			if(returnValue.split("@")[0] == "true")
			{
				alert(returnValue.split("@")[1]);
				top.returnValue = returnValue;
				top.close(); 
			}
			else
			{
				phaseInfoSet.text(returnValue.split("@")[1]);
			}
		}
	}

	document.onkeydown = function(){
		if(event.keyCode==27){
			top.returnValue = "_CANCEL_"; 
			top.close();
		}
	}; 
	
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>