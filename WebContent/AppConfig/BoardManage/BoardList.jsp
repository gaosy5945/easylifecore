<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		页面说明: 公告列表
	 */
	String rightType = CurPage.getParameter("RightType");
 	if(rightType == null) rightType = "";
 	ASObjectModel doTemp = new ASObjectModel("BoardList");
 	if("ReadOnly".equals(rightType)){
	 	doTemp.setJboWhere("IsPublish = '1'");
 	}
 	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
 	
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		{"true","All","Button","新增公告","新增公告","my_add()","","","",""},
		{"true","All","Button","删除公告","删除公告","my_del()","","","",""},
		{"true","","Button","公告详情","查看公告详情","my_detail()","","","",""},
		//{"true","","Button","公告附件","查看公告附件","DocDetail()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function my_add(){
		//AsControl.PopComp("/AppConfig/BoardManage/BoardUpDown.jsp","","dialogWidth=700px;dialogHeight=700px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		AsControl.PopComp("/AppConfig/BoardManage/BoardDetailInfo.jsp","", "dialogWidth=700px;dialogHeight=700px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	function my_detail(){
		var sBoardNo = getItemValue(0,getRow(),"BoardNo");
		if (typeof(sBoardNo)=="undefined" || sBoardNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var sDocNo = getItemValue(0,getRow(),"docNo");
		//AsControl.PopComp("/AppConfig/BoardManage/BoardDetailInfo.jsp","BoardNo="+sBoardNo,"rightdown","");
		AsControl.PopComp("/AppConfig/BoardManage/BoardDetailInfo.jsp","RightType=<%=rightType%>&BoardNo="+sBoardNo+"&DocNo="+sDocNo, "dialogWidth=700px;dialogHeight=700px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	
	}
	
	<%/*[Describe=查看公告附件;]*/%>
	/* function DocDetail(){
		
		var sDocNo = getItemValue(0,getRow(),"DocNo");
		if(typeof(sDocNo)=="undefined" || sDocNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//AsControl.OpenView("/AppConfig/Document/AttachmentList.jsp","DocNo="+sDocNo,"rightdown","");
		AsControl.PopView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo, "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	} */
	
	function my_del(){
		var sBoardNo = getItemValue(0,getRow(),"BoardNo");
		if (typeof(sBoardNo)=="undefined" || sBoardNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('2'))){ //您真的想删除该信息吗？
			as_delete('myiframe0');
		}
	}

	<%/*~[Describe=单击事件;]~*/%>
	
</script>
<%@	include file="/Frame/resources/include/include_end.jspf"%>