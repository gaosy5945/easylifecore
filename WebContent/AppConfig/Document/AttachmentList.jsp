<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		页面说明:文档附件列表
	 */
	//获得组件参数
	String sDocNo = CurPage.getParameter("DocNo");
	String sUserID = CurPage.getParameter("UserID");
	if(sDocNo == null) sDocNo = "";
	if(sUserID == null) sUserID = "";

	ASObjectModel doTemp = new ASObjectModel("AttachmentList");
	doTemp.setHtmlEvent("AttachmentNo,FileName,BeginTime,EndTime,ContentType,ContentLength", "ondblclick", "viewFile");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage ,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(25);//25条一分页
	dwTemp.genHTMLObjectWindow(sDocNo);
	
	String sButtons[][] = {
//		{(CurUser.getUserID().equals(sUserID)?"true":"false"),"","Button","新增","新增附件","newRecord()","","","",""},
//		{"true","","Button","查看内容","查看附件内容","viewFile()","","","",""},
//		{(CurUser.getUserID().equals(sUserID)?"true":"false"),"","Button","删除","删除文档信息","deleteRecord()","","","",""},
		};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		var sDocNo="<%=sDocNo%>";
		AsControl.PopView("/AppConfig/Document/AttachmentChooseDialog.jsp","DocNo="+sDocNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}

	function deleteRecord(){
		var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else{
			if(confirm(getHtmlMessage(2))){ //您真的想删除该信息吗？
        		as_delete('myiframe0');
    		}
		}
	}

	<%/*~[Describe=查看及修改详情;]~*/%>
	function viewFile(){
		var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		var sDocNo= getItemValue(0,getRow(),"DocNo");
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else{
			AsControl.OpenPage("/AppConfig/Document/AttachmentView.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo);
		}
	}
	
	// 附件下载功能
	function exportFile(){
		var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		var sDocNo= getItemValue(0,getRow(),"DocNo");
		if (sAttachmentNo =="undefined"||sAttachmentNo.length == 0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else{
			// http 方式
			//AsControl.PopView("/AppConfig/Document/AttachmentDownload.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo,"");
			// servlet 方式
			AsControl.PopView("/AppConfig/Document/AttachmentView.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo+"&ViewType=save");
		}
	}
</script>
<%@	include file="/Frame/resources/include/include_end.jspf"%>