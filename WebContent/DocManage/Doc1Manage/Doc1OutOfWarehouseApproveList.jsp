<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sApproveType = CurPage.getParameter("ApproveType");
	if(sApproveType==null) sApproveType ="";
	String sWhereSql = "";
	ASObjectModel doTemp = new ASObjectModel("Doc1OutOfWarehouseApplyList");
	if(sApproveType=="0010" || "0010".equals(sApproveType)){//待提交
		sWhereSql =  "  and O.status='02' ";
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);	
	}else	if(sApproveType=="0020" || "0020".equals(sApproveType)){//已提交
		sWhereSql =  "   and O.status='03' ";
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);	
	}
	doTemp.setDDDWJbo("TRANSACTIONCODE","jbo.ui.system.CODE_LIBRARY,itemno,ItemName,Isinuse='1' and CodeNo='DocumentTransactionCode' and ItemNo in('0020','0030') order by sortno");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//申请详情	签署意见	查看意见	打印出库审批表	打印封包编号
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			//{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","申请详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","","Button","签署意见","签署意见","opinionAdd()","","","","btn_icon_detail",""},
			{"true","","Button","查看意见","查看意见","opinionView()","","","","btn_icon_detail",""},
			{"false","","Button","打印出库审批表","打印出库审批表","printApprove()","","","","btn_icon_detail",""},
			//{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};

	if(sApproveType=="0010" || "0010".equals(sApproveType)){//待提交
		sButtons[2][0] = "false";
		sButtons[3][0] = "false"; 
	}else	if(sApproveType=="0020" || "0020".equals(sApproveType)){//已提交
		sButtons[1][0] = "false";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		 var sUrl = "/DocManage/Doc1Manage/Doc1OutOfWarehouseView.jsp";
		 var sPara = "";
		 var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		 var sAISerialNo = getItemValue(0,getRow(0),'ASSETSERIALNO');
		 
		 if(typeof(sDOSerialNo)=="undefined" || sDOSerialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		 sPara = "DOSerialNo="+sDOSerialNo+"&AISerialNo="+sAISerialNo+"&ApproveType=<%=sApproveType%>&RightType=ReadOnly";
		 AsControl.PopComp(sUrl,sPara,'','');
		 reloadSelf();
	}
	function opinionAdd(){
		//获取参数
		var sPTISerialNo = getItemValue(0,getRow(0),'TASKSERIALNO');
		var sDOSerialNo =  getItemValue(0,getRow(0),'SERIALNO');//出库申请流水号
		var sTransactionCode =  getItemValue(0,getRow(0),'TRANSACTIONCODE');//出库方式
		var sObjectType = getItemValue(0,getRow(0),'OBJECTTYPE');
		var sObjectNo = getItemValue(0,getRow(0),'ASSETSERIALNO');
		if(typeof(sDOSerialNo)=="undefined" || sDOSerialNo.length==0 ){
			alert("请选中一条记录！");
			return ;
		 }
		//左右视图设置中间页面
		var sOpinionUrl = "/DocManage/Doc2Manage/Doc2BPManage/DocOutApproveOpinionInfoView.jsp";
		var sPara = "PTISerialNo="+sPTISerialNo+"&DOSerialNo="+sDOSerialNo+"&DocType=01"+
		            "&TransactionCode="+sTransactionCode+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		AsControl.PopComp(sOpinionUrl,sPara,"");
		self.reloadSelf();  
	}
	//查看审批意见
	function opinionView(){
		var sOpinionUrl = "/DocManage/Doc1Manage/DocOutApproveOpinionInfo.jsp";
 		var sPTISerialNo = getItemValue(0,getRow(0),'TASKSERIALNO');
		 if(typeof(sPTISerialNo)=="undefined" || sPTISerialNo.length==0 || sPTISerialNo=="null"){
			alert("参数不能为空！");
			return ;
		 }
		var sPara = "PTISerialNo="+sPTISerialNo+"&RightType=ReadOnly";
		AsControl.PopComp(sOpinionUrl,sPara ,"dialogWidth=450px;dialogHeight=300px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;");
	}
	function printApprove(){
		alert("printApprove");
	}
	function printPackageId(){
		alert("printPackageId");
	}
	function submitRecord(){
		var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		var sAISerialNo = getItemValue(0,getRow(0),'AISerialNo');
		var sPara = "AISerialNo="+sAISerialNo+"&DOSerialNo="+sDOSerialNo+"&ApplyType=02";
		var sReturn=PopPageAjax("/DocManage/Doc1Manage/Doc1OutOfWarehouseAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
		if(sReturn || (typeof(sReturn)!="undefined" && sReturn=="true")){
			alert("审批成功！");
		}else {
			alert("审批失败!");
			return;
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
