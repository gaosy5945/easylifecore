<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("PubEdocConfigList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增模板","新增","add()","","","","",""},
			{"true","","Button","模板详情","详情","edit()","","","","",""},
			{"true","","Button","删除模板","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","","",""},
			{"true","","Button","格式文件上传","格式文件上传","upLoadform()","","","","",""},
			{"true","","Button","查看格式文件","查看格式文件","formedit(1)","","","","",""},
			{"true","","Button","数据文件上传","数据文件上传","upLoaddata()","","","","",""},
			{"true","","Button","查看数据文件","查看数据文件","formedit(0)","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 AsControl.PopView("/Common/Configurator/FlowManage/PubEdocConfigInfo.jsp",'','_self','');
		 reloadSelf();
	}
	function edit(){
		 var edocNo = getItemValue(0,getRow(0),'EdocNo');
		 if(typeof(edocNo)=="undefined" || edocNo.length==0 ){
			alert("请选择一条记录！");
			return ;
		 }
		AsControl.PopView("/Common/Configurator/FlowManage/PubEdocConfigEditInfo.jsp",'EdocNo=' +edocNo ,'dialogWidth=800px;dialogHeight=400px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;','');
	}
	function upLoadform(){
		var edocNo = getItemValue(0,getRow(0),'EdocNo');
		if(typeof(edocNo)=="undefined" || edocNo.length==0){
				alert("请选择一条记录！");
				return ;
			 }
		AsControl.PopView("/Common/Configurator/FlowManage/PubEdocUploadForm.jsp","EdocNo="+edocNo,"_self","");
		reloadSelf();
	}
	
	function formedit(flag){
		var sAttachmentNo = getItemValue(0,getRow(),"EdocName");
		var sDocNo= getItemValue(0,getRow(),"EdocNo");
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else{
			AsControl.PopView("/Common/Configurator/FlowManage/PubEDocView.jsp","EDocNo="+sDocNo+"&Flag="+flag);
		}
	}
	
	function upLoaddata(){
		var edocNo = getItemValue(0,getRow(0),'EdocNo');
		if(typeof(edocNo)=="undefined" || edocNo.length==0){
				alert("请选择一条记录！");
				return ;
			 }
		AsControl.PopView("/Common/Configurator/FlowManage/PubEdocUploadData.jsp","EdocNo="+edocNo,"_self","");
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
