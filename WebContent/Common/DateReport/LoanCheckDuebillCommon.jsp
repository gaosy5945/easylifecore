<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%
	//接收参数
	String tempNo = DataConvert.toString(CurPage.getParameter("TempNo"));//模板号
	String SerialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));//流水号
	String businessDate = com.amarsoft.app.base.util.DateHelper.getBusinessDate();
	ASObjectModel doTemp = new ASObjectModel(tempNo);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.setParameter("SerialNo", SerialNo);
	dwTemp.setParameter("BusinessDate", businessDate);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{("AcctLoanChange1".equals(tempNo) ? "true" : "false"),"","Button","详情","详情","view()","","","","",""},
			{"true","","Button","导出","导出Excel","as_defaultExport()","","","",""},
		};
	
%> 


<script type="text/javascript">
var showRowNum="None";
function view(){
	var serialNo = getItemValue(0,getRow(0),'RELATIVEOBJECTNO');
	var transSerialNo = getItemValue(0,getRow(0),'SERIALNO');
	var transCode = getItemValue(0,getRow(0),'TRANSACTIONCODE');
	if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return ;
	}
	
	if("0000"==transCode){
		alert("移植的贷后变更数据，不可查看交易详情！");
		return;
	}
	
	AsCredit.openFunction("ViewPostLoanChangeTabNew","serialNo="+serialNo+"&TransSerialNo="+transSerialNo+"&TransCode="+transCode+"&RightType=ReadOnly");
	reloadSelf();
}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@include file="/Frame/resources/include/include_end.jspf"%>
