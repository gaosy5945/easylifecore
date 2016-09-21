<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		Content: 对查询条件进行处理，并且显示数据窗口
	 */
	//获得组件参数	，传入要执行的sql语句、查询类型
	String querySQL   = CurPage.getAttribute("JBOQL"); 	//查询语句
	String queryClass = CurPage.getParameter("MajorObjClass"); 		//查询的jboclass
	String statResult = CurPage.getParameter("StatResult"); 		//查询类型,1--汇总,2--明细
	String sumFields = CurPage.getParameter("SumFields"); 		//汇总字段
	
	ASObjectModel doTemp = new ASObjectModel();
	doTemp.initQuery(queryClass, querySQL);
	doTemp.setColumnType(sumFields, "3"); //总计+小计 
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.setPageSize(20);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1";//只读模式
	if(statResult.equals("1")){//汇总查询
		dwTemp.ShowSummary="1";//设置合计列
	}
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		{"false","","Button","查看客户详情","查看客户详情","my_CustomerInfo()","","","",""},
		{"true","","Button","导出Excel","导出Excel","exportPage('"+sWebRootPath+"',0,'excel','"+dwTemp.getArgsValue()+"')","","","",""},
	};
%><%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	/*~[Describe=查看客户详情;]~*/
	function my_CustomerInfo(){
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
		}else{
			openObject("Customer",sCustomerID,"002");
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>