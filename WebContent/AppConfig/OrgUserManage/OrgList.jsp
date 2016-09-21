<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		页面说明: 机构管理列表
	 */
	String PG_TITLE = "机构管理列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获取组件参数
	String sOrgID = CurPage.getParameter("OrgID");
	if(sOrgID == null) sOrgID = "";
	String sSortNo = (new ASOrg(sOrgID, Sqlca)).getSortNo();
	if(sSortNo==null)sSortNo="";

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "OrgList";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
    //增加过滤器	
	doTemp.setColumnAttribute("OrgID,OrgName","IsFilter","1");
	    
    ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(200);

	//定义后续事件
	//dwTemp.setEvent("AfterDelete","!SystemManage.DeleteOrgBelong(#OrgID)");
	
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sSortNo+"%");

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()","","","",""},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()","","","",""},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""},
		{"true","","Button","初始化机构权限","初始化机构权限","initialOrgBelong()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
        OpenPage("/AppConfig/OrgUserManage/OrgInfo.jsp","_self","");            
	}
	
	function viewAndEdit(){
        var sOrgID = getItemValue(0,getRow(),"OrgID");
        if(typeof(sOrgID)=="undefined" || sOrgID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		OpenPage("/AppConfig/OrgUserManage/OrgInfo.jsp?CurOrgID="+sOrgID,"_self","");        
	}
    
	/*~[Describe=初始化机构权限;InputParam=无;OutPutParam=无;]~*/
	function initialOrgBelong(){
		if(confirm("你确定初始化机构权限吗？")){
			var returnValue = PopPage("/AppConfig/OrgUserManage/InitialOrgBelongAction.jsp","","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
			if("true"==returnValue)
			{
				alert("初始化机构权限成功！") ;
			}else{
				alert("初始化机构权限失败！") ;
			}
		}
	}
	
	function deleteRecord(){
		var sOrgID = getItemValue(0,getRow(),"OrgID");
        if(typeof(sOrgID) == "undefined" || sOrgID.length == 0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))){ //您真的想删除该信息吗？
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			if(parent.reloadView){
				parent.reloadView();
			}
		}
	}
	
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>