<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sSerialNo = CurPage.getParameter("RelativeObjectNo");
	if(sSerialNo == null) sSerialNo = "";
	String sTempletNo = "AssetChangeInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sSerialNo);
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			//{"true","","Button","�ύ","�ύ","commit()","","","","btn_icon_detail",""},
		};
	
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
function commit(){
	var serialNo = '<%=sSerialNo%>';
	var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.contract.action.RmnTfrRsrvAmtAplCommit", "rmnTfrRsrvAmtAplCommit",   "SERIALNO="+serialNo);
	if(typeof(sReturn) == "undefined" || sReturn.length == 0) return;
	
	if(sReturn.split("@")[0] == "true")
	{
		alert(sReturn.split("@")[1]);
		AsControl.OpenView("/BillPrint/OnetimeChg.jsp","SerialNo="+serialNo,"_blank");//ר��һ����ת���ý�
	}
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>