<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TransferApplyHistoryList");
	doTemp.setJboWhereWhenNoFilter("TRANSFERTYPE='10'");//默认展示未确认的申请

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(CurUser.getUserID());
	
	String sButtons[][] = {
			{"true","","Button","新增转出申请","新增转出申请","transferOut()","","","","",""},
			{"true","","Button","新增转入申请","新增转入申请","transferIn()","","","","",""},
			{"true","","Button","客户详情","客户详情","view()","","","","",""},
			{"true","","Button","取消转让","取消转让","cancel()","","","","",""},
			{"true","","Button","维护权回收","维护权回收","recover()","","","","",""}
		};
%> 
<script type="text/javascript">

	/*~[Describe=新增转出申请;InputParam=无;OutPutParam=无;]~*/
	function transferOut(){
		AsControl.PopComp("/CustomerManage/TransferManage/TransferOutApply.jsp","","resizable=yes;dialogWidth=850px;dialogHeight=680px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}

	/*~[Describe=新增转入申请;InputParam=无;OutPutParam=无;]~*/
	function transferIn(){
		AsControl.PopComp("/CustomerManage/TransferManage/TransferInApply.jsp","","resizable=yes;dialogWidth=850px;dialogHeight=680px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	
	/*~[Describe=查看客户详情;InputParam=无;OutPutParam=无;]~*/
	function view(){
		var customerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(customerID)=="undefined" || customerID.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
    	AsCredit.openFunction("CustomerDetail","CustomerID="+customerID,"");
		//OpenObject("Customer",customerID,"001");
	}
	/*~[Describe=取消转让;InputParam=无;OutPutParam=无;]~*/
	function cancel(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
		var transferType = getItemValue(0,getRow(),"TransferType");//转让状态
		if(transferType != "10"){
			alert("该申请已确认或已被拒绝,无法取消！");
			return;
		}
		if(confirm("是否确认取消转让申请？")){
			as_delete(0);
		}
	}
	/*~[Describe=维护权回收;InputParam=无;OutPutParam=无;]~*/
	function recover(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
		
		var operateType = getItemValue(0,getRow(),"OperateType");//操作类型
		var transferType = getItemValue(0,getRow(),"TransferType");//转让状态
		var rightType = getItemValue(0,getRow(),"RightType");//权限类型
		if(rightType == "10"){//管护权时
			alert("请选择类型为\"维护权\"的记录进行收回!");
			return;
		}
		if(operateType == "10"){//转入时无法收回维护权
			alert("请选择操作类型为\"转出\"的记录进行收回!");
			return;
		}
		if(transferType != "20"){
			alert("该记录未确认或已被拒绝,不需要收回维护权");
			return;
		}
		var customerID = getItemValue(0,getRow(),"CustomerID");
		var param = "userID=<%=CurUser.getUserID()%>,customerID="+customerID+",serialNo="+serialNo+",transferType="+transferType;
		var result = RunJavaMethodTrans("com.amarsoft.app.als.customer.transfer.action.TransferAction","recover",param);
		if(result == "true"){
			alert("维护权收回成功!");
			reloadSelf();
		}else{
			alert("维护权收回失败！");
		}
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
