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
	dwTemp.Style="1";      	     //--����ΪGrid���--
	//dwTemp.MultiSelect = true; 	 //�����ѡ
	dwTemp.ReadOnly = "1";	 	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");
    
	String sButtons[][] = {
			{"true","","Button","Ԥ������","�鿴/�޸�Ԥ������","viewAndEdit()","","","",""},
			{"true","","Button","������ʵ����鿴","�鿴/�޸�Ԥ������","viewResult()","","","",""},
		};
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
/*~[Describe=�鿴���޸�����;]~*/
	function viewAndEdit(){
		
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		AsCredit.openFunction("RiskWarningPointView","SerialNo="+serialNo+"&RightType=ReadOnly");
	}
	
	 /*~[Describe=�޸ķ������״̬;]~*/
	function viewResult(){
		
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		var flowSerilaNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskWarningPointBackView","getFlowPar","SerialNo="+serialNo);
		
		AsCredit.openFunction("RiskWarningPointBackView","SerialNo="+serialNo+"&FlowSerialNo="+flowSerilaNo+"&RightType=ReadOnly");
	}
	 
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
