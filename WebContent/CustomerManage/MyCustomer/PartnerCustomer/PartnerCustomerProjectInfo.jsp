<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	
	ASObjectModel doTemp = new ASObjectModel("PCProjectInfo");
	//���´������������߼�����
	//String LoanCount = Sqlca.getString(new SqlObject("select count(1) as LoanCount from contract_relative where ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and ObjectNo=:ObjectNo").setParameter("ObjectNo",serialNo));
	//doTemp.setJboWhere(doTemp.getJboWhere()+" and exists(select 1 from jbo.sys.ORG_BELONG OB where OB.BelongOrgID='"+CurOrg.getOrgID()+"' and O.ParticipateOrg like '%%')");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(customerID);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"false","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","viewProject()","","","","btn_icon_detail",""},
			{"false","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function viewProject(){
	var serialNo =  getItemValue(0,getRow(0),"SERIALNO");
	var customerID =  getItemValue(0,getRow(0),"CUSTOMERID");
	if(typeof(serialNo) == "undefined" || serialNo.length == 0){
		alert("��ѡ��һ����Ϣ��");
		return;
	}
    AsCredit.openFunction("ProjectInfoTab", "SerialNo="+serialNo+"&RightType="+"ReadOnly"+"&CustomerID="+customerID);
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
