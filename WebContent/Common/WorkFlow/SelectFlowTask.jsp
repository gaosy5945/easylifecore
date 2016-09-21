<%@ page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBeginMD.jsp"%>
<%
	//获取页面参数
	String templateNo = DataConvert.toString(CurPage.getParameter("TemplateNo"));//模板号
	String flowType = DataConvert.toString(CurPage.getParameter("FlowType"));//流程编号
	String phaseType = DataConvert.toString(CurPage.getParameter("PhaseType"));//阶段类型，支持多个
	String objectType = DataConvert.toString(CurPage.getParameter("ObjectType"));//对象类型，支持多个
	String queryType = DataConvert.toString(CurPage.getParameter("QueryType"));//查询类型

%>
<html>
<head> 
<!--为了页面美观,请不要删除下面 TITLE 中的空格 -->
<title>请选择流程任务信息</title>
</head>
<body class="pagebackground" style="overflow: auto;overflow-x:visible;overflow-y:visible">
<table width="100%" border='0' height="100%" cellspacing='0' align=center bordercolor='#999999' bordercolordark='#FFFFFF'>
<form  name="buff" align=center>
	<tr> 
			<td id="selectPage">
				<iframe name="ObjectList" width=100% height=100% frameborder=0 scrolling=no src="<%=sWebRootPath%>/Blank.jsp"></iframe>
			</td>
	</tr>
	<tr style="height:40px;">
		<td nowarp bgcolor="#e8e8e8" height="35" align=center valign="middle" colspan="2" style="border-top:1px solid #d8d8d8"> 
			<%=new Button("确认", "", "returnSelection()").getHtmlText()%>
			<%=new Button("取消", "", "doCancel()").getHtmlText()%>
		</td>
	</tr>
</form>
</table>
</body>
</html>
<script type="text/javascript">
	var objectInfo = "";
	function returnSelection(){
		ObjectList.mySelectRow();
		if(objectInfo == "" || objectInfo == "@@"){
			if(confirm("您尚未进行选择，确认要返回吗？（请点击要选择的任务前面的方框进行勾选）")){
				objectInfo = "_NONE_";
			}else{
				return;
			}
		}
		top.returnValue = objectInfo;
		top.close();
	}

	function clearAll(){
		top.returnValue='_CLEAR_';
		top.close();
	}

	function doCancel(){
		top.returnValue='_CANCEL_';
		top.close();
	}

	/*~[Describe=支持ESC关闭页面;InputParam=无;OutPutParam=无;]~*/
	document.onkeydown = function(){
		if(event.keyCode==27){
			top.returnValue = "_CANCEL_"; 
			top.close();
		}
	};
	
	OpenComp("FlowList","/Common/WorkFlow/FlowList.jsp","TemplateNo=<%=templateNo%>&FlowType=<%=flowType%>&PhaseType=<%=phaseType%>&QueryType=01&ObjectType=<%=objectType%>&ButtonSet=&ButtonFilter=&MultiSelectFlag=Y","ObjectList","");

</script>
<%@ include file="/IncludeEnd.jsp"%>