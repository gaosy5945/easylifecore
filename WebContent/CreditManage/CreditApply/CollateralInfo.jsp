<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%
	String PG_TITLE = "ѺƷ��Ϣ"; 
	String serialNo = CurPage.getParameter("SerialNo");if(serialNo == null)serialNo = "";
	String vouchType = CurPage.getParameter("VouchType");if(vouchType == null)vouchType = "";
	
	ASObjectModel doTemp = new ASObjectModel("CollateralInfo");
	
	if(vouchType.startsWith("020")){
		doTemp.setColumnAttribute("SerialNo", "ColHeader", "��Ѻ���");
		doTemp.setColumnAttribute("AssetSerialNo", "ColHeader", "��Ѻ����");
		doTemp.setColumnAttribute("AssetName", "ColHeader", "��Ѻ������");
	}
	else{
		doTemp.setColumnAttribute("SerialNo", "ColHeader", "��Ѻ���");
		doTemp.setColumnAttribute("AssetSerialNo", "ColHeader", "��Ѻ����");
		doTemp.setColumnAttribute("AssetName", "ColHeader", "��Ѻ������");
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����Ϊfreeform���
	dwTemp.ReadOnly = "0"; //����Ϊֻ��

	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","All","Button","����","����","saveRecord()","","","",""},
		};
%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>

<script type="text/javascript">
	function saveRecord(){
		as_save("0",'');
	}
	

</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
