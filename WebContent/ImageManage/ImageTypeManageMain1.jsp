<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��:Ӱ����������ҳ��
	 */
	String PG_TITLE = "Ӱ������������ҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;Ӱ������������ҳ��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "150";//Ĭ�ϵ�treeview���

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"Ӱ����������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
    //String sSqlTreeView = " from CODE_LIBRARY where CodeNo = 'ImageMain' and IsInUse='1' ";
	String sSqlTreeView = " from ECM_IMAGE_TYPE where length(typeNo)<=3 ";
    tviTemp.initWithSql("typeNo","typeName"," typeName ","","",sSqlTreeView,"Order By typeNo ",Sqlca);
	
	//�������ֶ�����ͼ�ṹ�ķ�����SQL���ɺʹ�������   �μ�View������ ExampleView.jsp��ExampleView01.jsp
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	/*function TreeViewOnClick() {
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1 = sCurItemDescribe[0];
		sCurItemDescribe2 = sCurItemDescribe[1];
		
		if ( sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root") {
			AsControl.OpenView( sCurItemDescribe1, sCurItemDescribe2, "right" );
			setTitle( "Ӱ������Ԥ��" );
		}
	}*/
	function TreeViewOnClick() {
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		openComp("ImageFileTypeList","/ImageManage/ImageFileTypeList.jsp","StartWithId="+sCurItemID, "right");
		//AsControl.OpenView( "/ImageManage/ImageTypeManageFrame.jsp", "StartWithId="+sCurItemID, "right" );
		setTitle( "Ӱ������Ԥ��" );
	}
	
	<%/*~[Describe=����treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		//selectItemByName("�ļ�����");	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��
		selectItem(10);
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
