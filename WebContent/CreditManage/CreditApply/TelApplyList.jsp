<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String PG_TITLE = "�绰�˲������б�"; // ��������ڱ��� <title> PG_TITLE </title>

	ASObjectModel doTemp = new ASObjectModel("ApplyTodoList");
	String status = CurPage.getParameter("Status");
	if(status == null) status="";
	String todoType = CurPage.getParameter("TodoType");
	if(todoType == null) todoType="";
	doTemp.appendJboWhere(" and BA.OperateOrgID like '" + CurOrg.getOrgID() + "%'");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setParameter("Status",status);
	dwTemp.setParameter("TodoType",todoType);
	dwTemp.genHTMLObjectWindow(todoType+","+status);
	
	String sButtons[][] = {
		{"true","All","Button","��ȡ����","��ȡ����","add()","","","",""},	
		{"true","All","Button","��˴���","��˴���","deal()","","","",""},	
		{"true","All","Button","ɾ������","ɾ������","deleteTask()","","","",""}
	};
	
	if(status.equals("02")){
		sButtons[0][0] = "false";
		sButtons[1][3] = "�������";
		sButtons[1][4] = "�������";
		sButtons[2][0] = "false";
	}
%><%@include file="/Frame/resources/include/ui/include_list.jspf" %>
<script type="text/javascript">
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function add(){
		var sResult = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.AcquireTodoTask", "getTask", "OrgID=<%=CurOrg.getOrgID()%>,UserID=<%=CurUser.getUserID()%>,TodoType=<%=todoType%>");
		reloadSelf();
	}
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function deal(){
		var objectNo = getItemValue(0,getRow(),"TraceObjectNo");
		AsCredit.openFunction("DataEntryDeal05", "ObjectType=jbo.app.BUSINESS_APPLY&ObjectNo="+objectNo+"&Status=<%=status%>");
	}
	
	/*~[Describe=ɾ��;InputParam=�����¼�;OutPutParam=��;]~*/
	function deleteTask(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		if(confirm('ȷʵҪɾ����?')){
			as_delete(0);
		}
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>