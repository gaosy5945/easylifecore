<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "�����鱨��"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�����鱨��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�����鱨��","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	int iTreeNode=1;

	//������ͼ�ṹ
	tviTemp.insertPage("root","δ��ɵĹ����鱨��","Unfinished","",iTreeNode++);
	tviTemp.insertPage("root","����ɵĹ����鱨��","Finished","",iTreeNode++);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		sAction = getCurTVItem().value;
		if(sAction=="Unfinished"){
			OpenComp("ManagerCheckReportList","/CreditManage/ManagerCheckReport/ManagerCheckReportList.jsp","Status=Unfinished&ComponentName=�����鱨��&Status="+getCurTVItem().id+"&OpenerFunctionName="+getCurTVItem().name,"right");
		}else if(sAction=="Finished"){
			OpenComp("ManagerCheckReportList","/CreditManage/ManagerCheckReport/ManagerCheckReportList.jsp","Status=Finished&ComponentName=�����鱨��&Status="+getCurTVItem().id+"&OpenerFunctionName="+getCurTVItem().name,"right");
		}else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
	
	startMenu();
	expandNode('root');		
</script>
<%@ include file="/IncludeEnd.jsp"%>