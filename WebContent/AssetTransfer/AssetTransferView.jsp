<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��:�ʲ�ת��������ҳ��
	 */
	String PG_TITLE = "�ʲ�ת��������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�ʲ�ת��������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	
	String viewID = CurPage.getParameter("ViewID");
	if(viewID == null) viewID = "";
	//���ҳ�����
	String projectStatus = DataConvert.toString(CurPage.getParameter("projectStatus"));//��Ŀ״̬
	String sAssetProjectType = DataConvert.toString(CurPage.getParameter("AssetProjectType"));//��Ŀ����
	String objectNo=CurComp.getParameter("ObjectNo");
	CurPage.setAttribute("SerialNo",objectNo);
	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�ʲ�ת��������","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo='AssetTransferViewTree' and IsInUse='1' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		var sItemDescribe = getCurTVItem().value;
		
		//alert("sCurItemID = "+sCurItemID);
		
		if(typeof(sItemDescribe) == 'undefined' || sItemDescribe.length == 0 || sItemDescribe=="null"){
			return;
		}
		AsControl.OpenView(sItemDescribe,"projectStatus=010&View=<%=viewID%>&ItemNo="+sCurItemID +"&AssetProjectType=<%=sAssetProjectType%>","right");
		setTitle(sCurItemname);
	}
	
	<%/*~[Describe=����treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		expandNode('03');
		selectItem('01');
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>