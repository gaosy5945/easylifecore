<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%		
	String Status = CurPage.getParameter("Status");
	if(Status == null) Status = ""; 
	ASObjectModel doTemp = new ASObjectModel("ProjectApprove");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("STATUS", Status);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","������Ŀ����","������Ŀ����","editProject()","","","","",""},
			{"02".equals(Status)?"false":"true","All","Button","ǩ�����","ǩ�����","signOpinion()","","","","",""},
			{"02".equals(Status)?"false":"true","All","Button","�ύ","�ύ","submitProject()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function editProject(){
		
	}
	function signOpinion(){
		
	}
	function submitProject(){
		var result = AsControl.PopComp("/ProjectManage/ProjectApprove/submitProjectDialog.jsp","","resizable=yes;dialogWidth=500px;dialogHeight=200px;center:yes;status:no;statusbar:no");

	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
