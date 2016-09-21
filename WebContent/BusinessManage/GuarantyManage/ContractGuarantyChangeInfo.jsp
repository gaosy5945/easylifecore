<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@page import="com.amarsoft.dict.als.object.Item"%>
<%@ page contentType="text/html; charset=GBK"%>

<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String PG_TITLE = "����������Ϣ"; 
	String templateNo = "ContractGuarantyInfo_Change";
	String serialNo = CurPage.getParameter("GCCSerialNo");if(serialNo == null)serialNo = "";
	String objectType = CurPage.getParameter("ObjectType");if(objectType == null) objectType = "";
	String objectNo = CurPage.getParameter("ObjectNo");if(objectNo == null) objectNo = "";
	String changeFlag = CurPage.getParameter("ChangeFlag");if(changeFlag == null)changeFlag = "";
	String transSerialNo = CurPage.getParameter("TransSerialNo");if(transSerialNo == null)transSerialNo = "";
	String contractType = CurPage.getParameter("ContractType");if(contractType == null)contractType = "";
	
	String guarantyType = CurPage.getParameter("GuarantyType");
	String guarantyTypeName = "";
	if(guarantyType == null) {
		guarantyType = "";
	}
	else{
		Item item = CodeManager.getItem("GuarantyType",guarantyType);
		templateNo = item.getAttribute6();
		
		guarantyTypeName = item.getItemName();
	}
	
	
	ASObjectModel doTemp = new ASObjectModel(templateNo);
	if("020".equals(contractType)&&!"020".equals(changeFlag)){
		doTemp.setReadOnly("*", true);
		doTemp.setColumnAttribute("GuarantyTypeName", "COLINNERBTEVENT", "");
		doTemp.setReadOnly("RelativeAmount,GuarantorName,CertType,CertID", false);
	}else if("010".equals(changeFlag)&&"01010".equals(guarantyType)){
		doTemp.setReadOnly("*", true);
		doTemp.setColumnAttribute("GuarantyTypeName,GuarantorName", "COLINNERBTEVENT", "");
		doTemp.setReadOnly("GuarantyTermType,GuarantyPeriodFlag,MI", false);
	}else if(!"020".equals(changeFlag)){
		doTemp.setReadOnly("*", true);
		doTemp.setColumnAttribute("GuarantyTypeName,GuarantorName", "COLINNERBTEVENT", "");
	}
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(doTemp,CurPage, request);

	dwTemp.Style="2";      //����Ϊfreeform���
	dwTemp.ReadOnly = "0"; //����Ϊֻ��

	dwTemp.setParameter("GuarantyContractChangeSerialNo", serialNo);
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		{("020".equals(contractType)||"020".equals(changeFlag)||("010".equals(changeFlag)&&"01010".equals(guarantyType)))?"true":"false","All","Button","����","����","saveRecord()","","","",""},
	};
	
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
	BusinessObject creditBo = bom.loadBusinessObject(objectType, objectNo);
	String customerID = creditBo.getString("CustomerID");
	String relativeGCSerialNo = "",relativeCRSerialNo="";
	if(serialNo!=null&&serialNo.length()>0){
		BusinessObject gcChange = bom.loadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT_CHANGE", serialNo);
		relativeGCSerialNo = gcChange.getString("RelativeGCSerialNo");
		ASValuePool crcPara = new ASValuePool();
		crcPara.setAttribute("ObjectNo", serialNo);
		crcPara.setAttribute("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT_CHANGE");
		crcPara.setAttribute("ContractSerialNo", objectNo);
		String crcSelectSql = " objectno=:ObjectNo and objecttype=:ObjectType and contractserialno=:ContractSerialNo ";
		List<BusinessObject> crChangeList = bom.loadBusinessObjects("jbo.app.CONTRACT_RELATIVE_CHANGE", crcSelectSql, crcPara);
		if(crChangeList.size()>0&&crChangeList!=null){
			BusinessObject crChange = crChangeList.get(0);
			relativeCRSerialNo = crChange.getString("RelativeCRSerialNo");
		}
	}
