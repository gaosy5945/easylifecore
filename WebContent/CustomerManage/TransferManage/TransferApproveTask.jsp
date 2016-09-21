<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TransferApproveList");
	doTemp.appendJboWhere(" and TransferType='10'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "0";	 //编辑模式
	//dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(CurUser.getUserID());
	
	String sButtons[][] = {
			{"true","","Button","同意","同意转移请求","doSure()","","","","",""},
			{"true","","Button","拒绝","拒绝转移请求","doReject()","","","","",""},
			{"true","","Button","客户详情","查看客户详情","view()","","","",""},
		};
%> 
<script type="text/javascript">
	/*~[Describe=同意转移请求;InputParam=无;OutPutParam=无;]~*/
	function doSure(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
		var operateType = getItemValue(0,getRow(),"UnOperateType");//反操作类型
		var rightType = getItemValue(0,getRow(),"RightType");//权限类型
		var mainTainTime = getItemValue(0,getRow(),"MainTainTime");//维护权期限
		var customerID = getItemValue(0,getRow(),"CustomerID");//客户编号
		if(operateType == "20" && rightType == "20" && (typeof(mainTainTime)=="undefined" || mainTainTime.length==0)){//转出维护权
			alert("请指定维护权期限!");
			return;
		}
		var param = "serialNo="+serialNo+",customerID="+customerID+",manaTime="+mainTainTime+",userID=<%=CurUser.getUserID()%>"+
					",orgID=<%=CurUser.getOrgID()%>,rightType="+rightType;
		var result = RunJavaMethodTrans("com.amarsoft.app.als.customer.transfer.action.TransferAction","consentTransfer",param);
		if(result == "true"){
			alert("客户转移成功！");
			reloadSelf();
		}else{
			alert("客户转移失败！");
		}
	}
	/*~[Describe=拒绝转移请求;InputParam=无;OutPutParam=无;]~*/
	function doReject(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
		var result = RunJavaMethodTrans("com.amarsoft.app.als.customer.transfer.action.TransferAction","rejectTransfer","serialNo="+serialNo);
		if(result == "true"){
			alert("已成功拒绝客户转移！");
			reloadSelf();
		}else{
			alert("拒绝客户转移失败！");
		}
	}

	/*~[Describe=查看客户详情;InputParam=无;OutPutParam=无;]~*/
	function view(){
		var customerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(customerID)=="undefined" || customerID.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
    	AsCredit.openFunction("CustomerDetail","CustomerID="+customerID,"");
		//AsControl.OpenObject("Customer",customerID,"001");
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
