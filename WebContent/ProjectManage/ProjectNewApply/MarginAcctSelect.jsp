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

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	//���ϸ�ҳ��õ�����Ĳ���
	String ProjectSerialNo = CurPage.getParameter("ProjectSerialNo");//��ݺ�
	if(ProjectSerialNo == null) ProjectSerialNo = "";
	String AccountNo = CurPage.getParameter("AccountNo");//��ݺ�	
	if(AccountNo == null) AccountNo = "";
	String MFCustomerID = CurPage.getParameter("MFCustomerID");//��ݺ�	
	if(MFCustomerID == null) MFCustomerID = "";
	String sTempletNo = "MarginBalance";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"false","All","Button","����","���������޸�","as_save(0)","","","",""},
	};
	%>
<%/*~END~*/%>
<html>
<body>
<title>��֤���˻��˺�����ѯ</title>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
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
	
			//ȡ���ر��ĵ�ReturnCode��ReturnMsg���жϷ��ر����Ƿ���ȷ
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
