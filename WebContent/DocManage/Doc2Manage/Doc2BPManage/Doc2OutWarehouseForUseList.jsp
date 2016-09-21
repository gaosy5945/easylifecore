<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sForUseType = (String)CurPage.getParameter("ForUseType");
	if(null==sForUseType) sForUseType="";
	String sWhereSql = "";
	ASObjectModel doTemp = new ASObjectModel("Doc2OutWarehouseForUseList");

	if(sForUseType == "0010" || "0010".equals(sForUseType)){
		sWhereSql = " AND  DFP.status in ('04','05') and O.STATUS='03'";//未领用
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	}
	if(sForUseType == "0020" || "0020".equals(sForUseType)){
		sWhereSql = " AND  DFP.status='06' and O.STATUS='03' "; //已领用
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","出库领用","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","申请详情","详情","edit()","","","","btn_icon_detail",""},
			{"false","","Button","下架","下架","PullOfShelves()","","","","btn_icon_detail",""},
			//{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};

	if(sForUseType == "0020" || "0020".equals(sForUseType)){
		 sButtons[0][0] = "false";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 
			var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseInfoView.jsp";
			//出库申请流水号 
			var sSerialNo = getItemValue(0,getRow(0),'SERIALNO');
			var sObjectType = getItemValue(0,getRow(0),'OBJECTTYPE');
			var sObjectNo = getItemValue(0,getRow(0),'OBJECTNO');
			if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0 ){
				alert("参数不能为空！");
				return ;
			} 
			var sOperationStatus = "04";
			var sRightType = "All";
			 var sApplyType = "<%=sForUseType%>";
			 if("0010"!=sApplyType){//待出库  待提交
				 sRightType = "ReadOnly";
			 }
			 AsControl.PopComp(sUrl,"SerialNo=" +sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType"+sObjectType+"&OperationType="+"0020"+"&OperationStatus="+sOperationStatus+"&RightType="+sRightType+"&DocType=02" ,'');
			 reloadSelf();
			  
	}
	function isUsePassword(){
		var sPassword = PopPage("/DocManage/Doc2Manage/Doc2BPManage/CheckDialog.jsp","","dialogWidth:350px;dialogHeight:150px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;");
        var retuStr = "false"; 
        retuStr = PopPage("/DocManage/Doc2Manage/Doc2BPManage/CheckDialogAction.jsp?Password="+sPassword,"","dialogWidth:320px;dialogHeight:270px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;");
		return retuStr;
		alert(sPassword+","+retuStr);
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
		 var sRightType = "All";
		 var sApplyType = "<%=sForUseType%>";
		 if("0010"!=sApplyType){//待出库  待提交
			 sRightType = "ReadOnly";
		 }
		 var sOperationStatus = "04";
		AsControl.PopComp(sUrl,"SerialNo=" +sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType"+sObjectType+"&OperationType="+"0020"+"&OperationStatus="+sOperationStatus+"&RightType="+sRightType+"&DocType=02" ,'');
		reloadSelf();
	}
	function PullOfShelves(){
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

			if(sDOSerialNo == null || sDOSerialNo == "" ||sDOSerialNo == "undefine" || sDOSerialNo.length == 0){
				alert("请选择一条数据！");
				return;
			}
		if(confirm('确实要下架吗?')) {//将位置置为空
			var sPara = "OperationType="+sOperationType+"&DOSerialNo="+sDOSerialNo+"&ObjectType="+sDOObjectType+"&ObjectNo="+sObjectNo+"&Position="+sPosition;
			//插入一条操作数据
			var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2specialKeepingAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");//
			if(sReturn || (typeof(sReturn)!="undefined" && sReturn=="true")){
					sMsg = "下架成功";
			} else {
				sMsg = "下架失败";
			}
			alert(sMsg);
		}
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
