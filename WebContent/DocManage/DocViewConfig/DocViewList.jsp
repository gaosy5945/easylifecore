<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sFolderId = (String)CurComp.getParameter("FolderId");
	if(null==sFolderId) sFolderId="";
	String sViewId = (String)CurComp.getParameter("ViewId");
	if(null==sViewId) sViewId="";
	
	ASObjectModel doTemp = new ASObjectModel("DocViewList");
	if(!"".equals(sFolderId) && null != sFolderId  && !"root".equals(sFolderId) &&  "root" != sFolderId){
		doTemp.setJboWhere(doTemp.getJboWhere()+" and parentFolder = '"+sFolderId+"'");
	} 
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	<%/*记录被选中时触发事件*/%>
	function mySelectRow(){
		 var sFolderId = getItemValue(0,getRow(0),'FOLDERID');
		 var sViewId = getItemValue(0,getRow(0),'VIEWID');
		if(typeof(sFolderId)=="undefined" || sFolderId.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","rightdown","");
		}else{
			AsControl.OpenView("/DocManage/DocViewConfig/DocViewFileList.jsp","ViewId="+sViewId+"&FolderId="+sFolderId,"rightdown","");
		}
	}

</script>	
<script type="text/javascript">
	function add(){
		 var sViewId = getSerialNo("DOC_VIEW_CATALOG","VIEWID","");
		 var sFolderId  = getSerialNo("DOC_VIEW_CATALOG","FOLDERID","");
		 var sUrl = "/DocManage/DocViewConfig/DocViewInfo.jsp";
		 AsControl.OpenView(sUrl,"ViewId="+sViewId+"&FolderId="+sFolderId+"&ParentFolder="+"<%=sFolderId%>",'rightup','');
		 reloadSelf();
	}
	function edit(){
		 var sUrl = "/DocManage/DocViewConfig/DocViewInfo.jsp";
		 var sViewId = getItemValue(0,getRow(0),'VIEWID');
		 var sFolderId = getItemValue(0,getRow(0),'FOLDERID');
		 if(typeof(sFolderId)=="undefined" || sFolderId.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		AsControl.OpenView(sUrl,'ViewId=' + sViewId + "&FolderId=" + sFolderId ,'_self','');
		 reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
