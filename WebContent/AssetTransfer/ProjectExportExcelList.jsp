<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//����
	String sPRISerialNoList = CurPage.getParameter("PRISerialNoList");
	if(StringX.isEmpty(sPRISerialNoList) || null == sPRISerialNoList || "null" == sPRISerialNoList) sPRISerialNoList = "";
	ASObjectModel doTemp = new ASObjectModel("ProjectAssetList");
	if(!StringX.isEmpty(sPRISerialNoList)){
		sPRISerialNoList = sPRISerialNoList.replace(",","','");
	}
	doTemp.appendJboWhere(" and O.SERIALNO in('"+sPRISerialNoList+"') ");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","����","����","exportRecord()","","","","btn_icon_add",""},
			{"true","","Button","ȡ��","ȡ��","cancle()","","","","btn_icon_detail",""},
		};
	//sButtonPosition = "south"; 
%>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	function exportRecord(){
		if(confirm("�Ƿ񵼳��ʲ���Ϣ��")){
			exportPage('<%=sWebRootPath%>',0,'excel','0'); 
		}
	}
	function cancle(){
		//�����ϸ�����
		self.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
