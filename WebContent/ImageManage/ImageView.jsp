<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 
 <%-- <%@page import="com.amarsoft.app.als.image.HTMLTreeViewYX"%> --%>
 <%
 
	/*
		ҳ��˵��:Ӱ�����ҳ��
	 */
	 
	//���ҳ�����   typeNo:Ӱ������ 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String typeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	String sType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));//ͨ���������ж����ĸ��ڵ㣬��ýڵ�������ҵ��
	String sApplyType = CurComp.getParameter("ApplyType");
	
	String sImageType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ImageType"));//Ӱ������
	
	if( sObjectNo == null ) sObjectNo = null;
	if( sObjectType == null ) sObjectType = null;
	if(typeNo==null) typeNo ="";
	if(sType==null) sType ="";
	if(sApplyType==null) sApplyType = "";
	if(sImageType==null) sImageType = "";
	
	//���л�ȡ�ͻ����� add by lyi 2014/06/20
	ASResultSet rs1 = null;
	//SqlObject so1 = null;
	String sCustomerName = "";
	
	if("Customer".equals(sObjectType)){
		/* so1 = new SqlObject("select CustomerName from Customer_Info where CustomerID = :CustomerID ");
		so1.setParameter("CustomerID", sObjectNo);
		rs1 = Sqlca.getASResultSet(so1); */
		rs1 = Sqlca.getASResultSet("select CustomerName from Customer_Info where CustomerID = '"+sObjectNo+"'");
		if(rs1.next()){
			sCustomerName = rs1.getString("CustomerName");
		}
		rs1.close();
	}
	//end
	
	String sGlobalType = sObjectType.equals("Customer") ? "�ͻ�" : "ҵ��";
	
	String PG_TITLE = sGlobalType+"Ӱ������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "";
	if("Customer".equals(sObjectType)){
		PG_CONTENT_TITLE = sGlobalType +"["+ sCustomerName + "]����Ӱ������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	}else{
		PG_CONTENT_TITLE = sGlobalType +"["+ sObjectNo + "]����Ӱ������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	}
	
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "300";//Ĭ�ϵ�treeview���
	/* if(typeNo.length()>0){
		PG_LEFT_WIDTH = "1";
	} */
	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"Ӱ��","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//TODO Ӱ�����͹��ˣ���Ҫ��ϸ��ƣ���ʱ�Ӽ�
	String sFilter =  "";
	String sAppend = " ";
	if( sObjectType.equals( "Customer" ) ){
		String sCustomerType = "";
		/* String sSql = "select CustomerType from CUSTOMER_INFO where CustomerID = :CustomerID ";
		sCustomerType = Sqlca.getString(new SqlObject(sSql).setParameter("CustomerID",sObjectNo)); */
		sCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID = '"+sObjectNo+"' ");
		sAppend = " and ECM_IMAGE_TYPE.TypeNo Like '10%' ";
	}
	
	
	/* String sTypeName = Sqlca.getString(new SqlObject("Select TypeName From ECM_IMAGE_TYPE Where TypeNo = :TypeNo").setParameter("TypeNo",sTypeNo));
	String sCount = Sqlca.getString( new SqlObject( "(Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.TypeNo Like :TypeNo )" ).setParameter("TypeNo",sTypeNo+"%"));
	if( sTypeName == null ) sTypeName = "";
	if( sCount == null ) sCount = "";
	String sTitle = sGlobalType + "��" + sObjectNo +"�����µ�Ӱ�����ϣ�" +  "��" + sTypeName +"��(" + sCount + "��)"; */
	
	//������ͼ�ṹ
	String sSqlTreeView = "from ECM_IMAGE_TYPE where  IsInUse = '1' " ; //+ sAppend
	//tviTemp.initWithSql("TypeNo","case when (Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.documentId is not null and ECM_PAGE.TypeNo Like ECM_IMAGE_TYPE.TypeNo || '%') > 0 then ( TypeName || '( <font color=\"red\">' || (Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.TypeNo Like ECM_IMAGE_TYPE.TypeNo || '%') || '</font> ��)') else TypeName end as TypeName ","TypeName","","",sSqlTreeView,"Order By TypeNo",Sqlca);
	tviTemp.initWithSql("TypeNo","TypeName","","","",sSqlTreeView,"Order By TypeNo",Sqlca);
	 //��ѯ����
	String querySumSql = "select count(*) as cc, typeNo from ECM_PAGE where ECM_PAGE.objectNo='"+sObjectNo+"' and  ECM_PAGE.documentId is not null and length(ECM_PAGE.documentId)>0 group  by ECM_PAGE.typeNo ";
	ASResultSet rs = Sqlca.getASResultSet( querySumSql);
	StringBuffer sbuf = new StringBuffer();
	while(rs.next()){
		int cc = rs.getInt("cc");
		String my_typeNo = rs.getString("typeNo");
		sbuf.append("setItemName('"+my_typeNo+"', getItemName('"+my_typeNo+"')+' ( " + cc + " ��)" +"');");
	}
	if(rs!=null) {
		rs.close();
	}

%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	/*Ӱ������ */
	var sTypeNo="<%=typeNo%>"; 
	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;//--�����ͼ�Ľڵ����
		//alert(sCurItemID);
		if( sCurItemID != "null" && sCurItemID != "root" && hasChild(getCurTVItem().id) ){
			var param = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&TypeNo="+sCurItemID;
			var sReadOnly = "All";//All�ɲ鿴���ϴ���ɾ��ͼƬ��ReadOnly��չʾͼƬ
			if(sReadOnly == "All"){
				OpenComp("Page111", "/ImageManage/ImagePage.jsp", param, "right" );
			}else{
				OpenComp("Page222", "/ImageTrans/ImageTrans.jsp", param, "right" );	
			}
			
			//AsControl.OpenView( "/ImageTrans/ImageTrans.jsp", param, "right" );
			if("Customer"== "<%=sObjectType%>"){
				setTitle( "<%=sGlobalType%>��<%=sCustomerName%>�����µ�Ӱ�����ϣ���" + getCurTVItem().name + "��" );
			}else{
				setTitle( "<%=sGlobalType%>��<%=sObjectNo%>�����µ�Ӱ�����ϣ���" + getCurTVItem().name + "��" );
			}
		}
	}
	
	function expandAll(){
		for( var i = 0; i < nodes.length; i++ ){
			if( !hasChild(nodes[i].id) ) expandNode( nodes[i].id );
		}
		if(sTypeNo.length>0){
			selectItem(sTypeNo);
		}
		//������ʾ���������Ŀ��Ϣ
		<%=sbuf.toString()%> 
	}
	
	function initTreeView(){
		<%-- <%=tviTemp.generateHTMLTreeView().replaceAll( "addItem", "addItemYX" )%> --%>
		<%=tviTemp.generateHTMLTreeView()%>
	}
	
	initTreeView();
	expandAll();
</script>
<%@ include file="/IncludeEnd.jsp"%>
