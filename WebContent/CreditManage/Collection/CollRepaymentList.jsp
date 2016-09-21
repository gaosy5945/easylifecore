<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String objectNo = CurPage.getParameter("ObjectNo");
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	String RightType = CurPage.getParameter("RightType");
	if(RightType==null) RightType="All";
	ASObjectModel doTemp = new ASObjectModel("CollRepaymentList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "0";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("CollectionTaskSerialNo", taskSerialNo);
	dwTemp.genHTMLObjectWindow(taskSerialNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"ReadOnly".equals(RightType)?"false":"true","","Button","����һ��","����һ��","add()","","","","",""},
			{"ReadOnly".equals(RightType)?"false":"true","","Button","ɾ��һ��","ɾ��һ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","",""},
			{"ReadOnly".equals(RightType)?"false":"true","","Button","�ύ","�ύ","dosave()","","","","",""},
			{"ReadOnly".equals(RightType)?"false":"true","","Button","ȡ��","ȡ��","cancel()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		as_add("myiframe0");
		setItemValue(0, getRow(0), "ObjectType", "jbo.acct.ACCT_LOAN");
		setItemValue(0, getRow(0), "ObjectNo", "<%=objectNo%>");
		setItemValue(0, getRow(0), "CollectionTaskSerialNo", "<%=taskSerialNo%>");
		setItemValue(0, getRow(0),"InputDate", "<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
		setItemValue(0, getRow(0), "InputUserID", "<%=CurUser.getUserID()%>");
		setItemValue(0, getRow(0), "InputOrgID", "<%=CurUser.getOrgID()%>");
		setItemValue(0, getRow(0), "Status", "1");
	}
	function cancel(){
		setItemValue(0, getRow(0), "REPAYAMOUNT", "");
		setItemValue(0, getRow(0), "REPAYDATE", "");
	}
	
	function getSum(){
		var RePayAmount=getItemValue(0,getRow(),"REPAYAMOUNT");
		if(parseInt(RePayAmount)<=0){
			alert("��ŵ������Ӧ����0");
			setItemValue(0, getRow(0), "REPAYAMOUNT", "");
			return;
		}
	}
	function dosave(){
		getSum();
		as_save(0);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
