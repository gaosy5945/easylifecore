<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>

<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String SerialNo = CurPage.getParameter("SerialNo");
	if(SerialNo == null) SerialNo= "";
	String ProjectSerialNo = CurPage.getParameter("ProjectSerialNo");
	if(ProjectSerialNo == null) ProjectSerialNo = "";
	String BuildingSerialNo = CurPage.getParameter("BuildingSerialNo");
	if(BuildingSerialNo == null) BuildingSerialNo = "";
	String ReadFlag = CurPage.getParameter("ReadFlag");
	if(ReadFlag == null) ReadFlag = "";
	String ProjectType = CurPage.getParameter("ProjectType");
	if(ProjectType == null) ProjectType = "";
	String CustomerID = CurPage.getParameter("CustomerID");
	if(CustomerID == null) CustomerID = "";

	//项目项下业务发放总额
	Double businessSum = Sqlca.getDouble(new SqlObject("select bd.businesssum from prj_relative pr, business_contract bc, business_duebill bd where bd.contractserialno = bc.serialno and pr.objecttype ='jbo.app.BUSINESS_CONTRACT' and pr.objectno=bc.serialno and pr.relativetype = '02' and pr.projectserialno = :projectserialNo").setParameter("projectserialNo",ProjectSerialNo)); 
	Double developAmount = Sqlca.getDouble(new SqlObject("select developAmount from prj_building where buildingSerialNo=:buildingSerialNo").setParameter("buildingSerialNo",BuildingSerialNo));
	Double progress = Sqlca.getDouble(new SqlObject("select progress from prj_building where buildingSerialNo=:buildingSerialNo").setParameter("buildingSerialNo",BuildingSerialNo));

	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info("ProjectBuildingInfo",BusinessObject.createBusinessObject(),CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.Style = "2";//freeform
	if("null".equals(businessSum)){
		dwTemp.setParameter("BusinessSum","0");
	}
	dwTemp.setParameter("SerialNo", SerialNo);
	dwTemp.genHTMLObjectWindow(SerialNo);

	//	dwTemp.replaceColumn("BUILDINGDEVELOPER", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/ProjectManage/BuildingManage/BuildingDeveloperList.jsp?BuildingSerialNo="+BuildingSerialNo+"&ReadFlag="+ReadFlag+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	//dwTemp.replaceColumn("BUILDINGBLOCK", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/ProjectManage/BuildingManage/BuildingBlockList.jsp?BuildingSerialNo="+BuildingSerialNo+"&ReadFlag="+ReadFlag+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	//dwTemp.replaceColumn("CLRMARGININFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"680\" frameborder=\"0\" src=\""+sWebRootPath+"/ProjectManage/ProjectNewApply/CLRMaginInfo.jsp?ObjectNo="+BuildingSerialNo+"&ProjectType="+ProjectType+"&CustomerID="+CustomerID+"&ObjectType="+"jbo.app.BUILDING_INFO"+"&Flag="+"1"+"&ReadFlag="+ReadFlag+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
			{"ReadOnly".equals(ReadFlag)?"false":"true","All","Button","保存","保存所有修改","saveRecord()","","","","",""},
			{"ReadOnly".equals(ReadFlag)?"false":"true","All","Button","暂存","暂时保存所有修改内容","saveRecordTemp()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">

	function saveRecord(){
		var commenceDate = getItemValue(0,getRow(0),"COMMENCEDATE");//开工日期
		var commenceYear = commenceDate.substring(0, 4);
		var commenceMonth = commenceDate.substring(5, 7);
		var commenceDay = commenceDate.substring(8, 10);
		var commenceDateSub = commenceYear+commenceMonth+commenceDay;
		var opDate = getItemValue(0,getRow(0),"OPDATE");//竣工日期
		var opYear = opDate.substring(0, 4);
		var opMonth = opDate.substring(5, 7);
		var opDay = opDate.substring(8, 10);
		var opDateSub = opYear+opMonth+opDay;
		var ecDate = getItemValue(0,getRow(0),"ECDATE");//竣工验收合格日期(预计)
		var ecYear = ecDate.substring(0, 4);
		var ecMonth = ecDate.substring(5, 7);
		var ecDay = ecDate.substring(8, 10);
		var ecDateSub = ecYear+ecMonth+ecDay;
		var deliverDate = getItemValue(0,getRow(0),"DELIVERDATE");//交房日期
		var deliverYear = deliverDate.substring(0, 4);
		var deliverMonth = deliverDate.substring(5, 7);
		var deliverDay = deliverDate.substring(8, 10);
		var deliverDateSub = deliverYear+deliverMonth+deliverDay;
		
		if((commenceDateSub != "" || commenceDateSub.length != 0) && (opDateSub != "" || opDateSub.length != 0)){
			if(opDateSub < commenceDateSub || opDateSub == commenceDateSub){
				alert("竣工日期不能小于等于开工日期，请重新输入！");
				return;
			}
		}
		if((opDateSub != "" || opDateSub.length != 0) && (ecDateSub != "" || ecDateSub.length != 0)){
			if(ecDateSub < opDateSub || ecDateSub == opDateSub){
				alert("竣工验收合格日期(预计)不能小于等于竣工日期，请重新输入！");
				return;
			}
		}
		if((commenceDateSub != "" || commenceDateSub.length != 0) && (ecDateSub != "" || ecDateSub.length != 0)){
			if(ecDateSub < commenceDateSub || ecDateSub == commenceDateSub){
				alert("竣工验收合格日期(预计)不能小于等于开工日期，请重新输入！");
				return;
			}
		}
		if((ecDateSub != "" || ecDateSub.length != 0) && (deliverDateSub != "" || deliverDateSub.length != 0)){
			if(deliverDateSub < ecDateSub || deliverDateSub == ecDateSub){
				alert("交房日期不能小于等于竣工验收合格日期(预计)，请重新输入！");
				return;
			}
		}
		if((commenceDateSub != "" || commenceDateSub.length != 0) && (deliverDateSub != "" || deliverDateSub.length != 0)){
			if(deliverDateSub < commenceDateSub || deliverDateSub == commenceDateSub){
				alert("交房日期不能小于等于开工日期，请重新输入！");
				return;
			}
		}
		if((opDateSub != "" || opDateSub.length != 0) && (deliverDateSub != "" || deliverDateSub.length != 0)){
			if(deliverDateSub < opDateSub || deliverDateSub == opDateSub){
				alert("交房日期不能小于等于竣工日期，请重新输入！");
				return;
			}
		}
		setItemValue(0,getRow(),"TEMPSAVEFLAG","0"); //暂存标志（0：保存  1：暂存）
	    as_save(0);
	}
	
	function saveRecordTemp()
	{
		setItemValue(0,getRow(),"TEMPSAVEFLAG","1"); //暂存标志（0：保存  1：暂存）
		as_saveTmp(0);
	}	
	
	function calculatePB(){
		var businessSum = getItemValue(0,getRow(),"BUSINESSSUM").replace(/,/g,"");
		var developAmount = getItemValue(0,getRow(),"DEVELOPAMOUNT").replace(/,/g,"");
		var progress = getItemValue(0,getRow(),"PROGRESS").replace(/,/g,"");
		if(developAmount < 0 || progress < 0) {
			alert("参数不可为负数！请重新输入！");
			return;
		}else if(developAmount == 0){
			alert("【开发贷款金额】不可为0！请输入！");
			return;
		}
/* 		else if(progress == 0){
			alert("【目前工程进度】不可为0！请输入！");
			return;
		} */
		if(businessSum == "0.00"){
			setItemValue(0,getRow(),"pb1","0"); 
			setItemValue(0,getRow(),"pb2","0"); 
		}else{
			var pb1 = FormatKNumber(parseFloat(businessSum)/parseFloat(developAmount),2);
			var pb2 = FormatKNumber(parseFloat(businessSum)/(parseFloat(developAmount)*parseFloat(progress)/100.00),2);
			setItemValue(0,getRow(),"pb1",pb1); 
			setItemValue(0,getRow(),"pb2",pb2);
		}
	}
	
	function initRow(){
		var serialNo = "<%=SerialNo%>";
  		var businessSum = "<%=businessSum%>";
		var developAmount = "<%=developAmount%>";
		var progress = "<%=progress%>";
		var customerID = "<%=CustomerID%>";
		var CustomerName = ProjectManage.selectCustomerName(customerID);
		if(typeof(serialNo) == "undefined" || serialNo.length == 0 || serialNo == "" || serialNo == "null"){
		    setItemValue(0,0,"PROJECTSERIALNO","<%=ProjectSerialNo%>");
			setItemValue(0,0,"BuildingSerialNo","<%=BuildingSerialNo%>");
			setItemValue(0,0,"BDBuildingSerialNo","<%=BuildingSerialNo%>");
			setItemValue(0,0,"BISerialNo","<%=BuildingSerialNo%>");
			setItemValue(0,0,"CustomerID","<%=CustomerID%>");
			setItemValue(0,0,"CustomerName",CustomerName);
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateHelper.getToday()%>");
		}
 		if(typeof(developAmount) != "undefined" || developAmount.length != 0 || developAmount != "0.00"){
			if(typeof(progress) != "undefined" || progress.length != 0 || progress != "0.00"){
				if(businessSum == "null") businessSum = "0.00";
				var pb1 = FormatKNumber(parseFloat(businessSum)/parseFloat(developAmount),2);
				var pb2 = FormatKNumber(parseFloat(businessSum)/(parseFloat(developAmount)*parseFloat(progress)/100.00),2);
				if(pb1 == "" || pb1 == "null" || pb1 == "NaN.00") pb1 = "0";
				if(pb2 == "" || pb2 == "null" || pb2 == "NaN.00") pb2 = "0";
				setItemValue(0,getRow(),"pb1",pb1);
				setItemValue(0,getRow(),"pb2",pb2);
			}
		} 
	}
	
	function selectPartner(){
		AsDialog.SetGridValue("SelectPartnerCustomer", "<%=CurUser.getUserID()%>", "CustomerName=CustomerName", "");
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
