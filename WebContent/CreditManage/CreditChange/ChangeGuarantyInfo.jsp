<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@page import="com.amarsoft.dict.als.object.Item"%>
<%@ page contentType="text/html; charset=GBK"%>

<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String PG_TITLE = "担保方案信息"; 
	String templateNo = "GuarantyContractInfo_Change";
	String serialNo = CurPage.getParameter("SerialNo");if(serialNo == null)serialNo = "";
	String gcSerialNo = CurPage.getParameter("GCSerialNo");if(gcSerialNo == null)gcSerialNo = "";
	String objectType = CurPage.getParameter("ObjectType");if(objectType == null) objectType = "";
	String objectNo = CurPage.getParameter("ObjectNo");if(objectNo == null) objectNo = "";
	String changeFlag = CurPage.getParameter("ChangeFlag");if(changeFlag == null)changeFlag = "";
	String parentTransSerialNo = CurPage.getParameter("ParentTransSerialNo");if(parentTransSerialNo == null) parentTransSerialNo = "";
	String documentObjectType = CurPage.getParameter("DocumentObjectType");if(documentObjectType == null) documentObjectType = "";
	
	
	String guarantyType = CurPage.getParameter("GuarantyType");
	String guarantyTypeName = "";
	if(guarantyType == null) {
		guarantyType = "";
	}
	else{
		Item item = CodeManager.getItem("GuarantyType",guarantyType);
		templateNo = item.getAttribute4();
		guarantyTypeName = item.getItemName();
	}
	
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel(templateNo,BusinessObject.createBusinessObject(),CurPage);
		
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(doTemp,CurPage, request);

	dwTemp.Style="2";      //设置为freeform风格
	dwTemp.ReadOnly = "0"; //设置为只读

	dwTemp.setParameter("GuarantyContractSerialNo", gcSerialNo);
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","All","Button","保存","保存","saveRecord()","","","",""},
	};
	
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
	BusinessObject creditBo = bom.loadBusinessObject(objectType, objectNo);
	String customerID = creditBo.getString("CustomerID"); 
	
%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>

