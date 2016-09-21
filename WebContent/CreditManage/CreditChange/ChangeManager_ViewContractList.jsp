<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String objectNo = CurPage.getParameter("ObjectNo");
	if(objectNo==null||objectNo.length()==0)objectNo="";
	
	String contractNoList="";
	BizObjectManager bm = JBOFactory.getBizObjectManager( "jbo.app.BUSINESS_CONTRACT_CHANGE" );
	BizObject bo= bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", objectNo).getSingleResult(false);
	if(bo!=null){
		contractNoList=bo.getAttribute("BATCHCHANGECONTRACTNOLIST").getString();
	}
	if(contractNoList==null)contractNoList="";
	
	contractNoList = "('"+contractNoList.replace(",", "','")+"')";
	
	ASObjectModel doTemp = new ASObjectModel("ChangeManager_ViewContractList");
	doTemp.appendJboWhere("  and  O.SerialNo in "+contractNoList);
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>

