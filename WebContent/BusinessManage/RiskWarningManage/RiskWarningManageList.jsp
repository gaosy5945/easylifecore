<%@page import="com.amarsoft.are.jbo.ql.Parser"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String inputuserid = CurUser.getUserID();
	String signalType  = DataConvert.toString(CurPage.getParameter("SignalType")); //"01"-发起;"02"-解除;"03"-提示
	if(signalType==null||signalType.length()==0)signalType="";
	String status = DataConvert.toString(CurPage.getParameter("Status"));
	if(status==null||status.length()==0)status="";
	String taskchannel = DataConvert.toString(CurPage.getParameter("TaskChannel"));//批量标识：01人工；02批量
	if(taskchannel==null||taskchannel.length()==0)taskchannel="";
	String templetNo = DataConvert.toString(CurPage.getParameter("TempletNo"));
	if(templetNo==null||templetNo.length()==0)templetNo="";
	ASObjectModel doTemp = new ASObjectModel(templetNo);
	if("3,5".equals(status)){//预警发起-已预警页面
		doTemp.appendJboWhere("status in ('3','5')");
	}else{
		doTemp.appendJboWhere(" status = '"+status+"' ");
	}
	if(!"".equals(taskchannel))doTemp.appendJboWhere(" and o.TaskChannel='"+taskchannel+"' ");
	//if(!"".equals(taskchannel))doTemp.appendJboWhere(" and o.TaskChannel in ('01','02') ");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.MultiSelect = true; //允许多选
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(signalType+","+inputuserid);

	String sthflag = "false" ,edtflag1 = "false" ,edtflag2 = "false";
	if("02".equals(taskchannel)){//定量处理三色预警
		if("0".equals(status))sthflag = "true";
		else edtflag1 = "true";
	}else{
		if("01".equals(signalType))edtflag1 = "true";
		if("02".equals(signalType))edtflag2 = "true";
	}
	String sButtons[][] = {
			{sthflag,"ALL","Button","处理","三色预警处理","doSth()","","","",""},//定量三色预警处理，taskchannel
			{edtflag1,"","Button","预警详情","查看/修改预警详情","viewAndEdit()","","","",""},
			{edtflag2,"","Button","预警解除详情","查看/修改预警详情","viewAndEdit()","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	function viewAndEdit(){//预警详情
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		var duebillSerialNo = getItemValue(0,getRow(),"OBJECTNO");
		var contractSerialno = getItemValue(0,getRow(),"CONTRACTSERIALNO");
		var customerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskWarningManagement", "getFlowSerialNo", "SerialNo="+serialNo);
		var putoutSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskWarningManagement", "getPutoutSerialNo", "SerialNo="+serialNo);
		AsCredit.openFunction("RiskWarningDetailInfo","SerialNo="+serialNo+"&DuebillSerialNo="+putoutSerialNo+"&ContractSerialno="+contractSerialno+"&ObjectType=jbo.al.RISK_WARNING_SIGNAL&ObjectNo="+serialNo+"&FlowSerialNo="+result+"&CustomerID="+customerID+"&RightType=ReadOnly");
		reloadSelf();
	}
	
	function doSth(){//预警详情
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		var duebillSerialNo = getItemValue(0,getRow(),"OBJECTNO");
		var customerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskWarningManagement", "getYRiskSerialNo", "SerialNo="+serialNo);
		AsCredit.openFunction("RiskWarningDetailInfo","SerialNo="+serialNo+"&DuebillSerialNo="+duebillSerialNo+"&YSerialNo="+result+"&CustomerID="+customerID);
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
