<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String PG_TITLE = "�ؼ���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������	��������ˮ�š��������͡������š�ҵ�����͡��ͻ����͡��ͻ�ID
	
	String templateNo = CurPage.getParameter("TemplateNo");
	String businessPriority = CurPage.getParameter("BusinessPriority");
	String nonstdIndicator = CurPage.getParameter("NonstdIndicator");
	String groupSerialNo = CurPage.getParameter("GroupSerialNo");
	String accountingOrgID = CurPage.getParameter("AccountingOrgID");
	String orgID = CurUser.getOrgID();
	String orgLevel = "";
	String orgName = "";
	ASResultSet rs = Sqlca.getASResultSet("Select OrgLevel,OrgName from ORG_INFO where OrgID = '"+orgID+"'");
	if(rs.next()){
		orgLevel = rs.getStringValue("OrgLevel");
		orgName = rs.getStringValue("OrgName");
	}
	//����ֵת���ɿ��ַ���
	if(templateNo == null) templateNo = "";	
	if(groupSerialNo ==  null) groupSerialNo = "";
	

	ASObjectModel doTemp = new ASObjectModel(templateNo,"");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","����","����","saveRecord()","","","",""},	
	};
	sButtonPosition = "south";
	
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	initAccountingOrgID();
	function initAccountingOrgID(){
		setItemValue(0, getRow(0), "OrgID", "<%=CurOrg.getOrgID()%>");
		setItemValue(0, getRow(0), "AccountingOrgID", "<%=CurOrg.getOrgID()%>");
		setItemValue(0, getRow(0), "AccountingOrgName", "<%=CurOrg.getOrgName()%>");
	}
	/*~[Describe=ѡ��ͻ��Ի���]~*/
	function selectApplyCustomer(){
		var occurType = getItemValue(0,getRow(),"OccurType");
		if(occurType == '0020' || occurType == '0030')
		{
			alert("���»��ɺ�������ѡ������Ϣ�����ɵ���ѡ��ͻ���");
			return;
		}
		
		var applyType = getItemValue(0,getRow(),"ApplyType");
		if(applyType == '2')
		{
			alert("�������ҵ����ѡ������Ϣ�����ɵ���ѡ��ͻ���");
			return;
		}
		
		var returnValue = AsDialog.SetGridValue('SelectApplyCustomer',"<%=CurUser.getUserID()%>,<%=groupSerialNo%>",'CustomerID@CustomerName@CertType@CertID@CustomerType','');
		if(typeof(returnValue)=="undefined"||returnValue=="_CANCEL_"
			||returnValue==""||returnValue=="null")
		{
			return;
		}else{
			setItemValue(0, getRow(0), "CustomerID", returnValue.split("@")[0]);
			setItemValue(0, getRow(0), "CustomerName", returnValue.split("@")[1]);
			setItemValue(0, getRow(0), "CertType", returnValue.split("@")[2]);
			setItemValue(0, getRow(0), "CertID", returnValue.split("@")[3]);
			setItemValue(0, getRow(0), "CustomerType", returnValue.split("@")[4]);
		}
	}
	calcBusinessTerm();
	//�������������
	function calcBusinessTerm(){
		var businessTermYear = getItemValue(0,getRow(),"BusinessTermYear");
		var businessTermMonth = getItemValue(0,getRow(),"BusinessTermMonth");
		if(typeof(businessTermYear) == "undefined" || businessTermYear.length == 0
			|| typeof(businessTermMonth) == "undefined" || businessTermMonth.length == 0) return;
		setItemValue(0,getRow(),"BusinessTerm",parseInt(businessTermYear)*12+parseInt(businessTermMonth));
	}
	//ͨ�����޼��㵽����
	function initMaturity()
	{
		initRate();
		var putoutDate=getItemValue(0,getRow(),"PutOutDate");
		var termMonth=getItemValue(0,getRow(),"BusinessTerm");
		var termDay=getItemValue(0,getRow(),"BusinessTermDay");
		if(typeof(putoutDate) == "undefined" || putoutDate.length == 0) return;
		if(typeof(termMonth) == "undefined" || termMonth.length == 0) return;
		if(typeof(termDay) == "undefined" || termDay.length == 0) return;
		if(termMonth>12 || termMonth<0){
			alert("������������Ӧ��0~12֮�䣬���������룡");
			return;
		}
		if(termDay>30 || termDay<0){
			alert("������������Ӧ��0~30֮�䣬���������룡");
			return;
		}
		var maturity=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CalcMaturity","calcMaturity","loanTermFlag="+"020"+",loanTerm="+termMonth+",putOutDate="+putOutDate);

 		maturity=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CalcMaturity","calcMaturity","loanTermFlag="+"010"+",loanTerm="+termDay+",putOutDate="+maturity);
		setItemValue(0, getRow(0), "MaturityDate",maturity);

	}
	function initTerm()
	{
		var putoutDate=getItemValue(0,getRow(),"PutOutDate");
		var maturityDate=getItemValue(0,getRow(),"MaturityDate");
		if(typeof(putoutDate) == "undefined" || putoutDate.length == 0) return;
		if(typeof(maturityDate) == "undefined" || maturityDate.length == 0) return;
		
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.DateAction","calcTerm","BeginDate="+putoutDate+",EndDate="+maturityDate);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0) return;
		var termMonth = returnValue.split("@")[0];
		var termDay = returnValue.split("@")[1];
		setItemValue(0, getRow(0), "BusinessTerm",termMonth);
		setItemValue(0, getRow(0), "BusinessTermDay",termDay);
	}
	function selectAccountingOrgID()
	{
		var returnValue = setObjectValue("SelectAccountBelongOrg","OrgID,<%=orgID%>&FolderSelectFlag=Y","");
		if(typeof(returnValue)=="undefined"||returnValue=="_CANCEL_"
			||returnValue==""||returnValue=="null")
		{
			return;
		}else if(returnValue=="_CLEAR_")
		{
			setItemValue(0, getRow(0), "AccountingOrgID", "");
			setItemValue(0, getRow(0), "AccountingOrgName", "");
			return;
		}
		
		var values = returnValue.split("@");
		var orgLevel = RunJavaMethodTrans("com.amarsoft.app.bizmethod.SystemManage","selectOrgLevel","paras=orgID@@"+values[0]);
		if("1"==orgLevel||"2"==orgLevel)
		{
			alert("���к�һ�����в�������Ϊ���˻�����������ѡ��");
			return;
		}else
		{
			setItemValue(0, getRow(0), "AccountingOrgID", values[0]);
			setItemValue(0, getRow(0), "AccountingOrgName", values[1]);
		}
	}
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		ChangeCustomer();
		var businessTermDay = getItemValue(0,getRow(),"BusinessTermDay");
		var businessTerm = getItemValue(0,getRow(),"BusinessTerm");
		if("<%=templateNo%>" != "ApplyCLKeyInfo"){
			if(typeof(businessTerm) != "undefined" && businessTerm.length != 0 
				&& typeof(businessTermDay) != "undefined" && businessTermDay.length != 0
				&& parseFloat(businessTerm) <= 0 && parseFloat(businessTermDay) <= 0){
				var businessType = getItemValue(0, getRow(0), "BusinessType");
				if(businessType == '500' || businessType == '502' || businessType == '666')
				{
				}else{
					alert("�������޲���С�ڵ���0");
					return;
				}
			}
		}
		//as_save("myiframe0");
		if(!iV_all("myiframe0"))return;
		if(!certCheck()) return;
		var para = "";
		para+=getItemValue(0,getRow(),"SerialNo")+",";
		para+="<%=CurPage.getParameter("ApplyType")%>,";
		para+=getItemValue(0,getRow(),"CLSerialNo")+",";
		para+=getItemValue(0,getRow(),"OccurType")+",";
		para+=getItemValue(0,getRow(),"RLSerialNo")+",";
		para+=getItemValue(0,getRow(),"BusinessType")+",";
		para+=getItemValue(0,getRow(),"ProductID")+",";
		para+=getItemValue(0,getRow(),"RelativeFlag")+",";
		para+=getItemValue(0,getRow(),"CustomerID")+",";
		para+="03"+",";
		para+=getItemValue(0,getRow(),"CertType")+",";
		para+=getItemValue(0,getRow(),"CertID")+",";
		para+=getItemValue(0,getRow(),"IssueCountry")+",";
		para+=getItemValue(0,getRow(),"CustomerName")+",";
		para+=getItemValue(0,getRow(),"BusinessCurrency")+",";
		para+=getItemValue(0,getRow(),"BusinessSum")+",";
		para+=getItemValue(0,getRow(),"BusinessTermUnit")+",";
		para+=getItemValue(0,getRow(),"BusinessTerm")+",";
		para+=getItemValue(0,getRow(),"BusinessTermDay")+",";
		para+=getItemValue(0,getRow(),"BusinessPriority")+",";
		para+=getItemValue(0,getRow(),"NonstdIndicator")+",";
		para+=getItemValue(0,getRow(),"AccountingOrgID")+",";
		para+=getItemValue(0,getRow(),"FundFlag")+",";
		para+=getItemValue(0,getRow(),"FundBusinessType")+",";
		para+=getItemValue(0,getRow(),"FundProductID")+",";
		para+="<%=CurUser.getUserID()%>,";
		para+="<%=CurUser.getOrgID()%>,<%=groupSerialNo%>"+",";
		para+=getItemValue(0,getRow(),"MarketCustomerID")+","+getItemValue(0,getRow(),"ProjectSerialNo")+","+getItemValue(0,getRow(),"MerchandiseID");
		var customer = AsControl.RunASMethod("BusinessManage","InitApplyInfo",para);
		if(typeof(customer) == "undefined" || customer.length == 0 || customer.indexOf("@") == -1)
		{
			alert("������������±��棡");
			return;
		}
		else
		{
			var flag = customer.split("@")[0];
			if(flag == "error")
			{
				alert(customer.split("@")[1]);
				return;
			}
			else
			{
				var serialNo = customer.split("@")[1];
				var customerID = customer.split("@")[2];
				var functionID = customer.split("@")[3];
				var flowSerialNo = customer.split("@")[4];
				var taskSerialNo = customer.split("@")[5];
				var phaseNo = customer.split("@")[6];
				var msg = customer.split("@")[7];
				setItemValue(0,getRow(),"CustomerID",customerID);
				setItemValue(0,getRow(),"SerialNo",serialNo);
				alert(msg);
				if(flag == "true")
				{
					top.returnValue = flag+"@"+taskSerialNo+"@"+flowSerialNo+"@"+phaseNo+"@"+functionID;
					top.close();
				}
			}
			
		}
	}
	
	//�ı�����������ʾ�����ض�Ⱥ�ͬ��
	function ChangeApplyType()
	{
		var applyType = getItemValue(0,getRow(),"ApplyType");
		if(applyType == '2')
		{
			showItem("myiframe0","CLContractNo");
			setItemRequired("myiframe0","CLContractNo",true);
			setItemValue(0,getRow(),"OccurType","0010");
			ChangeOccurType();
			hideItem("myiframe0","OccurType");
		}
		else
		{
			hideItem("myiframe0","CLContractNo");
			setItemValue(0,getRow(),"CLContractNo","");
			setItemRequired("myiframe0","CLContractNo",false);
			showItem("myiframe0","OccurType");
		}
	}
	
	//�ı䷢��������ʾ�����ع�����ͬ��
	function ChangeOccurType()
	{
		var occurType = getItemValue(0,getRow(),"OccurType");
		if(occurType == '0010')
		{
			hideItem("myiframe0","RLSerialNo");
			setItemValue(0,getRow(),"RLSerialNo","");
			setItemRequired("myiframe0","RLSerialNo",false);
		}
		else
		{
			showItem("myiframe0","RLSerialNo");
			setItemRequired("myiframe0","RLSerialNo",true);
		}
	}
	
	
	//�ı�֤�����ͺ�֤�������ѯ��Ӧ�Ŀͻ���Ϣ
	function ChangeCustomer()
	{
		var certType = getItemValue(0,getRow(),"CertType");
		var certID = getItemValue(0,getRow(),"CertID");
		if(typeof(certType) == "undefined" || certType.length == 0) return;
		if(typeof(certID) == "undefined" || certID.length == 0) return;
		
		if(!certCheck()) return;
		
		var customer = AsControl.RunASMethod("BusinessManage","KeyCustomer",certType+","+certID);
		if(typeof(customer) == "undefined" || customer.length == 0)
		{
			setItemValue(0,getRow(),"CustomerID","");
			//setItemValue(0,getRow(),"CustomerName","");
		}
		else
		{
			var customerID = customer.split("@")[0];
			var customerName = customer.split("@")[1];
			var customerType = customer.split("@")[2];
			var issueCountry = customer.split("@")[3];
			
			setItemValue(0,getRow(),"CustomerID",customerID);
			setItemValue(0,getRow(),"CustomerName",customerName);
			setItemValue(0,getRow(),"CustomerType",customerType);
			setItemValue(0,getRow(),"IssueCountry",issueCountry);
		}
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
	
	//���Ŷ����ʾ�ױ�ҵ��Ʒ��
	function DisplayBusinessType()
	{
		if("<%=CurPage.getParameter("ApplyType")%>" != "Apply03") return;
		var relativeFlag = getItemValue(0,getRow(),"RelativeFlag");
		if(relativeFlag == "1")
		{
			showItem("myiframe0","ProductName");
			showItem("myiframe0","BusinessTypeName");
			setItemRequired("myiframe0","BusinessTypeName",true);
		}
		else
		{
			hideItem("myiframe0","ProductName");
			hideItem("myiframe0","BusinessTypeName");
			setItemRequired("myiframe0","BusinessTypeName",false);
		}
	}
	
	//ѡ��ͻ�����ʱ֤�����͡�֤���š��ͻ�����Ϊֻ��
	function ChangeCustomerName(){
		setItemDisabled(0, getRow(), "CertID", true);
		setItemDisabled(0, getRow(), "CertType", true);
		setItemDisabled(0, getRow(), "CustomerName", true);
	}

	//��ʼ��ʱ���÷���
	ChangeApplyType();
	ChangeOccurType();
	DisplayBusinessType();
	ChangeBusinessTypeName();
	insert();
	
	function insert(){
		var businessTermDay = getItemValue(0, getRow(),"BusinessTermDay");
		 if(typeof(businessTermDay)=="undefined" || businessTermDay.length==0 ){
			setItemValue(0, getRow(), "BusinessTermDay", "0");
		 }
	}
	
	if(<%=businessPriority != null && !"".equals(businessPriority)%>)
	{
		setItemValue(0,getRow(),"BusinessPriority","<%=businessPriority%>");
	}
	if(<%=nonstdIndicator != null && !"".equals(nonstdIndicator)%>)
	{
		setItemValue(0,getRow(),"NonstdIndicator","<%=nonstdIndicator%>");
	}
	//���ͬʱ�����ױ�ѡ���ױʵķ�����Ʒ
	function selectProductFor555(){
		var inputParameters={"ProductType1":"02","Status":"1"};
		AsCredit.setJavaMethodTree("com.amarsoft.app.als.prd.web.ui.ProductTreeFor555",inputParameters,0,0,"ProductID","ProductName");
		var productID = getItemValue(0, getRow(), "ProductID");
		if(typeof(productID)=="undefined" || productID.length==0 ) return;
		var businessType = AsControl.RunASMethod("BusinessManage","KeyBusinessType",productID);
		if(businessType.split("@")[0] == "true"){
			setItemValue(0, getRow(), "BusinessType", businessType.split("@")[1]);
			setItemValue(0, getRow(), "BusinessTypeName", businessType.split("@")[2]);
		}
		ChangeBusinessTypeName();
	}
	//���ͬʱ�����ױ�ѡ���ױʵĻ�����Ʒ
	function selectBusinessTypeFor555(){
		var productID = getItemValue(0,getRow(),"ProductID");
		var inputParameters={"ProductType1":"01","ProjectProductID":productID,"ProductType3":"01","Status":"1"};
		AsCredit.setJavaMethodTree("com.amarsoft.app.als.prd.web.ui.ProductTreeFor555",inputParameters,0,0,"BusinessType","BusinessTypeName");
		ChangeBusinessTypeName();
	}
	//ѡ�񷽰���Ʒ
	function selectProduct(prductType3){
		var applyType = getItemValue(0,getRow(),"ApplyType");
		var occurType = getItemValue(0,getRow(),"OccurType");
		if(occurType == '0020' || occurType == '0030'){
			alert("���»��ɺ�������ѡ������Ϣ�����ɵ���ѡ�񷽰���Ʒ��");
			return;
		}
		
		if("2" == applyType) //�������
		{
			var CLSerialNo = getItemValue(0,getRow(),"CLSerialNo");
			if(typeof(CLSerialNo) == "undefined" || CLSerialNo.length == 0)
			{
				alert("����ѡ��������Ŷ�Ⱥ�ͬ��");
				return;
			}
		}
		var clcontractSerialNo = getItemValue(0,0,"CLSerialNo");
		var inputParameters={"ProductType1":"02","ProductType2":"1","ApplyType":applyType,"ProductType3":prductType3,"Status":"1","CLContractSerialNo":clcontractSerialNo};
		AsCredit.setJavaMethodTree("com.amarsoft.app.als.prd.web.ui.ProductTreeGenerator",inputParameters,0,0,"ProductID","ProductName");
		
		var productID = getItemValue(0, getRow(), "ProductID");
		if(typeof(productID)=="undefined" || productID.length==0 ) return;
		var businessType = AsControl.RunASMethod("BusinessManage","KeyBusinessType",productID);
		if(businessType.split("@")[0] == "true"){
			setItemValue(0, getRow(), "BusinessType", businessType.split("@")[1]);
			setItemValue(0, getRow(), "BusinessTypeName", businessType.split("@")[2]);
		}
		ChangeBusinessTypeName();
	}
	//ѡ��������Ʒ
	function selectMerchandiseBrandModel(){
		var merchandiseType = getItemValue(0,0,'MerchandiseType');
		if(typeof(merchandiseType)=="undefined" || merchandiseType=="") {
			alert("����ѡ����Ʒ����");
			return;
		}
		var values = setGridValuePretreat('MerchandiseList',merchandiseType,'MerchandiseID=MERCHANDISEID@BrandModel=BRANDMODEL@MerchandiseBrand=MERCHANDISEBRAND@MerchandisePrice=MERCHANDISEPRICE@MerchandiseAttribute1=ATTRIBUTE1@BusinessTermMonth=ATTRIBUTE2','');
		if(typeof(values)=="undefined" || values=="") {
			alert("���ȴ���ѡ��ѡ����Ʒ");
			return;
		}
		var businessTermMonth = parseInt(values.split('@')[5]);
		setItemValue(0,0,'BusinessTerm',values.split('@')[5]);
		setItemValue(0,0,'BusinessTermYear',parseInt(businessTermMonth/12));
		setItemValue(0,0,'BusinessTermMonth',businessTermMonth-parseInt(businessTermMonth/12)*12+"");
		
	}
	
	//ѡ�񹫻��𷽰���Ʒ
	function selectFundProduct(prductType3)
	{
		var applyType = getItemValue(0,getRow(),"ApplyType");
		var occurType = getItemValue(0,getRow(),"OccurType");
		if(occurType == '0020' || occurType == '0030')
		{
			alert("���»��ɺ�������ѡ������Ϣ�����ɵ���ѡ�񷽰���Ʒ��");
			return;
		}
		setObjectValuePretreat('SelectFundProductLibrary','ProductType1,02,ProductType2,1,ProductType3,'+prductType3+',ApplyType,'+applyType,'@FundProductID@0@FundProductName@1');
	}
	
	//ѡ�������Ʒ
	function selectBusinessType(prductType2,prductType3){
		var applyType = getItemValue(0,getRow(),"ApplyType");
		var occurType = getItemValue(0,getRow(),"OccurType");
		if(occurType == '0020' || occurType == '0030'){
			alert("���»��ɺ�������ѡ������Ϣ�����ɵ���ѡ�������Ʒ��");
			return;
		}
		
		if("2" == applyType) //�������
		{
			var CLSerialNo = getItemValue(0,getRow(),"CLSerialNo");
			if(typeof(CLSerialNo) == "undefined" || CLSerialNo.length == 0)
			{
				alert("����ѡ��������Ŷ�Ⱥ�ͬ");
				return;
			}
		}

		var productID = getItemValue(0,getRow(),"ProductID");
		if(typeof(productID) == "undefined" || productID.length == 0) productID = "";
		var inputParameters={"ProductType1":"01","ProductType2":prductType2,"ProjectProductID":productID,"ApplyType":applyType,"ProductType3":prductType3,"Status":"1"};
		
		var clcontractSerialNo = getItemValue(0,0,"CLSerialNo");
		inputParameters["CLContractSerialNo"]=clcontractSerialNo;
		AsCredit.setJavaMethodTree("com.amarsoft.app.als.prd.web.ui.ProductTreeGenerator",inputParameters,0,0,"BusinessType","BusinessTypeName");
		//ChangeBusinessTypeName();//ckxu�޸�
	}
	
	//ѡ��ͻ������Ϣ
	function selectCLContract()
	{
		var clType = "";
		if("<%=templateNo%>" == "ApplyBusInfo"){
			clType = "0101";
		}else{
			clType = "0101";			
		}
		var today =  "<%=DateHelper.getBusinessDate()%>"
		var returnValue = setGridValuePretreat('SelectCLContract','<%=CurUser.getUserID()%>,'+clType+','+today,'CLSerialNo=SerialNo@CLContractNo=CONTRACTARTIFICIALNO@CustomerID=CustomerID@CustomerName=CustomerName@CertType=CERTTYPE@CertID=CERTID@CustomerType=CUSTOMERTYPE@AccountingOrgID=ACCOUNTINGORGID@AccountingOrgName=ACCOUNTINGORGNAME','','1');
		if(typeof(returnValue)=="undefined" || returnValue.length==0 || returnValue == "_CLEAR_") return;
		ChangeCustomerName();
	}
	//ѡ����������Ϣ
	function selectMarketCustomer(){
		var marketProductID = getItemValue(0, getRow(0), "MerchandiseID");
		if(typeof(marketProductID)=="undefined" || marketProductID.length==0 || marketProductID==null)
		{
			alert("����ѡ����Ʒ");
			return;
		}
		//���������̵����ͺ����룬Ȼ�����ö�Ӧ����Ŀ���ͽ�����ʱ����Ĭ��ֻ����
		var returnvalue = setGridValuePretreat('ProjectMarketCreditList',marketProductID,'BusinessSum=PROJECTCLAMT@MarketCustomerID=CUSTOMERID@MarketCustomerName=CUSTOMERNAME@ProjectSerialNo=SERIALNO@ProjectName=PROJECTNAME@BusinessType=PRODUCTLIST@BusinessTypeName=PRODUCTLISTNAME','','');
		if(typeof(returnValue)=="undefined" || returnValue.length==0 || returnValue == "_CLEAR_") return;
		//setItemValue(0, getRow(0), "MarketCustomerID",returnvalue.split("@")[0]);
		//setItemValue(0, getRow(0), "MarketCustomerName",returnvalue.split("@")[1]);
	}
	//ѡ����Ŀ������Ϣ
	function selectProjectInfo(){
		var customerID = getItemValue(0, getRow(0), "MarketCustomerID");
		var merchandiseID = getItemValue(0, getRow(0), "MerchandiseID");
		if(typeof(customerID)=="undefined" || customerID.length==0 || customerID==null)
		{
			alert("��ѡ����������Ϣ");
			return;
		}
		var returnValue = setGridValuePretreat('ProjectMarketApplyList',customerID+","+merchandiseID,'ProjectSerialNo=SERIALNO@ProjectName=PROJECTNAME@BusinessSum=PROJECTCLAMT@BusinessType=PRODUCTLIST','','');
		if(typeof(returnValue)=="undefined" || returnValue.length==0 || returnValue == "_CLEAR_") return;
		// 		setItemValue(0, getRow(0), "ProjectSerialNo",returnvalue.split("@")[0]);
// 		setItemValue(0, getRow(0), "ProjectName",returnvalue.split("@")[1]);
		//��ȡ��Ʒ�����ƣ�������д�뵽����
		var returnProject = RunJavaMethodTrans("com.amarsoft.app.als.prd.web.GetProductInfo","getProductNames","productID="+returnValue.split("@")[3].replace(/[,]/g,"@"));
		setItemValue(0, getRow(0), "BusinessTypeName",returnProject.replace(/[@]/g,","));
	}
	//
	
	function ChangeBusinessTypeName(){
		var businessType = getItemValue(0, getRow(0), "BusinessType");
		if(businessType == '500' || businessType == '502' || businessType == '666'){
			setItemRequired("myiframe0","BusinessSum,BusinessTerm,BusinessTermDay,BusinessTermYear,BusinessTermMonth",false);
			hideItem("myiframe0","BusinessSum");
			hideItem("myiframe0","BusinessTermYear");
			hideItem("myiframe0","BusinessTermMonth");
			hideItem("myiframe0","Month");
			hideItem("myiframe0","BusinessTermDay");
			hideItem("myiframe0","Day");
			setItemDisabled(0, getRow(), "BusinessSum", true);
			setItemDisabled(0, getRow(), "BusinessTerm", true);
		}
		
		if("001,002".indexOf(businessType) >= 0 && businessType != "")
		{
			showItem("myiframe0","FundFlag");
			var fundFlag = getItemValue(0, getRow(0), "FundFlag");
			if(fundFlag == "1")
			{
				showItem("myiframe0","FundProductName");
				showItem("myiframe0","FundBusinessTypeName");
				setItemRequired("myiframe0","FundBusinessTypeName",true);
			}
			else
			{
				hideItem("myiframe0","FundProductName");
				hideItem("myiframe0","FundBusinessTypeName");
				setItemRequired("myiframe0","FundBusinessTypeName",false);
			}
		}
		else
		{
			try{
				hideItem("myiframe0","FundFlag");
				hideItem("myiframe0","FundProductName");
				hideItem("myiframe0","FundBusinessTypeName");
				setItemRequired("myiframe0","FundBusinessTypeName",false);
			}catch(e){}
		}
	}
	//ѡ��ͻ������Ϣ
	function selectDuebill()
	{	
		var returnValue = "";
		var templateNo = "<%=templateNo%>";
		if(templateNo == "ApplyKeyInfo"){
			returnValue = setGridValuePretreat('SelectDuebillNo1','<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>','RLSerialNo=SERIALNO@BusinessType=BUSINESSTYPE@BusinessTypeName=BUSINESSTYPENAME@ProductID=PRODUCTID@ProductName=PRODUCTNAME@CustomerID=CUSTOMERID@CustomerName=CUSTOMERNAME@CertType=CERTTYPE@CertID=CERTID@CustomerType=CUSTOMERTYPE@AccountingOrgID=ACCOUNTINGORGID@AccountingOrgName=ACCOUNTINGORGNAME','','1');
		}else if(templateNo == "ApplyBusInfo"){
			returnValue = setGridValuePretreat('SelectDuebillNo2','<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>','RLSerialNo=SERIALNO@BusinessType=BUSINESSTYPE@BusinessTypeName=BUSINESSTYPENAME@ProductID=PRODUCTID@ProductName=PRODUCTNAME@CustomerID=CUSTOMERID@CustomerName=CUSTOMERNAME@CertType=CERTTYPE@CertID=CERTID@CustomerType=CUSTOMERTYPE@AccountingOrgID=ACCOUNTINGORGID@AccountingOrgName=ACCOUNTINGORGNAME','','1');
		}else{
			returnValue = setGridValuePretreat('SelectDuebillNo','<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>','RLSerialNo=SERIALNO@CustomerID=CUSTOMERID@CustomerName=CUSTOMERNAME@CertType=CERTTYPE@CertID=CERTID@CustomerType=CUSTOMERTYPE','','1');
		}
		if(typeof(returnValue)=="undefined" || returnValue.length==0 || returnValue == "_CLEAR_") return;
		ChangeCustomerName();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>