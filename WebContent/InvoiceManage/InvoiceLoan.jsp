<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS" %>
<%@ page import="com.amarsoft.app.base.businessobject.BusinessObjectManager" %>
<%@ page import="com.amarsoft.app.base.businessobject.BusinessObject" %>
<%@ page import="com.amarsoft.app.base.util.DateHelper" %>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%><%	
	ASObjectModel doTemp = new ASObjectModel("InvoiceLoan");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	
	
	String orgID = CurOrg.getOrgID();
	
	String businessDate = DateHelper.getBusinessDate();
	String endDate = DateHelper.getRelativeDate(businessDate, DateHelper.TERM_UNIT_MONTH, 1);//获得一个月以内未生成票据的还款计划
	
	//dwTemp.ShowSummary="1";	 	 //汇总
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ORGID", orgID);
	dwTemp.setParameter("ENDDATE", endDate);
	dwTemp.MultiSelect = true;	 //多选
	dwTemp.genHTMLObjectWindow("");

	//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
	String sButtons[][] = {
		{"true","","Button","开票","开票","toInvoice()","","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function toInvoice(){
		var rows = getCheckedRows(0);
		if(typeof(rows)=="undefined" || rows.length==0) {
			alert("请勾选记录！");
			return;
		}
		var record = "";
		var productID = "";
		for(var i=0;i<rows.length;i++){
			record += "@"+getItemValue(0,rows[i],"SERIALNO");
			productID += "@" + getItemValue(0,rows[i],"PRODUCTID");
		}
		var products = productID.split("@");
		for(var i=1;i<products.length;i++){
			if(products[i] != products[1]){
				alert("选项对应的产品不同不能同时开票");
				return;
			}
		}
		if(record.length>0)record=record.substring(1);
		
		var result = AsControl.PopPage("/InvoiceManage/CreatInvoiceInfo.jsp","record="+record+"&productID="+products[1],"resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>