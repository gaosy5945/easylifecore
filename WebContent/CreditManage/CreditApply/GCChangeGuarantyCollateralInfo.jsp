<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.als.guaranty.model.GuarantyContractAction" %>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>

<%
	String PG_TITLE = "抵质押物信息"; 
	String serialNo = CurPage.getParameter("SerialNo");if(serialNo == null)serialNo = "";
	String objType = CurPage.getParameter("ObjType");if(objType == null)objType = "";//业务阶段类型apply、contract...
	String objNo = CurPage.getParameter("ObjNo");if(objNo == null)objNo = "";//业务阶段编号
	String assetSerialNo = CurPage.getParameter("AssetSerialNo");if(assetSerialNo == null)assetSerialNo = "";
	String gcSerialNo = CurPage.getParameter("GCSerialNo");if(gcSerialNo == null)gcSerialNo = "";
	String assetType = CurPage.getParameter("AssetType");if(assetType == null)assetType = "";
	String templateNo = CurPage.getParameter("TemplateNo");if(templateNo == null)templateNo = "";
	String hideFlag = CurPage.getParameter("HideFlag");if(hideFlag == null)hideFlag = "";
	String docFlag = CurPage.getParameter("DocFlag");if(docFlag == null)docFlag = "";
	//抵质押变更传入参数
	String objectType = CurPage.getParameter("ObjectType");if(objectType == null)objectType = "";
	String objectNo = CurPage.getParameter("ObjectNo");if(objectNo == null)objectNo = "";
	String changeFlag = CurPage.getParameter("ChangeFlag");if(changeFlag == null)changeFlag = "";
	String parentTransSerialNo = CurPage.getParameter("ParentTransSerialNo");if(parentTransSerialNo == null) parentTransSerialNo = "";//变更总交易流水号
	String sRightType = "";
	if(!assetSerialNo.equals("")){
		String editFlag = GuarantyContractAction.ifAssetEditable(assetSerialNo, gcSerialNo);
		if("false".equals(editFlag)){
			sRightType = "ReadOnly";
		}
	}
	String mode = CurPage.getParameter("Mode");if(mode == null) mode = "";//1：押品录入页面，为空时是抵押登记页面
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", serialNo);
	inputParameter.setAttributeValue("AssetSerialNo", assetSerialNo);
	inputParameter.setAttributeValue("TemplateNo", templateNo);
	inputParameter.setAttributeValue("GCSerialNo", gcSerialNo);
	inputParameter.setAttributeValue("AssetType", assetType);
	inputParameter.setAttributeValue("sRightType", sRightType);
	inputParameter.setAttributeValue("DocFlag", docFlag);
	inputParameter.setAttributeValue("Mode", mode);
	//GCChangeGuarantyAssetView
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info("GCChangeGuarantyAssetView",inputParameter, CurPage, request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.genHTMLObjectWindow(serialNo);

	String sButtons[][] = {
		{"true","All","Button","保存","保存","saveRecord()","","","",""},
	};
%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>

<script type="text/javascript">
	function saveRecord(){
		var checkResult = ALSObjectWindowFunctions.validate();
		if(!checkResult){
			ALSObjectWindowFunctions.showErrors();
			return;
		}
		
		var guarantyPercent = getItemValue(0,0,"GuarantyPercent");
		/* if(typeof(guarantyPercent)=="undefined" || guarantyPercent.length==0) {
			alert("请录入担保主债权金额和押品价值！");
			return;
		} */
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"AI");
		var assetType = getItemValue(subdwname,0,"AssetType");
		
		if(parseFloat(guarantyPercent) > 9999.0){
			alert("担保比例过大！");
			return;
		}
		
		if(subdwname>=0){
			setItemValue(subdwname,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
		}
		
		if(assetType == "30100100100"){//交易类应收账款
			var beginDate = getItemValue(subdwname,0,"RCVSTARTDATE");//应收账款起始时间
			var endDate = getItemValue(subdwname,0,"RCVENDDATE");//应收账款终止时间
			if(beginDate!=null&&beginDate.length!=0 && endDate!=null&&endDate.length!=0){
				if(beginDate > endDate){
					alert("应收账款起始时间不得晚于应收账款终止时间！");
					return;
				}
			}
		}
		
		var templateNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CollateralTemplate", "getTemplate", "ItemNo="+assetType);
		templateNo = templateNo.split("@");
		if(templateNo[0]=="false"){
			alert("未配置"+assetType+"的模板！");
			return;
		}
		
		var gcSerialNo = getItemValue(0,0,"GCSerialNo");
		//新增时押品唯一性校验
		var aidata=ALSObjectWindowFunctions.getAllData(subdwname);
		var inputparameter = {"aidata":aidata};
		var args=JSON.stringify({"InputParameter":inputparameter});
		var result=AsControl.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralInterfaceAction", "checkUniq",args);
		if(typeof(result) == "undefined" || result == null || result.length == 0)
		{
			alert("押品唯一性校验失败！");
			return;
		} 
		
		result=result.split("@");
		if(result[0] == "01"){//通过
			as_save("refreshCurrentPage()");
		}
		else if(result[0] == "02" || result[0] == "03"){//重复或疑似重复
			
			var assetNo = PopPage("/CreditManage/CreditApply/CollateralList2.jsp?Flag="+result[0]+"&SerialNos="+result[1]+"&CollNames="+result[2]+"&CollTypes="+result[3]+"&CollVals="+result[4],"","dialogHeight=400px;dialogWidth=600px;");
			if(typeof(assetNo)=="undefined" || assetNo.length==0)
			{
				if(result[0] == "02")
				{
					alert("押品系统存在重复的押品，请先进行引入。");
					return;
				}
				else if(result[0] == "03")
				{
					as_save("refreshCurrentPage()");
				}
			}
			else
			{
				var assetbo = new Array();
				assetbo[0] = ALSObjectWindowFunctions.getJSONBusinessObject(subdwname,0);
				var inputparameter = {"assetbo":assetbo};
				inputparameter["assetkeyinfo"] = assetNo;  //clrNo@clrName@clrType@clrValue
				
				var assetSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "getAssetSerialNo", "ClrSerialNo="+assetNo.split("@")[0]);
				if(assetSerialNo == "false"){//本地没有该押品，在本地新建押品数据，接口返回值更新至本地
					inputparameter["flag"] = "0";//新增
					inputparameter["asd"] = ALSObjectWindowFunctions.getObjectWindowMetaAttribute(subdwname,"SERIALIZED_ASDFULL");
					var args=JSON.stringify({"InputParameter":inputparameter});
					var newAssetNo=AsControl.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralInterfaceAction", "updateCollInfo",args);
					if(newAssetNo){
						var sReturn = AsControl.PopComp("/CreditManage/CreditApply/AfterLoanImportCollateralInfo.jsp", "SerialNo=&GCSerialNo="+gcSerialNo+"&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&TemplateNo="+templateNo[1]+"&AssetType="+assetType+"&AssetSerialNo="+newAssetNo, "");
						self.close();
					}
					else{
						alert("引入失败！");
						return;
					}
				}
				else{//本地有该押品，则按接口返回的要素信息更新
					inputparameter["flag"] = "1";//更新
					inputparameter["AssetSerialNo"] = assetSerialNo;
					var args=JSON.stringify({"InputParameter":inputparameter});
					var newAssetNo=AsControl.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralInterfaceAction", "updateCollInfo",args);
					if(newAssetNo){
						var sReturn = AsControl.PopComp("/CreditManage/CreditApply/AfterLoanImportCollateralInfo.jsp", "SerialNo=&GCSerialNo="+gcSerialNo+"&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&TemplateNo="+templateNo[1]+"&AssetType="+assetType+"&AssetSerialNo="+newAssetNo, "");
						self.close();
					}
					else{
						alert("引入失败！");
						return;
					}
				}
			}
		}
	}
	
	function refreshCurrentPage(){
		var serialNo = getItemValue(0,0,"SERIALNO");
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"AI");
		var assetSerialNo = getItemValue(subdwname,0,"SerialNo");
		AsControl.OpenView("/CreditManage/CreditApply/GCChangeGuarantyCollateralInfo.jsp", "SerialNo="+serialNo+"&AssetSerialNo="+assetSerialNo+
				"&GCSerialNo=<%=gcSerialNo%>&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&ObjNo=<%=objectNo%>"+
				"&ObjType=<%=objectType%>&ChangeFlag=<%=changeFlag%>&ParentTransSerialNo=<%=parentTransSerialNo%>"+
				"&TemplateNo=<%=templateNo%>&AssetType=<%=assetType%>&Mode=1", "_self");
		
	}
	
	function changeStatus1(){
		if(!confirm("确认办妥预抵押？")){
			return;
		}
		var grSerialNo = getItemValue(0,0,"SerialNo");
		var assetSerialNo = getItemValue(0,0,"AssetSerialNo");
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "finishColl", "AssetSerialNo="+assetSerialNo+",GRSerialNo="+grSerialNo);
		alert(returnValue);
		return;
	}
	
	function changeStatus2(){
		if(!confirm("确认办妥正式抵押？")){
			return;
		}
		var grSerialNo = getItemValue(0,0,"SerialNo");
		var assetSerialNo = getItemValue(0,0,"AssetSerialNo");
		//预售房正式抵押提示
		var realtyNote = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "preSaleNote", "AssetSerialNo="+assetSerialNo+",GRSerialNo="+grSerialNo);
		if(realtyNote != "true" && realtyNote != null && realtyNote.length > 0){
			if(confirm(realtyNote)){//选择是则预抵押，否则正式抵押
				var r1 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "finishColl", "AssetSerialNo="+assetSerialNo+",GRSerialNo="+grSerialNo);
				alert(r1);
				return;
			}
			else{
				var r2 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "finishFormalColl", "AssetSerialNo="+assetSerialNo+",GRSerialNo="+grSerialNo);
				alert(r2);
				return;
			}
		}
		
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "finishFormalColl", "AssetSerialNo="+assetSerialNo+",GRSerialNo="+grSerialNo);
		alert(returnValue);
		return;
	}
	
	function init(){
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"AI");
		var grSerialNo = getItemValue(0,0,"SerialNo");
		var grFlag = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "ifGRExists", "SerialNo="+grSerialNo);
		if(grFlag == "false"){
			setItemValue(0,0,"Status","0100");
		}
		
		var assettype = getItemValue(subdwname,0,"AssetType");
		if("<%=assetType%>".substring(0,2) == "20" || assettype.substring(0,2) == "20" || "<%=assetType%>".substring(0,5) == "40800" || assettype.substring(0,5) == "40800" || "<%=assetType%>".substring(0,5) == "40900" || assettype.substring(0,5) == "40900"){//分别判断新增和详情打开时的AssetType
			var province = getItemValue(subdwname,0,"Province");
			var city = getItemValue(subdwname,0,"City");
			var area = getItemValue(subdwname,0,"Area");
			var country = getItemValue(subdwname,0,"CountryCode");
			if(province==null) province="";
			if(city==null) city="";
			if(area==null) area="";
			if(country==null || typeof(country)=="undefined") country="";
	
			if(country == ""){
				setItemValue(subdwname,0,"CountryCode","CHN");
				setItemValue(subdwname,0,"CountryName","中华人民共和国");
			}
			var countryName = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.AddressAction", "getCountry", "Country="+country);
			if(typeof(countryName)!="undefined" && countryName.length!=0 && countryName!="false") {
				setItemValue(subdwname,0,"CountryName",countryName);
			}
			if(province != "" && city != "" && area != ""){
				var addName = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.AddressAction", "getAdd", "Province="+province+",City="+city+",Area="+area);
				if(typeof(addName)!="undefined" && addName.length!=0 && addName!="false"){
					addName = addName.split("@");
					setItemValue(subdwname,0,"ProvinceName",addName[0]);
					setItemValue(subdwname,0,"CityName",addName[1]);
					setItemValue(subdwname,0,"AreaName",addName[2]);
				}
			}
		}
		
		if("<%=assetType%>".substring(0,5) == "20100" || assettype.substring(0,5) == "20100"){
			changeHouseStatus();
		}
		
		if(subdwname>=0&&getRowCount(0) == 0){
			setItemValue(subdwname,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(subdwname,0,"INPUTORGID","<%=CurUser.getOrgID()%>");
			setItemValue(subdwname,0,"INPUTDATE","<%=StringFunction.getToday()%>");
		}
	}
	
	function selProvince(){
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"AI");
		var returnValue = AsCredit.selectTree("SelectCode_FixItemNoLength","CodeNo,AreaCode,ItemNoLength,2","",false);
		if(typeof(returnValue)=="undefined" || returnValue.length==0)  return;
		var itemNo = returnValue["ID"];
		var itemName = returnValue["Name"];
		if(typeof(itemNo)=="undefined" || itemNo.length==0) return;
		if(typeof(itemName)=="undefined" || itemName.length==0) return;
	
		setItemValue(subdwname,0,"Province",itemNo);
		setItemValue(subdwname,0,"City","");
		setItemValue(subdwname,0,"Area","");
		setItemValue(subdwname,0,"ProvinceName",itemName);
		setItemValue(subdwname,0,"CityName","");
		setItemValue(subdwname,0,"AreaName","");
	}
	function selCity(){
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"AI");
		var province = getItemValue(subdwname,0,"Province");
		if(typeof(province)=="undefined" || province.length==0){
			alert("请先录入省或直辖市！");
			return;
		}
		var returnValue = AsCredit.selectTree("SelectCode_FixLengthAndLike","CodeNo,AreaCode,ItemNoLength,4,ItemNo,"+province.substring(0,2),"",false);
		if(typeof(returnValue)=="undefined" || returnValue.length==0)  return;
		var itemNo = returnValue["ID"];
		var itemName = returnValue["Name"];
		if(typeof(itemNo)=="undefined" || itemNo.length==0) return;
		if(typeof(itemName)=="undefined" || itemName.length==0) return;
	
		setItemValue(subdwname,0,"City",itemNo);
		setItemValue(subdwname,0,"Area","");
		setItemValue(subdwname,0,"CityName",itemName);
		setItemValue(subdwname,0,"AreaName","");
	}
	function selArea(){
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"AI");
		var city = getItemValue(subdwname,0,"City");
		if(typeof(city)=="undefined" || city.length==0){
			alert("请先录入城市！");
			return;
		}
		var returnValue = AsCredit.selectTree("SelectCode_FixLengthAndLike","CodeNo,AreaCode,ItemNoLength,6,ItemNo,"+city.substring(0,4),"",false);
		if(typeof(returnValue)=="undefined" || returnValue.length==0)  return;
		var itemNo = returnValue["ID"];
		var itemName = returnValue["Name"];
		if(typeof(itemNo)=="undefined" || itemNo.length==0) return;
		if(typeof(itemName)=="undefined" || itemName.length==0) return;
	
		setItemValue(subdwname,0,"Area",itemNo);
		setItemValue(subdwname,0,"AreaName",itemName);
	}
	
	function selCountry(){
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"AI");
		var returnValue = AsCredit.selectTree("SelectCode","CodeNo,CountryCode","",false);
		if(typeof(returnValue)=="undefined" || returnValue.length==0)  return;
		var itemNo = returnValue["ID"];
		var itemName = returnValue["Name"];
		if(typeof(itemNo)=="undefined" || itemNo.length==0) return;
		setItemValue(subdwname,0,"CountryCode",itemNo);
		setItemValue(subdwname,0,"CountryName",itemName);
		
		if(itemNo != "CHN"){
			ALSObjectWindowFunctions.hideItems(subdwname,"FullAddress");
		}
		if(itemNo == "CHN"){
			ALSObjectWindowFunctions.showItems(subdwname,"FullAddress");
		}
	}
	
	function calcGuarantyPercent(){
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"AI");
		var guarantyValue = getItemValue(0,0,"GuarantyAmount");//担保主债权金额
		var confirmValue = getItemValue(subdwname,0,"ConfirmValue");//押品价值
	
		if(confirmValue==null || confirmValue == "0" || confirmValue == "0.00" || typeof(confirmValue)=="undefined" || confirmValue.length==0){
			setItemValue(0,0,"GuarantyPercent","");
			return;
		}
		if(confirmValue.length > 24){
			alert("数字超过24位，请重新输入！");
			setItemValue(subdwname,0,"ConfirmValue","");
			return;
		}
		var perct = 100*guarantyValue/confirmValue;
		
		setItemValue(0,0,"GuarantyPercent",Math.round(perct*100)/100);
	}
	
	function changeUseDetail(){
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"AI");
		var useDetail = getItemValue(subdwname,0,"UseDetail");
		var assetType = getItemValue(subdwname,0,"AssetType");
		if(assetType.substring(0,8) == "20100200" && useDetail == "02"){
			ALSObjectWindowFunctions.setItemsRequired(subdwname,"Rental",true);
		}
		if(assetType.substring(0,8) == "20100200" && useDetail != "02"){
			ALSObjectWindowFunctions.setItemsRequired(subdwname,"Rental",false);
		}
	}
	
	function changeHouseStatus(){
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"AI");
		var houseStatus = getItemValue(subdwname,subdwname,"HouseStatus");
		if(houseStatus == "01"){//现房
			ALSObjectWindowFunctions.setItemsRequired(subdwname,"RealtyCertID,LANDCERTID",true);
			ALSObjectWindowFunctions.setItemsRequired(subdwname,"REALTYPRESALECONTRACTNO",false);
		}
		if(houseStatus == "02"){//预售房
			ALSObjectWindowFunctions.setItemsRequired(subdwname,"RealtyCertID,LANDCERTID",false);
			ALSObjectWindowFunctions.setItemsRequired(subdwname,"REALTYPRESALECONTRACTNO",true);
		}
		else{}
	}

	$(document).ready(function(){
		setDialogTitle("抵质押物信息详情");
		init();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
