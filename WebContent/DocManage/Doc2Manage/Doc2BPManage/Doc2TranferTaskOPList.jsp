<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sPTISerialNo = (String)CurPage.getParameter("PTISerialNo");
	if(null==sPTISerialNo) sPTISerialNo="";
	ASObjectModel doTemp = new ASObjectModel("Doc2TranferTaskOPList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.MultiSelect = true;
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sPTISerialNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","引入相关业务资料","引入相关业务资料","add()","","","","btn_icon_add",""},
			{"true","","Button","业务资料详情","业务资料详情","edit()","","","","btn_icon_detail",""},
			{"true","","Button","删除引入","删除引入","deleteRecord()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		if(checkHavePTI()){//检查是否保存，即该批次流水号是否有存在pti表
			var sPTISerialNo = "<%=sPTISerialNo%>";
			 var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2TranferTaskOPAddList.jsp";
			 AsControl.OpenView(sUrl,'PTISerialNo='+sPTISerialNo,'_self','');
		}else {
			alert("请先保存该批次信息！");
		}
		 reloadSelf();
	}
	function checkHavePTI(){
		var sPTISerialNo = "<%=sPTISerialNo%>";
		var returnValue = false;
		if(sPTISerialNo != "" || sPTISerialNo != null){
			//RunMethod("PublicMethod","UpdateDocOperationSql","01,"+sRemark+","+sUserId+","+sDate+","+sDOSerialNo+"");
			var sSql ="select count(serialNo) as cnt from Pub_task_info pti where pti.serialno='"+sPTISerialNo+"'";
			var sReturn = RunMethod("PublicMethod","RunSql",sSql);
			if(sReturn == 1 || sReturn == "1"){
				returnValue = true;
			}else{
				returnValue = false;
			}
		}else {
			returnValue = false;
		}
		return returnValue;
	}
	function edit(){
		 var sPTISerialNo = "<%=sPTISerialNo%>";
		 var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/DocFilePackageInfo.jsp";
		 var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("您没有勾选任何行！");
		 }else if(arr.length >1){
			 alert("您选择了多行！");
		 }else{
			 for(var i=0;i<arr.length;i++){
				 var sDOSerialNo = getItemValue(0,arr[i],'SERIALNO');
				 var sPara = getItemValue(0,arr[i],'DFPSERIALNO');
				 alert(sDOSerialNo+","+sPara);
				 AsControl.OpenPage(sUrl,'DFPSerialNo=' +sPara +"&PTISerialNo="+sPTISerialNo ,'_self','');
			 }
		 }
	}
	
	function deleteRecord(){
		if(confirm('确实要删除吗?')){
			as_delete(0);
		}
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
