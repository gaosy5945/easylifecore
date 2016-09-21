<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@page import="com.amarsoft.app.als.businessobject.*"%> 
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
  
<%
	String PG_TITLE = "�����б�"; // ��������ڱ��� <title> PG_TITLE </title>

	String sObjectNo =CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	String status = CurPage.getParameter("Status");//״̬
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	

	//��ʾģ����
	String templateNo = "AcctFeeList";
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType", sObjectType);
	inputParameter.setAttributeValue("ObjectNo", sObjectNo);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(templateNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	dwTemp.Style = "1"; //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);
	
	String sButtons[][] = {
			{"true", "All", "Button", "����", "����һ����Ϣ","createFee()",""},
			{"true", "All", "Button", "ɾ��", "ɾ��һ����Ϣ","deleteRecord()",""},
			{"true", "", "Button", "����", "��������","viewFee()",""},
			{"false", "", "Button", "������ȡ", "������ȡ","FeeTransaction('3508')",""},
			{"false", "", "Button", "����֧��", "����֧��","FeeTransaction('3520')",""}
	};
	
	if(sObjectType.equals("PutOutApply")){
		sButtons[0][1]="false";
		sButtons[1][1]="false";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf" %>
<script language=javascript>
	/*~[Describe=�½�����;InputParam=��;OutPutParam=��;]~*/
	function createFee(){
		var returnValue = AsDialog.SelectGridValue("SelectComp","FEE%","ComponentID@ComponentName","",false);
		if(typeof(returnValue)=="undefined" || returnValue=="" || returnValue=="_CANCEL_" || returnValue=="_CLEAR_") return;
		
		var termID = returnValue.split("@")[0];
		AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.InitApplyObjects","initFee","ObjectType=<%=sObjectType%>,ObjectNo=<%=sObjectNo%>,ComponentID="+compID);
		<%-- var sReturn = RunMethod("LoanAccount","CreateFee",sTermID+",<%=businessObject.getObjectType()%>,<%=sObjectNo%>,<%=CurUser.getUserID()%>"); --%>
		reloadSelf();
	}
	
	function viewFee(){
		var feeSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(feeSerialNo)=="undefined"||feeSerialNo.length==0){
			alert("��ѡ��һ����¼");
			return;
		}
		popComp("AcctFeeInfo","/Accounting/LoanDetail/LoanTerm/AcctFeeInfo.jsp","FeeSerialNo="+feeSerialNo,"");
		reloadSelf();
	}
	
	/*~[Describe=ɾ��;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		setNoCheckRequired(0);  //���������б���������
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("ȷ��ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	/*~[Describe=���ý���;InputParam=��;OutPutParam=��;]~*/
	<%-- function FeeTransaction(transCode){
		var feeSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(feeSerialNo) == "undefined" || feeSerialNo.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		var transactionSerialNo = RunMethod("LoanAccount","CheckExistsTransaction","<%=BUSINESSOBJECT_CONSTANTS.fee%>,"+feeSerialNo+","+transCode+"");
		if(typeof(transactionSerialNo)=="undefined" || transactionSerialNo.length==0||transactionSerialNo=="Null") {
			//��������Ҫ���̵Ľ���
			var returnValue = RunMethod("LoanAccount","CreateTransaction",","+transCode+",<%=BUSINESSOBJECT_CONSTANTS.fee%>,"+feeSerialNo+",,<%=CurUser.getUserID()%>,2");
			returnValue = returnValue.split("@");
			transactionSerialNo = returnValue[1];
			if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
				alert("��������{"+transCode+"}ʱʧ�ܣ�����ԭ��Ϊ��"+returnValue);
				return;
			}
		}
		
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&ViewID=000";
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		if(confirm("��ȷ���Ƿ�������˴���"))
		{
			var returnValue = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,Y");
			if(typeof(returnValue)=="undefined"||returnValue.length==0){
				alert("ϵͳ�����쳣��");
				return;
			}
			var message=returnValue.split("@")[1];
			alert(message);
			reloadSelf();
		}
	} --%>
</script>
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>