<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = ""; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ѡ��ַ�Ŀ��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "���ڴ�ҳ�棬���Ժ�...";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "50%";//Ĭ�ϵ�treeview���

	CurPage.setAttribute("PG_CONTENT_TITLE_LEFT","&nbsp;&nbsp;��ѯ&nbsp;&nbsp;");
	CurPage.setAttribute("PG_CONTNET_TEXT_LEFT","���ڴ�ҳ�棬���Ժ�...");
	//���ҳ�����	
	String sAlertIDString = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlertIDString"));
%><%@include file="/Resources/CodeParts/VerticalSplit04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		OpenComp("ExampleList","/Frame/CodeExamples/ExampleList.jsp","ComponentName=�ҵ�����&SortNo="+getCurTVItem().id+"&OpenerFunctionName="+getCurTVItem().name,"right");
		setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
	}
	
	function reloadLeftAndRight(){
		left.reloadSelf();
		right.reloadSelf();
	}

	startMenu();
	expandNode('root');
	OpenComp("AlertDistributeUserQuery","/CreditManage/CreditAlarm/UserQueryList.jsp","","left");
	OpenComp("AlertDistributeSelectedUsers","/CreditManage/CreditAlarm/SelectedUserList.jsp","","right");
</script>
<%@ include file="/IncludeEnd.jsp"%>