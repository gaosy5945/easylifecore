<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String listType = CurPage.getParameter("ListType");
	if(listType == null) listType = "";
	String importTemplet = CurPage.getParameter("ImportTemplet");
	if(importTemplet == null) importTemplet = "";

	ASObjectModel doTemp = new ASObjectModel("CadReList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.MultiSelect = true; //允许多选
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.genHTMLObjectWindow(listType);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","All","Button","详情","详情","viewAndEdit()","","","","",""},
			{"true","All","Button","批量导入","批量导入","importData()","","","","",""},
			{"true","All","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'')","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script><script type="text/javascript">
	function add(){
		var listType = "<%=listType%>";
    	OpenPage("/CustomerManage/SpecialCustomerManage/CadReInfo.jsp?listType="+listType,"_self","");
		reloadSelf();
	}
	function viewAndEdit(){
		var serialNo = getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert("请选择一条信息！");
			return;
		}
		OpenPage("/CustomerManage/SpecialCustomerManage/CadReInfo.jsp?SerialNo="+serialNo,"_self","");
		reloadSelf();
	}
	
	function importData(){
	    var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
	    var parameter = "clazz=jbo.import.excel.CADRE_IMPORT";
	    var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
	    var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
	    reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
