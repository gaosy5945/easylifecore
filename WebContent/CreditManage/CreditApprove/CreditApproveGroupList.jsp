<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
    String taskSerialNo = CurPage.getParameter("TaskSerialNo");
    String objectNo = CurPage.getParameter("ObjectNo");
    if(objectNo == null) objectNo = "";
    if(taskSerialNo == null) taskSerialNo = "";
	ASObjectModel doTemp = new ASObjectModel("CreditApproveGroupList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	//dwTemp.MultiSelect = true;	 //��ѡ/**�޸�ģ��ʱ�벻Ҫ�޸���һ��*/
	//dwTemp.ShowSummary="1";	 	 //����/**�޸�ģ��ʱ�벻Ҫ�޸���һ��*/
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("APPLYSERIALNO", objectNo);
	dwTemp.setParameter("TaskSerialNo", taskSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""}
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
    function add(){
	     AsControl.OpenPage("/CreditManage/CreditApprove/CreditApproveGroupInfo.jsp","",'_self','');
         }
    
	function edit(){
		 var SerialNo = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(SerialNo)=="undefined" || SerialNo.length==0 ){
			alert("��ѡ��һ����Ϣ��");
			return ;
		 }
		AsControl.OpenPage("/CreditManage/CreditApprove/CreditApproveGroupInfo.jsp",'SerialNo=' +SerialNo ,'_self','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