<script type="text/javascript">
	function saveRecord(){
		if(getItemValue(0,getRow(),"ContractType") == "020"){
			var guarantyValue = getItemValue(0,getRow(),"GuarantyValue");
			var relativeAmount = getItemValue(0,getRow(),"RelativeAmount");
			if(typeof(guarantyValue)!="undefined" && guarantyValue.length!=0 && typeof(relativeAmount)!="undefined" && relativeAmount.length!=0){
				if(parseFloat(relativeAmount) > parseFloat(guarantyValue)){
					alert("最高额为本笔提供的担保金额不得大于担保合同金额！");
					setItemValue(0,getRow(),"RelativeAmount","");
					return;
				}
				//判断为本比担保金额不大于余额
				var serialno = getItemValue(0,getRow(),"SerialNo");
				if(typeof(serialno)!="undefined" && serialno.length!=0){
					var arSerialNo = getItemValue(0,getRow(),"ARSerialNo");
					if(typeof(arSerialNo)=="undefined" || arSerialNo.length==0) arSerialNo = "";
					var flag1 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "checkGCRelativeAmount", "GCSerialNo="+serialno+",ARSerialNo="+arSerialNo+",GuarantyValue="+guarantyValue+",RelativeAmount="+relativeAmount, ",");
					if(flag1 == "false"){
						alert("最高额为本笔提供的担保金额不得大于担保合同余额！");
						return;
					}
				}
			}
		}
		
		if (getRowCount(0)==0){
			setItemValue(0,getRow(),"InputDate","<%=DateHelper.getBusinessDate()%>");
			setItemValue(0,getRow(),"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"ContractSerialNo","<%=objectNo%>");
			setItemValue(0,getRow(),"ContractStatus","01");
			setItemValue(0,getRow(),"RelativeType","05");
			setItemValue(0,getRow(),"Currency",getItemValue(0,getRow(),"GuarantyCurrency"));
		}
		setItemValue(0,getRow(),"UpdateDate","<%=DateHelper.getBusinessDate()%>");
		setItemValue(0,getRow(),"UpdateUserID","<%=CurUser.getUserID()%>");
		
		as_save("0");
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
		
	function changeGuarantyType(){//根据担保方式调整页面
		var oldGuarantyType = getItemValue(0,getRow(),"GuarantyType");
		var returnValue= setObjectValue('SelectGuarantyType','CodeNo,GuarantyType','@GuarantyType@0@GuarantyTypeName@1');

		if(typeof(returnValue)=="undefined" || returnValue.length==0) return;
		returnValue = returnValue.split("@");
		if(returnValue[0] != oldGuarantyType){
			var serialNo = getItemValue(0,getRow(),"SerialNo");
			if(typeof(serialNo)=="undefined" || serialNo.length==0)
				serialNo = "<%=serialNo%>";
			AsControl.OpenView("/CreditManage/CreditApply/GuarantyInfo.jsp","SerialNo="+serialNo+"&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&GuarantyType="+returnValue[0],"_self","");
		}
	}
	
	function selectGuarantor(){
		var guarantyType = getItemValue(0,getRow(),"GuarantyType");
		var selectSource = "CustomerList";
		if(guarantyType == "01010" || guarantyType == "01020"){
			selectSource = "CustomerList1";//法人客户
		}
		else if(guarantyType == "01030" || guarantyType == "01080"){
			selectSource = "CustomerList2";//个人客户
		}
		else{}
		setGridValuePretreat(selectSource,'<%=CurUser.getUserID()%>,<%=customerID%>','GuarantorID=CustomerID@GuarantorName=CustomerName@CertType=CertType@CertID=CertID','');
	}
	
	function showProjectNo(){
		//法人保证时展现合作项目信息
		var vouchType = getItemValue(0,getRow(),"GuarantyType");
		if(vouchType == "01010"){
			showItem(0,"ProjectSerialNo");
		}
		else{
			hideItem(0,"ProjectSerialNo");
		}
	}
	
	//根据录入的CertType和CertID查询是否有该客户，若存在则更新页面的客户编号和名称，不存在则插入
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
	
	function getCeilingGCBalance(gcSerialNo){
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "getCeilingGCBalance", "GCSerialNo="+gcSerialNo);
		return returnValue;
	}
	
	function init(){
		if("<%=guarantyType%>" != ""){
			setItemValue(0,getRow(),"GuarantyType","<%=guarantyType%>");
			setItemValue(0,getRow(),"GuarantyTypeName","<%=guarantyTypeName%>");

			var gt = getItemValue(0,0,"GuarantyType");
			if("<%=guarantyType%>".substring(0, 3) == "020" || gt.substring(0, 3) == "020"){
				setItemHeader(0,0,"GuarantorName","抵押人名称");
			}
			if("<%=guarantyType%>" == "040" || gt == "040"){
				setItemHeader(0,0,"GuarantorName","出质人名称");
			}
		}
		

		//计算最高额担保合同余额
		var gcSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(gcSerialNo)=="undefined" || gcSerialNo.length==0) gcSerialNo="";
		var balance = getCeilingGCBalance(gcSerialNo);
		if(balance!="false"){
			setItemValue(0,0,"CeilingBalance",balance);
		}
		
		itemsControl();

		
		if("<%=guarantyType%>" == "01030" || getItemValue(0,0,"GuarantyType") == "01030"){//联贷联保保证
			setItemRequired(0,"CertType",false);
			setItemRequired(0,"CertID",false);
			hideItem(0,"CertType");
			hideItem(0,"CertID");
		} 

		if("<%=guarantyType%>" != "01030" && getItemValue(0,0,"GuarantyType") != "01030"){
			//除联贷联保
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
	}
	setDialogTitle("担保合同变更");
	init();
</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
