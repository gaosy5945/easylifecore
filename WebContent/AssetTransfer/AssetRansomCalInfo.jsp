<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	//�ʲ���ز���
	String sTempletNo = "AssetRansomCalInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(CurPage.getParameter(""));
	String sButtons[][] = {
		{"false","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"false","All","Button","����","�����б�","returnList()","","","",""}
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		
	}
	
	function cal(){
		var ransomDate = getItemValue(0,0,"RansomDate");
		if(ransomDate.length == 0){
			alert("����ѡ������");
			return;
		}
		
		
		
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
