<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sBDSerialNo = CurPage.getParameter("BDSerialNo");
	if(sBDSerialNo==null) sBDSerialNo = "";
	String sContractArtificialNo = CurPage.getParameter("ContractArtificialNo");
	if(sContractArtificialNo==null) sContractArtificialNo = "";
	String sBDType = CurPage.getParameter("BDType");
	if(sBDType==null) sBDType = "";
	ASObjectModel doTemp = new ASObjectModel("PDARecoverRecordList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sBDSerialNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{String.valueOf(!sBDType.equals("030")),"All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{String.valueOf(!sBDType.equals("030")),"","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var sUrl = "/RecoveryManage/NPAManage/NPADailyManage/PDARecoverRecordInfo.jsp";
		 AsControl.PopComp(sUrl,"ContractArtificialNo=<%=sContractArtificialNo%>&BDSerialNo=<%=sBDSerialNo%>",'','');
		 reloadSelf();
	}
	function edit(){
		 var sUrl = "/RecoveryManage/NPAManage/NPADailyManage/PDARecoverRecordInfo.jsp";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		 var status = "<%=sBDType%>";
		 if (status=="030") {
			AsControl.PopComp(sUrl,'SerialNo=' +sPara+"&RightType=ReadOnly" ,'','');
		 }else {
			AsControl.PopComp(sUrl,'SerialNo=' +sPara ,'','');
		 }
		 reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
