<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		页面说明:文档信息列表
		Input Param:
       		    ObjectNo: 对象编号
       		    ObjectType: 对象类型           		
	 */
	String PG_TITLE = "文档信息列表";
	//定义变量                     
	String sObjectNo = "";//--对象编号
	
	//获得组件参数
	String sObjectType = CurPage.getParameter("ObjectType");
	String sRightType = CurPage.getParameter("RightType");//权限
	if(sObjectType == null) sObjectType = "";
	if(sRightType == null) sRightType = "";
	if(sObjectType.equals("Customer"))
	 	sObjectNo = CurPage.getParameter("CustomerID");
	else
		sObjectNo = CurPage.getParameter("ObjectNo");
	if(sObjectNo == null) sObjectNo = "";

	if(sObjectType.equals("Other")) //其他文档
		sObjectType = "ClassifyCreditLineApplyPutOutApplyReserveSMEApplyTransformApply";
	
	ASObjectModel doTemp = new ASObjectModel("DocumentList");
	//根据对象编号进行查询
	//已在模板中控制，此处不需要重复控制
	//生成查询条件

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(25);
	
	//删除相应的物理文件;DelDocFile(表名,where语句)
	//dwTemp.setEvent("BeforeDelete","!DocumentManage.DelDocFile(DOC_ATTACHMENT,DocNo='#DocNo')");
	//dwTemp.setEvent("AfterDelete","!DocumentManage.DelDocRelative(#DocNo)");

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","All","Button","新增","新增文档信息","newRecord()","","","",""},
		{"true","All","Button","删除","删除文档信息","deleteRecord()","","","",""},
		{"true","","Button","文档详情","查看文档详情","viewAndEdit_doc()","","","",""},
		{"true","","Button","附件详情","查看附件详情","viewAndEdit_attachment()","","","",""},
		{"false","","Button","导出附件","导出附件文档信息","exportFile()","","","",""},
	};
	if(sObjectNo.equals("")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
	}
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		OpenPage("/AppConfig/Document/DocumentInfo.jsp?UserID="+"<%=CurUser.getUserID()%>","_self","");
	}

	function deleteRecord(){
		var sUserID=getItemValue(0,getRow(),"UserID");//取文档录入人	
		var sDocNo = getItemValue(0,getRow(),"DocNo");
		if (typeof(sDocNo)=="undefined" || sDocNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else if(sUserID=='<%=CurUser.getUserID()%>'){
			if(confirm(getHtmlMessage(2))){ //您真的想删除该信息吗？
				as_del('myiframe0');
				as_save('myiframe0'); //如果单个删除，则要调用此语句             
			}
		}else{
			alert(getHtmlMessage('3'));
			return;
		}
	}

	<%/*~[Describe=查看及修改详情;]~*/%>
	function viewAndEdit_doc(){
		var sDocNo=getItemValue(0,getRow(),"DocNo");
		var sUserID=getItemValue(0,getRow(),"UserID");//取文档录入人		     	
    	if (typeof(sDocNo)=="undefined" || sDocNo.length==0){
        	alert(getHtmlMessage(1));  //请选择一条记录！
			return;
    	}else{
    		OpenPage("/AppConfig/Document/DocumentInfo.jsp?DocNo="+sDocNo+"&UserID="+sUserID,"_self","");
        }
	}
	
	<%/*~[Describe=查看及修改附件详情;]~*/%>
	function viewAndEdit_attachment(){
    	var sDocNo=getItemValue(0,getRow(),"DocNo");
    	var sUserID=getItemValue(0,getRow(),"UserID");//取文档录入人
    	var sRightType="<%=sRightType%>";
    	if (typeof(sDocNo)=="undefined" || sDocNo.length==0){
        	alert(getHtmlMessage(1));  //请选择一条记录！
			return;         
    	}else{
    		//popComp("AttachmentList","/AppConfig/Document/AttachmentList.jsp","DocNo="+sDocNo+"&UserID="+sUserID+"&RightType="+sRightType);
    		AsControl.PopView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo+"&UserID="+sUserID+"&RightType="+sRightType, "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    		reloadSelf();
      	}
	}
	
	<%/*~[Describe=导出附件;]~*/%>
	function exportFile(){
    	OpenPage("/AppConfig/Document/ExportFile.jsp","_self","");
	}

	my_load(2,0,'myiframe0');
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>