<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "������������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview����
	//����������	
	String sTreeviewTemplet = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TreeviewTemplet"));

	//����
	String sCondition ="";
	int i=0,i1=0,i2=0;
	//280�����пͻ�������480��֧�пͻ�������000������ϵͳ����ά��Ա
	if (CurUser.hasRole("280") || CurUser.hasRole("480") || CurUser.hasRole("000")){
		i1 = 1;
	}
	//040�������Ŵ����մ�����Ա��240�������Ŵ����մ�����Ա��000������ϵͳ����ά��Ա
	if (CurUser.hasRole("040") || CurUser.hasRole("240")|| CurUser.hasRole("000")){
		i2 = 2;
	}
	i=i1+i2;
	if (i==3) sCondition ="";
	if (i==2) sCondition =" and Itemno like '02%'";
	if (i==1) sCondition =" and Itemno like '01%'";
	if (i==0) sCondition =" and Itemno like '1%'";
	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"���ռ�����","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= '"+sTreeviewTemplet+"'"+sCondition;
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		var sCurItemDescribe3=sCurItemDescribe[2];
		if(typeof(sCurItemID)!="undefined" && typeof(sCurItemDescribe2)!="undefined" && sCurItemDescribe2.length > 0 && sCurItemID !="root" && sCurItemID !="010" && sCurItemID !="020")
		{
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&InspectType="+sCurItemDescribe3,"right");
		}
		
		if(sCurItemDescribe1 != "null"&&sCurItemDescribe1!="root"){
			setTitle(getCurTVItem().name);
		}
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');	
	expandNode('01');
	expandNode('02');
	expandNode('01010');	
	expandNode('01020');
	selectItem('01010010');
</script>
<%@ include file="/IncludeEnd.jsp"%>