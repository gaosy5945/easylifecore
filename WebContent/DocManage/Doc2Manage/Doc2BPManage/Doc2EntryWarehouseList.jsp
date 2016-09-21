<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String transactionCode = CurPage.getParameter("TransactionCode");
	String status = CurPage.getParameter("Status");
	
	ASObjectModel doTemp = new ASObjectModel("Doc2EntryWarehouseList");//Doc2OutOfWarehouseApplyList
	if(!"".equals(transactionCode)&&!"0000".equals(transactionCode)){
		doTemp.setHeader("SERIALNO","入库编号");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.MultiSelect = true;
	dwTemp.setPageSize(15);
	
	dwTemp.setParameter("TransactionCode", transactionCode);
	dwTemp.setParameter("Status", status);
	dwTemp.setParameter("OrgID", CurOrg.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"false","All","Button","影像扫描","影像扫描","imageScanning()","","","","btn_icon_add",""},
			{"true","","Button","取消","取消","cancelRecord()","","","","btn_icon_detail",""},
			{"true","All","Button","清单打印","清单打印","printList()","","","","btn_icon_add",""},
			{"true","All","Button","提交","二类资料批量入库","entryWarehouse()","","","","btn_icon_add",""}
		};
	if("0040".equals(transactionCode)){
		sButtons[0][3] = "归还入库";
		sButtons[0][5] = "add3()";
		//sButtons[8][0] = "true";
	}else if("0015".equals(transactionCode)){
		sButtons[0][3] = "补充入库";
		sButtons[0][5] = "add1()";
	}else if("0010".equals(transactionCode)){
		sButtons[0][3] = "新增入库";
	}else{
		sButtons[0][0] = "false";
		sButtons[3][0] = "false";
		sButtons[5][0] = "true";
		sButtons[6][0] = "false";
		sButtons[7][0] = "true";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	function add1(){//补充入库
		var sAddDialogUrl = "/DocManage/Doc2Manage/Doc2BPManage/DocOperationAddDialog.jsp";//+"OperationType=02";
		var dialogStyle = "dialogWidth=450px;dialogHeight=300px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
		var returnValue = AsControl.PopComp(sAddDialogUrl,"",dialogStyle);
		
		if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'){
		 	var serialNo = returnValue;
		 	AsCredit.openFunction("BusinessDocInfo","SerialNo="+serialNo);
			reloadSelf();
		 }
		
		reloadSelf();
	}
	
	function add(){//新建入库
		 var sAddDialogUrl = "/DocManage/Doc2Manage/Doc2BPManage/DocOperationAddDialog.jsp";//+"OperationType=02";
		 var dialogStyle = "dialogWidth=450px;dialogHeight=300px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
		 var returnValue = AsControl.PopComp(sAddDialogUrl,"",dialogStyle);
		 if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'){
		 	var serialNo = returnValue;
		 	AsCredit.openFunction("BusinessDocInfo","SerialNo="+serialNo);
			reloadSelf();
		 }
	}

	function add3(){//归还入库
		var sAddDialogUrl = "/DocManage/Doc2Manage/Doc2BPManage/DocOperationAddDialog.jsp";//+"OperationType=02";
		var dialogStyle = "dialogWidth=450px;dialogHeight=300px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
		var returnValue = AsControl.PopComp(sAddDialogUrl,"",dialogStyle);
		if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'){
			var serialNo = returnValue;
			AsCredit.openFunction("BusinessDocInfo","SerialNo="+serialNo);
			reloadSelf();
		}
		reloadSelf();
	}
	
	function edit(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		AsCredit.openFunction("BusinessDocInfo","SerialNo="+serialNo);
		reloadSelf();
	}
	
	function imageScanning(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		AsCredit.openFunction("ImageDocInfo","SerialNo="+serialNo);
		reloadSelf();
	}
	
	function cancelRecord(){
		if(confirm('确实要取消吗?'))as_delete(0);
	}
	
	function printList(){
		//待入库tab页面，需要校验多选框只能勾选一个。
		if("0010"=="<%=transactionCode%>" || "0015"=="<%=transactionCode%>"){
			 var arr = new Array();
			 arr = getCheckedRows(0);
			 if(arr.length < 1){
				 alert("您没有勾选任何行！");
				 return ;
			 }else if(arr.length > 1){
				 alert("只能选择一条业务资料信息进行打印，请重新选择！");
				 return ;
			 }
		}
		
		 var sObjectNo = getItemValue(0, getRow(), "OBJECTNO");
		 if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0 ){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return ;
		 }
		 var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2MaterialList.jsp";
		 AsControl.PopComp(sUrl,"SerialNo="+sObjectNo,"");
	}
	
	//入库操作
	function entryWarehouse(){
		var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("您没有勾选任何行！");
		 }else{
			if(confirm('是否确定入库 ?')){ 
				 for(var i=0;i<arr.length;i++){
					 var serialNo = getItemValue(0,arr[i],"SERIALNO");
					 var transactionCode = getItemValue(0,arr[i],"TransactionCode");
					 var opStatus = getItemValue(0,arr[i],"STATUS");
					 var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc2ManageAction","commit","SerialNo="+serialNo+",TransactionCode="+transactionCode+",Status="+opStatus);
				 
				 }
				 if(returnValue == "提交成功！"){
						 alert("入库成功！");
				 }else {
						 alert("入库失败!");
					     return;
			    }  
			 }
		  }
		 reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
