<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	String sDOCNO = CurPage.getParameter("DOCNO");
	if(sDOCNO == null) sDOCNO = "";

	String sTempletNo = "RelativeDocumentInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sDOCNO);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"true","All","Button","查看/修改附件","查看/修改选中文档相关的所有附件","viewAndEdit_attachment()","","","",""},
		{"true","","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		self.close();
	}

	<%/*~[Describe=查看附件详情;]~*/%>
	function viewAndEdit_attachment(){
		
		/* if(!iV_all(0)){
			alert("请先保存数据！");
			return;
		} 
		if(as_isPageChanged()){
			alert("提交前请先保存数据！");
			return;
		} */
		var sDOCNO = getItemValue(0,getRow(),'DOCNO');
		var sSql = "select count(DOCNO) from DOC_LIBRARY dl where dl.docno='"+sDOCNO+"'";
		var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
		if(sReturnValue>0){
			var sDocNo = getItemValue(0,getRow(),"DocNo");
			var sUserID = getItemValue(0,getRow(),"UserID");//取录入人ID
			var sRightType="<%=CurPage.getParameter("RightType")%>";
			if (typeof(sDocNo)=="undefined" || sDocNo.length==0){
	        	alert("请先保存文档内容，再上传附件！");  //请选择一条记录！
				return;
	    	}else{
	    		//popComp("AttachmentList","/AppConfig/Document/AttachmentList.jsp","DocNo="+sDocNo+"&UserID="+sUserID+"&RightType="+sRightType);
				AsControl.PopView("/RecoveryManage/Common/Document/AttachmentFrame.jsp", "DocNo="+sDocNo+"&UserID="+sUserID+"&RightType="+sRightType, "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    		reloadSelf();
			}
		}else{
			alert("请先保存数据！");
			return;
		} 
		
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
