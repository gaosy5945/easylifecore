<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

	<%
	String PG_TITLE = "���׼�¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	String objectNo = CurPage.getParameter("ObjectNo");//������
	String objectType =  CurPage.getParameter("ObjectType");//��������
	if(objectNo == null)objectNo = "";
	if(objectType == null)objectType = "";

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "Acct_Transaction";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(objectNo+","+objectType);
	
	//����HTMLDataWindow
	
	String sButtons[][] = {
			{"true", "", "Button", "��������", "��������","viewLoanRecord()",""},
			{"true", "", "Button", "��¼����", "��¼����","viewSubjectRecord()",""},
	};
	%> 

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	/*~[Describe=�鿴���޸Ľ�������;InputParam=��;OutPutParam=��;]~*/
	function viewLoanRecord()
	{
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var documentType = getItemValue(0,getRow(),"DocumentType");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		if(typeof(documentType)=="undefined" || documentType.length==0) {
			alert("���ཻ��û��������Ϣ��")
		}else{
		   	OpenComp("TransactionInfo","/Accounting/Transaction/TransactionInfo.jsp","SerialNo="+serialNo+"&RightType=ReadOnly","_blank","");	
		}
	}
	
	/*~[Describe=�鿴���޸ķ�¼����;InputParam=��;OutPutParam=��;]~*/
	function viewSubjectRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else 
		{
		    OpenComp("LoanDetailList","/Accounting/LoanDetail/LoanDetailList.jsp","TransSerialNo="+sSerialNo,"_blank","");	
		}
	}
</script>


<script type="text/javascript">	



// 	AsOne.AsInit();
// 	init();
// 	my_load(2,0,'myiframe0');
</script>	

<%@ include file="/Frame/resources/include/include_end.jspf"%>
