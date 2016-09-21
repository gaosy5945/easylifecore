<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String ProjectSerialNo = CurPage.getParameter("SerialNo");
	if(ProjectSerialNo == null) ProjectSerialNo = "";
	String CustomerID = CurPage.getParameter("CustomerID");
	if(CustomerID == null) CustomerID = "";
	String ProjectType = CurPage.getParameter("ProjectType");
	if(ProjectType == null) ProjectType = "";

	String sTempletNo = "PBInfo";//--ģ���--
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ProjectSerialNo", ProjectSerialNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();	
	
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			{"true","All","Button","����","���������޸�","saveRecord()","","","","",""},
			{"true","All","Button","�ݴ�","��ʱ���������޸�����","saveRecordTemp()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	function selectPartner(){
		var bisubdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"BI");
		var bdsubdwname = ALSObjectWindowFunctions.getSubObjectWindowName(bisubdwname,"BD");
		var InputUserID = "<%=CurUser.getUserID()%>";
		AsCredit.setGridValue("SelectPartnerCustomer", InputUserID, "CustomerName=CustomerName", "","",bdsubdwname,0,"");
	}
	
	function saveRecord(){
		setItemValue(0,getRow(),"TEMPSAVEFLAG","0"); //�ݴ��־��0������  1���ݴ棩
	    as_save("updateProjectStatus()");
	}
	function updateProjectStatus(){
		var ProjectType = "<%=ProjectType%>";
		var ProjectSerialNo = "<%=ProjectSerialNo%>"
		if(ProjectType == "0110"){ 
			//���Ϊ�����ڷ���Ŀ�����ڱ���¥����Ϣ�󣬽���Ŀ״̬��Ϊ����ͨ��
			ProjectManage.updateProjectStatus(ProjectSerialNo);
		}
	}
	function checkDate(){
		var commenceDate = getItemValue(0,getRow(0),"COMMENCEDATE");//��������
		var commenceYear = commenceDate.substring(0, 4);
		var commenceMonth = commenceDate.substring(5, 7);
		var commenceDay = commenceDate.substring(8, 10);
		var commenceDateSub = commenceYear+commenceMonth+commenceDay;
		var opDate = getItemValue(0,getRow(0),"OPDATE");//��������
		var opYear = opDate.substring(0, 4);
		var opMonth = opDate.substring(5, 7);
		var opDay = opDate.substring(8, 10);
		var opDateSub = opYear+opMonth+opDay;
		var ecDate = getItemValue(0,getRow(0),"ECDATE");//�������պϸ�����(Ԥ��)
		var ecYear = ecDate.substring(0, 4);
		var ecMonth = ecDate.substring(5, 7);
		var ecDay = ecDate.substring(8, 10);
		var ecDateSub = ecYear+ecMonth+ecDay;
		var deliverDate = getItemValue(0,getRow(0),"DELIVERDATE");//��������
		var deliverYear = deliverDate.substring(0, 4);
		var deliverMonth = deliverDate.substring(5, 7);
		var deliverDay = deliverDate.substring(8, 10);
		var deliverDateSub = deliverYear+deliverMonth+deliverDay;
		
		if((commenceDateSub != "" || commenceDateSub.length != 0) && (opDateSub != "" || opDateSub.length != 0)){
			if(opDateSub < commenceDateSub || opDateSub == commenceDateSub){
				alert("�������ڲ���С�ڵ��ڿ������ڣ����������룡");
				setItemValue(0,getRow(0),"OPDATE","");
				return;
			}
		}
		if((opDateSub != "" || opDateSub.length != 0) && (ecDateSub != "" || ecDateSub.length != 0)){
			if(ecDateSub < opDateSub || ecDateSub == opDateSub){
				alert("�������պϸ�����(Ԥ��)����С�ڵ��ڿ������ڣ����������룡");
				setItemValue(0,getRow(0),"ECDATE","");
				return;
			}
		}
		if((commenceDateSub != "" || commenceDateSub.length != 0) && (ecDateSub != "" || ecDateSub.length != 0)){
			if(ecDateSub < commenceDateSub || ecDateSub == commenceDateSub){
				alert("�������պϸ�����(Ԥ��)����С�ڵ��ڿ������ڣ����������룡");
				setItemValue(0,getRow(0),"ECDATE","");
				return;
			}
		}
		if((ecDateSub != "" || ecDateSub.length != 0) && (deliverDateSub != "" || deliverDateSub.length != 0)){
			if(deliverDateSub < ecDateSub || deliverDateSub == ecDateSub){
				alert("�������ڲ���С�ڵ��ڿ������պϸ�����(Ԥ��)�����������룡");
				setItemValue(0,getRow(0),"DELIVERDATE","");
				return;
			}
		}
		if((commenceDateSub != "" || commenceDateSub.length != 0) && (deliverDateSub != "" || deliverDateSub.length != 0)){
			if(deliverDateSub < commenceDateSub || deliverDateSub == commenceDateSub){
				alert("�������ڲ���С�ڵ��ڿ������ڣ����������룡");
				setItemValue(0,getRow(0),"DELIVERDATE","");
				return;
			}
		}
		if((opDateSub != "" || opDateSub.length != 0) && (deliverDateSub != "" || deliverDateSub.length != 0)){
			if(deliverDateSub < opDateSub || deliverDateSub == opDateSub){
				alert("�������ڲ���С�ڵ��ڿ������ڣ����������룡");
				setItemValue(0,getRow(0),"DELIVERDATE","");
				return;
			}
		}
	}
	function saveRecordTemp()
	{
		setItemValue(0,getRow(),"TEMPSAVEFLAG","1"); //�ݴ��־��0������  1���ݴ棩
		as_saveTmp(0);
	}	
	function calculatePB(){
		var bisubdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"BI");
		var businessSum = getItemValue(bisubdwname,getRow(bisubdwname),"BUSINESSSUM").replace(/,/g,"");
		var developAmount = getItemValue(0,getRow(),"DEVELOPAMOUNT").replace(/,/g,"");
		var progress = getItemValue(0,getRow(),"PROGRESS").replace(/,/g,"");
		if(developAmount < 0 || progress < 0) {
			alert("��������Ϊ���������������룡");
			return;
		}
		if(businessSum == "0.00"){
			setItemValue(bisubdwname,getRow(bisubdwname),"pb1","0"); 
			setItemValue(bisubdwname,getRow(bisubdwname),"pb2","0"); 
		}else{
			var pb1 = FormatKNumber(parseFloat(businessSum)/parseFloat(developAmount),2);
			var pb2 = FormatKNumber(parseFloat(businessSum)/(parseFloat(developAmount)*parseFloat(progress)/100.00),2);
			if(pb1 == "" || pb1 == "null" || pb1 == "NaN.00" || pb1 == "Infinity.00") pb1 = "0";
			if(pb2 == "" || pb2 == "null" || pb2 == "NaN.00" || pb2 == "Infinity.00") pb2 = "0";
			setItemValue(bisubdwname,getRow(bisubdwname),"pb1",pb1); 
			setItemValue(bisubdwname,getRow(bisubdwname),"pb2",pb2);
		}
	}
	
	
	function initRow(){
		var bisubdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"BI");
		var bdsubdwname = ALSObjectWindowFunctions.getSubObjectWindowName(bisubdwname,"BD");
		var customerID = "<%=CustomerID%>";
		var CustomerName = ProjectManage.selectCustomerName(customerID);
		var BuildingSerialNo = getItemValue(0,getRow(0),"BuildingSerialNo");
		if(typeof(BuildingSerialNo) == "undefined" || BuildingSerialNo.length == 0){
			setItemValue(bdsubdwname,0,"CustomerID","<%=CustomerID%>");
			setItemValue(bdsubdwname,0,"CustomerName",CustomerName);
			setItemValue(bisubdwname,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(bisubdwname,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(bisubdwname,0,"INPUTDATE","<%=DateHelper.getBusinessDate()%>");
		}
		
  		var businessSum = ProjectManage.selectBusinessSum("<%=ProjectSerialNo%>");
  		setItemValue(bisubdwname,getRow(bisubdwname),"BUSINESSSUM",businessSum);
		var developAmount = getItemValue(0,getRow(0),"DEVELOPAMOUNT");
		var progress = getItemValue(0,getRow(0),"PROGRESS");
		
 		if(typeof(developAmount) != "undefined" || developAmount.length != 0 || developAmount != "0.00"){
			if(typeof(progress) != "undefined" || progress.length != 0 || progress != "0.00"){
				if(businessSum == "null") businessSum = "0.00";
				var pb1 = FormatKNumber(parseFloat(businessSum)/parseFloat(developAmount),2);
				var pb2 = FormatKNumber(parseFloat(businessSum)/(parseFloat(developAmount)*parseFloat(progress)/100.00),2);
				if(pb1 == "" || pb1 == "null" || pb1 == "NaN.00" || pb1 == "Infinity.00") pb1 = "0";
				if(pb2 == "" || pb2 == "null" || pb2 == "NaN.00" || pb2 == "Infinity.00") pb2 = "0";
				setItemValue(bisubdwname,getRow(bisubdwname),"pb1",pb1);
				setItemValue(bisubdwname,getRow(bisubdwname),"pb2",pb2);
			}
		} 
 		var ProjectType = "<%=ProjectType%>";
 		if(ProjectType != "0110"){
 			var bisubdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"PBI");
 			setItemDisabled(bisubdwname, getRow(bisubdwname), "ProjectName", true);
 		}
	}
	
	$(document).ready(function(){
		initRow();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
