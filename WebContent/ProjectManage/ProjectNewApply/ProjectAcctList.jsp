<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String objectNo = CurPage.getParameter("ObjectNo");
	if(objectNo == null) objectNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("ProjectAcctList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","",""},
			{"true","","Button","����","����","edit()","","","","",""},
			{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var objectType = "jbo.guaranty.CLR_MARGIN_INFO";
		var SerialNo = "";
		AsControl.OpenView("/ProjectManage/ProjectNewApply/ProjectAcctInfo.jsp","ObjectType="+objectType+"&SerialNo="+SerialNo+"&ObjectNo="+"<%=objectNo%>","_self","");
	}
	function edit(){
		 var SerialNo = getItemValue(0,getRow(0),"SerialNo");
		 if(typeof(SerialNo)=="undefined" || SerialNo.length==0 ){
			alert("��ѡ��һ����Ϣ��");
			return ;
		 }
		 AsControl.OpenView("/ProjectManage/ProjectNewApply/ProjectAcctInfo.jsp","SerialNo="+SerialNo+"&ObjectNo="+"<%=objectNo%>","_self","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