%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	function saveRecord(){
		if(getItemValue(0,0,"GuarantyType") != "01030"){
			if(!checkCertInfo()) return ;
		}
		
		setItemValue(0,0,"UpdateDate","<%=DateHelper.getToday()%>");
		setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
		
		as_save("refresh()");
	}
	
	function refresh(){
		var serialNo = getItemValue(0,0,"SerialNo");
		var guarantyType = getItemValue(0,0,"GuarantyType");
		AsControl.OpenPage("/BusinessManage/GuarantyManage/ContractGuarantyChangeInfo.jsp", "GCCSerialNo="+serialNo+"&ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&GuarantyType="+guarantyType+"&ChangeFlag=<%=changeFlag%>&TransSerialNo=<%=transSerialNo%>","_self");
	}
	
	function itemsControl(){
		var contractType = getItemValue(0,getRow(),"ContractType");
		if(contractType == "010"){
			setItemRequired(0,"RELATIVEAMOUNT",false);
			hideItem(0,"RELATIVEAMOUNT");
			hideItem(0,"CEILINGBALANCE");
		}
		else if(contractType == "020"){
			showItem(0,"RELATIVEAMOUNT");
			setItemRequired(0,"RELATIVEAMOUNT",true);
			showItem(0,"CEILINGBALANCE");
		}
		else{
			//hideItem(0,"CEILINGBALANCE");
		}
	}
		
	function changeGuarantyType(){//���ݵ�����ʽ����ҳ��
		var oldGuarantyType = getItemValue(0,getRow(),"GuarantyType");
		var returnValue= setObjectValue('SelectGuarantyType','CodeNo,GuarantyType','@GuarantyType@0@GuarantyTypeName@1');

		if(typeof(returnValue)=="undefined" || returnValue.length==0) return;
		returnValue = returnValue.split("@");
		if(returnValue[0] != oldGuarantyType){
			var serialNo = "<%=serialNo%>";
			if(typeof(serialNo)=="undefined" || serialNo.length==0){
				if(getRowCount(0)==1)serialNo = getItemValue(0,0,"SerialNo");
			}
			
			AsControl.OpenView("/BusinessManage/GuarantyManage/ContractGuarantyChangeInfo.jsp","GCCSerialNo="+serialNo+"&TransSerialNo=<%=transSerialNo%>&ChangeFlag=<%=changeFlag%>&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&GuarantyType="+returnValue[0],"_self","");
		}
	}
	
	function changeGuarantyTermType(){
		var guarantyTermType = getItemValue(0,getRow(),"GuarantyTermType");
		if(guarantyTermType == null || guarantyTermType.length == 0 || typeof(guarantyTermType) == "undefined")
			return;
		if(guarantyTermType == "01"){//ȫ�̵���
			hideItem(0,"GuarantyPeriodFlag");
			hideItem(0,"Remark");
			//setItemValue(0,0,"GuarantyPeriodFlag","");
		}
		if(guarantyTermType == "02"){//�׶��Ե���
			showItem(0,"GuarantyPeriodFlag");
			changeGuarantyPeriodFlag();
		}
	}
	
	function changeGuarantyPeriodFlag(){
		var guarantyPeriodFlag = getItemValue(0,getRow(),"GuarantyPeriodFlag");
		if(guarantyPeriodFlag == null || guarantyPeriodFlag.length == 0 || typeof(guarantyPeriodFlag) == "undefined")
			return;
		if(guarantyPeriodFlag == "01"){//����ʽ��Ѻ
			hideItem(0,"Remark");
		}
		if(guarantyPeriodFlag == "02"){//����
			showItem(0,"Remark");
		}
	}
	
	function selectGuarantor(){
		var guarantyType = getItemValue(0,getRow(),"GuarantyType");
		var selectSource = "CustomerList";
		if(guarantyType == "01010" || guarantyType == "01020"){
			selectSource = "CustomerList1";//���˿ͻ�
		}
		else if(guarantyType == "01030" || guarantyType == "01080"){
			selectSource = "CustomerList2";//���˿ͻ�
		}
		else{}
		setGridValuePretreat(selectSource,'<%=CurUser.getUserID()%>,<%=customerID%>','GuarantorID=CustomerID@GuarantorName=CustomerName@CertType=CertType@CertID=CertID','');
	}
	
	function showProjectNo(){
		//���˱�֤ʱչ�ֺ�����Ŀ��Ϣ
		var vouchType = getItemValue(0,getRow(),"GuarantyType");
		if(vouchType == "01010"){
			showItem(0,"ProjectSerialNo");
		}
		else{
			hideItem(0,"ProjectSerialNo");
		}
	}
	
	//����¼���CertType��CertID��ѯ�Ƿ��иÿͻ��������������ҳ��Ŀͻ���ź����ƣ������������
	function checkCustomer(){
		var certType = getItemValue(0,getRow(),"CertType");
		var certID = getItemValue(0,getRow(),"CertID");
		if(typeof(certType) == "undefined" || certType.length == 0) return;
		if(typeof(certID) == "undefined" || certID.length == 0) return;
		
		var customer = AsControl.RunASMethod("BusinessManage","KeyCustomer",certType+","+certID);
		if(typeof(customer) == "undefined" || customer.length == 0){
			setItemValue(0,getRow(),"GuarantorID","");
			//setItemValue(0,getRow(),"GuarantorName","");
		}
		else{
			var customerID = customer.split("@")[0];
			var customerName = customer.split("@")[1];			
			setItemValue(0,getRow(),"GuarantorID",customerID);
			setItemValue(0,getRow(),"GuarantorName",customerName);
		}
	}
	
	function getCeilingGCBalance(gcSerialNo,arSerialNo){
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "getCeilingGCBalance", "GCSerialNo="+gcSerialNo+",ARSerialNo="+arSerialNo);
		return returnValue;
	}
	
	//У�鱣֤���˻���Ϣ
	function checkAccount(subdwname,an,ana,ac,an1,acid,amfcid)
	{
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"MI");
		var accountNo = getItemValue(subdwname, getRow(), "AccountNo");
		var accountName = getItemValue(subdwname, getRow(), "AccountName");
		var accountCurrency = getItemValue(subdwname, getRow(), "AccountCurrency");

		var returnValue = AsControl.RunASMethod("WorkFlowEngine","CheckClientCHNName","06,"+accountNo+",7,"+accountName+","+accountCurrency);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		if(returnValue.split("@")[0] == "false"){
			alert(returnValue.split("@")[1]);
			return false;
		}else{
			setItemValue(subdwname, getRow(0), "AccountNo1", returnValue.split("@")[1]);
			setItemValue(subdwname, getRow(0), "AccountName", returnValue.split("@")[2]);
			setItemValue(subdwname, getRow(0), "CustomerID", returnValue.split("@")[3]);
			setItemValue(subdwname, getRow(0), "MFCustomerID", returnValue.split("@")[4]);
		}
		
		return true;
	}
	
	function checkCertInfo(){
		var certType=getItemValue(0,getRow(),"CertType");
		var certId=getItemValue(0,getRow(),"CertID");

		var result = CustomerManage.checkCertID(certType,certId,"CHN");
		if(!result){
			alert("��Ч��֤�����룬���������룡");
			return false;
		}
		return true;
	}
	
	function init(){
		//����������ֻ����߶��
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "getProduct", "ObjectType=<%=objectType%>,ObjectNo=<%=objectNo%>");
		if(returnValue!="false"){
			returnValue = returnValue.split("@");
			if(returnValue[2] == "500" || returnValue[2] == "502" || returnValue[2] == "555" || returnValue[2] == "999"){
				setItemValue(0,0,"ContractType","020");
				setItemDisabled(0,0,"ContractType",true);
			}
		}
		
		if("<%=guarantyType%>" != ""){
			setItemValue(0,getRow(),"GuarantyType","<%=guarantyType%>");
			setItemValue(0,getRow(),"GuarantyTypeName","<%=guarantyTypeName%>");

			var gt = getItemValue(0,0,"GuarantyType");
			if("<%=guarantyType%>".substring(0, 3) == "020" || gt.substring(0, 3) == "020"){
				setItemHeader(0,0,"GuarantorName","��Ѻ������");
			}
			if("<%=guarantyType%>" == "040" || gt == "040"){
				setItemHeader(0,0,"GuarantorName","����������");
			}
		}
		

		//������߶����ͬ���
		var gcSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(gcSerialNo)=="undefined" || gcSerialNo.length==0) gcSerialNo="";
		//var balance = getCeilingGCBalance(gcSerialNo);
		var balance = getCeilingGCBalance("<%=relativeGCSerialNo%>","<%=relativeCRSerialNo%>");
		if(balance!="false"){
			setItemValue(0,0,"CeilingBalance",balance);
		}
		
		itemsControl();

		
		if("<%=guarantyType%>" == "01030" || getItemValue(0,0,"GuarantyType") == "01030"){//����������֤
			setItemRequired(0,"CertType",false);
			setItemRequired(0,"CertID",false);
			hideItem(0,"CertType");
			hideItem(0,"CertID");
		} 

		if("<%=guarantyType%>" != "01030" && getItemValue(0,0,"GuarantyType") != "01030"){
			//����������
			var guarantorID = getItemValue(0,0,"GuarantorID");
			if(guarantorID != null && typeof(guarantorID) != "undefined" && guarantorID.length != 0){
				var guarantorInfo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CustInfoQuery", "getCertInfo", "CustomerID="+guarantorID);
				if(guarantorInfo != null && typeof(guarantorInfo) != "undefined" && guarantorInfo.length != 0){
					guarantorInfo = guarantorInfo.split("@");
					setItemValue(0,0,"CertType",guarantorInfo[1]);
					setItemValue(0,0,"CertID",guarantorInfo[2]);
				}
			}
		}
		
		if("<%=guarantyType%>" == "01010" || getItemValue(0,0,"GuarantyType") == "01010"){//���˱�֤
			showItem(0,"GuarantyTermType");
			showItem(0,"GuarantyPeriodFlag");
			showItem(0,"Remark");
		} 
		else{
			hideItem(0,"GuarantyTermType");
			hideItem(0,"GuarantyPeriodFlag");
			hideItem(0,"Remark");
		}
		changeGuarantyTermType();
		changeGuarantyPeriodFlag();
		
		
		if (getRowCount(0)==0){
			setItemValue(0,0,"InputDate","<%=DateHelper.getToday()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"ContractSerialNo","<%=objectNo%>");
			setItemValue(0,0,"ContractStatus","01");
			setItemValue(0,0,"RelativeType","05");
			setItemValue(0,0,"Currency",getItemValue(0,0,"GuarantyCurrency"));
			setItemValue(0,0,"ChangeFlag","<%=changeFlag%>");
			setItemValue(0,0,"RelativeTransSerialNo","<%=transSerialNo%>");
		}
		
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"MI");
		if(subdwname>=0){
			var accountNo = getItemValue(subdwname, getRow(), "AccountNo");
			if(typeof(accountNo)=="undefined"||accountNo.length==0)return;
			var accountName = getItemValue(subdwname, getRow(), "AccountName");
			if(typeof(accountName)=="undefined"||accountName.length==0){
				checkAccount();
			}
		}
	}
	
	$(document).ready(function(){
		setDialogTitle("������Ϣ����");
		init();
	});
</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>