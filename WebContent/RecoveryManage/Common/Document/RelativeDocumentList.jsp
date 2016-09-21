<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//获得组件参数
	String sObjectTable = CurPage.getParameter("ObjectTable");
	if(sObjectTable == null) sObjectTable = "";
	String sLISerialNo = CurPage.getParameter("SerialNo");
	if(sLISerialNo == null) sLISerialNo = "";

	ASObjectModel doTemp = new ASObjectModel("RelativeDocumentList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sObjectTable+","+sLISerialNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","addDocument()","","","","btn_icon_add",""},
			{"true","","Button","文档详情","文档详情","editDocument()","","","","btn_icon_detail",""},
			{"false","All","Button","上传附件","上传附件","uploadAttachment()","","","","btn_icon_add",""},
			{"false","","Button","附件详情","附件详情","viewAttachment()","","","","btn_icon_detail",""},
			{"true","All","Button","删除","删除","deleteRecord()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function addDocument(){
		 var sUrl = "/RecoveryManage/Common/Document/RelativeDocumentInfo.jsp";
		 AsControl.PopComp(sUrl, '', '');
		 reloadSelf();
	}
	function editDocument(){
		 var sUrl = "/RecoveryManage/Common/Document/RelativeDocumentInfo.jsp";
		 var sPara = getItemValue(0,getRow(0),'DOCNO');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		AsControl.PopComp(sUrl,'DOCNO=' +sPara ,'');
		reloadSelf();
	}
	function uploadAttachment(){
		viewAttachment();
	}
	function viewAttachment(){
		var sDocNo=getItemValue(0,getRow(),"DocNo");
    	var sUrl = "/RecoveryManage/Common/Document/AttachmentList.jsp";
    	if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
    	{        
        	alert(getHtmlMessage(1));  //请选择一条记录！
			return;         
    	}
    	else
    	{
    		//popComp("AttachmentList","/RecoveryManage/Common/Document/AttachmentList.jsp","DocNo="+sDocNo+"&UserID="+sUserID+"&RightType="+sRightType);
    		AsControl.PopComp(sUrl,'SerialNo=' +sDocNo ,'');
    		reloadSelf();
      	}
    	
	}
	function deleteRecord(){
		if(confirm('确实要删除吗?'))as_delete(0,'alert("删除成功！")');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
