<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("RiskWarningQueryIndustry");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","","Button","预警信号列表","详情","edit()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

function edit(){
		 var sUrl = "/BusinessManage/RiskWarningManage/RiskWarningSignalList.jsp";
		 var sPara = getItemValue(0,getRow(0),'INDUSTRYTYPE');
		 var slevel = getItemValue(0,getRow(0),'SIGNALLEVEL');
		
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		AsControl.PopComp(sUrl,'industrytype='+sPara+'&signallevel='+slevel, "");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
