<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sCustomerID =  CurPage.getParameter("CustomerID");
	if(sCustomerID == null) sCustomerID=""; 
	String sCustomerType =  CurPage.getParameter("CustomerType");
	if(sCustomerType == null) sCustomerType=""; 
	String sSerialNo = CurPage.getParameter("SerialNo");
	if(sSerialNo == null) sSerialNo=""; 
	String sListType =  CurPage.getParameter("ListType");
	if(sListType == null) sListType=""; 
	String sTempletNo = "CustomerAddressInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	
	if(!"null".equals(sListType)){
		doTemp.setDDDWJbo("ADDRESSTYPE", "jbo.sys.CODE_LIBRARY,ItemNo,ItemName,CodeNo = 'AddressType' and IsInuse='1' and ItemNo in ('04','05','08','E01') order by SortNo");
	}else if("null".equals(sListType)&&sCustomerType.substring(0,2).equals("01")){
		doTemp.setDDDWJbo("ADDRESSTYPE", "jbo.sys.CODE_LIBRARY,ItemNo,ItemName,CodeNo = 'AddressType' and IsInuse='1' and ItemNo in ('04','05','08','E01') order by SortNo");
	}else if("null".equals(sListType)&&sCustomerType.substring(0,2).equals("03")){
		doTemp.setDDDWJbo("ADDRESSTYPE", "jbo.sys.CODE_LIBRARY,ItemNo,ItemName,CodeNo = 'AddressType' and IsInuse='1' and ItemNo in ('01','02','03','E01') order by SortNo");
	} 
	
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("SerialNo", CurPage.getParameter("SerialNo"));
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回列表","returnBack()","","","",""}
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<HEAD>
<title>联系地址信息</title>
</HEAD>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">	
	var flag = "1";
	function returnBack()
	{
	  AsControl.OpenPage("/CustomerManage/CustomerAddressList.jsp","CustomerID="+"<%=sCustomerID%>"+"&CustomerType="+"<%=sCustomerType%>","_self","");
	} 
	function save(){
		var CustomerID = "<%=sCustomerID%>";
		var addressType = getItemValue(0,getRow(),"ADDRESSTYPE");
		CustomerManage.selectAddressIsNew(CustomerID,addressType);
		saveRecord();
	}
	function saveRecord(){
		changeZipCode();
		if(flag == "1"){
			//去掉地址信息中的回车符
			var address1 = getItemValue(0,getRow(),"ADDRESS1").replace(/[\r\n]/g,"");
			setItemValue(0,0,"ADDRESS1",address1);
			as_save(0);
		}
	}
	
	/*~[Describe=弹出国家/地区选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCountryCode(){
		sParaString = "CodeNo"+",CountryCode";
		var languageType = getItemValue(0,getRow(),"LanguageType");
		if(languageType == "020"){//语言类型为 英文或其他时，国家中屏蔽中国 选项
			sParaString += ",ItemNo,CHN";
		}
		sCountryCodeInfo = setObjectValue("SelectCode",sParaString,"@Country@0@CountryName@1",0,0,"");
		if(sCountryCodeInfo == "_CLEAR_"){//清空数据
			sCountryCodeInfo = "";
			sCountryCodeValue = "";
		}
		if (typeof(sCountryCodeInfo)!="undefined" && sCountryCodeInfo!="_NONE_" && sCountryCodeInfo!="_CANCEL_"){
			sCountryCodeInfo = sCountryCodeInfo.split('@');
			sCountryCodeValue = sCountryCodeInfo[0];//-- 所在国家(地区)代码
			if(sCountryCodeValue == "CHN"){//非中国时，隐藏所属省市字段
				showItem(0,"CITYNAME");
			}else{
				setItemValue(0,getRow(),"CITY","");
				setItemValue(0,getRow(),"CITYNAME","");
				hideItem(0,"CITYNAME");
			}
		}
	}
	
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode()
	{
		var sCity = getItemValue(0,getRow(),"CITY");
		sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sCity,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"CITY","");
			setItemValue(0,getRow(),"CITYNAME","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"CITY",sAreaCodeValue);
					setItemValue(0,getRow(),"CITYNAME",sAreaCodeName);				
			}
		}
	}	
	
	function hideAreaCode(){
		var country = getItemValue(0,getRow(),"COUNTRY");
		if(country != "CHN"){
			hideItem(0,"CITYNAME");
		}
	}
	function changeZipCode(){
		var country = getItemValue(0,getRow(),"COUNTRY");
		var zipCode = getItemValue(0,getRow(),"ZIPCODE");
		if(country == "CHN"){
			if(zipCode.length != 6){
				flag = "2";
				alert("邮政编码长度错误！");
				return;
			}
		}
		flag="1";
	}
	
	function initRow(){
		hideAreaCode();
		var sSerialNo = "<%=sSerialNo%>";
		if(sSerialNo == "undefined" || sSerialNo.length == 0 || sSerialNo == "null"){
			setItemValue(0,0,"OBJECTTYPE","jbo.customer.CUSTOMER_INFO");
			setItemValue(0,0,"OBJECTNO","<%=sCustomerID%>");
		}
	}
	//languageTypeChange();
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
