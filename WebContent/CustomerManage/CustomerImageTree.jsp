<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%>
 

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	String sSql = "";	//--���sql���
	String sCustomerType = "";//--�ͻ�����	
	ASResultSet rs = null;//--��Ž��
	//����������	,�ͻ�����
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%	
	//ȡ�ÿͻ�����
	sSql = "select CustomerType from CUSTOMER_INFO where CustomerID = :CustomerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sObjectNo));
	if(rs.next()){
		sCustomerType = rs.getString("CustomerType");
	}
	rs.getStatement().close();
	if(sCustomerType == null) sCustomerType = "";

	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�ͻ�Ӱ����Ϣ","right");
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//TODO Ӱ�����͹��ˣ���Ҫ��ϸ��ƣ���ʱ�Ӽ�
	String sFilter = "";
	if( sCustomerType.startsWith( "01" ) ) sFilter = "1020";
	else if( sCustomerType.startsWith( "02" ) ) sFilter = "1020";
	else if( sCustomerType.startsWith( "03" ) ) sFilter = "1010";
	String sAppend = " and TypeNo Like '" + sFilter + "%' ";

	//������ͼ�ṹ
	String sSqlTreeView = "from ECM_IMAGE_TYPE where IsInUse = '1' " + sAppend;
	tviTemp.initWithSql("TypeNo","case when (Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.TypeNo Like ECM_IMAGE_TYPE.TypeNo || '%') > 0 then ( TypeName || '( <font color=\"red\">' || (Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.TypeNo Like ECM_IMAGE_TYPE.TypeNo || '%') || '</font> ��)') else TypeName end as TypeName ","TypeName","","",sSqlTreeView,"Order By TypeNo",Sqlca);
	%>
<%/*~END~*/%>

<html>
<head>
<title>Ӱ����Ϣ</title>
<style type="text/css">
	.no_select {
		-moz-user-select:none;
	}
</style>
</head>
<body style="overflow: hidden;width:100%;height:100%;margin:0;">
		<iframe name="left" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0  ></iframe>
</body>
</html>

<script type="text/javascript">
	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;//--�����ͼ�Ľڵ����
		if( sCurItemID != "null" && sCurItemID != "root" && hasChild(getCurTVItem().id) ){
			var param = "ObjectType=Customer&ObjectNo=<%=sObjectNo%>&TypeNo="+sCurItemID;
			AsControl.OpenView( "/ImageManage/ImagePage.jsp", param, "frameright" );
		}
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView().replaceAll( "addItem", "addItemYX" )%>
	}
	
	function expandAll(){
		for( var i = 0; i < nodes.length; i++ ){
			if( !hasChild(nodes[i].id) ) expandNode( nodes[i].id );
		}
	}
		
	startMenu();
	expandAll();
</script>
<%@ include file="/IncludeEnd.jsp"%>