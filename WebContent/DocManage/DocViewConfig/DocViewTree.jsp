<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��:ʾ��������Ϣ�鿴ҳ��--
	 */
	String PG_TITLE = "SQL������ͼ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;SQL������ͼ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//���ҳ�����
	String sExampleId = CurComp.getParameter("ObjectNo");
	String sViewId = CurComp.getParameter("ViewId");

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"SQL������ͼ","right");
	tviTemp.ImageDirectory = ""; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	//���һ�� ����ҵ�������������� �˵�
	//tviTemp.insertPage("000", "root", "ҵ��������������", "GoDocCDConfig", "", 3);
	//tviTemp.initWithSql("FOLDERID","FOLDERNAME","FOLDERNAME","","",sSqlTreeView,"Order By FOLDERID",Sqlca);
	String sSqlTreeView = "select dvc.folderid,dvc.parentfolder,dvc.foldername,dvc.viewid from doc_view_catalog dvc where 1=1 order by dvc.viewid,dvc.folderid";
	try{
		ASResultSet rs = Sqlca.getASResultSet(sSqlTreeView);
		while(rs.next()){
			String root = rs.getString(2);
			if(root.equals("")) root="root";
			tviTemp.insertFolder(rs.getString(1), root, rs.getString(3), rs.getString(3)+","+rs.getString(1)+","+rs.getString(4), "", 3);
		}
	}catch(Exception e){
		e.fillInStackTrace();
	}
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	String sButtons[][] = {
			{"true","All","Button","����","����һ����¼","newRecord()","","","","btn_icon_add"},
			{"false","All","Button","����","���ø�����¼","changeMenuState('1')","","","",""},
			{"false","All","Button","ͣ��","ͣ�ø�����¼","changeMenuState('2')","","","",""},
			{"true","All","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","","btn_icon_delete"},
			{"true","","Button","ˢ��","ˢ�µ�ǰҳ��","reloadSelf()","","","",""},
	};
	
%><%@include file="/Resources/CodeParts/View07.jsp"%>
<script type="text/javascript"> 	
	
	<%/*[Describe=������¼;]*/%>
	function newRecord(){
		//��ȡ�����ڵ�ı��	 
		var sSortNo = getCurTVItem().id; //���ݲ˵������ɣ�����ȡ���ǲ˵������
		var sMenuValue = getCurTVItem().value;
		var sParentViewId = sMenuValue.split(",")[2];
		var sParentFolder = sMenuValue.split(",")[1];
		if("undefined" == sParentFolder || "null"==sParentFolder || typeof(sParentFolder)=="undefined" || sParentFolder.length==0){
			sParentFolder = "root";
		}
		var sPara = "";
		if("GoDocCDConfig"==sMenuValue || !sMenuValue){
			if(confirm("�Ƿ���"+getCurTVItem().name+"������")){
				sPara = "ParentFolder="+sFolderId;
			} else {
				sPara = "ParentFolder=root";
			}
		}
		 var sViewId = getSerialNo("DOC_VIEW_CATALOG","VIEWID","");
		 var sFolderId  = getSerialNo("DOC_VIEW_CATALOG","FOLDERID","");
		 var sUrl = "/DocManage/DocViewConfig/DocViewInfo.jsp";
		 sPara = sPara + "&GoBackType=1";
		 sPara = sPara + "&ViewId="+sViewId+"&FolderId="+sFolderId+"&ParentFolder="+sParentFolder;
		 AsControl.OpenPage(sUrl,sPara,'right','');
	}
	
	function changeMenuState(sChange){ // ���� 1��ͣ�� 2
		var sSortNo = getCurTVItem().id; //���ݲ˵������ɣ�����ȡ���ǲ˵������
		var sMenuValue = getCurTVItem().value;
		var sViewId = sMenuValue.split(",")[2];
		var sFolderId = sMenuValue.split(",")[1];
		if("GoDocCDConfig"==sMenuValue || !sMenuValue){
			alert(getMessageText('AWEW1001'));//��ѡ��һ����Ϣ��
			return ;
		}
		var sAction = "";
		if(sChange == "1") sAction = "����";
		else if(sChange == "2") sAction = "ͣ��";
		else sAction = "����";
		var sSql = "update doc_view_catalog set status='"+sChange+"' where viewid='"+sViewId+"' and folderid='"+sFolderId+"'";
		var sReturn = RunMethod("PublicMethod","RunSql",sSql);
		if(sReturn != 1){
			alert(sAction+"�ò˵���ʧ�ܣ�");
		}else{
		    alert("����Ŀ��"+sAction+"�ɹ���");
		}
	}

	<%/*[Describe=ɾ����¼;]*/%>
	function deleteRecord(){
		var sSortNo = getCurTVItem().id; //���ݲ˵������ɣ�����ȡ���ǲ˵������
		var sMenuValue = getCurTVItem().value;
		var sViewId = sMenuValue.split(",")[2];
		var sFolderId = sMenuValue.split(",")[1];
		if("GoDocCDConfig"==sMenuValue || !sMenuValue){
			alert(getMessageText('AWEW1001'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm("��ȷ��ɾ����")){
			var sReturn = RunJavaMethodTrans("com.amarsoft.app.bizmethod.DeleteDocCatalog","deleteDocCatalog","viewID="+sViewId+",folderID="+sFolderId);
			if(sReturn != 1){
				alert("ɾ���ò˵���ʧ�ܣ�");
			}else{
			    alert("�ò˵���ɾ���ɹ���");
			    reloadSelf();
			}
		}
	}
	
	function openChildComp(sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		/*
		 * ������������
		 * ToInheritObj:�Ƿ񽫶����Ȩ��״̬��ر��������������
		 * OpenerFunctionName:�����Զ�ע�����������REG_FUNCTION_DEF.TargetComp��
		 */
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		AsControl.OpenView(sURL,sParaStringTmp,"frameright");
	}
	
	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var sSortNo = getCurTVItem().id; //���ݲ˵������ɣ�����ȡ���ǲ˵������
		var sMenuValue = getCurTVItem().value;
		var sViewId = sMenuValue.split(",")[2];
		var sFolderId = sMenuValue.split(",")[1];
		var sCurItemname = getCurTVItem().name;
		var sReturnValue = PopPageAjax("/DocManage/DocViewConfig/SelectParentfolderAjax.jsp?FolderId="+sFolderId,"","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
		if("GoDocCDConfig"==sMenuValue || !sMenuValue){
			//openChildComp("/DocManage/DocViewConfig/DocViewFileList.jsp","FolderId=root&ViewId=root");
		}else{
			openChildComp("/DocManage/DocViewConfig/DocViewFileList.jsp","FolderId="+sFolderId+"&ViewId="+sViewId);
		} 
		setTitle(getCurTVItem().name);  
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("ҵ��������������");
	}
		
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
