<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String logType = CurPage.getParameter("LogType");
	String customerID = CurPage.getParameter("CustomerID");
	if(logType == null) logType = "";
	if(customerID == null) customerID = "";
	
	ASObjectModel doTemp = new ASObjectModel("CustomerOtherList");
	
	if("1".equals(logType)){//�ܻ������¼
		doTemp.setHeader("UserName", "�¹ܻ���");
		doTemp.setHeader("OrgName", "�¹ܻ�����");
		doTemp.setHeader("InputDate", "�������");
	}else if("2".equals(logType)){
		doTemp.setVisible("OldUserName", false);
		doTemp.setVisible("OldOrgName", false);
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(25);
	dwTemp.genHTMLObjectWindow(customerID+","+logType);
	
	String sButtons[][] = {};
%> 
<script type="text/javascript">
</script>
<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
