<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	String PG_TITLE = "显示模板库信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String sDONO = CurPage.getParameter("DONO");
	if(sDONO == null) sDONO = "";
	
	ASObjectModel doTemp = new ASObjectModel("DataObjectLibraryList");
	doTemp.setLockCount(2); //锁定两列
	doTemp.setDDDWJbo("DOCKID", "jbo.awe.DATAOBJECT_GROUP,DockID,DockName,DONO='"+sDONO+"' order by SortNo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sDONO);

	String sButtons[][] = {
		{"true", "All","Button","快速新增","当前页面新增","afterAdd()","","","","btn_icon_add"},
		{"true", "All","Button","快速保存","快速保存当前页面","afterSave()","","","","btn_icon_save"},
		{"true", "All","Button","快速复制","快速复制当前记录","quickCopy()","","","",""},
		{"true", "All", "Button", "删除", "", "deleteRecord()", "", "", "", ""},
		{"true", "All", "Button", "配置信息分组", "配置信息分组", "setGroup()", "", "", "", "btn_icon_edit"},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	var sDONO = "<%=sDONO%>";
	function afterSave(){
		as_save("myiframe0");
	}
	//快速新增
	function afterAdd(){
		as_add("myiframe0");
		//快速新增时候给定默认值
		setItemValue(0,getRow(),"DONO",sDONO);
	}
	function quickCopy(){
		var sColIndex = getItemValue(0,getRow(),"COLINDEX");
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.awe.config.dw.action.DataObjectLibListAction","quickCopyLib","DONO="+sDONO+",ColIndex="+sColIndex);
		if(returnValue == 'SUCCESS'){
			alert('复制成功！');
			reloadSelf();
		}else alert('对不起，复制失败！');
	}
	//快速删除
	function deleteRecord(){
		var sColIndex = getItemValue(0,getRow(),"COLINDEX");
		if (typeof(sColIndex)=="undefined" || sColIndex.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage("2"))){ //您真的想删除该信息吗？
			as_delete("myiframe0");
		}
	}

	function setGroup(){
		AsControl.PopView("/AppConfig/PageMode/DWConfig/DataObjectGroupList.jsp","DONo="+sDONO);
	}
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>