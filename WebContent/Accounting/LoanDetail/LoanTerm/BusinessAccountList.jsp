<%@page import="com.amarsoft.app.base.businessobject.BusinessObjectManager"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObject"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
  
<%
	String PG_TITLE = "�˻���Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String businessType = "";
	String projectVersion = "";
	
	//����������	
	
	//���ҳ�����
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	String status = CurPage.getParameter("Status");
	String right=CurPage.getParameter("RightType");
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(status == null) status = "";
	
	//��ʾģ����
	String sTempletNo = "BusinessAccountList";
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	String statusStr = status.replaceAll("@","','");
	doTemp.appendJboWhere(" and Status in('"+statusStr+"')");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style = "1"; //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);
	
	

	String sButtons[][] = {
			{"true", "All", "Button", "�����ſ��ʺ�", "����һ���ſ��ʺ���Ϣ","createRecord('00')",""},
			{"true", "All", "Button", "���������ʺ�", "����һ�������ʺ���Ϣ","createRecord('01')",""},
			{"true", "All", "Button", "���������ʺ�", "����һ�������ʺ���Ϣ","createRecord('99')",""},
			{"true", "", "Button", "����", "�˺�����","viewRecord()",""},
			{"true", "All", "Button", "ɾ��", "ɾ��һ����Ϣ","deleteRecord()",""},
	};
	if("ReadOnly".equals(right)||sObjectType.equals("PutOutApply")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
		sButtons[4][0]="false";
	}
	if(sObjectType.equals("jbo.acct.ACCT_LOAN_CHANGE" )){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script language=javascript>
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function createRecord(AccountIndicator){
		OpenPage("/Accounting/LoanDetail/LoanTerm/BusinessAccountInfo.jsp?Status=<%=status%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&AccountIndicator="+AccountIndicator,"_self","");
		//reloadSelf();
		}
	
	function viewRecord(){
		var SerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(SerialNo)=="undefined"||SerialNo.length==0){
			alert("��ѡ��һ����¼");
			return;
		}
		OpenPage("/Accounting/LoanDetail/LoanTerm/BusinessAccountInfo.jsp?Status=<%=status%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&SerialNo="+SerialNo,"_self","");
	}
	
	/*~[Describe=ɾ��;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		if(confirm("ȷ��ɾ������Ϣ��")){
			as_delete("myiframe0");
		}
	}
	//��ʼ��
// 	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>