<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	ASObjectModel doTemp = new ASObjectModel("CustomerListRelative");
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.MultiSelect = true; //�����ѡ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","ʧЧ","ʧЧ","LoseEfficacy()","","","","",""},
			{"true","All","Button","�������������","�������������","downLoad()","","","","",""},
			{"true","All","Button","����","����","exportPage('"+sWebRootPath+"',0,'excel','')","","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function LoseEfficacy(){
	var updateSerialNos = '';
	var recordArray = getCheckedRows(0); //��ȡ��ѡ����
	if (typeof(recordArray)=="undefined" || recordArray.length==0){
		alert("������ѡ��һ����¼��");
		return;
	}
	for(var i = 1;i <= recordArray.length;i++){ //ͨ��ѭ����ȡserialNo
		var SerialNo = getItemValue(0,recordArray[i-1],"SERIALNO");
		updateSerialNos += SerialNo+"@";
	}
	if(confirm('ȷ��Ҫ����ѡ��������ΪʧЧ��')){
		var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.activeCredit.customerBase.LoseEfficacy", "lose", "updateSerialNos="+updateSerialNos+",updateDate="+"<%=DateHelper.getBusinessDate()%>");
		if(sReturn == "SUCCEED"){
			alert("�����ɹ���");
			reloadSelf();
		}else{
			alert("����ʧ�ܣ�");
			reloadSelf();
		}

	}
}
function downLoad(){
	AsControl.PopPage("/ActiveCreditManage/CustomerAppoveManage/CustomerListRelativeListJB.jsp","","resizable=yes;dialogWidth=1000px;dialogHeight=500px;center:yes;status:no;statusbar:no");
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
