<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	//得到当前用户id
	String sUserId = CurUser.getUserID();
	
	ASObjectModel doTemp = new ASObjectModel("DocClassifyDirectoryConfigList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.MultiSelect = true; //允许多选
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sUserId);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var sViewId = getSerialNo("DOC_VIEW_CATALOG","VIEWID","");
		 var sFolderId  = getSerialNo("DOC_VIEW_CATALOG","FOLDERID","");
		 var sFileId  = getSerialNo("DOC_FILE_CONFIG","FILEID","");
		 var sUrl = "/DocManage/DocListDefinition/DocClassifyDirectoryConfigInfo.jsp";
		 AsControl.OpenPage(sUrl,'ViewId='+sViewId+'&FolderId='+sFolderId+'&FileId='+sFileId,'_self','');
	}
	function edit(){
		 var sUrl = "/DocManage/DocListDefinition/DocClassifyDirectoryConfigInfo.jsp";
		 var sFolderId = getItemValue(0,getRow(0),'FOLDERID');
		 var sViewId = getItemValue(0,getRow(0),'VIEWID');
		 var sFileId = getItemValue(0,getRow(0),'FILEID');
		 if(typeof(sFolderId)=="undefined" || sFolderId.length==0 || typeof(sViewId)=="undefined" || sViewId.length==0 || typeof(sFileId)=="undefined" || sFileId.length==0 ){
			alert("请选择一条信息！");
			return ;
		 }
		AsControl.OpenPage(sUrl,'ViewId='+sViewId+'&FolderId='+sFolderId+'&FileId='+sFileId,'_self','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
