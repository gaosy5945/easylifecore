<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "��ͬ����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ͬ����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	
	//����������	
	String sTreeviewTemplet = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TreeviewTemplet"));//�����״ͼ����

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��ͬ����","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = " from CODE_LIBRARY where CodeNo= '"+sTreeviewTemplet+"' and IsInUse = '1'";  //����ItemAttribute�����ж�     wqchen 2010.03.18�޸�
	String sApproveTreeView = "";
	sApproveTreeView = CurConfig.getConfigure("ApproveNeed");
	if("false".equalsIgnoreCase(sApproveTreeView)){
		sSqlTreeView = sSqlTreeView + " and ItemAttribute like '%SWITapply%' ";
	}else{
		sSqlTreeView = sSqlTreeView + " and ItemAttribute like '%SWITapprove%' ";
	}

	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		var sCurItemDescribe3=sCurItemDescribe[2];
		if(typeof(sCurItemDescribe3)!="undefined" && sCurItemDescribe3.length > 0){
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&DealType="+sCurItemDescribe3,"right");
		}
		setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');
	selectItem('010');
	selectItem('024');
</script>
<%@ include file="/IncludeEnd.jsp"%>