<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	String flowNo = Sqlca.getString(new SqlObject("select FlowNo from FLOW_OBJECT where ObjectNo = :ObjectNo and ObjectType =:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType));
	String flowVersion = Sqlca.getString(new SqlObject("select FlowVersion from FLOW_OBJECT where ObjectNo = :ObjectNo and ObjectType =:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType));
    if(objectNo == null) objectNo = "";
    if(objectType == null) objectType = "";
    String tempno = "CreditApproveList2";
    ASObjectModel doTemp = new ASObjectModel(tempno);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "0";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("objectNo", objectNo);
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","����","����","edit()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		var taskSerialNo = getItemValue(0,getRow(),"TASKSERIALNO");
		var flowSerialNo = getItemValue(0,getRow(),"FLOWSERIALNO");
		if(typeof(taskSerialNo)=="undefined" || taskSerialNo.length==0)  {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		AsCredit.openFunction("SignTApproveInfo1","TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>");
		//var returnValue = AsControl.RunASMethod("BusinessManage","QueryIsCanReadOpinion","<%=CurUser.getUserID()%>,"+flowSerialNo);
		//if(returnValue == "false"){
		//	alert("�Բ�����û��Ȩ�޲鿴���顣");
		//	return;
		//}else{
		//}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
