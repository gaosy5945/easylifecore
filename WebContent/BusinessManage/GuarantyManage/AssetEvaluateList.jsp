 <%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "ѺƷ������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	String assetSerialNo = CurPage.getParameter("AssetSerialNo");
	if(assetSerialNo == null) assetSerialNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("AssetEvaluateList");
		
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("AssetSerialNo", assetSerialNo);
	dwTemp.genHTMLObjectWindow(assetSerialNo);
	
	String sButtons[][] = {
			{"false","All","Button","��������","��������","view()","","","",""}
	};

%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	function view(){
		var serialNo=getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 