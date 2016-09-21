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
	if(relativeObjectNo == null) relativeObjectNo = "";
	if(relativeObjectType == null) relativeObjectType = "";
	if(transSerialNo == null) transSerialNo = "";
	if(transCode == null) transCode = "";
	
	String billMailFlag="",billAddressType="",customerID="",customerType="";
	BizObjectManager bm = JBOFactory.getBizObjectManager( relativeObjectType );
	BizObject bo= bm.createQuery("select O.CustomerID,O.BILLMAILFLAG,O.BILLADDRESSTYPE,CI.CustomerType from O,jbo.customer.CUSTOMER_INFO CI where O.CustomerID = CI.CustomerID and O.SerialNo=:SerialNo").setParameter("SerialNo", relativeObjectNo).getSingleResult(false);
	if(bo!=null){
		customerID=bo.getAttribute("CustomerID").getString();
		billMailFlag=bo.getAttribute("BILLMAILFLAG").getString();
		billAddressType=bo.getAttribute("BILLADDRESSTYPE").getString();
		customerType=bo.getAttribute("CustomerType").getString();
	}

	String sTempletNo = "ChangeBillAddressInfo01";//--模板号--
	/* ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request); */
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", objectNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("BILLADDRESSTYPEINFO","<iframe type='iframe' id=\"AddressPart\" name=\"AddressPart\" width=\"100%\" height=\"400px\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>",CurPage.getObjectWindowOutput());

	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function selectAddress(){
			AsDialog.SetGridValue("ACCTAddress","<%=customerID%>", "BILLADDRESSTYPE=ADDRESSTYPE@ADDRESSTYPE=ADDRESSTYPEName@BILLADDRESSTYPEINFO=ADDRSS1", "");
	}
	function openAddress(){
		var obj = $('#ContentFrame_AddressPart');
		var billMailFlag =getItemValue(0,getRow(),"BILLMAILFLAG");
		if(typeof(obj) == "undefined" || obj == null||billMailFlag =="0") return;
		var billAddressType = getItemValue(0,getRow(),"BILLADDRESSTYPE");
		if(typeof(billAddressType) == "undefined" || billAddressType==null||billAddressType.length == 0) return;
		OpenComp("CustomerAddressList","/CustomerManage/CustomerAddressList.jsp","CustomerID=<%=customerID%>&CustomerType=<%=customerType%>&AddressType="+billAddressType,"AddressPart","");
		
	}
	
	function saveRecord(){
		as_save('selfRefresh()');
	}
	
	function initRow(){
		if (getRowCount(0)==0){
			setItemValue(0,getRow(),"OLDBILLMAILFLAG","<%=billMailFlag%>");
			setItemValue(0,getRow(),"OLDBILLADDRESSTYPE","<%=billAddressType%>");
		}
	}
	function changeFlag(){
		var billMailFlag =getItemValue(0,getRow(),"BILLMAILFLAG");
		if(billMailFlag =="0"){
			setItemRequired(0,"BILLADDRESSTYPE,ADDRESSTYPE", false);
			hideItem(0,"BILLADDRESSTYPE");
			hideItem(0,"ADDRESSTYPE");
			document.frames["myiframe0"].document.all("AddressPart").parentNode.parentNode.style.display="none";
			//hideItem(0,"BILLADDRESSTYPEINFO");
		}else{
			setItemRequired(0,"BILLADDRESSTYPE,ADDRESSTYPE", true);
			showItem(0,"BILLADDRESSTYPE");
			showItem(0,"ADDRESSTYPE");
			document.frames["myiframe0"].document.all("AddressPart").parentNode.parentNode.style.display="block";
			//showItem(0,"BILLADDRESSTYPEINFO");
		}
		openAddress();
	}
	
	$(document).ready(function(){
		initRow();
		//openAddress();
		changeFlag();
	});
	
	function selfRefresh(){
		AsControl.OpenPage("/CreditManage/CreditChange/ChangeBillAddressInfo.jsp","ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&TransSerialNo=<%=transSerialNo%>&TransCode=<%=transCode%>&RelativeObjectNo=<%=relativeObjectNo%>&RelativeObjectType=<%=relativeObjectType%>","_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
