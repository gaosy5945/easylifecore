<%@ page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBeginMD.jsp"%>
<%
	//��ȡҳ�����
	String templateNo = DataConvert.toString(CurPage.getParameter("TemplateNo"));//ģ���
	String flowType = DataConvert.toString(CurPage.getParameter("FlowType"));//���̱��
	String phaseType = DataConvert.toString(CurPage.getParameter("PhaseType"));//�׶����ͣ�֧�ֶ��
	String objectType = DataConvert.toString(CurPage.getParameter("ObjectType"));//�������ͣ�֧�ֶ��
	String queryType = DataConvert.toString(CurPage.getParameter("QueryType"));//��ѯ����

%>
<html>
<head> 
<!--Ϊ��ҳ������,�벻Ҫɾ������ TITLE �еĿո� -->
<title>��ѡ������������Ϣ</title>
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
			<%=new Button("ȷ��", "", "returnSelection()").getHtmlText()%>
			<%=new Button("ȡ��", "", "doCancel()").getHtmlText()%>
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
			if(confirm("����δ����ѡ��ȷ��Ҫ�����𣿣�����Ҫѡ�������ǰ��ķ�����й�ѡ��")){
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

	/*~[Describe=֧��ESC�ر�ҳ��;InputParam=��;OutPutParam=��;]~*/
	document.onkeydown = function(){
		if(event.keyCode==27){
			top.returnValue = "_CANCEL_"; 
			top.close();
		}
	};
	
	OpenComp("FlowList","/Common/WorkFlow/FlowList.jsp","TemplateNo=<%=templateNo%>&FlowType=<%=flowType%>&PhaseType=<%=phaseType%>&QueryType=01&ObjectType=<%=objectType%>&ButtonSet=&ButtonFilter=&MultiSelectFlag=Y","ObjectList","");

</script>
<%@ include file="/IncludeEnd.jsp"%>