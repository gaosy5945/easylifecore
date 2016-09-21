<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.als.guaranty.model.GuarantyContractAction" %>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>

<%
	String PG_TITLE = "引入抵质押物信息"; 

	String assetSerialNo = CurPage.getParameter("AssetSerialNo");if(assetSerialNo == null)assetSerialNo = "";
	String gcSerialNo = CurPage.getParameter("GCSerialNo");if(gcSerialNo == null)gcSerialNo = "";
	String assetType = CurPage.getParameter("AssetType");if(assetType == null)assetType = "";
	String templateNo = CurPage.getParameter("TemplateNo");if(templateNo == null)templateNo = "";
	String objectType = CurPage.getParameter("ObjectType");if(objectType == null)objectType = "";
	String objectNo = CurPage.getParameter("ObjectNo");if(objectNo == null)objectNo = "";
	String sRightType = "";
	if(!assetSerialNo.equals("")){
		String editFlag = GuarantyContractAction.ifAssetEditable(assetSerialNo, gcSerialNo);
		if("false".equals(editFlag)){
			sRightType = "ReadOnly";
		}
	}
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", "");
	inputParameter.setAttributeValue("AssetSerialNo", assetSerialNo);
	inputParameter.setAttributeValue("TemplateNo", templateNo);
	inputParameter.setAttributeValue("GCSerialNo", gcSerialNo);
	inputParameter.setAttributeValue("AssetType", assetType);
	inputParameter.setAttributeValue("sRightType", sRightType);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info("GuarantyAssetView1",inputParameter, CurPage, request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();

	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","All","Button","保存","保存","saveRecord()","","","",""}
		};

%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>

<script type="text/javascript">
	function saveRecord(){
		var guarantyPercent = getItemValue(0,0,"GuarantyPercent");
		if(typeof(guarantyPercent)=="undefined" || guarantyPercent.length==0) {
			alert("请录入担保主债权金额和押品价值！");
			return;
		}
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"AI");
		var assetType = getItemValue(subdwname,0,"AssetType");		
		as_save();
	}
	
	function init(){
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"AI");
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
			if(typeof(countryName)=="undefined" || countryName.length==0 || countryName=="false") return;
			setItemValue(subdwname,0,"CountryName",countryName);
			
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
		
	}
	
	function selAddress(){
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"AI");
		var returnValue = AsCredit.selectTree("SelectCode","CodeNo,AreaCode","",false);
		if(typeof(returnValue)=="undefined" || returnValue.length==0)  return;
		var itemNo = returnValue["ID"];
		var itemName = returnValue["Name"];
		if(typeof(itemNo)=="undefined" || itemNo.length==0) return;
		var addName = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.AddressAction", "splitAdd", "ItemNo="+itemNo+",ItemName="+itemName);
		if(typeof(addName)=="undefined" || addName.length==0) return;
		addName = addName.split("@");

		setItemValue(subdwname,0,"Province",itemNo.substring(0,2));
		setItemValue(subdwname,0,"City",itemNo.substring(2,4));
		setItemValue(subdwname,0,"Area",itemNo.substring(4,6));
		setItemValue(subdwname,0,"FullAddress",itemName);
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
	
	setDialogTitle("抵质押物信息详情");
	init();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
