<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("RiskWarningQueryIndustry");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","","Button","Ԥ���ź��б�","����","edit()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

function edit(){
		 var sUrl = "/BusinessManage/RiskWarningManage/RiskWarningSignalList.jsp";
		 var sPara = getItemValue(0,getRow(0),'INDUSTRYTYPE');
		 var slevel = getItemValue(0,getRow(0),'SIGNALLEVEL');
		
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.PopComp(sUrl,'industrytype='+sPara+'&signallevel='+slevel, "");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
