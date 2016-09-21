<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������ͬ������"; 
	String serialNo = CurPage.getParameter("SerialNo");
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	String customerID = CurPage.getParameter("CustomerID");
	String applicantType = CurPage.getParameter("ApplicantType");
	if("".equals("applicantType") || applicantType== null){
		applicantType = "03";
	}
	if(serialNo == null) serialNo="";
	if(objectType == null) objectType="";
	if(objectNo == null) objectNo="";
	if(customerID == null) customerID="";
	String sTempletNo= "";
	if("03".equals(applicantType)){
		sTempletNo="NewCommonApplier";
	}else if("05".equals(applicantType)){
		sTempletNo="NewShareAppply";
	}
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,"");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����Ϊfreeform���
	dwTemp.ReadOnly = "0"; 

	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","All","Button","����","����","saveRecord()","","","",""},
	};
	%>
<%/*~END~*/%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>

	<script type="text/javascript">
	//������ʱ�ͻ������Ϊ����������
	function saveRecord(){
		if(!iV_all("myiframe0"))return;
		if(!checkCertInfo()) return ;
		//if(!certCheck()) return; 
		var certType = getItemValue(0,getRow(),"CertType");
		var certID = getItemValue(0,getRow(),"CertID");
		var customerID = getItemValue(0,getRow(),"ApplicantID");
		var customerName = getItemValue(0,getRow(),"ApplicantName");

		if((customerID == null || customerID.length == 0) && (typeof(certType) != "undefined" && certType.length != 0) && (typeof(certID) != "undefined" && certID.length != 0)){
			var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CustInfoQuery","addCustomer",
					"CertType="+certType+",CertID="+certID+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,"+
					"CustomerName="+customerName);
			sReturn = sReturn.split("@");
			if(sReturn[0] == "true"){
				alert("�����ͻ��ɹ���");
				setItemValue(0,0,"ApplicantID",sReturn[1]);
			}else if(sReturn[0] == "SUCCEED"){
				setItemValue(0,0,"ApplicantID",sReturn[1]);
			}
		}
		
		setItemValue(0,getRow(), "ApplicantType", "<%=applicantType%>");
		setItemValue(0,getRow(),"InputOrgID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"InputDate","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
		as_save("myiframe0","self.close();");
	}
	
	function init(){
		setItemValue(0,0,"ObjectNo","<%=objectNo%>");
		setItemValue(0,0,"ObjectType","<%=objectType%>");
	}
	
	//����¼���CertType��CertID��ѯ�Ƿ��иÿͻ��������������ҳ��Ŀͻ���ź����ƣ������������
	function checkCustomer(){
		var certType = getItemValue(0,getRow(),"CertType");
		var certID = getItemValue(0,getRow(),"CertID");
		if(typeof(certType) == "undefined" || certType.length == 0) return;
		if(typeof(certID) == "undefined" || certID.length == 0) return;
		
		//if(!certCheck()) return;
		
		var customer = AsControl.RunASMethod("BusinessManage","KeyCustomer",certType+","+certID);
		if(typeof(customer) == "undefined" || customer.length == 0)
		{
			setItemValue(0,getRow(),"ApplicantID","");
			/* setItemValue(0,getRow(),"ApplicantName",""); */
		}
		else
		{
			var customerID = customer.split("@")[0];
			var customerName = customer.split("@")[1];
			var customerType = customer.split("@")[2];
			setItemValue(0,getRow(),"ApplicantID",customerID);
			setItemValue(0,getRow(),"ApplicantName",customerName);
			//setItemValue(0,getRow(),"CustomerType",customerType);
		}
	}
	
	//����ѡ��Ŀͻ�����ҳ���֤����Ϣ
	function updateCert(){
		var returnValue = AsDialog.SetGridValue("ApplicantList", "<%=CurUser.getUserID()%>,<%=objectType%>,<%=objectNo%>", "CustomerID@CustomerName@CertID@CertType", "");
		//var customerID = getItemValue(0,0,"ApplicantID");
		//if(customerID == null || customerID.length == 0) return;
		//var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CustInfoQuery","getCertInfo","CustomerID="+customerID);
		//if(sReturn == null) return;
		//sReturn = sReturn.split("@");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0) return;
		returnValue = returnValue.split("@");
		setItemValue(0,0,"CertType",returnValue[3]);
		setItemValue(0,0,"CertID",returnValue[2]);
		setItemValue(0,0,"ApplicantName",returnValue[1]);
		setItemValue(0,0,"ApplicantID",returnValue[0]);
	}
	
	//���֤֤�����
	function certCheck()
	{
		var certType = getItemValue(0,getRow(),"CertType");
		var certID = getItemValue(0,getRow(),"CertID");
		if(typeof(certType) == "undefined" || certType.length == 0) return;
		if(typeof(certID) == "undefined" || certID.length == 0) return;
		
	 	if (!CustomerManage.checkCertID(certType, certID)){
	 		setItemUnit(0,getRow(),"CertID","<font color=red>"+getBusinessMessage('156')+"</font>");
			return false;
		}
	 	else
	 		setItemUnit(0,getRow(),"CertID","");
		return true;
	}
	
	function checkCertInfo(){
		var certType=getItemValue(0,getRow(),"CertType");
		var certId=getItemValue(0,getRow(),"CertID");
		var countryCode=getItemValue(0,getRow(),"issueCountry");
		var result = CustomerManage.checkCertID(certType,certId,countryCode);
		if(!result){
				alert("��Ч��֤�����룬���������룡");
				return false;
		}
		return true;
	}
	
	init();
	
	</script>

	
<%@ include file="/Frame/resources/include/include_end.jspf"%>
