<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//获取页面参数
	String objectType = CurPage.getParameter("ObjectType");
	String userID = CurUser.getUserID();
	if(objectType == null || objectType == "undefined") objectType = "";
	if(userID == null || userID == "undefined") userID = "";
	
	ASObjectModel doTemp = new ASObjectModel("DocLibraryList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("UserID", userID);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			{"true","All","Button","上传","上传EXCEL","upLoad()","","","",""},
			{"true","","Button","文档详情","查看文档详情","viewAndEdit_attachment()","","","",""},
			{"true","All","Button","删除","删除文档信息","deleteRecord()","","","",""},
			{"true","All","Button","批量导入","批量导入","initialize()","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function upLoad(){
		AsControl.PopView("/CreditManage/CreditApply/BatchFrame.jsp","objectType=<%=objectType%>", "dialogWidth=500px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}

	function deleteRecord(){
		var inputUserID=getItemValue(0,getRow(),"InputUserID");//取文档录入人	
		var sDocNo = getItemValue(0,getRow(),"DocNo");
		if (typeof(sDocNo)=="undefined" || sDocNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else if(inputUserID=='<%=CurUser.getUserID()%>'){
			if(confirm(getHtmlMessage(2))){ //您真的想删除该信息吗？
				as_delete('myiframe0');
				as_save('myiframe0'); //如果单个删除，则要调用此语句             
			}
		}else{
			alert(getHtmlMessage('3'));
			return;
		}
	}
	<%/*~[Describe=查看及修改附件详情;]~*/%>
	function viewAndEdit_attachment(){
		var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		var sDocNo= getItemValue(0,getRow(),"DocNo");
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else{
			AsControl.PopView("/AppConfig/Document/AttachmentView.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo);
		}
	}
	function initialize(){
		var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
	    var parameter = "clazz=jbo.import.excel.CREDIT_LOAN&userId="+'<%=CurUser.getUserID()%>'+"&orgId="+'<%=CurOrg.getOrgID()%>';
	    var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
	    var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
	    reloadSelf();
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
