<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("ProjectCLAccountList");
	doTemp.setJboWhereWhenNoFilter(" and 1=2 ");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","������Ŀ����","������Ŀ����","view()","","","","",""},
			{"true","All","Button","����ҵ����ϸ","����ҵ����ϸ","projectBusinessDetail()","","","","",""},
			{"true","All","Button","��Ŀ�����ʷ","��Ŀ�����ʷ","projectAlterHistory()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditLineManage/CreditLineLimit/js/CreditLineManage.js"></script>
<script type="text/javascript">

	function view(){
		var ProjectSerialNo = getItemValue(0,getRow(0),"SERIALNO");
		var CustomerID = getItemValue(0,getRow(0),"CUSTOMERID");
		var RightType = "ReadOnly";
		if(typeof(ProjectSerialNo)=="undefined" || ProjectSerialNo.length==0 ){
			 alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		 }
		var flowSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectFlowSerialNo", "selectFlowSerialNo", "ObjectNo="+ProjectSerialNo);
		AsCredit.openFunction("ProjectCLViewMainInfo","ProjectSerialNo="+ProjectSerialNo+"&CustomerID="+CustomerID+"&RightType="+RightType+"&FlowSerialNo="+flowSerialNo);
	}
	function projectBusinessDetail(){
		var serialNo =  getItemValue(0,getRow(0),"SERIALNO");
		var projectType =  getItemValue(0,getRow(0),"PROJECTTYPE");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		AsControl.PopPage("/ProjectManage/ProjectQuery/ProjectBusinessDetail.jsp","SerialNo="+serialNo+"&ProjectType="+projectType,"resizable=yes;dialogWidth=880px;dialogHeight=450px;center:yes;status:no;statusbar:no");
	}
	function projectAlterHistory(){
		var serialNo =  getItemValue(0,getRow(0),"AGREEMENTNO");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		AsControl.PopPage("/ProjectManage/ProjectAlterNewApply/PrjAlterHistory.jsp","SerialNo="+serialNo,"resizable=yes;dialogWidth=680px;dialogHeight=450px;center:yes;status:no;statusbar:no");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
