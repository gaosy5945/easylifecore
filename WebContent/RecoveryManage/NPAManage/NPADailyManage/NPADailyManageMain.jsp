<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "�����ʲ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�����ʲ�����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,"�����ʲ�����","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = " from CODE_LIBRARY where CodeNo = 'NPADaily' and ItemNo not like '005%' and IsInUse = '1' ";
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
			
		if(sItemMenuNo!="root" && sItemMenuNo!="0" && sItemMenuNo!="005" && sItemMenuNo!="010" && sItemMenuNo!="020" && sItemMenuNo!="1" && sItemMenuNo!="110" && sItemMenuNo!="120")
		{
			if(sItemMenuNo != "null" ){   //�˵�����������Ŀ¼
				OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName=sCurItemName&ItemMenuNo="+sItemMenuNo,"right",OpenStyle);
				setTitle(sCurItemName);
			}
		}
	}

	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
	
	startMenu();
	expandNode('root');
	expandNode('0');
	expandNode('010');
	expandNode('040');
	expandNode('005');
	expandNode('030');
	expandNode('045');
	selectItem('01010');	 
</script>
<%@ include file="/IncludeEnd.jsp"%>