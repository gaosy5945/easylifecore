<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		页面说明: 用户管理列表
	 */
	String PG_TITLE = "用户管理列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获取组件参数
	String sOrgID = CurPage.getParameter("OrgID");
	if(sOrgID == null) sOrgID = "";
	String sSortNo = (new ASOrg(sOrgID, Sqlca)).getSortNo();
	if(sSortNo==null)sSortNo="";
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "UserList_1";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
    //filter过滤条件
    doTemp.setColumnAttribute("BelongOrgName,UserName,UserID","IsFilter","1");

    ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(20);
	
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sSortNo);
	
	String sButtons[][] = {
            {"true","","Button","新增","在当前机构中新增人员","my_add()","","","",""},			
            {"true","","Button","详情","查看用户详情","viewAndEdit()","","","",""},
            {"false","","Button","用户资源","查看用户授权资源","viewResources()","","","",""},
            {"true","","Button","用户角色","查看并可修改人员角色","viewAndEditRole()","","","",""},
            {"true","","Button","批量更新角色","批量更新角色","my_Addrole()","","","",""},
			{"true","","Button","多用户更新角色","多用户更新角色","MuchAddrole()","","","",""},
            {"true","","Button","转移","转移人员至其他机构","UserChange()","","","",""},                       
            {"true","","Button","初始密码","初始化该用户密码","ClearPassword()","","","",""},
        };
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function my_add(){
		OpenPage("/AppConfig/OrgUserManage/UserInfo.jsp","_self","");
	}
	
	function viewAndEdit(){
		var sUserID = getItemValue(0,getRow(),"UserID");
		if (typeof(sUserID)=="undefined" || sUserID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			OpenPage("/AppConfig/OrgUserManage/UserInfo.jsp?UserID="+sUserID,"_self","");
		}
	}
	
	/*~[Describe=查看用户授权资源;InputParam=无;OutPutParam=无;]~*/
	function viewResources(){
		var sUserID = getItemValue(0,getRow(),"UserID");
		if(typeof(sUserID)=="undefined" || sUserID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			AsControl.PopView("/AppConfig/OrgUserManage/ViewUserResources.jsp","UserID="+sUserID,"");
		}
	}

	<%/*~[Describe=查看并可修改人员角色;]~*/%>
	function viewAndEditRole(){
        var sUserID=getItemValue(0,getRow(),"UserID");
        if(typeof(sUserID)=="undefined" ||sUserID.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
        }else{
        	var sStatus=getItemValue(0,getRow(),"Status");
        	if(sStatus!="1")
        		alert(sUserID+"非正常用户，无法查看用户角色！");
        	else
            	sReturn=popComp("UserRoleList","/AppConfig/OrgUserManage/UserRoleList.jsp","UserID="+sUserID,"");
        }    
    }
    
    <%/*~[Describe=批量更新角色;]~*/%>    
    function my_Addrole(){
	    var sUserID=getItemValue(0,getRow(),"UserID");
 		if(typeof(sUserID)=="undefined" ||sUserID.length==0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
    	}else{
        	var sStatus=getItemValue(0,getRow(),"Status");
        	if(sStatus!="1")
        		alert(sUserID+"非正常用户，无法批量更新角色！");
        	else
        		PopPage("/AppConfig/OrgUserManage/AddUserRole.jsp?UserID="+sUserID,"","dialogWidth=550px;dialogHeight=350px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
    	}
	}
	
	<%/*~[Describe=多用户更新角色;]~*/%>
	function MuchAddrole(){
		var sUserID=getItemValue(0,getRow(),"UserID");
 		if(typeof(sUserID)=="undefined" ||sUserID.length==0){ 
		    alert(getHtmlMessage('1'));//请选择一条信息！
    	}else{
    		var sStatus=getItemValue(0,getRow(),"Status");
        	if(sStatus!="1")
        		alert(sUserID+"非正常用户，无法多用户更新角色！");
        	else
        		PopPage("/AppConfig/OrgUserManage/AddMuchUserRole.jsp?UserID="+sUserID,"","dialogWidth=550px;dialogHeight=600px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
		}
	}

	<%/*~[Describe=转移人员至其他机构;]~*/%>
	function UserChange(){
        var sUserID = getItemValue(0,getRow(),"UserID");
        var sFromOrgID = getItemValue(0,getRow(),"BelongOrg");
        var sFromOrgName = getItemValue(0,getRow(),"BelongOrgName");
        if(typeof(sUserID)=="undefined" ||sUserID.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
        }else{
            //获取当前用户
			sOrgID = "<%=CurOrg.getOrgID()%>";
			sParaStr = "OrgID,"+sOrgID;
			sOrgInfo = setObjectValue("SelectBelongOrg",sParaStr,"",0,0);	
		    if(sOrgInfo == "" || sOrgInfo == "_CANCEL_" || sOrgInfo == "_NONE_" || sOrgInfo == "_CLEAR_" || typeof(sOrgInfo) == "undefined"){
			    if( typeof(sOrgInfo) != "undefined"&&sOrgInfo != "_CLEAR_")alert(getBusinessMessage('953'));//请选择转移后的机构！
			    return;
		    }else{
			    sOrgInfo = sOrgInfo.split('@');
			    sToOrgID = sOrgInfo[0];
			    sToOrgName = sOrgInfo[1];
			    
			    if(sFromOrgID == sToOrgID){
					alert(getBusinessMessage('954'));//不允许人员转移在同一机构中进行，请重新选择转移后机构！
					return;
				}
				//调用页面更新
				sReturn = AsControl.RunJsp("/AppConfig/OrgUserManage/UserShiftActionAjax.jsp","UserID="+sUserID+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&ToOrgID="+sToOrgID+"&ToOrgName="+sToOrgName); 
				if(sReturn == "TRUE"){
	                alert(getBusinessMessage("914"));//人员转移成功！
	                reloadSelf();           	
	            }else if(sReturn == "FALSE"){
	                alert(getBusinessMessage("915"));//人员转移失败！
	            }
			}
		}
	}
	
	<%/*~[Describe=引入人员至当前机构;]~*/%>
	function my_import(){
       sParaString = "BelongOrg"+","+"<%=sOrgID%>";		
		sUserInfo = setObjectValue("SelectImportUser",sParaString,"",0,0,"");
		if(typeof(sUserInfo) != "undefined" && sUserInfo != "" && sUserInfo != "_NONE_" && sUserInfo != "_CANCEL_" && sUserInfo != "_CLEAR_"){
       		sInfo = sUserInfo.split("@");
	        sUserID = sInfo[0];
	        sUserName = sInfo[1];
	        if(typeof(sUserID) != "undefined" && sUserID != ""){
	        	if(confirm(getBusinessMessage("912"))){ //您确定将所选人员引入到本机构中吗？
        			var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.orguser.action.UserManageAction","addUser","UserID="+sUserID+",OrgID=<%=sOrgID%>");
					if(sReturn == "SUCCESS"){
		        		alert(getBusinessMessage("913"));//人员引入成功！
		        		reloadSelf();
	        		}
	        	}else{
	        		alert("人员转移失败!");
	        	}
	        }
       	}
	}

	<%/*~[Describe=从当前机构中删除该人员;]~*/%>
	function my_disable(){
		var sUserID = getItemValue(0,getRow(),"UserID");
		if(typeof(sUserID) == "undefined" || sUserID.length == 0){
			alert(getMessageText('AWEW1001'));//请选择一条信息！
		}else if(confirm("您真的想停用该用户吗？")){
            var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.orguser.action.UserManageAction","disableUser","UserID="+sUserID);
            if(sReturn == "SUCCESS"){
			    alert("信息停用成功！");
			    reloadSelf();
			}
		}
	}

	<%/*~[Describe=启用用户;]~*/%>
	function my_enable(){
		var sUserID = getItemValue(0,getRow(),"UserID");
		if(typeof(sUserID) == "undefined" || sUserID.length == 0){
			alert(getMessageText('AWEW1001'));//请选择一条信息！
		}else if(confirm("您真的想启用该用户吗？")){
            var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.orguser.action.UserManageAction","enableUser","UserID="+sUserID);
            if(sReturn == "SUCCESS"){
			    alert("信息启用成功！");
			    reloadSelf();
			}
		}
	}
	
	<%/*~[Describe=初始化用户密码;]~*/%>
	function ClearPassword(){
        var sUserID = getItemValue(0,getRow(),"UserID");
        var sInitPwd = "000000als";
        if (typeof(sUserID)=="undefined" || sUserID.length==0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getBusinessMessage("916"))){ //您确定要初始化该用户的密码吗？
		    var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.orguser.action.ClearPasswordAction","initPWD","UserID="+sUserID+",InitPwd="+sInitPwd);
			if(sReturn == "SUCCESS"){
			    alert(getBusinessMessage("917"));//用户密码初始化成功！
			    reloadSelf();
			}else{
				alert("用户密码初始化成功！");
			}
		}
	}
	
	function queryUser()
	{
		var userID = getItemValue(0,getRow(),"UserID");
        if(typeof(userID)=="undefined" || userID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.oci.user.UserSync","sync","UserID="+userID);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0) return;
		alert(returnValue.split("@")[1]);
		reloadSelf();
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>