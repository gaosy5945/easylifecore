<%@ page contentType="text/html; charset=GBK"%>
<%@include file="/Frame/resources/include/include_begin.jspf"%>
<% 
String phaseOpinion = "合作项目审查";
%>


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
		<font color="#000000"><b>动作选择列表：</b></font>
	</div>
	<div style="margin-top:10px;margin-left:10px;font-size:12px;border:1px solid lightgray;padding:10px;">
		<%
		out.println("<a class='opinion-style2' href='javascript:void(0)' onclick='doActionList(this)'><input type='radio' name='phaseopinion' value='"+phaseOpinion+"' >&nbsp&nbsp"+phaseOpinion+"</input></a>");
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
 	<%-- var taskSerialNo = "<%=taskSerialNo%>"; --%>
	/*~[Describe=取消提交;InputParam=无;OutPutParam=无;]~*/
	function doCancel(){
		if(confirm("您确定要放弃此次提交吗？")){
			top.returnValue = "_CANCEL_";
			top.close();
		}
	}
	
	
	/*~[Describe=控制动作选择窗口;InputParam=无;OutPutParam=无;]~*/
	function doActionList(obj){
		
		$(obj).siblings().removeClass("opinion-focus");
		$(obj).addClass("opinion-focus");
		var phaseOpinion = $(obj).find("input").val();
		$(obj).find("input").prop("checked","true");
		if(!phaseOpinion){
			alert("请选择提交动作！");
			actionSet.empty().hide();
			phaseInfoSet.text("");
			return;
		}else{
			if(phases.length==0) return;
			actionSet.empty().show();
			actionSet.append("<div style='margin-top:10px;margin-left:15px;font-size:12px;'><font color='#000000'><b>请选择"+phaseOpinion.split("@")[1]+"用户：</b></font></div><div id='phaseaction' style='margin-top:10px;margin-left:10px;font-size:12px;border:1px solid lightgray;padding:5px;'></div>");
			var phaseAction = $("#phaseaction");
			for(var i=0;i<phases.length;i++){
				if(phases[i][0] == phaseOpinion)
				{
					phaseAction.append("<a class='opinion-style' href='javascript:void(0)' onclick='getNextPhaseInfo(this)'><input type='radio' name='phaseaction' value='"+phases[i][1]+"'>"+phases[i][2]+"</input></a>");
				}
			}
			
		}
	}
</script>
<%/*~END~*/%>
<%@include file="/Frame/resources/include/include_end.jspf"%>