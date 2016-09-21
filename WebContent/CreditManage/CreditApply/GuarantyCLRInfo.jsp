<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>

<%
	String PG_TITLE = "保证金详情"; 
	String serialNo = CurPage.getParameter("SerialNo");if(serialNo == null)serialNo = "";
	String objectType = CurPage.getParameter("ObjectType");if(objectType == null)objectType = "";
	String objectNo = CurPage.getParameter("ObjectNo");if(objectNo == null)objectNo = "";
	String rightType = CurPage.getParameter("RightType");if(rightType == null)rightType = "";
	
	Double prepaySum = Sqlca.getDouble(new SqlObject("select (PrepayPercent*PrepayAmount)/100 as prepaySum from clr_margin_info where objectno=:objectNo and objectType='jbo.app.BUILDING_INFO'").setParameter("objectNo",objectNo));
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info("GuarantyCLRInfo",BusinessObject.createBusinessObject(),CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.Style="2";      //设置为freeform风格
	dwTemp.ReadOnly = "0"; //设置为只读
	if(rightType.equals("ReadOnly"))
		dwTemp.ReadOnly = "1";
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.genHTMLObjectWindow(objectType+","+objectNo);

	String sButtons[][] = {
			{"true","All","Button","保存","保存","saveRecord()","","","",""},
		};
	if(rightType.equals("ReadOnly"))
		sButtons[0][0] = "false";
%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>

<script type="text/javascript">
	function calculatePrepaySum(){
		var prepayAmount = getItemValue(0,getRow(),"PrepayAmount").replace(/,/g,"");
		var prepayPercent = getItemValue(0,getRow(),"PrepayPercent").replace(/,/g,"");
		if(prepayAmount < 0 || prepayPercent < 0) {
			alert("参数不可为负数！请重新输入！");
			return;
		}else if(prepayAmount == 0 || prepayPercent == 0){
			setItemValue(0,getRow(),"PrepaySum","0");
		}else{
			var prepaySum = FormatKNumber(parseFloat(prepayAmount)*parseFloat(prepayPercent)/100.00,2);
			setItemValue(0,getRow(),"PrepaySUm",prepaySum); 
		}
	}
	function itemsControl(){
		var calMethod = getItemValue(0,getRow(),"IndividualCalMethod");
		if(typeof(calMethod) == "undefined" || calMethod.length == 0) return;
		if(calMethod == "010" || calMethod == "030"){
			hideItem(0,"IndividualAmount");
			showItem(0,"IndividualPercent");
			setItemRequired(0,"IndividualAmount",false);
			setItemRequired(0,"IndividualPercent",true);
		}
		else if(calMethod == "040"){
			hideItem(0,"IndividualPercent");
			showItem(0,"IndividualAmount");
			setItemRequired(0,"IndividualAmount",true);
			setItemRequired(0,"IndividualPercent",false);
		}
		else{}
	}

	function saveRecord(){
		if(getRowCount(0) == 0){
			try{
				setItemValue(0,getRow(),"InputUserID", "<%=CurUser.getUserID()%>");
				setItemValue(0,getRow(),"InputOrgID", "<%=CurOrg.getOrgID()%>");
				setItemValue(0,getRow(),"InputDate", "<%=DateHelper.getToday()%>");
			}catch(e){}
		}
		else{
			try{
				setItemValue(0,getRow(),"UpdateUserID", "<%=CurUser.getUserID()%>");
				setItemValue(0,getRow(),"UpdateOrgID", "<%=CurOrg.getOrgID()%>");
				setItemValue(0,getRow(),"UpdateDate", "<%=DateHelper.getToday()%>");	
			}catch(e){}
		}
		as_save(0);
	}
	
	//校验保证金账户信息
	function checkAccount(subdwname,an,ana,ac,an1,acid,amfcid)
	{
		var accountNo = getItemValue(0, getRow(), "AccountNo");
		var accountName = getItemValue(0, getRow(), "AccountName");
		var accountCurrency = getItemValue(0, getRow(), "AccountCurrency");

		var returnValue = AsControl.RunASMethod("WorkFlowEngine","CheckClientCHNName","06,"+accountNo+",7,"+accountName+","+accountCurrency);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		if(returnValue.split("@")[0] == "false"){
			alert(returnValue.split("@")[1]);
			return false;
		}else{
			setItemValue(0, getRow(0), "AccountNo1", returnValue.split("@")[1]);
			setItemValue(0, getRow(0), "AccountName", returnValue.split("@")[2]);
			setItemValue(0, getRow(0), "CustomerID", returnValue.split("@")[3]);
			setItemValue(0, getRow(0), "MFCustomerID", returnValue.split("@")[4]);
		}
		
		return true;
	}
	
	function init(){
		if (getRowCount(0)!=0){
			//setItemDisabled(0,getRow(),"AccountNo",true);
			var calMethod = getItemValue(0,getRow(),"IndividualCalMethod");
			if(calMethod == "010" || calMethod == "030"){
				hideItem(0,"IndividualAmount");
				showItem(0,"IndividualPercent");
				setItemRequired(0,"IndividualAmount",false);
				setItemRequired(0,"IndividualPercent",true);
			}
			else if(calMethod == "040"){
				hideItem(0,"IndividualPercent");
				showItem(0,"IndividualAmount");
				setItemRequired(0,"IndividualAmount",true);
				setItemRequired(0,"IndividualPercent",false);
			}
			else{}
		}
		var objectType = "<%=objectType%>";
		var prepaySum = "<%=prepaySum%>";
		if(prepaySum == "null"){
			prepaySum = "0";
		}
		setItemValue(0,getRow(),"PrepaySum",prepaySum);
		if(objectType == "jbo.app.BUILDING_INFO"){
			setItemValue(0,getRow(),"ObjectType","jbo.app.BUILDING_INFO");
			setItemValue(0,getRow(),"ObjectNo","<%=objectNo%>");
		}else{
			setItemValue(0,getRow(),"ObjectType","jbo.guaranty.GUARANTY_CONTRACT");
			setItemValue(0,getRow(),"ObjectNo","<%=objectNo%>");
		}

	}
	
	init();
</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
