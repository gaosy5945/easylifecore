<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	
	String sObjectNo = CurPage.getParameter("ObjectNo");//������ˮ�ţ�������Ϣ����ծ�ʲ���Ϣ���Ѻ����ʲ���Ϣ
	if(sObjectNo == null) sObjectNo = "";
	String sObjectType = CurPage.getParameter("ObjectType");//�������ͣ�LIChangeManager��DAChangeManager��PDAChangeManager
	if(sObjectType == null) sObjectType = "";
	String sGoBackType = CurPage.getParameter("GoBackType");//����ҳ�棺1��2��3
	if(sGoBackType == null) sGoBackType = "";

	ASObjectModel doTemp = new ASObjectModel("ChangeManagerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sObjectType+","+sObjectNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","goBack()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		self.close();
		<%-- var sGoBackType = "<%=sGoBackType%>";
		
		if(sGoBackType == "1"){ //����������
			self.close();
			//OpenPage("/RecoveryManage/LawCaseManage/LawCaseManagerChangeList.jsp","right","");
		} else if(sGoBackType == "2"){//��ծ�ʲ�
			OpenPage("/RecoveryManage/PDAManage/PDAManagerChange/RepayAssetList.jsp","right","");
		} else if(sGoBackType == "3"){//�Ѻ����ʲ�
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/VerifitionAssetChangeList.jsp","right","");
		} --%>
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
