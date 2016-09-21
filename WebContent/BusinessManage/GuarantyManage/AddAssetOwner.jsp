<%@ page contentType="text/html; charset=GBK"%>
<%@ page import= "com.amarsoft.app.base.util.DateHelper" %>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%
	String PG_TITLE = "����Ȩ������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	String aoSerialNo = CurPage.getParameter("AssetOwnerSerialNo");
	String assetSerialNo = CurPage.getParameter("AssetSerialNo");
	if(aoSerialNo ==  null) aoSerialNo = "";
	if(assetSerialNo ==  null) assetSerialNo = "";
	String grSerialNo = CurPage.getParameter("GRSerialNo");
	if(grSerialNo == null) grSerialNo = "";
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", aoSerialNo);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info("AssetOwnerKeyInfo",inputParameter, CurPage, request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	dwTemp.setParameter("SerialNo", aoSerialNo);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","All","Button","����","����","saveRecord()","","","",""},	
	};

	String userID = "";
	if(!"".equals(grSerialNo)){
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		BusinessObject gr = bom.loadBusinessObject("jbo.guaranty.GUARANTY_RELATIVE", grSerialNo);
		if(gr!=null){
			BusinessObject gc = bom.loadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", gr.getString("GCSerialNo"));
			if(gc!=null){
				userID = gc.getString("InputUserID");
			}
		}
	}
	if(StringX.isEmpty(userID)) userID = CurUser.getUserID();
	
	//modify by lzq 20150330�����һ�����ϳ��������в鿴ѺƷ���鲻������,����ɾ�� ����Ȩ��
	String sRightType = CurPage.getParameter("RightType");if(sRightType == null)sRightType = "";
	if("ReadOnly".equals(sRightType)){
		 sButtons[0][0] = "false";
	} 

	sButtonPosition = "south";
	
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">

	function saveRecord(){
		if(!iV_all("0")) return ;
		if(!certCheck()) return;
		var customerID = getItemValue(0,getRow(),"CustomerID");
		var customerName = getItemValue(0,getRow(),"CustomerName");
		var certType = getItemValue(0,getRow(),"OwnerCertType");
		var certID = getItemValue(0,getRow(),"OwnerCertID");
		if((customerID == null || customerID.length == 0) && (typeof(certType) != "undefined" && certType.length != 0) && (typeof(certID) != "undefined" && certID.length != 0)){
			var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CustInfoQuery","addCustomer",
					"CertType="+certType+",CertID="+certID+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,"+
					"CustomerName="+customerName);
			sReturn = sReturn.split("@");
			if(sReturn[0] == "true"){
				alert("�����ͻ��ɹ���");
				setItemValue(0,0,"CustomerID",sReturn[1]);
			}
		}
		setItemValue(0,getRow(),"UpdateDate","<%=DateHelper.getToday()%>");
		as_save(0,"self.close();");
	}
	
	//�ı�֤�����ͺ�֤�������ѯ��Ӧ�Ŀͻ���Ϣ
	function changeCustomer()
	{
		var certType = getItemValue(0,getRow(),"OwnerCertType");
		var certID = getItemValue(0,getRow(),"OwnerCertID");
		if(typeof(certType) == "undefined" || certType.length == 0) return;
		if(typeof(certID) == "undefined" || certID.length == 0) return;
		
		if(!certCheck()) return;
		
		var customer = AsControl.RunASMethod("BusinessManage","KeyCustomer",certType+","+certID);
		if(typeof(customer) == "undefined" || customer.length == 0) return;
		else{
			var customerID = customer.split("@")[0];
			var customerName = customer.split("@")[1];
			setItemValue(0,getRow(),"CustomerID",customerID);
			setItemValue(0,getRow(),"CustomerName",customerName);
		}
	}
	
	
	//���֤֤�����
	function certCheck()
	{
		var certType = getItemValue(0,getRow(),"OwnerCertType");
		var certID = getItemValue(0,getRow(),"OwnerCertID");
		if(typeof(certType) == "undefined" || certType.length == 0) return;
		if(typeof(certID) == "undefined" || certID.length == 0) return;
		
	 	if (!CustomerManage.checkCertID(certType, certID)){
	 		setItemUnit(0,getRow(),"OwnerCertID","<font color=red>"+getBusinessMessage('156')+"</font>");
			return false;
		}
	 	else
	 		setItemUnit(0,getRow(),"OwnerCertID","");
		return true;
	}
	
	//ѡ��ͻ�����ʱ֤�����͡�֤���š��ͻ�����Ϊֻ��
	function ChangeCustomerName(){
		setItemDisabled(0, getRow(), "CertID", true);
		setItemDisabled(0, getRow(), "CertType", true);
		setItemDisabled(0, getRow(), "CustomerName", true);
	}

	function selectOwner(){
		setGridValuePretreat("CustomerList",'<%=userID%>','CustomerID=CustomerID@CustomerName=CustomerName@OwnerCertType=CertType@OwnerCertID=CertID','');
	}
	
	setItemValue(0,0,"AssetSerialNo","<%=assetSerialNo%>");
	if(getRowCount(0)==0){
		setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"InputOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(),"InputDate","<%=DateHelper.getToday()%>");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>