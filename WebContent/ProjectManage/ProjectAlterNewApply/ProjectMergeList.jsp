<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("ProjectMergeList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.MultiSelect = true; //允许多选
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","","Button","获取贷款业务明细","获取贷款业务明细","getChecked()","","","",""},
			{"true","","Button","确定","确定","confirm()","","","",""},
			{"true","","Button","取消","取消","cancel()","","","",""},
			{"true","","Button","提交","提交","submit()","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function getChecked(){
		var arr = getCheckedRows(0);
		var SerialNos = "''";
		for(var i=0;i<arr.length;i++){
			SerialNos = "'"+getItemValue(0,i,"SERIALNO")+"'"+","+SerialNos;
		}
		//展示贷款页面明细
		AsControl.OpenView("/ProjectManage/ProjectAlterNewApply/ProjectMergeCreditList.jsp", "SerialNos="+SerialNos, "rightdown", "");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
