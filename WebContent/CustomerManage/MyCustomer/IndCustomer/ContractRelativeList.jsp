<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String SerialNo = CurPage.getParameter("SerialNo");
	if(SerialNo == null) SerialNo = "";
	ASObjectModel doTemp = new ASObjectModel("ContractRelativeList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("SerialNo", SerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		 var ContractSerialNo = getItemValue(0,getRow(0),'ContractSerialNo');
		 if(typeof(ContractSerialNo)=="undefined" || ContractSerialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		 AsCredit.openFunction("ContractInfo","ObjectNo="+ContractSerialNo+"&ObjectType="+"jbo.app.BUSINESS_CONTRACT"+"&RightType="+"ReadOnly");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
