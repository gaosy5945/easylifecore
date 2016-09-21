<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sSignalType  = DataConvert.toString(CurPage.getParameter("SignalType"));
	if(sSignalType==null||sSignalType.length()==0)sSignalType="";
	String sTempletNo  = DataConvert.toString(CurPage.getParameter("TempletNo"));
	if(sTempletNo==null||sTempletNo.length()==0)sTempletNo="";
	String sDoFlag  = DataConvert.toString(CurPage.getParameter("DoFlag"));
	if(sDoFlag==null||sDoFlag.length()==0)sDoFlag="";
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);//"RiskWarningPointList"
	doTemp.setJboWhere(" O.SIGNALID=RWC.SIGNALID and RWC.OBJECTTYPE = '02' and o.status = '1'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	//dwTemp.MultiSelect = true; 	 //允许多选
	dwTemp.ReadOnly = "1";	 	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");
    
	String sButtons[][] = {
			{"true","","Button","预警详情","查看/修改预警详情","viewAndEdit()","","","",""},
			{"true","","Button","整改落实情况查看","查看/修改预警详情","viewResult()","","","",""},
		};
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
/*~[Describe=查看及修改详情;]~*/
	function viewAndEdit(){
		
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		AsCredit.openFunction("RiskWarningPointView","SerialNo="+serialNo+"&RightType=ReadOnly");
	}
	
	 /*~[Describe=修改反馈结果状态;]~*/
	function viewResult(){
		
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var flowSerilaNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskWarningPointBackView","getFlowPar","SerialNo="+serialNo);
		
		AsCredit.openFunction("RiskWarningPointBackView","SerialNo="+serialNo+"&FlowSerialNo="+flowSerilaNo+"&RightType=ReadOnly");
	}
	 
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
