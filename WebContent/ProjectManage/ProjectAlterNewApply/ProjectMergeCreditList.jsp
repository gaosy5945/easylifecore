<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
    String sSerialNos = CurPage.getAttribute("SerialNos");

	ASObjectModel doTemp = new ASObjectModel("ProjectRelativeContract1");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.MultiSelect = true; //�����ѡ
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sSerialNos);

	String sButtons[][] = {
    	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
