<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String docNo = CurPage.getParameter("DocNo");
	if(docNo == null) docNo = "";

	String sTempletNo = "RiskWarningReport";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(docNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","save_Record()","","","",""},
		{"true","All","Button","提交","完提交","Submit()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

	function save_Record(){
		setItemValue(0, 0, "InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0, 0, "UserName","<%=CurUser.getUserName()%>");
		setItemValue(0, 0, "InputDate","<%=StringFunction.getToday()%>");
		as_save(0);
	}
		
	function Submit(){
		var docNo = "<%=docNo%>";
		var phaseAction = getItemValue(0,getRow(),"PHASEACTIONTYPE");	
		if (typeof(docNo)=="undefined" || docNo.length==0){
			alert("请保存后再提交！"); 
			return;
		}
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.risk.RiskReportUpload", "updateIsOrNoSortNo", "DocNo="+docNo+",PhaseActionType="+phaseAction);
		
		if(result =="true"){
			alert("风险报告提交成功！");
			top.close();
		}else{
			alert("风险报告提交失败！");
		}
	}
	
	
	function onChangePhaseAction(){
		var phaseAction = getItemValue(0,getRow(),"PHASEACTIONTYPE");		
		if(phaseAction == '01'){
			setItemRequired(0,"PhaseOpinion",false);
		}
		else{
			setItemRequired(0,"PhaseOpinion",true);
		}
	}
	
	function GetSerialNo(){
		var serialNo = getSerialNo("PUB_TODO_LIST","SERIALNO","");
		setItemValue(0,0,"TRACEOBJECTTYPE", "jbo.doc.DOC_LIBRARY");
		setItemValue(0,0,"TRACEOBJECTNO", "<%=docNo%>");
		setItemValue(0,0,"TODOTYPE", "11");
	}
	
	if("<%=serialNo%>" == ""){
		GetSerialNo();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
