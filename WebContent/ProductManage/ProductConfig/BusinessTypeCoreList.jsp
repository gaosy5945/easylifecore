<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("BusinessTypeCoreList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
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
	function add(){
		 AsControl.PopView("/ProductManage/ProductConfig/BusinessTypeCoreInfo.jsp", "","dialogWidth:400px;dialogHeight:250px;resizable:yes;scrollbars:no;status:no;help:no");
		 reloadSelf();
	}
	function edit(){
		 var itemNo = getItemValue(0,getRow(0),'ItemNo');
		 if(typeof(itemNo)=="undefined" || itemNo.length==0 ){
			 alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		 }
		 AsControl.PopView("/ProductManage/ProductConfig/BusinessTypeCoreInfo.jsp", "ItemNo="+itemNo,"dialogWidth:400px;dialogHeight:250px;resizable:yes;scrollbars:no;status:no;help:no");
		 reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
