<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String userID = CurUser.getUserID();
	ASObjectModel doTemp = new ASObjectModel("BusinessApplyAllList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("UserID", userID);
	dwTemp.genHTMLObjectWindow(userID);

	String sButtons[][] = {
		//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
		{"true","","Button","����","����","edit()","","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		var serialNo = getItemValue(0, getRow(0), "SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//��ҳ��
		AsCredit.openFunction("ApplyInfo","ObjectNo="+serialNo+"&ObjectType=jbo.app.BUSINESS_APPLY&RightType=ReadOnly","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
