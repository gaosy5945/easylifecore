<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sDOCNO = CurPage.getParameter("SerialNo");//权限
	if(sDOCNO == null) sDOCNO = "";
	ASObjectModel doTemp = new ASObjectModel("DOCAttachmentList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sDOCNO);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增附件","新增附件","newRecord()","","","","btn_icon_add",""},
			{"true","","Button","附件详情","附件详情","viewFile()","","","","btn_icon_detail",""},
			{"true","","Button","删除附件","删除附件","deleteRecord()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function newRecord(){
	var sDocNo="<%=sDOCNO%>";
	AsControl.PopView("/RecoveryManage/Common/Document/AttachmentChooseDialog.jsp","DocNo="+sDocNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
<%@ include file="/Frame/resources/include/include_end.jspf"%>
