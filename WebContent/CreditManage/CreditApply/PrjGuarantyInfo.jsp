<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@page import="com.amarsoft.dict.als.object.Item"%>
<%@ page contentType="text/html; charset=GBK"%>

<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String PG_TITLE = "合作项目担保额度"; 
	String templateNo = "GuarantyContractInfo_Prj";
	String serialNo = CurPage.getParameter("SerialNo");if(serialNo == null)serialNo = "";
	String objectType = CurPage.getParameter("ObjectType");if(objectType == null) objectType = "";
	String objectNo = CurPage.getParameter("ObjectNo");if(objectNo == null) objectNo = "";
	String changeFlag = CurPage.getParameter("ChangeFlag");if(changeFlag == null)changeFlag = "";
	String parentTransSerialNo = CurPage.getParameter("ParentTransSerialNo");if(parentTransSerialNo == null) parentTransSerialNo = "";
	String documentObjectType = CurPage.getParameter("DocumentObjectType");if(documentObjectType == null) documentObjectType = "";
	
	
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel(templateNo,BusinessObject.createBusinessObject(),CurPage);
	
	String jboFrom = doTemp.getJboFrom();
	String jboWhere = doTemp.getJboWhere();

	String[] relativeTables=com.amarsoft.app.als.guaranty.model.GuarantyFunctions.getRelativeTable(objectType);
	if(!StringX.isEmpty(relativeTables[0])){
		jboFrom=StringFunction.replace(jboFrom, "jbo.app.APPLY_RELATIVE", relativeTables[0]);
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

	dwTemp.setParameter("GuarantyContractSerialNo", serialNo);
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
			setItemValue(0,getRow(),"<%=!StringX.isEmpty(relativeTables[1]) ? relativeTables[1] : "ApplySerialNo"%>","<%=objectNo%>");
			setItemValue(0,getRow(),"ContractStatus","01");
			setItemValue(0,getRow(),"RelativeType","05");
			setItemValue(0,getRow(),"Currency",getItemValue(0,getRow(),"GuarantyCurrency"));
		}
		setItemValue(0,getRow(),"UpdateDate","<%=DateHelper.getBusinessDate()%>");
		setItemValue(0,getRow(),"UpdateUserID","<%=CurUser.getUserID()%>");
		
		as_save("0");
	}
	
	//合作项目详情
	function openPrj(){
		var prjSerialNo = getItemValue(0,0,"ProjectSerialNo");
		AsCredit.openFunction("ProjectInfoTree", "SerialNo="+prjSerialNo+"&RightType="+"ReadOnly");
	}
	
	function changeGuarantyTermType(){
		var guarantyTermType = getItemValue(0,getRow(),"GuarantyTermType");
		if(guarantyTermType == null || guarantyTermType.length == 0 || typeof(guarantyTermType) == "undefined")
			return;
		if(guarantyTermType == "01"){//全程担保
			hideItem(0,"GuarantyPeriodFlag");
			hideItem(0,"Remark");
			//setItemValue(0,0,"GuarantyPeriodFlag","");
		}
		if(guarantyTermType == "02"){//阶段性担保
			showItem(0,"GuarantyPeriodFlag");
			changeGuarantyPeriodFlag();
		}
	}
	
	function changeGuarantyPeriodFlag(){
		var guarantyPeriodFlag = getItemValue(0,getRow(),"GuarantyPeriodFlag");
		if(guarantyPeriodFlag == null || guarantyPeriodFlag.length == 0 || typeof(guarantyPeriodFlag) == "undefined")
			return;
		if(guarantyPeriodFlag == "01"){//已正式抵押
			hideItem(0,"Remark");
		}
		if(guarantyPeriodFlag == "02"){//其他
			showItem(0,"Remark");
		}
	}
	
	function init(){
		setItemValue(0,getRow(),"GuarantyType","01010");
		setItemValue(0,getRow(),"GuarantyTypeName","法人保证");

		var guarantorID = getItemValue(0,0,"GuarantorID");
		if(guarantorID != null && typeof(guarantorID) != "undefined" && guarantorID.length != 0){
			var guarantorInfo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CustInfoQuery", "getCertInfo", "CustomerID="+guarantorID);
			if(guarantorInfo != null && typeof(guarantorInfo) != "undefined" && guarantorInfo.length != 0){
				guarantorInfo = guarantorInfo.split("@");
				setItemValue(0,0,"CertType",guarantorInfo[1]);
				setItemValue(0,0,"CertID",guarantorInfo[2]);
			}
		}
		
		changeGuarantyTermType();
		changeGuarantyPeriodFlag();
		
		var prjSerialNo = getItemValue(0,0,"ProjectSerialNo");
		var prjName = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "getPrjName", "PrjSerialNo="+prjSerialNo);
		if(typeof(prjName)!="undefined" && prjName.length!=0){
			setItemValue(0,0,"ProjectName",prjName);
		}
		
	}
	setDialogTitle("担保信息详情");
	init();
</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
