<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

	String sTempletNo = "CRQQueryRegulationInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.setParameter("SerialNo", "001");
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","save()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function save(){
		var USEROBJECT = getItemValue(0, getRow(), "USEROBJECT");
		var USEROBJECT1 = getItemValue(0, getRow(), "USEROBJECT1");
		var USEROBJECT2 = getItemValue(0, getRow(), "USEROBJECT2");
		if(USEROBJECT.indexOf("01") > -1 && USEROBJECT1.indexOf("01") > -1 && USEROBJECT2.indexOf("01") > -1){
		
		}else{
			alert("征信查询对象中借款人为必选项，请重新选择！");
			return;
		}
		setItemValue(0, getRow(0), "SerialNo", "001");
		var MAXOVERDUEDAYS = getItemValue(0,getRow(),"MAXOVERDUEDAYS");
		var MINOVERDUEDAYS = getItemValue(0,getRow(),"MINOVERDUEDAYS");
		if(MAXOVERDUEDAYS<=MINOVERDUEDAYS && MAXOVERDUEDAYS != ""){
			alert("消费贷款征信批量查询规则，录入的“最大逾期天数”必须大于“最小逾期天数”！");
			return;
		}
		var MAXBALANCE1 = getItemValue(0,getRow(),"MAXBALANCE1");
		var MINBALANCE1 = getItemValue(0,getRow(),"MINBALANCE1");
		if(MAXBALANCE1<=MINBALANCE1 && MAXBALANCE1 != ""){
			alert("消费贷款征信批量查询规则，录入的“最大客户贷款余额（非经营类）”必须大于“最小客户贷款余额（非经营类）”！");
			return;
		}
		var MAXBALANCE2 = getItemValue(0,getRow(),"MAXBALANCE2");
		var MINBALANCE2 = getItemValue(0,getRow(),"MINBALANCE2");
		if(MAXBALANCE2<=MINBALANCE2 && MAXBALANCE2 != ""){
			alert("消费贷款征信批量查询规则，录入的“最大客户贷款余额（含经营类）”必须大于“最小客户贷款余额（含经营类）”！");
			return;
		}
		var MAXBALANCE3 = getItemValue(0,getRow(),"MAXBALANCE3");
		var MINBALANCE3 = getItemValue(0,getRow(),"MINBALANCE3");
		if(MAXBALANCE3<=MINBALANCE3 && MAXBALANCE3 != ""){
			alert("消费贷款征信批量查询规则，录入的“最大客户纯信用贷款余额（非经营类）”必须大于“最小客户纯信用贷款余额（非经营类）”！");
			return;
		}
		var MAXOVERDUEDAYS1 = getItemValue(0,getRow(),"MAXOVERDUEDAYS1");
		var MINOVERDUEDAYS1 = getItemValue(0,getRow(),"MINOVERDUEDAYS1");
		if(MAXOVERDUEDAYS1<=MINOVERDUEDAYS1 && MAXOVERDUEDAYS1 != ""){
			alert("网贷业务征信批量查询规则，录入的“最大逾期天数”必须大于“最小逾期天数”！");
			return;
		}
		
		as_save(0);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
