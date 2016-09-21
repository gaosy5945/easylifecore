<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
  
<%
	String customerType = CurPage.getParameter("CustomerType");
	if(customerType == null) customerType = "";

	String sTempletNo = "NewCustomerInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//���ͻ�����Ϊ�գ���ʹ�ͻ����Ϳɼ���ѡ������ȡĬ�ϻ�ȡ�Ŀͻ�����
	if("".equals(customerType)){
		doTemp.setVisible("CUSTOMERTYPE", true);
		doTemp.setRequired("CUSTOMERTYPE", true);
		doTemp.setReadOnly("CUSTOMERTYPE", false);
    }else if(customerType.substring(0, 2).equals("03")){
    	doTemp.setDDDWJbo("CustomerType","jbo.sys.CODE_LIBRARY,itemNo,ItemName,codeno = 'CustomerType' and ItemNo like '03%' and IsInUse = '1' ");
    	doTemp.setDefaultValue("CUSTOMERTYPE",customerType);
    	doTemp.setReadOnly("CUSTOMERTYPE", true);
    }else{
    	doTemp.setDDDWJbo("CustomerType","jbo.sys.CODE_LIBRARY,itemNo,ItemName,codeno = 'CustomerType' and ItemNo like '01%' and IsInUse = '1' ");
    	doTemp.setDefaultValue("CUSTOMERTYPE", "01");
    }

	if(customerType.substring(0,2).equals("01")){
		doTemp.setDDDWJbo("CERTTYPE", "jbo.sys.CODE_LIBRARY,ItemNo,ItemName,CodeNo = 'CustomerCertType' and IsInuse='1' and ItemNo like '2%' and ItemNo <> '2' order by SortNo");
		doTemp.setDefaultValue("CERTTYPE", "2020");
	}else if(customerType.substring(0,2).equals("03")){
		doTemp.setDDDWJbo("CERTTYPE", "jbo.sys.CODE_LIBRARY,ItemNo,ItemName,Codeno='CustomerCertType' and SortNo like '1%' and isinuse = '1' order by SortNo");
		doTemp.setDefaultValue("CERTTYPE", "1");
	} 
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("CustomerID", "");
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","ȷ��","ȷ��","saveRecord()","","","",""}, 
		{"true","All","Button","ȡ��","ȡ��","top.close();","","","",""}, 
	};
	sButtonPosition = "south";
%>
<HEAD>
<title>�ͻ�����</title>
</HEAD>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>

<%@page import="com.amarsoft.app.als.customer.model.CustomerConst"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script><script type="text/javascript">

	function saveRecord(){
		if(!iV_all("0")) return ;
		if(!checkCertInfo()) return ;

		var customerName = getItemValue(0,getRow(),"CustomerName");
		var customerType = getItemValue(0,getRow(),"CustomerType");
		var certIDTemp = getItemValue(0,getRow(),"CertID");
		var certID = certIDTemp.replace(/\s+/g,"");
		var certType = getItemValue(0,getRow(),"CertType");
		var issueCountry = getItemValue(0,getRow(),"IssueCountry");
		var inputOrgID = "<%=CurOrg.getOrgID()%>"; 
		var inputUserID = "<%=CurUser.getUserID()%>"; 
		var inputDate = "<%=StringFunction.getToday()%>";

 		var sReturn = CustomerManage.checkCustomer(certID, customerName, customerType, certType, issueCountry, inputOrgID, inputUserID, inputDate);
 		temp = sReturn.split("@");	
 		if(temp[0] == "true"){
			var result = CustomerManage.createCustomerInfo(customerName, customerType, certID, certType, issueCountry, inputOrgID, inputUserID, inputDate);
			tempResult = result.split("@");
			var sCustomerID = tempResult[1];
			//CustomerManage.updateSex(sCustomerID,certType,certID);
			if(tempResult[0] == "true"){
		 		alert("�ͻ�\""+tempResult[2]+"\"�����ɹ���");
				top.returnValue="true@"+tempResult[1]+"@"+tempResult[2]+"@"+tempResult[3];
		 		top.close();
			}else{
				alert("�ͻ�\""+tempResult[2]+"\"����ʧ�ܣ�");
				return;
			}
	 	}else if(temp[0] == "CBEmpty"){
	 		var CustomerID = temp[1];
	 		var sReturn = CustomerManage.selectCustomerBelong(CustomerID, inputOrgID, inputUserID, inputDate);
	 		if(sReturn == "SUCCEED"){
	 			var IsSameName = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.IsSameCustomerName", "isSameCustomerName","CustomerName="+customerName+",CertID="+certID+",CertType="+certType);
	 			if(IsSameName == "No"){
	 				alert("��ע��ÿͻ�Ϊ�����ͻ����Ҵ����ͻ�������¼��ͻ����Ʋ�����");
	 			}
	 			alert("�ͻ�����ɹ���");
	 			top.returnValue="true@"+temp[1]+"@"+temp[2]+"@"+temp[3];
	 			top.close();
	 		}else{
	 			alert("�ͻ�����ʧ�ܣ�");
	 		}
	 	}else{
	 		alert("�ͻ�\""+customerName+"\"���ڡ�"+temp[1]+"�����������ȷ��");
	 		return;
	 	}
 		
	}
	
	function checkCertInfo(){
		var certType=getItemValue(0,getRow(),"CertType");
		var certId=getItemValue(0,getRow(),"CertID");
		var countryCode=getItemValue(0,getRow(),"issueCountry");
		var recertId=getItemValue(0,getRow(),"ReCERTID");
		if(recertId && certId && certId!=recertId){
			alert("֤������ȷ����֤�����벻һ��!"); 
			return false;
		}
		var result = CustomerManage.checkCertID(certType,certId,countryCode);
		if(!result){
				alert("��Ч��֤�����룬���������룡");
				return false;
		}
		return true;
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 