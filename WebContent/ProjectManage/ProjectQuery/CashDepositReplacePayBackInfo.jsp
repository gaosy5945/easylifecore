<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String ProjectSerialNo = CurPage.getParameter("SerialNo");//������Ŀ���
	String ProjectType = CurPage.getParameter("ProjectType");//������Ŀ����
	if(ProjectSerialNo == null) ProjectSerialNo = "";
	if(ProjectType == null) ProjectType = "";

	String sTempletNo = "CashDepositReplacePayBackInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveDeal()","","","",""},
		/* {String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","����","�����б�","returnList()","","","",""} */
	};
	//sButtonPosition = "south";
%>
<HEAD>
<title>��֤�����</title>
</HEAD>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	<%-- function returnList(){
		OpenPage("<%=sPrevUrl%>", "_self");
	} --%>
	
	function saveDeal(){
		
// 		var serialNo = getItemValue(0,getRow(0),"SerialNo");
// 		var amount = getItemValue(0,getRow(0),"Amount");
<%-- 		AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.CashDepositReplacePayBack","dealCashDeposit","SerialNo="+serialNo+",Amount="+amount+",ProjectSerialNo=<%=ProjectSerialNo%>,ProjectType=<%=ProjectType%>"); --%>
		as_save(0);
	}
	
	function initItem(){
		var serialNo = getSerialNo("CLR_MARGIN_WASTEBOOK","SERIALNO","");
		setItemValue(0,getRow(),"SERIALNO",serialNo);
		setItemValue(0,getRow(),"TRANSACTIONCODE","003");//��֤�𷽰����  
		setItemValue(0,getRow(),"CURRENCY","CNY"); 
		setItemValue(0,getRow(),"OBJECTTYPE","jbo.prj.PRJ_BASIC_INFO");  
		setItemValue(0,getRow(),"OBJECTNO",<%=ProjectSerialNo%>);  
	}
	
	initItem();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
