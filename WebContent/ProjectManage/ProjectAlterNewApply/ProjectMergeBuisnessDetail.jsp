<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String ProjectSerialNo = CurPage.getParameter("SerialNo");
	if(ProjectSerialNo == null) ProjectSerialNo = "";
	String ProjectSerialNoNew = CurPage.getParameter("ProjectSerialNo");
	if(ProjectSerialNoNew == null) ProjectSerialNoNew = "";

	ASObjectModel doTemp = new ASObjectModel("ProjectBusinessDetail");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.MultiSelect = true; //�����ѡ
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ProjectSerialNo", ProjectSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","ȷ��","ȷ��","enSure()","","","","",""},
		};
	sASWizardHtml = "<p><font color='red' size='2'> ������ҵ����ϸ�� </font></p>" ; 
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	function enSure(){
		var ProjectSerialNoNew = "<%=ProjectSerialNoNew%>";
		var ProjectSerialNoOld = "<%=ProjectSerialNo%>";
		var relaPRSerialNos = '';
		var recordArray = getCheckedRows(0);//��ȡ��ѡ����
		if (typeof(recordArray)=="undefined" || recordArray.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		for(var i = 1;i <= recordArray.length;i++){//ͨ��ѭ����ȡ
			var PRSerialNo = getItemValue(0,recordArray[i-1],"SerialNo");
			relaPRSerialNos += PRSerialNo+"@";
		}
		//var result = CustomerManage.importCustomer(recordArray, relaCustomerIDs, userID, inputDate, inputOrgID);
		var result = ProjectManage.projectMerge(ProjectSerialNoNew, ProjectSerialNoOld, relaPRSerialNos);
		if(result == "SUCCEED"){
			alert("��Ŀ�ϲ��ɹ���");
		}else{
			alert("��Ŀ�ϲ�ʧ�ܣ�");
		}
		reloadSelf();
	}
	
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
