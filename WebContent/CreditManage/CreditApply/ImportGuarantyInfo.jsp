<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>

<%
	String PG_TITLE = "引入最高额担保"; 
	String serialNo = CurPage.getParameter("SerialNo");if(serialNo == null)serialNo = "";
	String objectType = CurPage.getParameter("ObjectType");if(objectType == null) objectType = "";
	String objectNo = CurPage.getParameter("ObjectNo");if(objectNo == null) objectNo = "";
	String changeFlag = CurPage.getParameter("ChangeFlag"); if(changeFlag == null) changeFlag = "";//变更标示
	String parentTransSerialNo = CurPage.getParameter("ParentTransSerialNo");if(parentTransSerialNo == null) parentTransSerialNo = "";
	String documentObjectType = CurPage.getParameter("DocumentObjectType");if(documentObjectType == null) documentObjectType = "";

	String[] relativeTables=com.amarsoft.app.als.guaranty.model.GuarantyFunctions.getRelativeTable(objectType);
	String serialNoType="ApplySerialNo";
	if(!StringX.isEmpty(relativeTables[0])){
		serialNoType=StringFunction.replace(serialNoType, "ApplySerialNo", relativeTables[1]);
	}
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", serialNo);
	inputParameter.setAttributeValue(serialNoType, objectNo);
	
	//ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info("ImportGuarantyInfo", inputParameter, CurPage, request);
	//ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();	
	
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("ImportGuarantyInfo",inputParameter,CurPage);
	
	String jboFrom = doTemp.getJboFrom();
	String jboWhere = doTemp.getJboWhere();

	if(!StringX.isEmpty(relativeTables[0])){
		jboFrom=StringFunction.replace(jboFrom, "jbo.app.APPLY_RELATIVE", relativeTables[0]);
		jboFrom=StringFunction.replace(jboFrom, "ApplySerialNo", relativeTables[1]);
		jboWhere=StringFunction.replace(jboWhere, "ApplySerialNo", relativeTables[1]);
		ASColumn col = doTemp.getColumn("ApplySerialNo");
		col.setAttribute("ColActualName",relativeTables[1]);
		col.setAttribute("ColName",relativeTables[1]);
	}
	doTemp.setJboFrom(jboFrom);
	doTemp.setJboWhere(jboWhere);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(doTemp,CurPage, request);
	
	dwTemp.Style="2";      //设置为freeform风格
	dwTemp.ReadOnly = "0"; //设置为只读

	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.setParameter(serialNoType, objectNo);
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

		setItemValue(0,getRow(),"<%=!StringX.isEmpty(relativeTables[1]) ? relativeTables[1] : "ApplySerialNo"%>","<%=objectNo%>");
		setItemValue(0,getRow(),"UpdateDate","<%=DateHelper.getBusinessDate()%>");
		setItemValue(0,getRow(),"UpdateUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"RelativeType","05");
		setItemValue(0,getRow(),"Currency",getItemValue(0,getRow(),"GuarantyCurrency"));
		as_save("refresh()");
	}
	
	function refresh(){
		var serialNo = getItemValue(0,0,"SerialNo");
		AsControl.OpenPage("/CreditManage/CreditApply/ImportGuarantyInfo.jsp", "SerialNo="+serialNo+"&ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&ChangeFlag=<%=changeFlag%>&ParentTransSerialNo=<%=parentTransSerialNo%>&DocumentObjectType=<%=documentObjectType%>","_self");
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
		setGridValuePretreat(selectSource,'<%=CurUser.getUserID()%>,<%=customerID%>','GuarantorID=CustomerID@GuarantorName=CustomerName','');
	}

	function changeGuarantyTermType(){
		var guarantyTermType = getItemValue(0,getRow(),"GuarantyTermType");
		if(guarantyTermType == null || guarantyTermType.length == 0 || typeof(guarantyTermType) == "undefined")
			return;
		if(guarantyTermType == "01"){//全程担保
			hideItem(0,"GuarantyPeriodFlag");
		}
		if(guarantyTermType == "02"){//阶段性担保
			showItem(0,"GuarantyPeriodFlag");
		}
	}
	
	function init(){
		//计算最高额担保合同余额
		var gcSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(gcSerialNo)=="undefined" || gcSerialNo.length==0) gcSerialNo="";
		var balance = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "getCeilingGCBalance", "GCSerialNo="+gcSerialNo);
		if(balance!="false"){
			setItemValue(0,0,"CeilingBalance",balance);
		}
		
		if(getItemValue(0,0,"GuarantyType") == "01010"){//法人保证
			showItem(0,"GuarantyTermType");
			showItem(0,"GuarantyPeriodFlag");
		} 
		else{
			hideItem(0,"GuarantyTermType");
			hideItem(0,"GuarantyPeriodFlag");
		}
		changeGuarantyTermType();
	}
	
	init();
</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
