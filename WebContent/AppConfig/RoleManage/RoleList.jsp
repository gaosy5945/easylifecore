<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%><%
	String PG_TITLE = "角色列表";

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "RoleList";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);

	//增加过滤器	
	doTemp.setColumnAttribute("RoleID,RoleName","IsFilter","1");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增角色","新增一种角色","newRecord()","","","",""},
		{"true","","Button","详情","查看角色情况","viewAndEdit()","","","",""},
		{"true","","Button","删除","删除该角色","deleteRecord()","","","",""},
		{"true","","Button","角色下用户","查看该角色所有用户","viewUser()","","","",""},
		{"true","","Button","系统权限","系统权限定义","my_AddMenu()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("RoleInfo","/AppConfig/RoleManage/RoleInfo.jsp","","");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0) {
			reloadSelf();
		}
	}
	
	function viewAndEdit(){
		var sRoleID = getItemValue(0,getRow(),"RoleID");
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
	
		sReturn=popComp("RoleInfo","/AppConfig/RoleManage/RoleInfo.jsp","RoleID="+sRoleID,"");
		//修改数据后刷新列表
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			reloadSelf();
		}
	}
	
	function deleteRecord(){
		var sRoleID = getItemValue(0,getRow(),"RoleID");
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getBusinessMessage("902"))){ //删除该角色的同时将删除该角色对应的权限，确定删除该角色吗？
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	<%/*~[Describe=给角色授权主菜单;]~*/%>
	function my_AddMenu(){
		var sRoleID = getItemValue(0,getRow(),"RoleID");
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		AsControl.OpenComp("/AppConfig/RoleManage/RoleRightTree.jsp","RoleID="+sRoleID,"_blank","");
	}
	
	<%/*[Describe=查看该角色所有用户;]*/%>
	function viewUser(){
		var sRoleID = getItemValue(0,getRow(),"RoleID");
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0){
			alert(getMessageText('AWEW1001'));//请选择一条信息！
			return;
		}
		PopPage("/AppConfig/RoleManage/ViewAllUserList.jsp?RoleID="+sRoleID,"","dialogWidth=700px;dialogHeight=540px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
	}
	
	function queryRole()
	{
		var roleID = getItemValue(0,getRow(),"RoleID");
        if(typeof(roleID)=="undefined" || roleID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.oci.role.RoleSync","sync","RoleID="+roleID);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0) return;
		alert(returnValue.split("@")[1]);
		reloadSelf();
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>