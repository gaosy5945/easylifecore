<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��:�ʲ�ת���б�
	 */
	String PG_TITLE = "�ʲ�ת��"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�ʲ�ת����ҳ��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�ʲ�ת����ҳ��","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo='AssetTransferTree' and IsInUse='1' and (itemNo like '01%' or itemNo like '03%')";
	tviTemp.initWithSql("SortNo","ItemName","","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		var sUrl = "/AssetTransfer/AssetTransferList.jsp";
		
		if(sCurItemID == '0101'){//�ѽ�����Ŀ
			AsControl.OpenView(sUrl,"projectStatus=010","right");
		}else if(sCurItemID == '0102'){//����Ч��Ŀ
			AsControl.OpenView(sUrl,"projectStatus=020","right");
		}else if(sCurItemID == '0103'){//�ѽ�����Ŀ
			AsControl.OpenView(sUrl,"projectStatus=030","right");
		}else if(sCurItemID == '0104'){//�ѽ�����Ŀ
			AsControl.OpenView(sUrl,"projectStatus=040","right");
		}else if(sCurItemID == '0105'){//�ѹ鵵��Ŀ
			AsControl.OpenView(sUrl,"projectStatus=050","right");
		}else if(sCurItemID == '03'){//��Ŀ��ز�ѯ
			AsControl.OpenView("/AssetTransfer/AssetProjectQueryList.jsp","AssetProjectType=010","right");
		}else{
			return;
		}
		
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=����treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		expandNode('01');
		selectItem('0101');
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>