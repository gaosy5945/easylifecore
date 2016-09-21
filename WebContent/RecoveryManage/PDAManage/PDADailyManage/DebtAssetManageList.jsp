<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("PDADailyList");

	String role = "PLBS0052";
	if(CurUser.hasRole(role)){
		doTemp.appendJboWhere(" and exists (select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = '" 
				+ CurUser.getOrgID() + "' and  OB.BelongOrgID = O.ManageOrgID) ");
	}else{
		doTemp.appendJboWhere(" AND O.ManageUserID ='"+CurUser.getUserID()+"' ");
	}
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow("");

	//删除抵债资产后删除关联信息
    //dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(AssetInfo,#SerialNo,DeleteBusiness)");
	
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","新增","新增一条记录","newRecord()","","","",""},
			{"true","","Button","资产详情","查看/修改资产详情","viewAndEdit()","","","",""},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""},
			{"true","","Button","处置终结","终结所选中的记录","finishRecord()","","","",""},
			{"true","","Button","导出数据","导出到excel","exportExcel()","","","",""},
			//{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function exportExcel(){
		if(confirm("是否导出当前批次抵债资产管理信息！")){
			exportPage('<%=sWebRootPath%>',0,'excel','<%=dwTemp.getArgsValue()%>'); 
		}
	}
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		var sAssetInfo =PopPage("/RecoveryManage/PDAManage/PDADailyManage/PDATypeDialog.jsp","","resizable=yes;dialogWidth=28;dialogHeight=10;center:yes;status:no;statusbar:no");
		sAssetInfo = sAssetInfo.split("@");
		var sAISerialNo=sAssetInfo[1];
		var sDASerialNo=sAssetInfo[2];
		if(typeof(sAISerialNo) != "undefined" && sAISerialNo.length != 0)
		{			
			//popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","SerialNo="+sSerialNo+"AssetSerialNo="+sAssetSerialNo,"");
			var sFunctionID="PDAInfoList";
			AsCredit.openFunction(sFunctionID,"SerialNo="+sDASerialNo+"&AssetSerialNo="+sAISerialNo+"&AssetType="+sAssetInfo[0]);	
			reloadSelf();
		} 		
	}
			
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		 var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		 var sAssetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");	
		 var sDebtAssetStatus = getItemValue(0,getRow(),"Status");
		 if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		} else {
			 if(sDebtAssetStatus!="01"){
				 alert("请选择处置状态为待处置的信息进行删除操作！");
				 return;
			 }
			if(confirm("确定要删除吗？")){
				//插入刚刚产生的序列号记录，补充缺省值。
				PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDADeleteActionAjax.jsp?SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo,"","");
			}
		}
		reloadSelf();
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得抵债资产流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sAssetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");	
		var sAssetType = getItemValue(0,getRow(),"AssetType");
		var manageUserID = getItemValue(0,getRow(),"ManageUserID");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		//popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo,"");
		var sFunctionID="PDAInfoList";
		var sDAStatus = getItemValue(0,getRow(),"Status");
		var rightType = "<%=CurPage.getParameter("RightType")%>";
		if(manageUserID!="<%=CurUser.getUserID()%>"||sDAStatus == "03"){
			rightType = "ReadOnly";
		}
		AsCredit.openFunction(sFunctionID,"SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo+"&AssetType="+sAssetType + "&AssetStatus=" + sDAStatus + "&RightType=" + rightType);	
		reloadSelf();	
	}	
		
	/*~[Describe=终结资产，设置终结状态，终结日期;InputParam=无;OutPutParam=SerialNo;]~*/
	function finishRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sAssetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");	
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		var RightType = "All";
		var sDAStatus = getItemValue(0,getRow(),"Status");
		if(sDAStatus == "03") RightType = "ReadOnly";
		AsControl.PopComp("/RecoveryManage/PDAManage/PDADailyManage/PDADisposalEndInfo.jsp", "SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo+"&Type=1&RightType=" + RightType, "dialogWidth:720px;dialogheight:580px", "");
		reloadSelf();
	
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
