<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%
	//���ղ���
	String tempNo = DataConvert.toString(CurPage.getParameter("TempNo"));//ģ���
	String SerialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));//��ˮ��
	String businessDate = com.amarsoft.app.base.util.DateHelper.getBusinessDate();
	ASObjectModel doTemp = new ASObjectModel(tempNo);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.setParameter("SerialNo", SerialNo);
	dwTemp.setParameter("BusinessDate", businessDate);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{("AcctLoanChange1".equals(tempNo) ? "true" : "false"),"","Button","����","����","view()","","","","",""},
			{"true","","Button","����","����Excel","as_defaultExport()","","","",""},
		};
	
%> 


<script type="text/javascript">
var showRowNum="None";
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
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@include file="/Frame/resources/include/include_end.jspf"%>
