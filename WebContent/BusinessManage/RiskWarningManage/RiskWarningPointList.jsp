<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	
//��ȡǰ�˴���Ĳ���
	String flowNo =  DataConvert.toString(CurPage.getParameter("FlowNo"));
	if(flowNo==null||flowNo.length()==0)flowNo="";
	
	String status = DataConvert.toString(CurPage.getParameter("Status"));
	if(status==null||status.length()==0)status="";

	String sTempletNo = DataConvert.toString(CurPage.getParameter("TempletNo"));
	if(sTempletNo==null||sTempletNo.length()==0)sTempletNo="";
	
	String applyType = DataConvert.toString(CurPage.getParameter("ApplyType"));
	if(applyType==null||applyType.length()==0)applyType="";
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);//"RiskWarningPointList"
	if("3".equals(status)){
		doTemp.appendJboWhere("Status = '3'");
	}else if("4".equals(status)){
		doTemp.appendJboWhere("Status = '4'");
	}else if("2".equals(status)){
		doTemp.appendJboWhere("Status = '2'");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.MultiSelect = true; 	 //�����ѡ
	dwTemp.ReadOnly = "1";	 	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(CurUser.getOrgID());
    
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","������ʾ����","������ʾ����","edit()","","","","",""},
			{("2".equals(status) ? "true" : "false"),"","Button","�ջ�","�ջ�","takeBack()","","","","",""},
			/* {("1".equals(status))?"true":"false","","Button","�ٴη���","�ٴη������Ԥ��","addRiskPoint()","","","","",""}, */
		};
	
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function takeBack(){
		var flowSerialNo = getItemValue(0,getRow(),"FlowSerialNo");
		var taskSerialNo = flowSerialNo+"0001";
		if(typeof(taskSerialNo) == "undefined" || taskSerialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(!confirm("ȷ���ջظ�����")) return;
		//�����ջؽӿ�
		var returnValue = AsControl.RunASMethod("WorkFlowEngine","TakeBack","<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,"+taskSerialNo+","+flowSerialNo);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		if(returnValue.split("@")[0] == "false") alert(returnValue.split("@")[1]);
		else
		{
			var rwSerialNo = getItemValue(0,getRow(),"SERIALNO");
			AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskWarningThreeSubmitDeal", "updateThreeWarningSubmitStatus", "SerialNo="+rwSerialNo+",Status=1");
			alert(returnValue.split("@")[1]);
			reloadSelf();
		}
	} 
	function addRiskPoint(signalType){
		 var ySerialNos = getItemValue(0, getRow(0), "SerialNo");
		 
		 AsCredit.RunJavaMethodTrans("com.amarsoft.app.risk.StartRiskWarningPoint", "reRunRiskPoint", "FlowNo=<%=flowNo%>"+",ApplyType=<%=applyType%>"+",riskSignalSerialNoString="+ySerialNos);
		 reloadSelf();
	}
	
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 var status = "<%=status%>";
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		 if(status =="3"){
			 AsCredit.openFunction("AddRiskPoint05","SerialNo="+serialNo);
		 }else{
			AsControl.OpenView("/BusinessManage/RiskWarningManage/RiskWarningPointInfo.jsp","SerialNo="+serialNo+"&RightType2=ReadOnly","_blank");
		 }
	}
	
	function updateSignalStatus(status){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		alert(sSerialNo);
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		var num = AsControl.RunASMethod("RiskWarningManage","UpdateSignalStatus",sSerialNo+","+status);
		
       	if(num>0){
       		alert("�ύ�ɹ���");
       	}else
       	{
       		alert("�ύʧ�ܣ�");
       	}
       	reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
