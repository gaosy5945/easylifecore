<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("RiskWarningOrgList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","","Button","Ԥ���ͻ��б�","����","edit()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

function edit(){
	
	 var sUrl = "BusinessManage/RiskWarningManage/RiskWarningCustomerInfo.jsp";
	 var  cstrisklevel= getItemValue(0,getRow(0),'cstrisklevel');
	 var  inputorgid = getItemValue(0,getRow(0),'INPUTORGID');
	 if(typeof(inputorgid)=="undefined" || inputorgid.length==0 ){
		alert("��������Ϊ�գ�");
		return ;
	 }
	 AsControl.PopComp(sUrl,"cstrisklevel="+cstrisklevel+"&inputorgid="+inputorgid,"resizable=yes;dialogWidth=1200px;dialogHeight=1200px;center:yes;status:no;statusbar:no");
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
