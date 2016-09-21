<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	/*
		页面说明: 资料扫描资料列表
	 */
	String PG_TITLE = "资料列表";
	
 	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	if(objectNo == null) objectNo = "";
	if(objectType == null) objectType = "";
	
	//通过DW模型产生ASDataObject对象doTemp
	ASObjectModel doTemp = new ASObjectModel("ApplyDocList","");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage ,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	<%/*记录被选中时触发事件*/%>
	function mySelectRow(){
		var fileID = getItemValue(0,getRow(),"FileID");
		if(typeof(fileID)=="undefined" || fileID.length==0) {
			AsControl.OpenView("/ImageManage/ImagePage.jsp","","frameleft","");
			//TextToShow=请先选择相应的信息!
		}else{
			AsControl.OpenView("/ImageManage/ImagePage.jsp","","frameleft","");
		}
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>