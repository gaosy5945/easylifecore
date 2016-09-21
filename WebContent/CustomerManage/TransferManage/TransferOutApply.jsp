<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "TransferSimpleInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("Customers","<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"400\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/TransferManage/TransferCustomerList.jsp?CompClientID="+sCompClientID+"&TransferType=10\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
			{"true","All","Button","确定","保存所有修改","doSure()","","","",""},
			{"true","All","Button","取消","返回列表","top.close()","","","",""}
			};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

	/*~[Describe=确定;InputParam=无;OutPutParam=无;]~*/
	function doSure(){
		if(!iV_all("0")) return; 
		var userID = getItemValue(0,getRow(),"RECEIVEUSERID");
		if(userID=="<%=CurUser.getUserID()%>"){
			alert("接受用户不能选自己！");
			return;
		}
		var rightType = getItemValue(0,getRow(),"RightType");
		var maintainTime = getItemValue(0,getRow(),"MAINTAINTIME");
		if(rightType=="20"&& (typeof(maintainTime)=="undefine" || maintainTime.length==0)){
			alert("请选择维护权期限！");
			return;
		}
		//获取所选客户
		var customers = window.frames["frame_list"].returnCustomers();
		if(typeof(customers)=="undefined" || customers.length==0){
			alert("请至少选择一条客户记录！");
			return;
		}
		if(customers == "error") return;
		var orgID = getItemValue(0,getRow(),"RECEIVEORGID");
		var afrightFlag = getItemValue(0,getRow(),"AfrightFlag");
		var maintainTime = getItemValue(0,getRow(),"MAINTAINTIME");
		var param = "customerID="+customers+",userID=<%=CurUser.getUserID()%>,orgID=<%=CurUser.getOrgID()%>,receiveUserID="+userID
					+",receiveOrgID="+orgID+",rightType="+rightType+",afrightFlag="+afrightFlag+",manaTime="+maintainTime;
		var result = RunJavaMethodTrans("com.amarsoft.app.als.customer.transfer.action.TransferAction","saveTransferOut",param);
		if(result == "true"){
			alert("转让申请成功！");
			self.close();
		}
	}

	/*~[Describe=选择用户信息;InputParam=无;OutPutParam=无;]~*/
	function selectUser(){
		var result = setObjectValue("SelectAllUser","","",0,0,"");
		if(typeof(result)=="undefined" || result.length==0) return;
		if(result == "_CLEAR_"){
			setItemValue(0,getRow(),"RECEIVEUSERID","");//接收用户号
			setItemValue(0,getRow(),"UserName","");//用户名称
			setItemValue(0,getRow(),"RECEIVEORGID","");//接收机构号
			setItemValue(0,getRow(),"OrgName","");//机构名称
		}else{
			var params = result.split("@");
			setItemValue(0,getRow(),"RECEIVEUSERID",params[0]);//接收用户号
			setItemValue(0,getRow(),"UserName",params[1]);//用户名称
			setItemValue(0,getRow(),"RECEIVEORGID",params[2]);//接收机构号
			setItemValue(0,getRow(),"OrgName",params[3]);//机构名称
		}
	}
	/*~[Describe=转移权限变更;InputParam=无;OutPutParam=无;]~*/
	function rightChange(){
		var rightType = getItemValue(0,getRow(),"RightType");
		if(rightType == "10"){//管护权
			//管护权时,显示'是否转移业务管护权'字段，隐藏维护权期限字段
			hideItem(0,"MAINTAINTIME");
			setItemValue(0,getRow(),"MAINTAINTIME","");
			setItemValue(0,getRow(),"AFRIGHTFLAG","2");
			hideItem(0,"AFRIGHTFLAG");
		}else if(rightType == "20"){//维护权
			//维护权时,隐藏'是否转移业务管护权'字段，显示维护权期限字段
			hideItem(0,"AFRIGHTFLAG");
			setItemValue(0,getRow(),"AFRIGHTFLAG","");
			showItem(0,"MAINTAINTIME");
		}
	}
	rightChange();
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
