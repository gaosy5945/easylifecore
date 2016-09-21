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
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sFolderId);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","","Button","删除","删除","deleteRecord()","","","","btn_icon_delete",""},
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
			alert("参数不能为空！");
			return ;
		 } */
		AsControl.PopComp(sUrl,'ViewId=' + sViewId + "&FolderId=" + sFolderId  + "&FileId=" + sFileId ,"","");
	}
	function deleteRecord(){
		 var sViewId = getItemValue(0,getRow(0),'VIEWID');
		 var sFolderId = getItemValue(0,getRow(0),'FOLDERID');
		 var sFileId = getItemValue(0,getRow(0),'FILEID');
		if(confirm('确实要删除吗?')){
			//as_delete(0);
			var sSql = "delete doc_view_file   where viewid='"+sViewId+"' and folderid='"+sFolderId+"' and fileid='"+sFileId+"'";
			var sReturn = RunMethod("PublicMethod","RunSql",sSql);
			if(sReturn != 1){
				alert("删除失败！");
			}else{
				var sSql1 = "delete doc_file_config   where  fileid='"+sFileId+"'";
				var sReturn = RunMethod("PublicMethod","RunSql",sSql1);
				alert("删除成功！");
				reloadSelf();
			}
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
