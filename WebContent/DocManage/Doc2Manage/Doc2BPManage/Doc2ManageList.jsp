<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String status = CurPage.getParameter("Status"); 
	if(status == null || status == "nulll" || "null".equals(status))status = "";
	
	ASObjectModel doTemp = new ASObjectModel("Doc2ManageViewList");//Doc2OutOfWarehouseList
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	
	dwTemp.setParameter("Status", status);
	dwTemp.setParameter("OrgID", CurOrg.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","影像扫描","影像扫描","imageScanning()","","","","btn_icon_add",""},
			{"true","All","Button","清单打印","清单打印","printList()","","","","btn_icon_add",""},
			{"true","","Button","打印入库交接单","打印入库交接单","printEntryList()","","","","btn_icon_detail",""},
			{"false","","Button","上架","上架","EntryOfShelves()","","","","",""},
			{"false","","Button","出库","出库","OutOfShelves()","","","","btn_icon_add",""},
		};
	if("03".equals(status)){
		sButtons[1][0] = "false";
		sButtons[3][0] = "false";
		sButtons[5][0] = "true";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	
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
		 var sObjectNo = getItemValue(0, getRow(), "OBJECTNO");
		 if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0 ){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return ;
		 }
		 var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2MaterialList.jsp";
		 AsControl.PopComp(sUrl,"SerialNo="+sObjectNo,"");
	}
	function OutOfShelves(){
		var sDfpSerialNo = getItemValue(0, getRow(), "PACKAGESERIALNO");
		var sDOSerialNo = getItemValue(0, getRow(), "SERIALNO");
		if(typeof(sDfpSerialNo)=="undefined" || sDfpSerialNo.length==0 ){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return ;
		}
		var sPara = "DFPSerialNo="+sDfpSerialNo+",DOSerialNo="+sDOSerialNo+",OutType=02,TransCode=0020,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.DocOutManageAction", "doOutWarehouse", sPara);

		if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'){
		 	var serialNo = returnValue;
			var sOperationStatus = "04";
			AsControl.PopComp("/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseView.jsp","SerialNo="+serialNo+"&DoSerialNo="+sDOSerialNo+"&DFPSerialNo="+sDfpSerialNo+"&OperationType=0020&OperationStatus="+sOperationStatus+"&RightType=All&DocType=02",'');
			reloadSelf();
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
