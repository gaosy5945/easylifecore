<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("AssetForChangeList");

	doTemp.setJboWhereWhenNoFilter(" and 1=2 ");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.setPageSize(10);
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","ר���ʽ�һ����ת���ý�","ר���ʽ�һ����ת���ý�","assetchange()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function assetchange(){
	var serialNo = getItemValue(0,getRow(),"SERIALNO");
	if(typeof(serialNo)=="undefined" || serialNo.length==0){
		alert("��ѡ��һ�ʽ����Ϣ��");
		return;
	}else{
		AsControl.OpenView("/CreditManage/CreditChange/AssetChangeInfo.jsp","SerialNo="+serialNo,"_blank");
	}
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>

