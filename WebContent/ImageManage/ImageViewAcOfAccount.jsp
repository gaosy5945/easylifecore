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
	
	String sRight = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Right"));//Ӱ������
	if(sRight == null) sRight = "All";
	
	if( sObjectNo == null ) sObjectNo = null;
	if( sObjectType == null ) sObjectType = null;
	if(typeNo==null) typeNo ="";
	if(sType==null) sType ="";
	if(sApplyType==null) sApplyType = "";
	if(sImageType==null) sImageType = "";
	
	//���л�ȡ�ͻ����� add by lyi 2014/06/20
	String sCustomerName = "";
	
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
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"Ӱ������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//TODO Ӱ�����͹��ˣ���Ҫ��ϸ��ƣ���ʱ�Ӽ�
	String sFilter =  "";
	String sAppend = " ";
	if( sObjectType.equals( "Customer" ) ){
		String sCustomerType = "";
		sCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID = '"+sObjectNo+"' ");
		if( sCustomerType != null ){
			if( sCustomerType.startsWith( "01" ) ) sFilter = "1020";
			else if( sCustomerType.startsWith( "02" ) ) sFilter = "1020";
			else if( sCustomerType.startsWith( "03" ) ) sFilter = "1010";
		}
		sAppend = " and ECM_IMAGE_TYPE.TypeNo Like '" + sFilter + "%' ";
	}else if( sObjectType.equals( "Business" ) ){
		String sBusinessType = Sqlca.getString("Select BusinessType From BUSINESS_APPLY "+
				" Where SerialNo = '"+sObjectNo+"' ");
		if( sBusinessType == null ) sBusinessType = " ";
		sFilter = "%";
		/* sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA Where ProductID = '"+ sBusinessType +"') "; */
		sAppend += " and TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA Where '"+ sBusinessType +"'  like ProductID||'%' ) ";
	}else if( sObjectType.equals( "AccountChangeType" ) ){//�˺ű��Ӱ������
		sObjectType="CBCreditApply";
		sAppend += " and TypeNo In ('40','4010' ) ";
		sFilter = "4010";
	}else if(sObjectType.equals("AheadType")){//��ǰ����ɨ��
		sObjectType="CBCreditApply";
		sAppend += " and TypeNo In ('41','4110' ) ";
		sFilter = "4110";
	}
	else if( sObjectType.equals( "FileManageView" ) ){//��ͨ���ļ�����򿪵�ҳ��
		//��ȡ�ͻ����ͣ�ͨ���ͻ����ͽ����ж����ĸ�ҵ������
		String sCustomerType = Sqlca.getString("Select CustomerType From Customer_Info Where CustomerID = '"+sObjectNo+"'" );
		if( sCustomerType == null ) sCustomerType = " ";
		if( sCustomerType != null ){
			if( sCustomerType.startsWith( "01" ) ) sFilter = "1020";
			else if( sCustomerType.startsWith( "02" ) ) {
				sFilter = "1020";
			}
			else if( sCustomerType.startsWith( "03" ) ) {
				sFilter = "1010";
			}else{
				sFilter = "1020";
			}
		}
		/* String sBusinessType = Sqlca.getString( new SqlObject("Select BusinessType From BUSINESS_APPLY "+
				" Where SerialNo = :SerialNo").setParameter( "SerialNo", sObjectNo ) );
		if( sBusinessType == null ) sBusinessType = " "; */
		
		if (sCustomerType.equals("0310")){//����Ǹ��˿ͻ�
			
			if(CurUser.hasRole("482")){//֧��С΢�ͻ������µĸ��˿ͻ��ǿ��԰���С΢ҵ���
				if(sType.equals("0010")){//����ҵ������
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '4010%' or ImageTypeNo like '4020%' or ImageTypeNo like '6020010%') )  ";
				}else if(sType.equals("0020")){//��������
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '4010%' or ImageTypeNo like '4020%') )  "; */
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '6020020%' or ImageTypeNo like '6020030%' or ImageTypeNo like '6020040%' or ImageTypeNo like '6020050%') )  ";
				}else if(sType.equals("0030")){//�����������
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '4040%' or ImageTypeNo like '6030%'  )  ";
				}else if(sType.equals("0040")){//��������
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '4030%' or ImageTypeNo like '6010%' )  ";
				}else if(sType.equals("0050")){//��������
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo like '50%'  "; */
					sAppend += " and TypeNo is null ";
				}else if(sType.equals("0060")){//����
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '4010%' or ImageTypeNo like '4020%') )  "; */
					sAppend = " and ECM_IMAGE_TYPE.TypeNo Like '" + sFilter + "%' ";
				}
			}else{//��С΢�ͻ���������С΢ҵ��
				if(sType.equals("0010")){//����ҵ������
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '4010%' or ImageTypeNo like '4020%') )  ";
				}else if(sType.equals("0020")){//��������
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '4010%' or ImageTypeNo like '4020%') )  "; */
					sAppend += " and TypeNo is null ";
				}else if(sType.equals("0030")){//�����������
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '4040%'  )  ";
				}else if(sType.equals("0040")){//��������
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '4030%'  )  ";
				}else if(sType.equals("0050")){//��������
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo like '50%'  "; */
					sAppend += " and TypeNo is null ";
				}else if(sType.equals("0060")){//����
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '4010%' or ImageTypeNo like '4020%') )  "; */
					sAppend = " and ECM_IMAGE_TYPE.TypeNo Like '" + sFilter + "%' ";
				}
			}
			
		}else{//�Ǹ��˿ͻ�����
			if(CurUser.hasRole("482")){//֧��С΢�ͻ������µĸ��˿ͻ��ǿ��԰���С΢ҵ���
				if(sType.equals("0010")){//����ҵ������
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '3010%' or ImageTypeNo like '6020010%') )  ";
				}else if(sType.equals("0020")){//��������
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '4010%' or ImageTypeNo like '4020%') )  "; */
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '6020020%' or ImageTypeNo like '6020030%' or ImageTypeNo like '6020040%' or ImageTypeNo like '6020050%') )  ";
				}else if(sType.equals("0030")){//�����������
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '3030%' or ImageTypeNo like '6030%'  )  ";
				}else if(sType.equals("0040")){//��������
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '6010%' )  ";
				}else if(sType.equals("0050")){//��������
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo like '50%'  "; */
					sAppend += " and TypeNo is null ";
				}else if(sType.equals("0060")){//����
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '4010%' or ImageTypeNo like '4020%') )  "; */
					sAppend = " and ECM_IMAGE_TYPE.TypeNo Like '" + sFilter + "%' ";
				}
			}else{//��С΢�ͻ��������Ĺ�˾ҵ��
				if(sType.equals("0010")){//����ҵ������
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '3010%'  )  ";
				}else if(sType.equals("0020")){//��������
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '3020%'  )  ";
				}else if(sType.equals("0030")){//�����������
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '3030%'  )  ";
				}else if(sType.equals("0040")){//��������
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '4030%'  )  "; */
					sAppend += " and TypeNo is null ";
				}else if(sType.equals("0050")){//��������
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo like '50%'  "; */
					sAppend += " and TypeNo is null ";
				}else if(sType.equals("0060")){//����
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '4010%' or ImageTypeNo like '4020%') )  "; */
					sAppend = " and ECM_IMAGE_TYPE.TypeNo Like '" + sFilter + "%' ";
				}
			}
		}
		
		sFilter = "%";
	}
	
	//������ͼ�ṹ
	String sSqlTreeView = "from ECM_IMAGE_TYPE where  IsInUse = '1' " + sAppend;
	//tviTemp.initWithSql("TypeNo","case when (Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.documentId is not null and ECM_PAGE.TypeNo Like ECM_IMAGE_TYPE.TypeNo || '%') > 0 then ( TypeName || '( <font color=\"red\">' || (Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.TypeNo Like ECM_IMAGE_TYPE.TypeNo || '%') || '</font> ��)') else TypeName end as TypeName ","TypeName","","",sSqlTreeView,"Order By TypeNo",Sqlca);
		tviTemp.initWithSql("TypeNo","TypeName","","","",sSqlTreeView,"Order By TypeNo",Sqlca);
	//��ѯ����
	String querySumSql = "select count(*) as cc, typeNo from ECM_PAGE where ECM_PAGE.objectNo='"+sObjectNo+"' and  ECM_PAGE.documentId is not null and length(ECM_PAGE.documentId)>0 group  by ECM_PAGE.typeNo ";
	ASResultSet rs = Sqlca.getASResultSet(querySumSql);
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
		if( sCurItemID != "null" && sCurItemID != "root" && hasChild(getCurTVItem().id) ){
			var param = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&TypeNo="+sCurItemID;
			var sReadOnly = "<%=sRight%>";
			if(sReadOnly == "All"){
				openComp("ImagePageAc", "/ImageManage/ImagePageAc.jsp", param, "right" );
			}else{
				openComp("ImageTrans", "/ImageTrans/ImageTrans.jsp", param, "right" );	
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
			//if( !hasChild(nodes[i].id) ) expandNode( nodes[i].id );
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
		expandNode('root');
		selectItem(50);
	}
	
	initTreeView();
	expandAll();
</script>
<%@ include file="/IncludeEnd.jsp"%>
