<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

	String sTempletNo = CurPage.getParameter("TemplateNo");//--ģ���--MarketCustomerInfo
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDDDWJbo("CertType","jbo.sys.CODE_LIBRARY,itemNo,ItemName,Codeno='CustomerCertType'  and ItemNo like '2%' and ItemNo <> '2' and IsInuse='1' ");	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("CustomerID", "");
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","All","Button","����","����","top.close()","","","",""},
	};
	sButtonPosition = "south";
%>
<HEAD>
<title>����������</title>
</HEAD>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script><script type="text/javascript">
function saveRecord(){
	if(!iV_all("0")) return ;
	if(!checkCertInfo()) return ;
	var certType = getItemValue(0,getRow(0),"CertType");
	var certIDTemp = getItemValue(0,getRow(0),"CertID");
	var certID = certIDTemp.replace(/\s+/g,"");
	var customerName = getItemValue(0,getRow(0),"CustomerName");
	var listType = getItemValue(0,getRow(0),"ListType");
	var countryCode = getItemValue(0,getRow(0),"CountryCode");
	var inputOrgID = getItemValue(0,getRow(0),"InputOrgID");
	var inputUserID = getItemValue(0,getRow(0),"InputUserID");
	var inputDate = getItemValue(0,getRow(0),"InputDate");
	var applyType ="<%=CurPage.getParameter("ApplyType")%>,";
	var status =getItemValue(0,getRow(0),"STATUS");
    //var sReturn = CustomerManage.checkPartnerAndAdd(certType,certID,customerName,listType,countryCode,inputOrgID,inputUserID,inputDate);
   // ���ͻ��Ƿ����
    var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.AddAndCheckMarketCustomer", "checkCustomerListAndInfo", "ApplyType="+applyType+","+"CertType="+certType+",CertID="+certID+",CustomerName="+customerName+",ListType="+listType+",CountryCode="+countryCode+",InputOrgID="+inputOrgID+",InputUserID="+inputUserID+",InputDate="+inputDate+",Status="+status);
    //var customer = AsControl.RunASMethod("BusinessManage","InitApplyInfo",para);
    temp = sReturn.split("@");
    if(temp[0] == "true"){
 		alert("�ͻ�\""+temp[2]+"\"�����ɹ���");
 		var sCustomerID = temp[1];
		top.returnValue = "true@"+temp[5]+"@"+temp[4]+"@"+temp[6]+"@"+temp[3];
		//flag+"@"+taskSerialNo+"@"+flowSerialNo+"@"+phaseNo+"@"+functionID;
		CustomerManage.updateCertID(sCustomerID, certType, certID);
		CustomerManage.updateCustomerName(sCustomerID);
 		top.close();
 	}else if(temp[0] == "Import"){
 		alert("�ͻ�\""+temp[2]+"\"����ɹ���");
 		sCustomerID = temp[1];
 		sCustomerType = temp[3];
		top.returnValue="true@"+temp[1]+"@"+temp[2]+"@"+temp[3];
 		top.close();
 	}else{
 		alert("�ͻ�\""+customerName+"\"�����������ȷ�ϣ�");
 	}
 }
	function checkCertInfo(){
		var certId=getItemValue(0,getRow(),"CertID");
		var recertId=getItemValue(0,getRow(),"ReCERTID");
		if(recertId && certId && certId!=recertId){
			alert("֤������ȷ����֤�����벻һ��!"); 
			return false;
		}
		return true;
	}

	function initRow(){
		setItemValue(0,getRow(),"INPUTUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"CUSTOMERNAME","");
		setItemValue(0,getRow(),"CERTID","");
		setItemValue(0,getRow(),"CERTTYPE","2010");//�����̻��ŵ�׼�룬֤������Ĭ��ΪӪҵִ��
		//setItemValue(0,getRow(),"LISTTYPE","0020");//0020
		setItemValue(0,getRow(),"INPUTORGID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,getRow(),"INPUTDATE","<%=StringFunction.getToday()%>");
		setItemValue(0,getRow(),"STATUS","4");
	}

</script>
<script type="text/javascript">
initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
