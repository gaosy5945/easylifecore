<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "�����ʲ������˱������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�����ʲ������˱������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "1";//Ĭ�ϵ�treeview���
	//�������
	String sPhaseType="010";

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�����ʲ������˱�������б�","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'NPAChangeList' and IsInUse = '1'";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		var sItemMenuNo = getCurTVItem().id;      //CodeLibrary ��describe��Ϊ�˵����
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		var sCurItemDescribe = sCurItemDescribe.split("@");
		var sCurItemDescribe1=sCurItemDescribe[0];
		var sCurItemDescribe2=sCurItemDescribe[1];
		var sCurItemDescribe3=sCurItemDescribe[2];
		if(sItemMenuNo != "null" ){   //�˵�����������Ŀ¼
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName=sCurItemName&ItemMenuNo="+sCurItemDescribe3,"right",OpenStyle);
			setTitle(sCurItemName);
		}
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>		
	}

	startMenu();
	selectItem('<%=sPhaseType%>');
	expandNode('root');
</script>
<%@ include file="/IncludeEnd.jsp"%>