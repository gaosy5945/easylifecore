<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>

<%
	//���ղ���
	String tempNo = DataConvert.toString(CurPage.getParameter("TempNo"));//ģ���
	ASObjectModel doTemp = null;

	doTemp = new ASObjectModel(tempNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	//dwTemp.setParameter(name, value)
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.setPageSize(10);
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","view()","","","","",""},
		};
%> 

<script type="text/javascript">
function view(){
	 var serialNo = getItemValue(0,getRow(0),'RELATIVEOBJECTNO');
	 var transSerialNo = getItemValue(0,getRow(0),'SERIALNO');
	 var transCode = getItemValue(0,getRow(0),'TRANSACTIONCODE');
	 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
		 alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return ;
	 }
	 AsCredit.openFunction("PostLoanChangeTabNew","serialNo="+serialNo+"&transSerialNo="+transSerialNo+"&TransCode="+transCode+"&RightType=ReadOnly");
	 //reloadSelf();
}
</script>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>