<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String sParentFolderId = CurPage.getParameter("ParentFolderId");
	if(sParentFolderId == null) sParentFolderId = "";

	ASObjectModel doTemp = new ASObjectModel("DocClassifyList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sParentFolderId);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var sViewId = getSerialNo("DOC_VIEW_CATALOG","VIEWID","");
		 var sFolderId  = getSerialNo("DOC_VIEW_CATALOG","FOLDERID","");
		 var sFileId  = getSerialNo("DOC_FILE_CONFIG","FILEID","");
		 var sParentFolderId = "<%=sParentFolderId%>";
		 var sUrl = "/DocManage/DocListDefinition/DocClassifyInfo.jsp";
		 AsControl.OpenPage(sUrl,'ViewId='+sViewId+'&FolderId='+sFolderId+'&FileId='+sFileId+'&ParentFolderId='+sParentFolderId,'_self','');
	}
	function edit(){
		 var sUrl = "/DocManage/DocListDefinition/DocClassifyInfo.jsp";
		 var sFolderId = getItemValue(0,getRow(0),'FOLDERID');
		 var sViewId = getItemValue(0,getRow(0),'VIEWID');
		 var sFileId = getItemValue(0,getRow(0),'FILEID');
		 var sParentFolderId = "<%=sParentFolderId%>";
		 if(typeof(sFolderId)=="undefined" || sFolderId.length==0 || typeof(sViewId)=="undefined" || sViewId.length==0 || typeof(sFileId)=="undefined" || sFileId.length==0 || typeof(sParentFolderId)=="undefined" || sParentFolderId.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.OpenPage(sUrl,'ViewId='+sViewId+'&FolderId='+sFolderId+'&FileId='+sFileId ,'_self','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
