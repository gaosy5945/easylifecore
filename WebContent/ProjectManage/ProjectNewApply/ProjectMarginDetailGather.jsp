<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
 <style>
 /*ҳ��С����ʽ*/
.list_div_pagecount{
	font-weight:bold;
}
/*�ܼ���ʽ*/
.list_div_totalcount{
	font-weight:bold;
}
 </style>
<%	
	String MarginSerialNo = CurPage.getParameter("MarginSerialNo");
	if(MarginSerialNo == null) MarginSerialNo = "";	
	
	ASObjectModel doTemp = new ASObjectModel("ProjectMarginDetailGather");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ShowSummary = "1";
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("MarginSerialNo", MarginSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
