<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "���Ŷ����ֹ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���Ŷ����ֹ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"���Ŷ����ֹ","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	tviTemp.insertPage("root","��Ч�����Ŷ���б�","",1);
	tviTemp.insertPage("root","����ֹ�����Ŷ���б�","",2);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=='��Ч�����Ŷ���б�'){
			OpenComp("CreditLineStopList","/CreditManage/CreditLine/CreditLineStopList.jsp","StopFlag=1","right");
		}
		if(sCurItemname=='����ֹ�����Ŷ���б�'){
			OpenComp("CreditLineStopList","/CreditManage/CreditLine/CreditLineStopList.jsp","StopFlag=2","right");
		}
		setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	startMenu();
	expandNode('root');	
	selectItemByName('��Ч�����Ŷ���б�');
</script>
<%@ include file="/IncludeEnd.jsp"%>