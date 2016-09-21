<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String objectType = CurPage.getParameter("ObjectType");
	if(objectType == null) objectType = "";
	String objectNo = CurPage.getParameter("ObjectNo");
	if(objectNo == null) objectNo = "";
	String productID = CurPage.getParameter("ProductID");
	if(productID == null) productID = "";
	String businessType = CurPage.getParameter("BusinessType");
	if(businessType == null) businessType = "";

	String templateNo = "BusinessHouse";
	if(businessType.equals("003")){//商用房抵押贷款
		templateNo = "BusinessHouse1";
	}
	//汽车贷款附属信息
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(templateNo,BusinessObject.createBusinessObject(),CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "0";//只读模式
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.genHTMLObjectWindow(objectType+","+objectNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""}
	};
			
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){ 
		if (!iV_all("0")) return; 
		var deliveryDate = getItemValue(0, getRow(0), "DELIVERYDATE");
		var completionDate = getItemValue(0, getRow(0), "COMPLETIONDATE");
		if(typeof(deliveryDate) != "undefined" && deliveryDate != "" && typeof(completionDate) != "undefined" && completionDate != ""){
			if(deliveryDate<completionDate){
				alert("竣工时间必须早于交房时间");
				setItemValue(0, getRow(0), "DELIVERYDATE", "");
				setItemValue(0, getRow(0), "COMPLETIONDATE", "");
				return;
			}
		}
		as_save(0);
	}
	
	function refresh(){
		AsControl.OpenComp("/CreditManage/CreditApply/BusinessHousePurchasing.jsp", "ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>", "_self", "");
	}
	
	/* function changeAssetType(){
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"BI");
		var assetType = getItemValue(0,0,"AssetType");
		if(assetType == "20100100100" || assetType == "20100100110" || assetType == "20100100120"){//公寓、别墅、政策性住房
			ALSObjectWindowFunctions.setItemsRequired(subdwname,"RealtyPolicy,FamilyEstateNo,BorrowerEstateNo",true);
		}
		else{
			ALSObjectWindowFunctions.setItemsRequired(subdwname,"RealtyPolicy,FamilyEstateNo,BorrowerEstateNo",false);
		}
	} */
	
	function changeHouseStatus(){
		var houseStatus = getItemValue(0,0,"HouseStatus");
		if(houseStatus == "01"){
			ALSObjectWindowFunctions.setItemsRequired(0,"COMPLETIONDATE",true);
		}
		else{
			ALSObjectWindowFunctions.setItemsRequired(0,"COMPLETIONDATE",false);
		}
	}
	
	//获取楼盘名称
	function getBuilding(){
		var result = AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageAddorView.jsp","DialogTitle=楼盘信息","resizable=yes;dialogWidth=650px;dialogHeight=500px;center:yes;status:no;statusbar:no");
		if(typeof(result)=="undefined"){
			return;
		}
		result = result.split("@");
		REALESTATEID = result[0];
		REALESTATENAME = result[1];
		setItemValue(0,getRow(),"REALESTATEID",REALESTATEID);
		setItemValue(0,getRow(),"REALESTATENAME",REALESTATENAME);
	}
	
	function calcFirstPayRatio(){
		var contractAmount = getItemValue(0,getRow(),"ContractAmount");//购买总价
		var firstPayAmount = getItemValue(0,getRow(),"FirstPayAmount");//首付金额
		var floorArea = getItemValue(0,0,"FloorArea");//建筑面积
		
		if(contractAmount != null && contractAmount.length != 0 && firstPayAmount != null && firstPayAmount.length != 0){
			if(contractAmount == 0){
				setItemValue(0,getRow(),"FirstPayPercent",0);
				return;
			}
			var ratio = 100*firstPayAmount/contractAmount;
			setItemValue(0,getRow(),"FirstPayPercent",Math.round(ratio*100)/100);
		}
		else{
			setItemValue(0,getRow(),"FirstPayPercent",0);
		}
		
		if(contractAmount != null && contractAmount.length != 0 && floorArea != null && floorArea.length != 0 && floorArea != "0.00"){
			var price = contractAmount/floorArea;
			setItemValue(0,getRow(),"REALTYUNITPRICE",Math.round(price*100)/100);
		}
		else{
			setItemValue(0,getRow(),"REALTYUNITPRICE","");
		}
	}
	
	function selProvince(){
		var returnValue = AsCredit.selectTree("SelectCode_FixItemNoLength","CodeNo,AreaCode,ItemNoLength,2","",false);
		if(typeof(returnValue)=="undefined" || returnValue.length==0)  return;
		var itemNo = returnValue["ID"];
		var itemName = returnValue["Name"];
		if(typeof(itemNo)=="undefined" || itemNo.length==0) return;
		if(typeof(itemName)=="undefined" || itemName.length==0) return;

		setItemValue(0,0,"Province",itemNo);
		setItemValue(0,0,"City","");
		setItemValue(0,0,"Area","");
		setItemValue(0,0,"ProvinceName",itemName);
		setItemValue(0,0,"CityName","");
		setItemValue(0,0,"AreaName","");
	}
	function selCity(){
		var province = getItemValue(0,0,"Province");
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

		setItemValue(0,0,"City",itemNo);
		setItemValue(0,0,"Area","");
		setItemValue(0,0,"CityName",itemName);
		setItemValue(0,0,"AreaName","");
	}
	function selArea(){
		var city = getItemValue(0,0,"City");
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

		setItemValue(0,0,"Area",itemNo);
		setItemValue(0,0,"AreaName",itemName);
	}
	
	function init(){
		
		setItemValue(0,getRow(),"ObjectType","<%=objectType%>");
		setItemValue(0,getRow(),"ObjectNo","<%=objectNo%>");
		if("<%=productID%>" != "034" && "<%=productID%>" != "036" || "<%=productID%>" == ""){
			var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"BI");
			if(subdwname==-1) return;
			ALSObjectWindowFunctions.hideItems(subdwname,"JLDBalance,JLDSTATUS");//接力贷
		}
		
		if("<%=businessType%>" == "003"){//个人商用房抵押贷款
			ALSObjectWindowFunctions.setItemDisabled(0, 0, "IsCollateral", false);
		}
		
		//changeAssetType();
		
		var province = getItemValue(0,0,"Province");
		var city = getItemValue(0,0,"City");
		var area = getItemValue(0,0,"Area");
		if(province==null) province="";
		if(city==null) city="";
		if(area==null) area="";
		if(province != "" && city != "" && area != ""){
			var addName = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.AddressAction", "getAdd", "Province="+province+",City="+city+",Area="+area);
			if(typeof(addName)!="undefined" && addName.length!=0 && addName!="false"){
				addName = addName.split("@");
				setItemValue(0,0,"ProvinceName",addName[0]);
				setItemValue(0,0,"CityName",addName[1]);
				setItemValue(0,0,"AreaName",addName[2]);
			}
		}
	}
	
	$(document).ready(function(){
		init();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
