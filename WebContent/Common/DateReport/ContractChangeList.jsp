<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%
	//���ղ���
	String sTempletNo = DataConvert.toString(CurPage.getParameter("TempletNo"));//ģ���
	String SerialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));//��ˮ��

	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.setParameter("SerialNo", SerialNo);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","����","����","view()","","","","",""},
		};
	
%> 

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function view(){
	var serialNo = getItemValue(0,getRow(0),'RELATIVEOBJECTNO');
	var transSerialNo = getItemValue(0,getRow(0),'SERIALNO');
	var transCode = getItemValue(0,getRow(0),'TRANSACTIONCODE');
	if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return ;
	}
	
	if("0000"==transCode){
		alert("��ֲ�Ĵ��������ݣ����ɲ鿴�������飡");
		return;
	}
	
	AsCredit.openFunction("ViewPostLoanChangeTabNew","serialNo="+serialNo+"&TransSerialNo="+transSerialNo+"&TransCode="+transCode+"&RightType=ReadOnly");
	reloadSelf();
}
</script>

<%@include file="/Frame/resources/include/include_end.jspf"%>
