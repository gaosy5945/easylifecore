<%@page import="com.amarsoft.are.jbo.ql.Parser"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String inputuserid = CurUser.getUserID();
	String signalType  = DataConvert.toString(CurPage.getParameter("SignalType")); //"01"-����;"02"-���;"03"-��ʾ
	if(signalType==null||signalType.length()==0)signalType="";
	String status = DataConvert.toString(CurPage.getParameter("Status"));
	if(status==null||status.length()==0)status="";
	String taskchannel = DataConvert.toString(CurPage.getParameter("TaskChannel"));//������ʶ��01�˹���02����
	if(taskchannel==null||taskchannel.length()==0)taskchannel="";
	String templetNo = DataConvert.toString(CurPage.getParameter("TempletNo"));
	if(templetNo==null||templetNo.length()==0)templetNo="";
	ASObjectModel doTemp = new ASObjectModel(templetNo);
	if("3,5".equals(status)){//Ԥ������-��Ԥ��ҳ��
		doTemp.appendJboWhere("status in ('3','5')");
	}else{
		doTemp.appendJboWhere(" status = '"+status+"' ");
	}
	if(!"".equals(taskchannel))doTemp.appendJboWhere(" and o.TaskChannel='"+taskchannel+"' ");
	//if(!"".equals(taskchannel))doTemp.appendJboWhere(" and o.TaskChannel in ('01','02') ");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.MultiSelect = true; //�����ѡ
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(signalType+","+inputuserid);

	String sthflag = "false" ,edtflag1 = "false" ,edtflag2 = "false";
	if("02".equals(taskchannel)){//����������ɫԤ��
		if("0".equals(status))sthflag = "true";
		else edtflag1 = "true";
	}else{
		if("01".equals(signalType))edtflag1 = "true";
		if("02".equals(signalType))edtflag2 = "true";
	}
	String sButtons[][] = {
			{sthflag,"ALL","Button","����","��ɫԤ������","doSth()","","","",""},//������ɫԤ������taskchannel
			{edtflag1,"","Button","Ԥ������","�鿴/�޸�Ԥ������","viewAndEdit()","","","",""},
			{edtflag2,"","Button","Ԥ���������","�鿴/�޸�Ԥ������","viewAndEdit()","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	function viewAndEdit(){//Ԥ������
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		var duebillSerialNo = getItemValue(0,getRow(),"OBJECTNO");
		var contractSerialno = getItemValue(0,getRow(),"CONTRACTSERIALNO");
		var customerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskWarningManagement", "getFlowSerialNo", "SerialNo="+serialNo);
		var putoutSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskWarningManagement", "getPutoutSerialNo", "SerialNo="+serialNo);
		AsCredit.openFunction("RiskWarningDetailInfo","SerialNo="+serialNo+"&DuebillSerialNo="+putoutSerialNo+"&ContractSerialno="+contractSerialno+"&ObjectType=jbo.al.RISK_WARNING_SIGNAL&ObjectNo="+serialNo+"&FlowSerialNo="+result+"&CustomerID="+customerID+"&RightType=ReadOnly");
		reloadSelf();
	}
	
	function doSth(){//Ԥ������
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		var duebillSerialNo = getItemValue(0,getRow(),"OBJECTNO");
		var customerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskWarningManagement", "getYRiskSerialNo", "SerialNo="+serialNo);
		AsCredit.openFunction("RiskWarningDetailInfo","SerialNo="+serialNo+"&DuebillSerialNo="+duebillSerialNo+"&YSerialNo="+result+"&CustomerID="+customerID);
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
