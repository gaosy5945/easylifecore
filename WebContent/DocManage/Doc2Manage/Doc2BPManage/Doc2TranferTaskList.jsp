<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sTranferType = CurPage.getParameter("TranferType");
	if(sTranferType == null) sTranferType = "";
	String sWhereSql = "";
	ASObjectModel doTemp = new ASObjectModel("Doc2TranferTaskList");

	if("0010".equals(sTranferType) || "0010" == sTranferType){
		sWhereSql = " and O.status ='01' and O.OPERATEUSERID ='"+CurUser.getUserID()+"' ";//待移库
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	}
	if("0020".equals(sTranferType) || "0020" == sTranferType){
		sWhereSql = " and O.status ='02' and O.OPERATEUSERID ='"+CurUser.getUserID()+"' ";//已移库
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","","Button","移库","移库","tranferRecord()","","","","btn_icon_delete",""},
			{"true","","Button","删除","删除","deleteRecord()","","","","btn_icon_delete",""},
			{"true","","Button","打印移库清单","打印移库清单","printTranfer()","","","","btn_icon_detail",""},
		};

	if("0010".equals(sTranferType) || "0010" == sTranferType){
		sButtons[4][0] ="false";
	}else	if("0020".equals(sTranferType) || "0020" == sTranferType){
		sButtons[0][0] ="false";
		sButtons[2][0] ="false";
		sButtons[3][0] ="false";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var sPTISerialNo = getSerialNo("PUB_TASK_INFO","SerialNo","");
		var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2TranferTaskView.jsp";
		AsControl.OpenPage(sUrl,"PTISerialNo=" +sPTISerialNo ,'_self','');
		reloadSelf();
	}
	function edit(){
		 var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2TranferTaskView.jsp";
		 var sPTISerialNo = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPTISerialNo)=="undefined" || sPTISerialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		AsControl.OpenPage(sUrl,"PTISerialNo=" +sPTISerialNo,'_self','');
	}
	function tranferRecord(){
		 var sPTISerialNo = getItemValue(0,getRow(0),'SerialNo');
		//1.当前批次关联的业务资料（DOC_OPERATION,DOC_FILE_PACKAGE）  置为：已移库，2.当前批次（PUB_TASK_INFO） 置为：已移库
		if(confirm('确实要移库吗?')){
			var sSql1 = "update pub_task_info  set status='02' where serialno='" +sPTISerialNo+"'";
			var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql1);//删除DO表（关联的业务资料信息）
			if(sReturnValue > -1 ){
				//将相关联的业务资料信息置为已移库 09 已移库  do，dfp
				//var sSql1 = "update doc_file_package  set status='09' where serialno='" +sPTISerialNo+"'";
				//var sReturnValue1 =  RunMethod("PublicMethod","RunSql",sSql1);//删除DO表（关联的业务资料信息）
				//if(sReturnValue1 > -1 ){
					alert("移库成功！");
				//}
				reloadSelf();
			}
		}
	}
	function deleteRecord(){
		var sPTISerialNo = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPTISerialNo)=="undefined" || sPTISerialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		 if(confirm('确实要删除吗?')){
				var sSql1 = "delete doc_operation do where do.taskserialno='" +sPTISerialNo+"'";
				var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql1);//删除DO表（关联的业务资料信息）
				if(sReturnValue > -1 ){
					as_delete(0);//删除当前批次信息
					//alert("删除移库申请成功！");
					reloadSelf();
				}
			}
	}
	function printTranfer(){
		alert("printTranfer");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
