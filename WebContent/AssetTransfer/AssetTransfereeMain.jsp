<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��:�ʲ������б�
	 */
	String PG_TITLE = "�ʲ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�ʲ�������ҳ��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�ʲ�������ҳ��","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo='AssetTransferTree' and IsInUse='1' and (itemNo like '02%' or itemNo like '03%')";
	tviTemp.initWithSql("SortNo","ItemName","","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		var sUrl = "/AssetTransfer/AssetTransfereeList.jsp";
		
		if(sCurItemID == '0201'){
			AsControl.OpenView(sUrl,"projectStatus=010","right");//�½�
		}else if(sCurItemID == '0202'){
			AsControl.OpenView(sUrl,"projectStatus=020","right");//���ˣ���Ч��
		}else if(sCurItemID == '0203'){
			AsControl.OpenView(sUrl,"projectStatus=040","right");//����
		}else if(sCurItemID == '0204'){
			AsControl.OpenView(sUrl,"projectStatus=050","right");//�鵵
		}else if(sCurItemID == '03'){//��Ŀ��ز�ѯ
			AsControl.OpenView("/AssetTransfer/AssetProjectQueryList.jsp","AssetProjectType=020","right");
		}else{
			return;
		}
		
		setTitle(sCurItemname);
	}
	
	<%/*~[Describe=����treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		expandNode('02');
		selectItem('0201');
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>