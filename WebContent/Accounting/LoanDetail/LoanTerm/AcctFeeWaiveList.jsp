<%@ page contentType="text/html; charset=GBK"%>
<%-- <%@include file="/IncludeBegin.jsp"%> --%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
  
<%
	String PG_TITLE = "���ü����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String businessType = "";
	String projectVersion = "";
	
	//����������	
	
	//���ҳ�����
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	String status = CurPage.getParameter("Status");//״̬
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";

	//��ʾģ����
	String sTempletNo = "AcctFeeWaiveList";
	String sTempletFilter = "1=1";
	
	//ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,"");
	//doTemp.WhereClause += " and Status in('"+status.replaceAll("@","','")+"')";
	doTemp.appendJboWhere(" and Status in('"+status.replaceAll("@","','")+"')");
	//ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp, request);
	dwTemp.Style = "1"; //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	//Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sObjectType);
	//for(int i=0;i < vTemp.size();i++)out.print((String) vTemp.get(i));
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);
	

	String sButtons[][] = {
			{"true", "All", "Button", "����", "����һ����Ϣ","createRecord()",""},
			{"true", "", "Button", "����", "��������","viewFee()",""},
			{"true", "All", "Button", "ɾ��", "ɾ��һ����Ϣ","deleteRecord()",""},
	};
%>
<%-- <%@ include file="/Resources/CodeParts/List05.jsp"%> --%>
<%@include file="/Frame/resources/include/ui/include_list.jspf" %>
<script language=javascript>
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function createRecord(){
		OpenPage("/Accounting/LoanDetail/LoanTerm/AcctFeeWaiveInfo.jsp","_self","");
	}
	
	function viewFee(){
		var SerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(SerialNo)=="undefined"||SerialNo.length==0){
			alert("��ѡ��һ����¼");
			return;
		}
		OpenPage("/Accounting/LoanDetail/LoanTerm/AcctFeeWaiveInfo.jsp?SerialNo="+SerialNo,"_self","");
	}
	
	/*~[Describe=ɾ��;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		setNoCheckRequired(0);  //���������б���������
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("ȷ��ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}	
	
	//��ʼ��
	/* AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0'); */
</script>
<%/*~END~*/%>

<%-- <%@include file="/IncludeEnd.jsp"%> --%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>