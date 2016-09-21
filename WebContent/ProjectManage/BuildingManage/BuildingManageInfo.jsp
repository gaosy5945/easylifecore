<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String RightType = CurPage.getParameter("RightType");
	if(RightType == null) RightType = "";
    String projectSerialNo = "" ;

  	ASResultSet rs1 = Sqlca.getASResultSet(new SqlObject("select projectSerialNo from PRJ_BUILDING where buildingSerialNo=:buildingSerialNo ").setParameter("buildingSerialNo",serialNo));
 	if(rs1.next()){
 		projectSerialNo=rs1.getString("projectSerialNo");
			if(projectSerialNo == null) {
				projectSerialNo = "";
			}
		}
	rs1.getStatement().close(); 

	String sTempletNo = "BuildingManageInfoNew";//--模板号--
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", serialNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();	
	
	dwTemp.Style = "2";//freeform

	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			{"true","All","Button","保存","保存所有修改","saveRecord()","","","","btn_icon_save",""},
			{"true","All","Button","暂存","暂时保存所有修改内容","saveRecordTemp()","","","",""},
	};
%>
<HEAD>
<title>楼盘详情</title>
</HEAD>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	function saveRecord(){
		setItemValue(0,getRow(),"TEMPSAVEFLAG","0"); //暂存标志（0：保存  1：暂存）
		as_save("myiframe0");
	}
	function saveRecordTemp()
	{
		setItemValue(0,getRow(),'TEMPSAVEFLAG',"1"); //暂存标志（0：保存  1：暂存）
		as_saveTmp("myiframe0");
	}
	function calculatePB(){
		var businessSum = getItemValue(0,getRow(),"BUSINESSSUM").replace(/,/g,"");
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"PB");
		var developAmount = getItemValue(subdwname,getRow(subdwname),"DEVELOPAMOUNT").replace(/,/g,"");
		var progress = getItemValue(subdwname,getRow(subdwname),"PROGRESS").replace(/,/g,"");
		if(developAmount < 0 || progress < 0) {
			alert("参数不可为负数！请重新输入！");
			return;
		}
		if(businessSum == "0.00"){
			setItemValue(0,getRow(),"pb1","0"); 
			setItemValue(0,getRow(),"pb2","0"); 
		}else{
			var pb1 = FormatKNumber(parseFloat(businessSum)/parseFloat(developAmount),2);
			var pb2 = FormatKNumber(parseFloat(businessSum)/(parseFloat(developAmount)*parseFloat(progress)/100.00),2);
			if(pb1 == "" || pb1 == "null" || pb1 == "NaN.00" || pb1 == "Infinity.00") pb1 = "0";
			if(pb2 == "" || pb2 == "null" || pb2 == "NaN.00" || pb1 == "Infinity.00") pb2 = "0";
			setItemValue(0,getRow(),"pb1",pb1); 
			setItemValue(0,getRow(),"pb2",pb2);
		}
	}
	function initRow(){
		var buildingType = getItemValue(0,getRow(),"BUILDINGTYPE");
		var status = getItemValue(0,getRow(),"STATUS");
		var houseCondition = getItemValue(0,getRow(),"HOUSECONDITION");
		var buyBack = getItemValue(0,getRow(),"BUYBACK");
		var landProperty = getItemValue(0,getRow(),"LANDPROPERTY");
		if(typeof(buildingType) == "undefined" || buildingType.length == 0){
			setItemValue(0,0,"BUILDINGTYPE","01");
		}
		if(typeof(status) == "undefined" || status.length == 0){
			setItemValue(0,0,"STATUS","1");
		}
		if(typeof(houseCondition) == "undefined" || houseCondition.length == 0){
			setItemValue(0,0,"HOUSECONDITION","01");
		}
		if(typeof(buyBack) == "undefined" || buyBack.length == 0){
			setItemValue(0,0,"BUYBACK","1");
		}
		if(typeof(landProperty) == "undefined" || landProperty.length == 0){
			setItemValue(0,0,"LANDPROPERTY","01");
		}
		
  		var businessSum = ProjectManage.selectBusinessSum("<%=projectSerialNo%>");
  		setItemValue(0,getRow(),"BUSINESSSUM",businessSum);
  		
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"PB");
		var developAmount = getItemValue(subdwname,getRow(subdwname),"DEVELOPAMOUNT");
		var progress = getItemValue(subdwname,getRow(subdwname),"PROGRESS");
		
 		if(typeof(developAmount) != "undefined" || developAmount.length != 0 || developAmount != "0.00"){
			if(typeof(progress) != "undefined" || progress.length != 0 || progress != "0.00"){
				if(businessSum == "null") businessSum = "0.00";
				var pb1 = FormatKNumber(parseFloat(businessSum)/parseFloat(developAmount),2);
				var pb2 = FormatKNumber(parseFloat(businessSum)/(parseFloat(developAmount)*parseFloat(progress)/100.00),2);
				if(pb1 == "" || pb1 == "null" || pb1 == "NaN.00" || pb1 == "Infinity.00") pb1 = "0";
				if(pb2 == "" || pb2 == "null" || pb2 == "NaN.00" || pb1 == "Infinity.00") pb2 = "0";
				setItemValue(0,getRow(),"pb1",pb1);
				setItemValue(0,getRow(),"pb2",pb2);
			}
		} 
	}
	function compareSize(){
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"PB");
		var commenceDate = getItemValue(subdwname,getRow(subdwname),"COMMENCEDATE");//开工日期
		var commenceYear = commenceDate.substring(0, 4);
		var commenceMonth = commenceDate.substring(5, 7);
		var commenceDay = commenceDate.substring(8, 10);
		var commenceDateSub = commenceYear+commenceMonth+commenceDay;
		var opDate = getItemValue(subdwname,getRow(subdwname),"OPDATE");//竣工日期
		var opYear = opDate.substring(0, 4);
		var opMonth = opDate.substring(5, 7);
		var opDay = opDate.substring(8, 10);
		var opDateSub = opYear+opMonth+opDay;
		var ecDate = getItemValue(subdwname,getRow(subdwname),"ECDATE");//竣工验收合格日期(预计)
		var ecYear = ecDate.substring(0, 4);
		var ecMonth = ecDate.substring(5, 7);
		var ecDay = ecDate.substring(8, 10);
		var ecDateSub = ecYear+ecMonth+ecDay;
		var deliverDate = getItemValue(subdwname,getRow(subdwname),"DELIVERDATE");//交房日期
		var deliverYear = deliverDate.substring(0, 4);
		var deliverMonth = deliverDate.substring(5, 7);
		var deliverDay = deliverDate.substring(8, 10);
		var deliverDateSub = deliverYear+deliverMonth+deliverDay;
		
		if((commenceDateSub != "" || commenceDateSub.length != 0) && (opDateSub != "" || opDateSub.length != 0)){
			if(opDateSub < commenceDateSub || opDateSub == commenceDateSub){
				alert("竣工日期不能小于等于开工日期，请重新输入！");
				setItemValue(subdwname,getRow(subdwname),"OPDATE","");
				return;
			}
		}
		if((opDateSub != "" || opDateSub.length != 0) && (ecDateSub != "" || ecDateSub.length != 0)){
			if(ecDateSub < opDateSub || ecDateSub == opDateSub){
				alert("竣工验收合格日期(预计)不能小于等于竣工日期，请重新输入！");
				setItemValue(subdwname,getRow(subdwname),"ECDATE","");
				return;
			}
		}
		if((commenceDateSub != "" || commenceDateSub.length != 0) && (ecDateSub != "" || ecDateSub.length != 0)){
			if(ecDateSub < commenceDateSub || ecDateSub == commenceDateSub){
				alert("竣工验收合格日期(预计)不能小于等于开工日期，请重新输入！");
				setItemValue(subdwname,getRow(subdwname),"ECDATE","");
				return;
			}
		}
		if((ecDateSub != "" || ecDateSub.length != 0) && (deliverDateSub != "" || deliverDateSub.length != 0)){
			if(deliverDateSub < ecDateSub || deliverDateSub == ecDateSub){
				alert("交房日期不能小于等于竣工验收合格日期(预计)，请重新输入！");
				setItemValue(subdwname,getRow(subdwname),"DELIVERDATE","");
				return;
			}
		}
		if((commenceDateSub != "" || commenceDateSub.length != 0) && (deliverDateSub != "" || deliverDateSub.length != 0)){
			if(deliverDateSub < commenceDateSub || deliverDateSub == commenceDateSub){
				alert("交房日期不能小于等于开工日期，请重新输入！");
				setItemValue(subdwname,getRow(subdwname),"DELIVERDATE","");
				return;
			}
		}
		if((opDateSub != "" || opDateSub.length != 0) && (deliverDateSub != "" || deliverDateSub.length != 0)){
			if(deliverDateSub < opDateSub || deliverDateSub == opDateSub){
				alert("交房日期不能小于等于竣工日期，请重新输入！");
				setItemValue(subdwname,getRow(subdwname),"DELIVERDATE","");
				return;
			}
		}
		
	}
	
	function selectProject(){
		var bdsubdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"PB");
		AsCredit.setGridValue("SelectProjectList", "<%=CurUser.getUserID()%>", "ProjectName=PROJECTNAME@ProjectSerialNo=SERIALNO", "","",bdsubdwname,0);
	}
	function selectPartner(){
		var bdsubdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"BD");
		AsCredit.setGridValue("SelectPartnerCustomer", "<%=CurUser.getUserID()%>", "CustomerName=CustomerName", "","",bdsubdwname,0);
	}
	$(document).ready(function(){
		initRow();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
