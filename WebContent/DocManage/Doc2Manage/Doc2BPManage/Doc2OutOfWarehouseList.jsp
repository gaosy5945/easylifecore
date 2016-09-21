<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String status = CurPage.getParameter("Status"); 
	if(status == null || status == "nulll" || "null".equals(status))status = "";
	String sWhereSql = "";
	ASObjectModel doTemp = new ASObjectModel("Doc2ManageOutViewList");//Doc2OutOfWarehouseApplyList  Doc2ManageOutViewList  Doc2ManageViewList
	doTemp.setHeader("SERIALNO","出库编号");
	sWhereSql = " O.SERIALNO=DO.OBJECTNO AND O.packageType='02'  and O.Status=:Status and do.status='01' and DO.transactioncode in('0020','0030') and DO.inputuserid ='"+ CurUser.getUserID() +"' ";//and DFP.POSITION is not null
	doTemp.setJboWhere(sWhereSql);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.MultiSelect = true;
	
	dwTemp.setParameter("Status", status);
	dwTemp.setParameter("OrgID", CurOrg.getOrgID());
	
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","归还入库","归还入库","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			//{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var sSerialNoList = "";
		var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("您没有勾选任何行！");
			 return;
		 }else{
			 if(confirm("是否归还入库?")){//您确定将选中的档案已归还入库
				for(var i=0;i<arr.length;i++){
				 var sDfpSerialNo = getItemValue(0, arr[i], "PACKAGESERIALNO");
					var sDOSerialNo = getItemValue(0, arr[i], "SERIALNO");
					if(typeof(sDfpSerialNo)=="undefined" || sDfpSerialNo.length==0 ){
							alert(getHtmlMessage('1'));//请选择一条信息！
							return ;
					}
					var sPara = "DFPSerialNo="+sDfpSerialNo+",DOSerialNo="+sDOSerialNo+",OutType=03,TransCode=0040,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
						var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.DocOutManageAction", "doOutWarehouse", sPara);
				
						if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'){
						 	/* var serialNo = returnValue;
						 	var sOperationStatus = "04";
						 	AsControl.PopComp("/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseView.jsp","SerialNo=" +serialNo+"&OperationType=0020&OperationStatus="+sOperationStatus+"&RightType=All&DocType=02",'');
							 */
							sSerialNoList += sDOSerialNo + ","; 
						}
				 }
				if(sSerialNoList.split(",").length>0){
					 alert("出库编号："+sSerialNoList+"已成功归还入库！");
					 reloadSelf();	
				}else{
					alert("归还入库失败！");
				} 
			 }
		 }
	}
	function edit(){
		var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseView.jsp";
		 var sSerialNo = getItemValue(0,getRow(0),'SerialNo');
		 var sObjectType = getItemValue(0,getRow(0),'ObjectType');
		 var sObjectNo = getItemValue(0,getRow(0),'ObjectNo');
		 if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		 var  sRightType = "ReadOnly";
		AsControl.PopComp(sUrl,"SerialNo=" +sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&OperationType=0020&DocType=02&RightType="+sRightType,'');
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
