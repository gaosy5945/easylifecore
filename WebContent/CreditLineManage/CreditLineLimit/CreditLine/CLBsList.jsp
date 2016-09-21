<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String ContractSerialNo = "";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select * from contract_relative where objectno=:objectNo and objecttype = 'jbo.app.BUSINESS_CONTRACT'").setParameter("objectNo",serialNo));
	while(rs.next()){
		String Temp = rs.getString("ContractSerialNo");
		ContractSerialNo += Temp+"@";
	}
	rs.getStatement().close();
	
	ASObjectModel doTemp = new ASObjectModel("CLBsList");
	
	doTemp.appendJboWhere(" and O.SerialNo in('"+ContractSerialNo.replaceAll("@", "','")+"')");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�������","�������","view()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function view(){
	var SerialNo = getItemValue(0,getRow(0),"SerialNo");
	if(typeof(SerialNo)=="undefined" || SerialNo.length==0)  {
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return ;
	}
	var BusinessType = getItemValue(0,getRow(0),"BusinessType");
	var RightType = "ReadOnly";
	var ApplySerialNo = getItemValue(0,getRow(0),"ApplySerialNo");
	AsCredit.openFunction("CLViewMainInfo","SerialNo="+SerialNo+"&BusinessType="+BusinessType+"&ObjectNo="+ApplySerialNo+"&ObjectType=jbo.app.BUSINESS_APPLY"+"&RightType="+RightType);
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
