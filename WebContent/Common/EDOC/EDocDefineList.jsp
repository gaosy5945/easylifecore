<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("EdocDefinelist");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	 //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","newRecord()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","","Button","删除","删除","deleteRecord()","","","","btn_icon_delete",""},
			{"true","","Button","格式文件上传","格式文件上传","TemplateUploadFmt()","","","","",""},			
			{"true","","Button","数据定义文件上传","数据定义文件上传","TemplateUploadDef()","","","","",""},
			{"true","","Button","查看格式文件","查看格式文件","TemplateViewFmt()","","","","",""},			
			{"true","","Button","查看数据定义文件","查看数据定义文件","TemplateViewDef()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
function newRecord(){
	AsControl.OpenPage("/Common/EDOC/EDocDefineInfo.jsp","","_self");
    reloadSelf();
}

/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
function viewAndEdit(){
    var edocNo = getItemValue(0,getRow(),"EDocNo");
    if(typeof(edocNo)=="undefined" || edocNo.length==0) {
		alert(getHtmlMessage('1'));//请选择一条信息！
        return ;
	}
    AsControl.OpenPage("/Common/EDOC/EDocDefineInfo.jsp","EDocNo="+edocNo,"_self");
    reloadSelf();
}

/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
function deleteRecord(){
	var edocNo = getItemValue(0,getRow(),"EDocNo");
    if(typeof(edocNo)=="undefined" || edocNo.length==0) {
		alert(getHtmlMessage('1'));//请选择一条信息！
        return ;
	}
	
	// 	var printNum = RunJavaMethodTrans("com.amarsoft.app.edoc.SelectEDocDefine","selectEDocDefine","docNo="+edocNo);
	var printNum = RunJavaMethodTrans("com.amarsoft.app.bizmethod.BusinessManage","selectEDocDefine","paras=docNo@@"+edocNo);
	printNum = parseInt(printNum);
	if(printNum > 0){
		alert('该模板已生成电子合同，不能删除！');
	}else{
		if(confirm("确定要删除该模板吗？")) 
			as_delete(0);
	}
}

/*~[Describe=格式文件上传;InputParam=无;OutPutParam=无;]~*/
function TemplateUploadFmt(){
	var edocNo = getItemValue(0,getRow(),"EDocNo");
    if(typeof(edocNo)=="undefined" || edocNo.length==0) {
		alert(getHtmlMessage('1'));//请选择一条信息！
        return;
	}
    
	var fileName = getItemValue(0,getRow(),"FileNameFmt");//模板文件名称
    if(typeof(fileName)!="undefined" &&  fileName.length!=0) {
		if(!confirm("电子文档格式文件已经存在，确定要覆盖上传吗？"))
		    return;
	}
	popComp("TemplateChooseDialog","/Common/EDOC/TemplateChooseDialog.jsp","EDocNo="+edocNo+"&DocType=Fmt","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	reloadSelf();
}

/*~[Describe=数据定义文件上传;InputParam=无;OutPutParam=无;]~*/
function TemplateUploadDef(){
	var edocNo = getItemValue(0,getRow(),"EDocNo");
    if(typeof(edocNo)=="undefined" || edocNo.length==0) {
		alert(getHtmlMessage('1'));//请选择一条信息！
        return ;
	}
    
	var fileName = getItemValue(0,getRow(),"FileNameDef");//模板文件名称
    if(typeof(fileName)!="undefined" &&  fileName.length!=0) {
		if(!confirm("电子文档数据定义文件已经存在，确定要覆盖上传吗？"))
		    return;
	}
	popComp("TemplateChooseDialog","/Common/EDOC/TemplateChooseDialog.jsp","EDocNo="+edocNo+"&DocType=Def","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	reloadSelf();
}

function TemplateViewFmt(){
	var edocNo = getItemValue(0,getRow(),"EDocNo");
    if(typeof(edocNo)=="undefined" || edocNo.length==0) {
		alert(getHtmlMessage('1'));//请选择一条信息！
        return ;
	}
	
	var fileName = getItemValue(0,getRow(),"FileNameFmt");//--格式文件
    if(typeof(fileName)=="undefined" || fileName.length==0) {
		alert("文件未上传！");//请选择一条信息！
        return ;
	}
	popComp("TemplateView","/Common/EDOC/TemplateView.jsp","EDocNo="+edocNo+"&EDocType=Fmt");
}

/*~[Describe=定义文件查看;InputParam=无;OutPutParam=无;]~*/
function TemplateViewDef(){//alert("developing...");return;
	var edocNo = getItemValue(0,getRow(),"EDocNo");//--永久类型编号
    if(typeof(edocNo)=="undefined" || edocNo.length==0) {
		alert(getHtmlMessage('1'));//请选择一条信息！
        return;
	}
	
	var fileName = getItemValue(0,getRow(),"FileNameDef");//--格式文件
    if(typeof(fileName)=="undefined" || fileName.length==0) {
		alert("文件未上传！");//请选择一条信息！
        return ;
	}
	popComp("TemplateView","/Common/EDOC/TemplateView.jsp","EDocNo="+edocNo+"&EDocType=Def");
}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>