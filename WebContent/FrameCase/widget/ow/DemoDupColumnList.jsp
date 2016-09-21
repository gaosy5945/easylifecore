<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
 	/*有重名字段（ColActualName相同）的List案例*/
	ASObjectModel doTemp = new ASObjectModel("DemoEntList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";		//--设置为Grid风格--
	dwTemp.ReadOnly = "0";	//只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","","btn_icon_save"},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function mySelectRow(){
		alert("第"+(getRow()+1)+"行的CI客户编号："+getItemValue(0,getRow(),"V.CUSTOMERID1")+",EI客户编号："+getItemValue(0,getRow(),"CUSTOMERID"));
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
