<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@page import="com.amarsoft.app.als.businessobject.*"%> 
  
<%
	String PG_TITLE = "�˻���Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	String sObjectNo = CurPage.getParameter("OBJECTNO");
	String sObjectType = CurPage.getParameter("OBJECTTYPE");
	String accountIndicator =CurPage.getParameter("ACCOUNTINDICATOR");
	String status = CurPage.getParameter("STATUS");
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(status == null) status = "";

	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectNo", sObjectNo);
	inputParameter.setAttributeValue("ObjectType", sObjectType);
	
	//��ʾģ����	
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("DepositAccountsList", inputParameter,CurPage);
	doTemp.appendJboWhere(" and Status in('"+status.replaceAll("@","','")+"')");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	if(accountIndicator != null && !"".equals(accountIndicator)) 
		doTemp.appendJboWhere(" and AccountIndicator in('"+accountIndicator.replaceAll("@","','")+"')");
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	
	dwTemp.Style = "1"; //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);

	String sButtons[][] = {
			{"true", "All", "Button", "����", "����һ���˻���Ϣ","createRecord()",""},
			{"true", "", "Button", "����", "����","view()",""},
			{"true", "All", "Button", "ɾ��", "ɾ��һ����Ϣ","deleteRecord()",""},
	};

%>
<%@include file="/Frame/resources/include/ui/include_list.jspf" %>
<script language=javascript>
	function createRecord(){
		AsControl.PopView("/Accounting/LoanDetail/LoanTerm/DepositAccountsInfo.jsp","STATUS=<%=status%>&OBJECTNO=<%=sObjectNo%>&OBJECTTYPE=<%=sObjectType%>&ACCOUNTINDICATOR=<%=accountIndicator%>","dialogWidth:400px;dialogHeight:300px;","");
		reloadSelf();
	}
	
	function view(){
		var SerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(SerialNo)=="undefined"||SerialNo.length==0){
			alert("��ѡ��һ����¼");
			return;
		}
		OpenPage("/Accounting/LoanDetail/LoanTerm/DepositAccountsInfo.jsp?STATUS=<%=status%>&OBJECTNO=<%=sObjectNo%>&OBJECTTYPE=<%=sObjectType%>&ACCOUNTINDICATOR=<%=accountIndicator%>&SERIALNO="+SerialNo,"_self","");
	}
	
	/*~[Describe=ɾ��;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		//setNoCheckRequired(0);  //���������б���������
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("ȷ��ɾ������Ϣ��")){
			as_delete("0");
			as_save("0");  
			/* as_delete(0,'','delete');
			as_do(0,'','save'); */
		}
		reloadSelf();
	}
</script>
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>