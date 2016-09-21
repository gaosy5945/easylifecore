<%@page import="com.amarsoft.dict.als.object.ObjectType"%>
<%@page import="com.amarsoft.dict.als.manage.ObjectTypeManager"%>
<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMD.jsp"%><%
	String sObjectType  = CurPage.getParameter("ObjectType");
	String sParaString = CurPage.getParameter("ParaString");
	if(sParaString==null) sParaString="";
	sParaString = StringFunction.replace(sParaString,"~","&");
	sParaString = StringFunction.replace(sParaString,"^","%");
	
	String sSelectionDialogURL = "",sSelectionDialogCompID="";
	
	ObjectType type = ObjectTypeManager.getObjectType(sObjectType);
	String sObjectAttribute = type.getObjectAttribute();
	String sObjectTypeName  = type.getObjectName();
	
	sSelectionDialogURL = StringFunction.getProfileString(sObjectAttribute,"SelectionDialog");
	if(sSelectionDialogURL!=null)	sSelectionDialogURL = sSelectionDialogURL.trim();
	sSelectionDialogCompID = StringFunction.getProfileString(sObjectAttribute,"SelectionDialogCompID");
	if(sSelectionDialogCompID==null || sSelectionDialogCompID.equals(""))
		sSelectionDialogCompID = sObjectType+"SelectionDialog";
%>
<html>
<head> 
<!-- 为了页面美观,请不要删除下面 TITLE 中的空格 -->
<title>请选择<%=sObjectTypeName%>
 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　
 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　
</title>
</head>
<body class="pagebackground" style="overflow: auto;overflow-x:visible;overflow-y:visible">
<form  name="buff" align=center>
<table width="100%" border='1' height="98%" cellspacing='0' align=center bordercolor='#999999' bordercolordark='#FFFFFF'>
<%if(sSelectionDialogURL==null || sSelectionDialogURL.equals("")){%>
	<tr> 
		<td id="selectPage" valign=top>
			<p>没有定义对象选择窗口。请在"业务对象类型设置"模块定义 SelectionDialog 属性。</p>
		</td>
	</tr>
<%}else{%>
	<tr> 
		<td id="selectPage">
			<iframe name="ObjectList" width=100% height=100% frameborder=0 scrolling=no src="<%=sWebRootPath%>/Blank.jsp"></iframe>
		</td>
	</tr>
<%}%>
	<tr>
		<td nowarp bgcolor="" height="25" align=center  colspan="2"> 
			<%=new Button("确认", "", "returnSelection()").getHtmlText()%>
			<%=new Button("清空", "", "clearAll()").getHtmlText()%>
			<%=new Button("取消", "", "doCancel()").getHtmlText()%>
		</td>
	</tr>
</table>
</form>
</body>
</html>
<script type="text/javascript">
	var sObjectInfo="";
	function returnSelection(){
		if(sObjectInfo==""){
			if(confirm("您尚未进行选择，确认要返回吗？")){
				sObjectInfo="_NONE_";
			}else{
				return;
			}
		}
		top.returnValue=sObjectInfo;
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
	
	<%if(sSelectionDialogURL!=null && !sSelectionDialogURL.equals("")){%>
		OpenComp("<%=sSelectionDialogCompID%>","<%=sSelectionDialogURL%>","<%=sParaString%>","ObjectList","");
	<%}%>
</script>
<%@ include file="/IncludeEnd.jsp"%>