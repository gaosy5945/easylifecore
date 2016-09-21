<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.amarsoft.app.oci.bean.OCITransaction"%>
<%@page import="com.amarsoft.app.oci.bean.Message"%>
<%@page import="com.amarsoft.app.oci.instance.CoreInstance"%>
<%@page import="com.amarsoft.app.als.project.QueryMarginBalance"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.BizObjectQuery"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	//从上个页面得到传入的参数
	String ProjectSerialNo = CurPage.getParameter("ProjectSerialNo");//借据号
	if(ProjectSerialNo == null) ProjectSerialNo = "";
	String AccountNo = CurPage.getParameter("AccountNo");//借据号	
	if(AccountNo == null) AccountNo = "";
	String MFCustomerID = CurPage.getParameter("MFCustomerID");//借据号	
	if(MFCustomerID == null) MFCustomerID = "";
	String sTempletNo = "MarginBalance";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"false","All","Button","保存","保存所有修改","as_save(0)","","","",""},
	};
	%>
<%/*~END~*/%>
<html>
<body>
<title>保证金账户账号余额查询</title>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%	
	StringBuffer sJSScript = new StringBuffer();
	JBOTransaction tx = null;
	try{
		tx = JBOFactory.createJBOTransaction();
		//QueryMarginBalance QMB = new QueryMarginBalance();
		//String MFCustomerID = QMB.queryMarginBalance(ProjectSerialNo, tx);
		
		String TranTellerNo = "92261005";
		String BranchId = "2261";
		int StartNum1 = 0;
		int QueryNum1 = 9;
		String BussCode = "5850";
		try{
			BizObjectManager bmCMI = JBOFactory.getBizObjectManager("jbo.guaranty.CLR_MARGIN_INFO");
			tx.join(bmCMI);
			OCITransaction oci = CoreInstance.CorpCrnAcctQry(TranTellerNo, BranchId, AccountNo, tx.getConnection(bmCMI));
	
			//取返回报文的ReturnCode和ReturnMsg，判断返回报文是否正确
			String ReturnCode = oci.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnCode");
			String ReturnMsg = oci.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnMsg");
			if(("000000000000").equals(ReturnCode)){
				String MarginBalanceTemp = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("AcctBal");
				String MarginBalance = MarginBalanceTemp.replace(" ", "");
				%>
					<script>setItemValue(0,0,"BALANCE","<%=MarginBalance%>");</script>
				<%
			}
		}catch(Exception ex){
			String msg = ex.getMessage();
			%> <script type="text/javascript"> alert("<%=msg%>"); top.close(); </script><%
		}
		tx.commit();
	}catch(Exception ex){
		tx.rollback();
		throw ex;
	}

%>
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
