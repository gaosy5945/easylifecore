<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "�ͻ�Ⱥ����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�ͻ�Ⱥ����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�ͻ�Ⱥ��Ϣ����","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'UnionType' and isinuse = '1' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var curItemID = getCurTVItem().id;//�ͻ�Ⱥ����
		var curItemName = getCurTVItem().name;//�ͻ�Ⱥ����

		OpenComp("UnionList","/CustomerManage/UnionManage/UnionCustomerList.jsp","CustomerType="+curItemID,"right");
		setTitle(curItemName);
	}
	startMenu();
	expandNode('root');
	selectItemByName('�Թ�������');
</script>
<%@ include file="/IncludeEnd.jsp"%>