<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
    String sCONTRACTSERIALNO = CurPage.getParameter("CONTRACTSERIALNO");
    
	String sSERIALNO = CurPage.getParameter("SERIALNO");
	if(sSERIALNO == null)     sSERIALNO = "";
	String CUSTOMERID = CurPage.getParameter("CUSTOMERID");
	String CUSTOMERNAME = CurPage.getParameter("CUSTOMERNAME");
	String CERTTYPE = CurPage.getParameter("CERTTYPE");
	String CERTID = CurPage.getParameter("CERTID");
	ASObjectModel doTemp = new ASObjectModel("AssetForChange");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("sSERIALNO");
	
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","ȷ��","ȷ��","sure()","","","","",""},
		};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
function sure(){
	if(typeof(SERIALNO)=="undefined" || SERIALNO.length==0){
		alert("��ѡ��һ�ʽ����Ϣ��");
		return;
	}else{
		AsControl.OpenPage("/CreditManage/CreditChange/AssetChangeInfo.jsp","SERIALNO="+SERIALNO,"frame_info1");
	}
}
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
