<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String sTempletNo = "AssetDebtDetailInfo";//--�ʲ�֤ȯ���ֶ�ģ�崦--
	String sTempletFilter = "1=1"; 
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setReadOnly("*",true);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";
	
	dwTemp.genHTMLObjectWindow(serialNo);
	
	String sButtons[][] = {
		{"false","All","Button","����","����","asSave()","","","",""},
		{"false","All","Button","ȡ��","ȡ��","goBack()","","","",""}, 	
	};
	// sButtonPosition = "south"; 
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<%@page import="com.amarsoft.app.als.customer.model.CustomerConst"%>

<script type="text/javascript">
	function goBack(){ 
		self.close();
	}
	function asSave(){
		
		if(!iV_all("myiframe0"))return; 
		
		as_save("myiframe0","");
	}
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
