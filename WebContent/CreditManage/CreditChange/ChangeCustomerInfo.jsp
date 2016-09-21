<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.als.awe.ow.ALSBusinessProcess"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	String transSerialNo = CurPage.getParameter("TransSerialNo");
	String transCode = CurPage.getParameter("TransCode");
	String relativeObjectNo = CurPage.getParameter("RelativeObjectNo");
	String relativeObjectType = CurPage.getParameter("RelativeObjectType");
	if(objectNo == null) objectNo = "";
	if(objectType == null) objectType = "";
	
	//取该合同的客户编号、客户名称
	String customerID="",customerName="";
	BizObjectManager bm = JBOFactory.getBizObjectManager(relativeObjectType);
	BizObject bo= bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", relativeObjectNo).getSingleResult(false);
	if(bo!=null){
		customerID=bo.getAttribute("CustomerID").getString();
		customerName=bo.getAttribute("CustomerName").getString();
	}
	int bdNum = 0;
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
	ASValuePool selectBDPara = new ASValuePool();
	selectBDPara.setAttribute("SerialNo", relativeObjectNo);
	String selectBDSql = "businessstatus in ('L0','L11','L12','L13') "+ 
			"and exists (select 1 from jbo.app.CONTRACT_RELATIVE CR where CR.ContractSerialNo=O.ContractSerialNo and CR.ObjectType='jbo.app.BUSINESS_CONTRACT' "+ 
			"and CR.RelativeType='06' and CR.ObjectNo=:SerialNo)";
	List<BusinessObject> bdList = bom.loadBusinessObjects("jbo.app.BUSINESS_DUEBILL", selectBDSql, selectBDPara);
	if(bdList!=null&&bdList.size()>0){
		bdNum = bdList.size();
	}
	
	String sTempletNo = "ChangeCustomerInfo01";//--模板号--
	/* ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request); */
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", objectNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	dwTemp.Style = "2";//freeform
	
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord();","","","",""},

	};

%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

	function saveRecord(){
		setItemValue(0,0,"UPDATEDATE","<%=DateHelper.getBusinessDate()%>");
		as_save("myiframe0");
	}
	
	//查看客户信息
	function viewOldCustomer(){
		viewCustomer(getItemValue(0,getRow(),"OLDCUSTOMERID"));
	}
	
	function viewNewCustomer(){
		viewCustomer(getItemValue(0,getRow(),"NEWCUSTOMERID"));
	}
	
	//客户详情
	function viewCustomer(customerID)
	{
		if(typeof(customerID)== "undefined" || customerID.length == 0)
		{
			return;
		}
		AsCredit.openFunction("IndCustomerInfo","RightType=ReadOnly&CustomerID="+customerID);
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/%>
	function initRow(){
		<%-- if (getRowCount(0)==0){
			setItemValue(0,0,"OLDCUSTOMERID","<%=customerID%>");
			setItemValue(0,0,"OLDCUSTOMERNAME","<%=customerName%>");
			setItemUnit(0,0,"OLDCUSTOMERNAME","<input type=button value=客户详情 onclick=\"viewOldCustomer()\"/>");
			setItemUnit(0,0,"NEWCUSTOMERNAME","<input type=button value=客户详情 onclick=\"viewNewCustomer()\"/>");
			setItemValue(0,getRow(),"CONTRACTSERIALNO","<%=objectNo%>");
		} --%>
		setItemUnit(0,0,"OLDCUSTOMERNAME","<input type=button value=客户详情 onclick=\"viewOldCustomer()\"/>");
		setItemUnit(0,0,"NEWCUSTOMERNAME","<input type=button value=客户详情 onclick=\"viewNewCustomer()\"/>");
	}

	function selectApplyCustomer(){
		var selectGrid = "SelectChangeCustomer2";
		var selectPara = "<%=customerID%>";
		if("<%=bdNum%>">0){
			selectGrid = "SelectChangeCustomer1";
			selectPara = "<%=relativeObjectNo%>,<%=customerID%>";
		}
		var returnValue = AsDialog.SetGridValue(selectGrid,selectPara,'CustomerID@CustomerName@CertType@CertID@CustomerType','');
		if(typeof(returnValue)=="undefined"||returnValue=="_CANCEL_"
			||returnValue==""||returnValue=="null")
		{
			return;
		}else{
			setItemValue(0, getRow(0), "NEWCUSTOMERID", returnValue.split("@")[0]);
			setItemValue(0, getRow(0), "NEWCUSTOMERNAME", returnValue.split("@")[1]);
			//setItemValue(0, getRow(0), "CertType", returnValue.split("@")[2]);
			//setItemValue(0, getRow(0), "CertID", returnValue.split("@")[3]);
			//setItemValue(0, getRow(0), "CustomerType", returnValue.split("@")[4]);
		}
	}
	
	$(document).ready(function(){
		initRow();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
