<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	ASObjectModel doTemp = new ASObjectModel("TestCustomerInfoD"); //通过显示模板生成
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
	};
	sButtonPosition = "south";
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var cityArray = new Array();
	var areaArray = new Array();
	function setArea(cityValue){
		//alert(cityValue);
		var aCode = [];
		if(areaArray[cityValue]){
			aCode = areaArray[cityValue];
		}else{
			var sReturn = RunJavaMethod("com.amarsoft.awe.dw.ui.control.address.AreaFetcher","getAreas","city="+cityValue);
			//alert(sReturn);
			if(sReturn!=""){
				aCode = sReturn.split(",");
			}
		}
		var data = {};
		for(var i = 0; i < aCode.length - 1; i += 2){
			data[aCode[i]] = aCode[i+1];
		}
		//alert(JSON.stringify(data));
		AsForm.FlatSelect("#ATTR3", data, 200);
		/*
		//alert(aCode);
		var oArea = document.getElementById("ATTR3");
		var options = oArea.options;
		options.length = 1;
		options[0] = new Option("请选择区县","");
		options[0].selected = true;
		for(var i=0;i<aCode.length;i+=2){
			var curOption = new Option(aCode[i+1],aCode[i]);
			if(aCode[i]==areaValue)curOption.selected = true;
				options[options.length] = curOption;
		}
		*/
	}
	function setCity(provValue){
		//alert(provValue);
		var aCode = [];
		if(cityArray[provValue]){
			aCode = cityArray[provValue];
		}else{
			var sReturn = RunJavaMethod("com.amarsoft.awe.dw.ui.control.address.CityFetcher","getCities","prov="+provValue);
			if(sReturn!=""){
				aCode = sReturn.split(",");
			}
		}
		var data = {};
		for(var i = 0; i < aCode.length - 1; i += 2){
			data[aCode[i]] = aCode[i+1];
		}
		//alert(JSON.stringify(data));
		AsForm.FlatSelect("#ATTR2", data, 200);
		/*
		var oCity = document.getElementById("ATTR2");
		var options = oCity.options;
		options.length = 1;
		options[0] = new Option("请选择城市","");
		options[0].selected = true;
		//alert(options[0]);
		for(var i=0;i<aCode.length;i+=2){
			var curOption = new Option(aCode[i+1],aCode[i]);
			if(aCode[i]==cityValue)curOption.selected = true;
			options[options.length] = curOption;
		}
		setArea(getItemValue(0,0,'ATTR2'));
		*/
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>