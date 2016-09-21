<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TransferApproveList");
	doTemp.setVisible("AFFIRMDATE", true);
	doTemp.appendJboWhere(" and TransferType='20'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.genHTMLObjectWindow(CurUser.getUserID());
	
	String sButtons[][] = {
	        {"true","","Button","维护权收回","收回维护权","recover()","","","",""},
			{"true","","Button","客户详情","查看客户详情","view()","","","",""}
		};
%> 
<script type="text/javascript">
	/*~[Describe=维护权回收;InputParam=无;OutPutParam=无;]~*/
	function recover(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
		
		var operateType = getItemValue(0,getRow(),"UnOperateType");//操作类型
		var rightType = getItemValue(0,getRow(),"RightType");//权限类型
		if(operateType == "10"){//转入时无法收回维护权
			alert("请选择操作类型为\"转出\"的记录进行收回!");
			return;
		}
		if(rightType == "10"){//管护权时
			alert("请选择类型为\"维护权\"的记录进行收回!");
			return;
		}
		var customerID = getItemValue(0,getRow(),"CustomerID");
		var param = "userID=<%=CurUser.getUserID()%>,customerID="+customerID+",serialNo="+serialNo+",transferType=20";
		var result = RunJavaMethodTrans("com.amarsoft.app.als.customer.transfer.action.TransferAction","recover",param);
		if(result == "true"){
			alert("维护权收回成功!");
			reloadSelf();
		}else{
			alert("维护权收回失败！");
		}
	}
	/*~[Describe=查看客户信息;InputParam=无;OutPutParam=无;]~*/
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
