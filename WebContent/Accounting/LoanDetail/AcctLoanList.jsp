<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@ include file="/Accounting/include_accounting.jspf"%>
<%
	String PG_TITLE = "̨����Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String businessType = "";
	String projectVersion = "";
	
	//����������	
	
	//���ҳ�����
	String sObjectNo = CurPage.getParameter("ObjectNo");
	if(sObjectNo == null) sObjectNo = "";
	
	//��ʾģ����
	String sTempletNo = "AcctLoanList";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sObjectNo);
	
	String sButtons[][] = {
			{"true", "", "Button", "����", "����","viewRecord()","","","","btn_icon_detail",""},
	};
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>

<script type="text/javascript">
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else 
		{
			OpenComp("AcctLoanView","/Accounting/LoanDetail/AcctLoanView.jsp","ObjectNo="+sSerialNo+"&ObjectType=<%=BUSINESSOBJECT_CONSTANTS.loan%>"+"&RightType=ReadOnly","_blank","");				
		}
	}
</script>


<script language=javascript>
	//��ʼ��
</script>
<%
/*~END~*/
%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
