<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String inputUserID = CurUser.getUserID();
	String finishFlag = CurPage.getAttribute("finishFlag");//"0" 未完成流程 ； "1" 已完成流程
	String[] roleID01 = {"PLBS0001","PLBS0002"};//客户经理
	String[] roleID02 = {"PLBS0018"};//风险监控岗
	ASObjectModel doTemp = new ASObjectModel("ThreeColorWarningQuery");
	
	if("0".equals(finishFlag)){
		if(CurUser.hasRole(roleID01) && !CurUser.hasRole(roleID02)){
			doTemp.appendJboWhere(" (O.Status = '1' or O.Status = '2') and O.InputUserId = '"+inputUserID+"' ");
		}else{
			doTemp.appendJboWhere(" (O.Status = '1' or O.Status = '2')");
		}
	}else{
		if(CurUser.hasRole(roleID01) && !CurUser.hasRole(roleID02)){
			doTemp.appendJboWhere(" (O.Status = '3' or O.Status = '4' or O.Status = '5') and O.InputUserId = '"+inputUserID+"' ");
		}else{
			doTemp.appendJboWhere(" (O.Status = '3' or O.Status = '4' or O.Status = '5') ");
		}
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(CurUser.getOrgID());

	String sButtons[][] = {
			{"true","","Button","详情","查看/修改预警详情","viewAndEdit()","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function viewAndEdit(){//预警详情
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		var duebillSerialNo = getItemValue(0,getRow(),"OBJECTNO");
		var customerID = getItemValue(0,getRow(),"CustomerID");
		var signalType = getItemValue(0,getRow(),"SIGNALTYPE");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskWarningManagement", "getYRiskSerialNo", "SerialNo="+serialNo);
		var flowSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskWarningManagement", "getFlowSerialNo", "SerialNo="+serialNo);
		AsCredit.openFunction("ThreeColorRiskDetailInfo","SerialNo="+serialNo+"&FlowSerialNo="+flowSerialNo+"&SignalType="+signalType+"&DuebillSerialNo="+duebillSerialNo+"&YSerialNo="+result+"&CustomerID="+customerID+"&RightType=ReadOnly");
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
