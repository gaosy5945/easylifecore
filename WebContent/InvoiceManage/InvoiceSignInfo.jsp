<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
        Author: undefined 2016-01-11
        Content: ʾ������ҳ��
        History Log: 
    */
	String serialNo = CurPage.getParameter("serialNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "InvoiceSignInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","All","Button","ȷ��","ȷ��","sign()","","","",""},
			{"true","All","Button","ȡ��","ȡ��","top.close();","","","",""}, 
	};
	sButtonPosition = "south";
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function sign(){
		if(!iV_all("0")) return ;
		var signName = getItemValue(0,getRow(0),'signName');
		var	signID = getItemValue(0,getRow(0),'signID');
		var signPhone = getItemValue(0,getRow(0),'signPhone');
		var signDate = getItemValue(0,getRow(0),'signDate');
		var record = "<%=serialNo%>"+"&"+signName+"&"+signID+"&"+signPhone+"&"+signDate;
		var result = RunJavaMethod("com.amarsoft.app.als.afterloan.invoice.InvoicePost","InvoiceSign","record="+record);
		if(result=="true")
			alert("ǩ����Ϣ�Ѽ�¼��Ʊ�ݱ�ע�У�");
		top.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>