<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "ҵ����Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ҵ����ʾ��Ԥ��","right");
	//tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	
	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo='ClewAndAlarmMain' and IsInUse='1'";
	tviTemp.initWithSql("SortNo","ItemName","ItemNo","ItemDescribe","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ�� ID�ֶ�,Name�ֶ�,Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�,OrderBy�Ӿ�,Sqlca
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;	
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	myleft.width=225;
	startMenu();
	expandNode('root');
	expandNode('01');	
	expandNode('02');
</script>
<%@ include file="/IncludeEnd.jsp"%>