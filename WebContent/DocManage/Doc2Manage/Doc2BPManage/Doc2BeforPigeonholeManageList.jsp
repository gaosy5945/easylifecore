<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String opStatus = CurPage.getParameter("OpStatus");//预归档状态
	String flag = CurPage.getParameter("Flag");//是否专夹保管
	if(opStatus == null) opStatus = "";
	if(flag ==  null) flag = "";
	String transactionCode = CurPage.getParameter("TransactionCode"); 
	String sExistsWhere = "";
	ASObjectModel doTemp = new ASObjectModel("Doc2BeforPigeonholeManageList");
	//显示不同界面
	if("Y".equals(flag)){
		doTemp.appendJboWhere(" and dfp.position is not null ");
	} 
	//doTemp.setHtmlEvent("OBJECTTYPE", "OnChange", "selectDocType()","");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	
	dwTemp.setParameter("Status", opStatus);
	dwTemp.setParameter("OrgID", CurOrg.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"false","","Button","专夹保管","专夹保管","specialKeeping()","","","","btn_icon_add",""},
			{"true","","Button","影像扫描","影像扫描","imageScanning()","","","","btn_icon_add",""},
			{"true","","Button","取消","取消","cancleRecord()","","","","btn_icon_delete",""},
			{"false","","Button","预归档","预归档","submitRecord()","","","","",""}
		};
	if("03".equals(opStatus) && "N".equals(flag)){
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
	}else if("03".equals(opStatus) && "Y".equals(flag)){
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[5][0] = "false";
	}
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	//新增
	function add(){
		 var sAddDialogUrl = "/DocManage/Doc2Manage/Doc2BPManage/DocOperationAddDialog.jsp";//+"OperationType=02";
		 var dialogStyle = "dialogWidth=450px;dialogHeight=300px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
		 var returnValue = AsControl.PopComp(sAddDialogUrl,"TransactionCode=0000",dialogStyle);
		 
		 if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'){
			serialNo = returnValue;
		 	AsCredit.openFunction("BusinessDocInfo","SerialNo="+serialNo);
			reloadSelf();
		 } 
		 self.reloadSelf();
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

	function specialKeeping(){
		var sSerialNo = getItemValue(0,getRow(0),'SerialNo');
		if(sSerialNo == null) sSerialNo = "";
		var sObjectType = getItemValue(0,getRow(0),'ObjectType');
		if(sObjectType == null) sObjectType = "";
		var sObjectNo = getItemValue(0,getRow(0),'ObjectNo');
		if(sObjectNo == null) sObjectNo = "";
		var sParaValue = "SerialNo="+sSerialNo + "&ObjectType=" + sObjectType + "&ObjectNo=" + sObjectNo+"&KeepingType=0201";
		var returnValue = PopPage("/DocManage/Doc2Manage/Doc2BPManage/DocWarehouseAddDialog.jsp?"+sParaValue,"","resizable=yes;dialogWidth=500;dialogHeight=200;center:yes;status:no;statusbar:no");
		returnValue = returnValue.split("@");
		var returnSerialNo = returnValue[1];
		if(returnSerialNo == null || returnSerialNo == "undefine" || returnSerialNo == "null"){
			returnSerialNo = "";
		}
		if(returnValue[0] == "TRUE"){
			alert(returnSerialNo+"专夹保管成功！");
		}else {
			alert(returnSerialNo+"专夹保管失败！");
		}
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
	
	function cancleRecord(){
		var opStatus = "<%=opStatus%>";
		var flag = "<%=flag%>";
		if(opStatus == "03"  && "Y" == flag) {
			if(confirm('确实要取消专夹保管吗?')) {//取消专夹保管，将位置置为空
				var sDOObjectType = getItemValue(0,getRow(0),'ObjectType');
				if(sDOObjectType == null) sObjesDOObjectTypectType = "";
				var sObjectNo = getItemValue(0,getRow(0),'ObjectNo');
				if(sObjectNo == null) sObjectNo = "";
				var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
				if(sDOSerialNo == null) sDOSerialNo = "";
				var sUserId = "<%=CurUser.getUserID()%>";
				var sOrgId = "<%=CurUser.getOrgID()%>";
				var sDate = "<%=StringFunction.getToday()%>";
				var sOperationType = "";//预归档
				var sRemark = "";
				var sPosition = "";//取消专夹保管  专夹架位
				var sMsg = "";
				var sPara = "OperationType="+sOperationType+"&DOSerialNo="+sDOSerialNo+"&ObjectType="+sDOObjectType+"&ObjectNo="+sObjectNo+"&Position="+sPosition+"&KeepingType=0101";
				var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2specialKeepingAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");//
				if(sReturn || (typeof(sReturn)!="undefined" && sReturn=="true")){
					var sReturnValue =  RunMethod("PublicMethod","UpdateDocOperationSql","01,"+sRemark+","+sUserId+","+sDate+","+sDOSerialNo+"");
					if(sReturnValue >0){ 
						sMsg = "取消专夹保管成功";
					}else {
						sMsg = "取消专夹保管失败";	
					}
				} else {
					sMsg = "取消专夹保管失败";
				}
				alert(sMsg);
			}
		}
		else
		{
			if(confirm('确实要取消吗?')) {
				//as_delete(0,'alert(getRowCount(0))');
				var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
				if(sDOSerialNo == null) sDOSerialNo = "";
				var sSql = "  delete doc_operation_file dof where dof.operationserialno='"+sDOSerialNo+"'";
				var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
				if(sReturnValue > -1){ 
					as_delete(0);
					sMsg = "取消成功！";
				}else {
					sMsg = "取消失败！";
				}
			}
		}
		reloadSelf();
	}

	//预归档
	function submitRecord(){
		var sDOObjectType = getItemValue(0,getRow(0),'ObjectType');
		if(sDOObjectType == null) sObjesDOObjectTypectType = "";
		var sObjectNo = getItemValue(0,getRow(0),'ObjectNo');
		if(sObjectNo == null) sObjectNo = "";
		var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		if(sDOSerialNo == null) sDOSerialNo = "";
		var sOperationType = "0010";//预归档
		var sPosition = "";//取消专夹保管  专夹架位
		var sPara = "OperationType="+sOperationType+"&DOSerialNo="+sDOSerialNo+"&ObjectType="+sDOObjectType+"&ObjectNo="+sObjectNo+"&Position="+sPosition;
		//插入一条操作数据
		var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2submitAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");//
		if(sReturn || (typeof(sReturn)!="undefined" && sReturn=="true")){
			var sSql = "update doc_operation set status='0201' where serialno='" +sDOSerialNo+"'";
			var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
			if(sReturnValue >0){
				alert("预归档成功");
				reloadSelf();
			}
		}
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
