<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String Status = CurPage.getParameter("Status");
	if(Status == null) Status = "";

	ASObjectModel doTemp = new ASObjectModel("ProjectOthersApplyList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("Status", Status);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","��������","��������","add()","","","","",""},
			{"true","","Button","ȡ������","ȡ������","edit()","","","","",""},
			{"true","","Button","��Ŀ�������","��Ŀ�������","edit()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var sReturn = AsControl.PopPage("/ProjectManage/ProjectAlterNewApply/ProjectAlterOthersNew.jsp","","resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
		//AsCredit.openFunction("ProjectOthersApplyInfo","CustomerID="+sReturn[]);
	}
	function edit(){
		 var sUrl = "";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.OpenPage(sUrl,'SerialNo=' +sPara ,'_self','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
