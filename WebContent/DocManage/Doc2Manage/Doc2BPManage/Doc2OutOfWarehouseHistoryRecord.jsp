<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	String status = CurPage.getParameter("Status");
	
	ASObjectModel doTemp = new ASObjectModel("OutOfWarehouseHistoryRecordList");
	 
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	
	dwTemp.setParameter("ObjectNo", sObjectNo);
	dwTemp.setParameter("ObjectType", sObjectType); 
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		};
	 
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
