<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%	
	//获取阶段类型
	String sApplyType = CurPage.getParameter("ApplyType");
	if(sApplyType==null) sApplyType ="";
	String sRightType = CurPage.getParameter("RightType");
	if(sRightType==null) sRightType ="";  
	String sWhereSql = "";
	//设置显示模板编号 
	ASObjectModel doTemp = new ASObjectModel("Doc1OutOfWarehouseApplyList");
	//出库申请阶段  只显示当前用户申请待提交的业务
	if(sApplyType=="0010" || "0010".equals(sApplyType)){
		sWhereSql =  " and O.status='01' and O.inputuserid = '"+CurUser.getUserID()+"' ";
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	//出库审批阶段 只显示分配给当前用户待审批的业务
	}else if(sApplyType=="0020" || "0020".equals(sApplyType)){
		sWhereSql =  " and O.status in ('02','03','04') and O.inputuserid = '"+CurUser.getUserID()+"' ";
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);	
	}
	doTemp.setDDDWJbo("TRANSACTIONCODE","jbo.ui.system.CODE_LIBRARY,itemno,ItemName,Isinuse='1' and CodeNo='DocumentTransactionCode' and ItemNo in('0020','0030') order by sortno");
	//加载显示视图
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","出库申请","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","申请详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","","Button","取消申请","删除","deleteRecord()","","","","btn_icon_delete",""},
			{"true","","Button","提交","提交","submitRecord()","","","","btn_icon_detail",""},
		};
	if(sApplyType=="0010" || "0010".equals(sApplyType)){//待提交
	}else	if(sApplyType=="0020" || "0020".equals(sApplyType)){//已提交
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	/*************新增出库申请*************/
	function add(){ 
		 var sUrl = "/DocManage/Doc1Manage/Doc1OutOfWarehouseView.jsp";
		 var sDOSerialNo = getSerialNo("doc_operation","serialNo","");
		 AsControl.PopComp(sUrl,'DOSerialNo='+sDOSerialNo+"&ApplyType=<%=sApplyType%>",'','');
		 reloadSelf();
		 //AsCredit.openFunction("BusinessDoc1Info","DOSerialNo="+sDOSerialNo);
	}
	/*********查看出库详情**********/
	function edit(){
		 var sUrl = "/DocManage/Doc1Manage/Doc1OutOfWarehouseView.jsp";
		 var sPara = "";
		 var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		 var sAISerialNo = getItemValue(0,getRow(0),'ASSETSERIALNO');
		 if(typeof(sDOSerialNo)=="undefined" || sDOSerialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		if("0020"=="<%=sApplyType%>"){
			sRightType="ReadOnly";
		}else{
			sRightType="All";
		}
		 sPara = "DOSerialNo="+sDOSerialNo+"&AISerialNo="+sAISerialNo+"&ApplyType=<%=sApplyType%>&RightType="+sRightType;
		 AsControl.PopComp(sUrl,sPara,'','');
		 reloadSelf();
	}
	
	/*********取消出库申请*********/
	function deleteRecord(){
		//获取当期要删除的出库申请流水号
		 var sDOSerialNo = getItemValue(0,getRow(0),'SERIALNO'); 
		 if(confirm('确实要删除吗?')){
			 sSql = "delete from doc_operation where  serialno='"+sDOSerialNo+"'";
			 //执行删除操作
			 var sReturn =  RunMethod("PublicMethod","RunSql",sSql);  
			 if( sReturn >= 0 || sReturn == "1" || sReturn =="0"){
				as_delete(0);
			 }else{
				alert("删除失败！");
			 }  
		 }  
	}
	
	/************提交出库申请到审批阶段*************/
	function submitRecord(){
		//获取提交出库申请流水号
		var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		var sPara = "DOSerialNo="+sDOSerialNo+",ApplyType=01,UserID=<%=CurUser.getUserID()%>";
	 	var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc1EntryWarehouseAdd", "commit", sPara);
	 	if(sReturn || (typeof(sReturn)!="undefined" && sReturn=="true")){
	 		alert("提交成功！");
	 		self.reloadSelf();
	 	}else {
	 		alert("提交失败!");
	 		return;
	 	} 
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
