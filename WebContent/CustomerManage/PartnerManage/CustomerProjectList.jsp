<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	ASObjectModel doTemp = new ASObjectModel("CustomerProjectList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(customerID);
	
	String sButtons[][] = {
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""}
		};
%> 
<script type="text/javascript">
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length==0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}
		AsControl.PopComp("/CustomerManage/PartnerManage/ProjectInfoView.jsp","CustomerID=<%=customerID%>&SerialNo="+serialNo, "","");
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
