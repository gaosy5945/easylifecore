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
	
	//取该合同的客户经理信息
	/* String executiveUserID="",executiveUserName="",executiveOrgID="",executiveOrgName="";
	BizObjectManager bm = JBOFactory.getBizObjectManager( "jbo.app.BUSINESS_CONTRACT" );
	BizObject bo= bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", serialNo).getSingleResult(false);
	if(bo!=null){
		executiveUserID=bo.getAttribute("EXECUTIVEUSERID").getString();
		executiveUserName = com.amarsoft.dict.als.manage.NameManager.getUserName(executiveUserID);
		executiveOrgID=bo.getAttribute("EXECUTIVEORGID").getString();
		executiveOrgName = com.amarsoft.dict.als.manage.NameManager.getOrgName(executiveOrgID);
	} */
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
	BusinessObject relativeobject = bom.loadBusinessObject(relativeObjectType, relativeObjectNo);
	String businesstype = relativeobject.getString("BusinessType");
	String productType3="",roleid="";
	BizObjectManager bm = JBOFactory.getBizObjectManager( "jbo.prd.PRD_PRODUCT_LIBRARY" );
	BizObject bo= bm.createQuery("PRODUCTID=:ProductID").setParameter("ProductID", businesstype).getSingleResult(false);
	if(bo!=null){
		productType3=bo.getAttribute("productType3").getString();
		if("01".equals(productType3)){
			roleid="PLBS0001";//消费类理财经理
		}else{
			roleid="PLBS0002";//经营类理财经理
		}
	}

	String sTempletNo = "ChangeManager01";//--模板号--
	/* ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request); */
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", objectNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("CONTRACTLISTVIEW","<iframe type='iframe' id=\"ContractListPart\" name=\"ContractListPart\" width=\"100%\" height=\"400px\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>",CurPage.getObjectWindowOutput());
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		//as_save("myiframe0");
		var batchFlag = getItemValue(0,0,"ISBATCHCHANGEFLAG");
		if("0"==batchFlag){
			setItemValue(0,0,"BATCHCHANGECONTRACTNOLIST","");
		}
		as_save('refreshSelf()');
	}
	<%/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/%>
	
	function initRow(){
		<%-- if (getRowCount(0)==0){
			setItemValue(0,0,"OLDEXECUTIVEUSERID","<%=executiveUserID%>");
			setItemValue(0,0,"OLDEXECUTIVEUSERNAME","<%=executiveUserName%>");
			setItemValue(0,0,"OLDEXECUTIVEORGID","<%=executiveOrgID%>");
			setItemValue(0,0,"OLDEXECUTIVEORGNAME","<%=executiveOrgName%>");
			setItemValue(0,getRow(),"CONTRACTSERIALNO","<%=serialNo%>");
		} --%>
	}
	
	function selectUserInfo(){
		setGridValuePretreat('SelectUserByRoleAndOrg','<%=roleid%>,<%=CurUser.getOrgID()%>','EXECUTIVEUSERID=USERID@EXECUTIVEUSERNAME=USERNAME@EXECUTIVEORGID=BELONGORG@EXECUTIVEORGNAME=BELONGORGNAME','03','1');
	}
	
	function selectContractByUser(){
		var orgid = getItemValue(0,getRow(),"OLDEXECUTIVEORGID");
		//SelectContractByExecutiveUserID
		var sStyle = "dialogWidth:800px;dialogHeight:600px;resizable:yes;scrollbars:no;status:no;help:no";
		
		//AsDialog.SelectGridValue(doNo, inputParameters, returnFieldString, "",multiFlag,windowStyle,"",manualQueryFlag);
		var returnValueList = AsDialog.SelectGridValue("SelectContractByExecutiveOrgID",orgid+",<%=relativeObjectNo%>",'serialNo@','','true',sStyle,'','2');
		if(typeof(returnValueList)=="undefined"||returnValueList.length==0){
			return;
		}
		
		var returntemp = returnValueList.split("~");
		for(var i=0;i<returntemp.length;i++){
			returnValueList = returnValueList.replace("~",",");
		}
		var BATCHCHANGECONTRACTNOLIST = getItemValue(0, 0, "BATCHCHANGECONTRACTNOLIST");
		if(typeof(BATCHCHANGECONTRACTNOLIST)!="undefined" && BATCHCHANGECONTRACTNOLIST.length!=0){
			returnValueList = BATCHCHANGECONTRACTNOLIST + "," + returnValueList;
		}
		setItemValue(0,0,"BATCHCHANGECONTRACTNOLIST",returnValueList);
	}

	function changeFlag(){
		var batchFlag = getItemValue(0,0,"ISBATCHCHANGEFLAG");
		if("0"==batchFlag){
			setItemRequired(0,"BATCHCHANGECONTRACTNOLIST", false);
			hideItem(0,"BATCHCHANGECONTRACTNOLIST");
			document.frames["myiframe0"].document.all("ContractListPart").parentNode.parentNode.style.display="none";
		}else{
			setItemRequired(0,"BATCHCHANGECONTRACTNOLIST", true);
			showItem(0,"BATCHCHANGECONTRACTNOLIST");
			document.frames["myiframe0"].document.all("ContractListPart").parentNode.parentNode.style.display="block";
		}
		openContractList();
	}
	
	function openContractList(){
		var obj = $('#ContentFrame_ContractListPart');
		var batchFlag = getItemValue(0,0,"ISBATCHCHANGEFLAG");
		if(typeof(obj) == "undefined" || obj == null||batchFlag =="0") return;
		if(typeof(batchFlag) == "undefined" || batchFlag==null||batchFlag.length == 0) return;
		OpenComp("ChangeManager_ViewContractList","/CreditManage/CreditChange/ChangeManager_ViewContractList.jsp","ObjectNo=<%=objectNo%>","ContractListPart","");
	}
	
	function refreshSelf(){
		AsControl.OpenPage("/CreditManage/CreditChange/ChangeManagerInfo.jsp", 
				"ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&TransSerialNo=<%=transSerialNo%>&TransCode=<%=transCode%>&RelativeObjectNo=<%=relativeObjectNo%>&RelativeObjectType=<%=relativeObjectType%>","_self");
	}
	
	$(document).ready(function(){
		initRow();
		changeFlag();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
