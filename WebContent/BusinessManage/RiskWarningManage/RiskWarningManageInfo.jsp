<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	//String PG_TITLE = "关键信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数	：申请流水号、对象类型、对象编号、业务类型、客户类型、客户ID
	
	String sTaskSerialNo = CurPage.getParameter("TaskSerialNo");
	if(sTaskSerialNo==null)sTaskSerialNo="";
	String sFlowSerialNo = CurPage.getParameter("FlowSerialNo");
	if(sFlowSerialNo==null)sFlowSerialNo="";
	String sRightType = CurPage.getParameter("RightType");
	if(sRightType==null)sRightType="";
	String sPhaseNo = CurPage.getParameter("PhaseNo");
	if(sPhaseNo==null)sPhaseNo="";
	
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
	BusinessObject bo = bom.loadBusinessObject("jbo.flow.FLOW_OBJECT", "ObjectType","jbo.al.RISK_WARNING_SIGNAL","FlowSerialNo",sFlowSerialNo);
	String objectNo = bo.getAttribute("ObjectNo").getString();
	BusinessObject boSignal = bom.loadBusinessObject("jbo.al.RISK_WARNING_SIGNAL", "SerialNo",objectNo);
	String taskChannel = boSignal.getAttribute("TaskChannel").getString();//批量标识：01人工；02批量
	BusinessObject boRWO = bom.loadBusinessObject("jbo.al.RISK_WARNING_OBJECT", "SignalSerialNo",objectNo,"ObjectType","jbo.acct.ACCT_LOAN");
	
	if(taskChannel==null)taskChannel="";
	String signalType = boSignal.getAttribute("SignalType").getString();
	if(signalType==null)signalType="";
	String serialNo = boSignal.getAttribute("SerialNo").getString();
	if(serialNo==null)serialNo="";
	String loanSerialNo = boRWO.getAttribute("ObjectNo").getString();
	if(loanSerialNo==null)loanSerialNo="";
	
	String YserialNo = CurPage.getParameter("YSerialNo");
	if(YserialNo==null)YserialNo="";
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID==null)customerID="";
	String flowNo = CurPage.getParameter("FlowNo");
	if(flowNo==null)flowNo="";
	String objectType = "RiskWarningExclude";
	String rightType2 = CurPage.getParameter("RightType2");
	if(rightType2==null)rightType2="";
	String templateNo ="";
	if("02".equals(taskChannel)){//定量处理
		templateNo = "RiskWarningTaskDtInfo";//--模板号--
	}else if("01".equals(signalType)){//发起预警
		templateNo = "RiskWarningDetailInfo";//--模板号--
	}else{//解除
		templateNo = "RiskWarningCancelInfo";//--模板号--
	}
	//通过显示模版产生ASDataObject对象doTemp
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	//inputParameter.setAttributeValue("YserialNo", YserialNo);
	inputParameter.setAttributeValue("SerialNo", serialNo);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(templateNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	dwTemp.Style = "2";//freeform

	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");
	
	if("ReadOnly".equals(rightType2)){
		doTemp.setReadOnly("*", true);
	}
	dwTemp.genHTMLObjectWindow(serialNo);
	if(!"02".equals(taskChannel)){
		if("01".equals(signalType)){
			//dwTemp.replaceColumn("ATTACHMENT", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"\\Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
			dwTemp.replaceColumn("WARNINGLIST", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/BusinessManage/RiskWarningManage/RiskWarningManageHistList.jsp?SerialNo="+loanSerialNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
			dwTemp.replaceColumn("HISTORYSIGNAL", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/BusinessManage/RiskWarningManage/RWSignalHistoryList.jsp?CustomerID="+customerID+"&SerialNo="+objectNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
		}else{
			dwTemp.replaceColumn("CANCELDETAIL", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/BusinessManage/RiskWarningManage/RiskWarningCancelOpinionInfo.jsp?SerialNo="+serialNo+"&RightType="+rightType2+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
		}
	}
	
	String sButtons[][] = {
			{("ReadOnly".equals(rightType2)||(!"01".equals(signalType)))?"false":"true","All","Button","保存","保存","saveRecord()","","","","btn_icon_save"},	
			{("ReadOnly".equals(rightType2)||(!"02".equals(taskChannel)))?"false":"true","All","Button","提交","提交","dosubmit()","","","","btn_icon_submit"},
			{"true","","Button","排查结果附件","排查结果附件","upload()","","","",""}
	};
	//sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function selectSignal(){
		AsCredit.setGridValue("SelectWarningSingal","","SIGNALNAME=SIGNALNAME@SIGNALID=SIGNALID@SIGNALLEVEL=SIGNALLEVEL@SIGNALSUBJECT=SIGNALSUBJECT@SIGNALTYPEName=SIGNALSUBJECTNAME@SIGNALLEVELName=SIGNALLEVELNAME@RISKINDEXATTRIBUTEName=RISKINDEXATTRIBUTENAME","","",0,0);
	}
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function upload(){
		AsControl.PopView("/Common/BusinessObject/BusinessObjectDocumentList.jsp", "ObjectType=RiskWarningExclude&ObjectNo=<%=serialNo%>");
	}
	function saveRecord(postevent){
		//if(!iV_all("myiframe0"))return;
		as_save("myiframe0",postevent);
	}
	
	function dosubmit(){
		//if(!iV_all("myiframe0"))return;
		saveRecord("submitAction()");
	}
	
	function submitAction(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo)=="undefined" || serialNo.length==0 )
		{
			alert("没有可被提交的预警");
			return ;
		}
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskWarningTaskAction","TaskDtSubmit","serialNo="+serialNo);
		if(returnValue!="Success"){
			alert(returnValue);
			return;
		}
		top.close();
	}
	//是否需要排除字段事件
	function isExclude(){
		var isExclude = getItemValue(0, getRow(0), 'IsExclude');
		if(isExclude == "1"){
			setItemRequired(0, "EXCLUDERESULT", true);
		}else{
			setItemRequired(0, "EXCLUDERESULT", false);
		}
	}
	//是否预警字段事件
	function isWarning(){
		var isWarning = getItemValue(0, getRow(0), 'IsWarning');
		if(isWarning=="1"){
			setItemRequired(0, "DEALMETHOD", true);
			setItemRequired(0, "DENYREASON", false);
		}else if(isWarning=="0"){
			setItemRequired(0, "DEALMETHOD", false);
			setItemRequired(0, "DENYREASON", true);
		}else{
			setItemRequired(0, "DEALMETHOD", false);
			setItemRequired(0, "DENYREASON", false);
		}
	}
	
	<%-- function openDoc(){
		var objectNo=getItemValue(0,0,"SerialNo");
		OpenComp("DocumentList","/Common/BusinessObject/BusinessObjectDocumentList.jsp","ObjectType=<%=objectType%>&RightType=<%=rightType2%>&ObjectNo="+objectNo,"frame_list","");
	} --%>
	
	 $(document).ready(function(){
		 setFlowSerialNo();
 	});
	 
	function setFlowSerialNo(){
		setItemValue(0, getRow(), 'FlowSerialNo', "<%=sFlowSerialNo%>")
	}
	
	function SelectDealMethod(){
		var codeNo = "DealMethod";
		AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "\n", "","0",getRow(),"","DealMethod");
	}
	function changeSignalLevel(){
		
	}
	<%-- if((getItemValue(0,getRow(0),'SignalType'))=="01"&&"02"!="<%=taskChannel%>"){
		openDoc();
	} --%>
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>