<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
    String CLASSIFYSTATUS = CurPage.getParameter("Itemno");
	ASObjectModel doTemp = new ASObjectModel("DUEBILL_RISK_APPLY");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	
	dwTemp.genHTMLObjectWindow(CLASSIFYSTATUS);
	
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","��������","��������","viewAndEdit()","","","","",""},
			{"true","","Button","�鿴���","�鿴���","edit()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

function viewAndEdit(){
	var serialNo=getItemValue(0,getRow(),"SerialNo");
	if(typeof(serialNo)=="undefined" || serialNo.length==0) 
	{
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return ;
	}
	AsControl.PopComp("/RiskClassify/SingleAdjust.jsp", "SerialNo="+serialNo);
	reloadSelf();
}


	 
	 
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
