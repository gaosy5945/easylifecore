<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sViewId = CurPage.getParameter("ViewId");
	if(sViewId == null) sViewId = "";
	String sFolderId = CurPage.getParameter("FolderId");
	if(sFolderId == null) sFolderId = "";
	String sFileId = CurPage.getParameter("FileId");
	if(sFileId == null) sFileId = "";
	String sParentFolderId = CurPage.getParameter("ParentFolderId");
	if(sParentFolderId == null) sParentFolderId = "";
	ASObjectModel doTemp = new ASObjectModel("DocViewFileList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sFolderId);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ��","ɾ��","deleteRecord()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var sPara = "ViewId=<%=sViewId%>&FolderId=<%=sFolderId%>";
		 var sUrl = "/DocManage/DocViewConfig/DocViewFileInfo.jsp";
		 AsControl.PopComp(sUrl,'','','');
		 self.reloadSelf();
	}
	function edit(){
		 var sUrl = "/DocManage/DocViewConfig/DocViewFileInfo.jsp";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 var sViewId = getItemValue(0,getRow(0),'VIEWID');
		 var sFolderId = getItemValue(0,getRow(0),'FOLDERID');
		 var sFileId = getItemValue(0,getRow(0),'FILEID');
		 /* if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 } */
		AsControl.PopComp(sUrl,'ViewId=' + sViewId + "&FolderId=" + sFolderId  + "&FileId=" + sFileId ,"","");
	}
	function deleteRecord(){
		 var sViewId = getItemValue(0,getRow(0),'VIEWID');
		 var sFolderId = getItemValue(0,getRow(0),'FOLDERID');
		 var sFileId = getItemValue(0,getRow(0),'FILEID');
		if(confirm('ȷʵҪɾ����?')){
			//as_delete(0);
			var sSql = "delete doc_view_file   where viewid='"+sViewId+"' and folderid='"+sFolderId+"' and fileid='"+sFileId+"'";
			var sReturn = RunMethod("PublicMethod","RunSql",sSql);
			if(sReturn != 1){
				alert("ɾ��ʧ�ܣ�");
			}else{
				var sSql1 = "delete doc_file_config   where  fileid='"+sFileId+"'";
				var sReturn = RunMethod("PublicMethod","RunSql",sSql1);
				alert("ɾ���ɹ���");
				reloadSelf();
			}
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
