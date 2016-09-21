<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID  = CurPage.getParameter("CustomerID");
	String serialNo  = CurPage.getParameter("SerialNo");
	if(customerID==null||customerID.length()==0)customerID="";
	if(serialNo==null||serialNo.length()==0)serialNo="";	
	
	ASObjectModel doTemp = new ASObjectModel("RWSignalHistoryList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(customerID+","+serialNo);

	String sButtons[][] = {
			
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
