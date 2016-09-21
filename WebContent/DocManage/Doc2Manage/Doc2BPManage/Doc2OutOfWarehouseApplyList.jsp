<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sApplyType = CurPage.getParameter("ApplyType");
	if(sApplyType == null) sApplyType = "";
	String sWhereSql = "";
	String sOperationStatus = "";
	ASObjectModel doTemp = new ASObjectModel("Doc2OutOfWarehouseApplyList");

	if("0010".equals(sApplyType)){//待出库  待提交
		sWhereSql = " and O.status='01' and O.inputuserid ='"+ CurUser.getUserID() +"' ";//and DFP.POSITION is not null 
		sOperationStatus = "01";
	}else if("0020".equals(sApplyType)){//审批中  审批中
		sWhereSql = " and O.status='02'  and O.inputuserid ='"+ CurUser.getUserID() +"' ";
		sOperationStatus = "02";
	}else if("0030".equals(sApplyType)){//已出库  审批通过
		sWhereSql = " and O.status='03' and O.inputuserid ='"+ CurUser.getUserID() +"' ";
		sOperationStatus = "03";
	}else if("0040".equals(sApplyType)){//已出库-借用
		sWhereSql = " and O.status='03' and O.inputuserid ='"+ CurUser.getUserID() +"' ";
		sOperationStatus = "04";
	}else if("0050".equals(sApplyType)){//已出库-正式出库
		sWhereSql = " and O.status='03'  and O.inputuserid ='"+ CurUser.getUserID() +"' ";
		sOperationStatus = "04";
	}else if("0060".equals(sApplyType)){//被退回出库申请
		sWhereSql = "  and O.status='04' and O.inputuserid ='"+ CurUser.getUserID() +"' ";
		sOperationStatus = "05";
	}
	doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"false","All","Button","出库申请","出库申请","add()","","","","btn_icon_add",""},
			{"true","","Button","申请详情","申请详情","edit()","","","","btn_icon_detail",""},
			{"false","All","Button","取消申请","取消申请","cancel()","","","","btn_icon_detail",""},
			{"false","All","Button","提交","提交","submit()","","","","btn_icon_detail",""},
			{"true","","Button","查看意见","查看意见","OpinionView()","","","","btn_icon_detail",""},
			{"false","All","Button","再次提交","再次提交","submitAgain()","","","","btn_icon_detail",""},
		};

	if("0010".equals(sApplyType)){//待出库  待提交
		sButtons[0][0] = "true";
		sButtons[2][0] = "true";
		sButtons[3][0] = "true";
		sButtons[4][0] = "false";
	}else if("0020".equals(sApplyType)){//审批中  审批中
		sButtons[4][0] = "false";
	}else if("0030".equals(sApplyType)){//已出库  审批通过
	}else if("0040".equals(sApplyType)){//已出库-借用
	}else if("0050".equals(sApplyType)){//已出库-正式出库
	}else if("0060".equals(sApplyType)){//被退回出库申请
		sButtons[5][0] = "true";
	}
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript"> 
	function add(){
		
		var pkSerialNo = AsDialog.SetGridValue('Doc2ManageList1','<%=CurUser.getOrgID()%>,03','ss=SerialNo','');
		if(typeof(pkSerialNo)=="undefined" || pkSerialNo.length==0 || pkSerialNo == "_CLEAR_") return;
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc2ManageAction","createDo","SerialNo="+pkSerialNo+",TransactionCode=0020,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'){
		 	var serialNo = returnValue;
		 	var sOperationStatus = "<%=sOperationStatus%>";
		 	AsControl.PopComp("/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseInfoView.jsp","SerialNo=" +serialNo+"&OperationType=0020&OperationStatus="+sOperationStatus+"&RightType=All&DocType=02",'');
			reloadSelf();
		}
	}
	
	function edit(){
		var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseInfoView.jsp";
		 var sSerialNo = getItemValue(0,getRow(0),'SerialNo');
		 var sObjectType = getItemValue(0,getRow(0),'ObjectType');
		 var sObjectNo = getItemValue(0,getRow(0),'ObjectNo');
		 if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		 var sOperationStatus = "<%=sOperationStatus%>";
		 var sRightType = " ";  
		 if("<%=sApplyType%>"!="0010"&&"<%=sApplyType%>"!="0060"){//待出库  待提交 或 申请被退回再次提交
			 sRightType = "ReadOnly";
		 }else{
			 sRightType = "All";
		 }
		AsControl.PopComp(sUrl,"SerialNo=" +sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&OperationType=0020&OperationStatus="+sOperationStatus+"&DocType=02&RightType="+sRightType,'');
		reloadSelf();
	}
	function cancel(){
		var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		var sDOObjectType = getItemValue(0,getRow(0),'ObjectType');
		var sDOObjectNo = getItemValue(0,getRow(0),'ObjectNo');
		var sOperationType = getItemValue(0,getRow(0),'TRANSACTIONCODE');//出库方式
		var sPara = "OperationType="+sOperationType+"&DOSerialNo="+sDOSerialNo+"&ObjectType="+sDOObjectType+"&ObjectNo="+sDOObjectNo+"&DOSerialNo="+sDOSerialNo+"&Status="+"01";
		if(confirm("确定要取消吗？")){
			var sSql = "delete doc_operation_file  where operationserialno='" +sDOSerialNo+"'";
			var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
			if(sReturnValue >-1){
				as_delete(0);
				reloadSelf();
			}else{
				alert("取消申请失败！");
			}
		}
		
	}
	function submit(){
		var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		var sDOObjectType = getItemValue(0,getRow(0),'ObjectType');
		var sDOObjectNo = getItemValue(0,getRow(0),'ObjectNo'); 
		var sOperationdescript = getItemValue(0,getRow(0),'OPERATEDESCRIPTION');
		if((typeof(sOperationdescript)!="undefined" && sOperationdescript.length==0)){
			alert("请到详情信息中录入必输项，再提交");
			return;
		}
		var sOperationType = getItemValue(0,getRow(0),'TRANSACTIONCODE');//出库方式
		var sPara = "OperationType="+sOperationType+"&DOSerialNo="+sDOSerialNo+"&ObjectType="+sDOObjectType+"&ObjectNo="+sDOObjectNo+"&DOSerialNo="+sDOSerialNo+"&Status="+"01";
		//插入一条操作数据
		var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseSubmitAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");//
		if((typeof(sReturn)!="undefined" && sReturn=="true")){
				alert("申请提交成功！");
				reloadSelf();
		}else{
			alert("申请提交失败！");
		}
	}
	function OpinionView(){
		var sOpinionUrl = "/DocManage/Doc1Manage/DocOutApproveOpinionInfo.jsp";
 		var sPTISerialNo = getItemValue(0,getRow(0),'TASKSERIALNO');
		 if(typeof(sPTISerialNo)=="undefined" || sPTISerialNo.length==0 || sPTISerialNo=="null"){
			alert("参数不能为空！");
			return ;
		 }
		var sPara = "PTISerialNo="+sPTISerialNo+"&RightType=ReadOnly";
		AsControl.PopComp(sOpinionUrl,sPara ,"dialogWidth=450px;dialogHeight=300px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;");
		reloadSelf();
	}
	function submitAgain(){
		var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		var sDOObjectType = getItemValue(0,getRow(0),'ObjectType');
		var sDOObjectNo = getItemValue(0,getRow(0),'ObjectNo');
		var sOperationType = getItemValue(0,getRow(0),'TRANSACTIONCODE');//出库方式
		if(typeof(sDOSerialNo)=="undefined" || sDOSerialNo.length==0){
			alert("你没有选择要提交的信息！");
			return ;
		 }
		var sPara = "OperationType="+sOperationType+"&DOSerialNo="+sDOSerialNo+"&ObjectType="+sDOObjectType+"&ObjectNo="+sDOObjectNo+"&DOSerialNo="+sDOSerialNo+"&Status="+"05";
		//插入一条操作数据
		var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseSubmitAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");//
		if(sReturn || (typeof(sReturn)!="undefined" && sReturn=="true")){
				alert("申请提交成功！");
				reloadSelf();
		}else{
			alert("申请提交失败！");
		}
	}
	 
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
