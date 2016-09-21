<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	//定义变量
	String sCurBranchOrg=""; //当前用户所在分行
	String sUserID =CurUser.getUserID();
	String sOrgID=CurUser.getOrgID();
	String sCurBranchSortNo = ""; //当前用户所在分行的SortNo
	String sTempletNo = "";//模板
	String sRight="All";
	String sRoleID="";

	//获得组件参数    ：客户类型
	String sCustomerType = CurComp.getParameter("CustomerType");
	if(sCustomerType == null) sCustomerType = "";

	String hasRole016 ="false";  //added by yzheng 2013/05/29
	String hasRole216 ="false";
    //016 总行集团家谱维护岗,216 分行集团家谱维护岗
    if(CurUser.hasRole("016") || CurUser.hasRole("216")|| CurUser.hasRole("000")){
    	sTempletNo = "GroupCustomerList";
    	hasRole016 = "true";
    	hasRole216 = "true";
    }else{
    	out.println("没有家谱维护权限");
    	return;
    }

    ASObjectModel doTemp = new ASObjectModel(sTempletNo);
    doTemp.setHtmlEvent("", "ondblclick", "viewGroupInfo");//添加双击查看详情功能
    
    //产生DataWindow
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
    dwTemp.setPageSize(20); //设置在datawindows中显示的行数
    dwTemp.Style="1"; //设置DW风格 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    
    //生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sUserID+","+sOrgID);

    String sButtons[][] = {
		{"true","","Button","新增集团","新增一条记录","newRecord()","","","",""}, 
 		{"true","","Button","集团详情","集团详情","viewGroupInfo()","","","",""},
 		{"true","","Button","删除集团","删除集团","deletePhyRecord()","btn_icon_delete"},//(sRightType.equals("ReadOnly")?"false":"true")
 		{CurUser.hasRole("016")?"false":"true","","Button","加入总行管理名单","加入总行管理名单","changeGroupType2()","","","",""},
		//{"true","","Button","加入总行管理名单","加入总行管理名单","changeGroupType2()","","","",""},
 		{"true","","Button","集团家谱复核意见","查看集团家谱复核意见","viewOpinions()","","","",""},
 		{"false","","Button","集团家谱概况","查看集团家谱概况","viewGroupFamily()","btn_icon_detail"},
 		{"false","","Button","集团家谱历次已认定版本","查看集团家谱历次已认定版本","viewGroupFamilyList()","btn_icon_detail"},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script language=javascript>
    /*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
    function newRecord(){
		var sCustomerType ="<%=sCustomerType%>";
		AsControl.PopView("/CustomerManage/GroupManage/GroupCustomerInfo.jsp","CustomerType="+sCustomerType,"resizable=yes;dialogWidth=50;dialogHeight=30;center:yes;status:no;statusbar:no");
		reloadSelf();
    } 
    
    /*~[Describe=集团概况;InputParam=无;OutPutParam=无;]~*/
	function viewGroupInfo(){
      	var sGroupID = getItemValue(0,getRow(),"GroupID");
      	if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
      	    alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
      	
		//查看集团是否有在途申请，如有则返回 
		var sReturn =RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkOnLineApply","GroupID="+sGroupID);  
		
		var hasRole016 = "<%= hasRole016%>";  //added by yzheng 2013/05/29
		var hasRole216 = "<%= hasRole216%>";
		
		if ( (sReturn == "ReadOnly" && hasRole016 == "true") || (sReturn == "ReadOnly" && hasRole216 == "true") ){
			sRightType=sReturn;
		}
		else{
			sRightType="<%=sRight %>";
		}
		AsCredit.openFunction("CustomerDetail","CustomerID="+sGroupID+"&RightType="+sRightType,"");
		//AsControl.OpenObject("Customer",sGroupID,sRightType);
		//打开集团详情页面
		//AsControl.PopView("/CustomerManage/CustomerDetailTab.jsp","GroupID="+sGroupID+"&GroupName="+sGroupName+"&GroupType2="+sGroupType2+"&MgtOrgID="+sMgtOrgID+"&MgtUserID="+sMgtUserID+"&KeyMemberCustomerID="+sKeyMemberCustomerID+"&RightType="+sRightType,"");
		reloadSelf();	
	}  
    
    /*~[Describe=集团家谱;InputParam=无;OutPutParam=无;]~*/
	function viewGroupFamily(){
		var sGroupID = getItemValue(0,getRow(),"GroupID");
		var sMgtOrgID=getItemValue(0,getRow(),"MgtOrgID");
		var sMgtUserID=getItemValue(0,getRow(),"MgtUserID");
		var sKeyMemberCustomerID=getItemValue(0,getRow(),"KeyMemberCustomerID");
		var sGroupName=getItemValue(0,getRow(),"GroupName");
		var sGroupType2=getItemValue(0,getRow(),"GROUPTYPE2");
      	if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
      	    alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
      	
        //查看集团是否有在途申请，如有则返回 
		var sReturn =RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkOnLineApply","GroupID="+sGroupID);  
        
		var hasRole016 = "<%= hasRole016%>";  //added by yzheng 2013/05/29
		var hasRole216 = "<%= hasRole216%>";
		
		if ( (sReturn == "ReadOnly" && hasRole016 == "true") || (sReturn == "ReadOnly" && hasRole216 == "true") ){
			sRightType=sReturn;
		}
		else  sRightType="<%=sRight %>";
		
		AsControl.PopView("/CustomerManage/GroupFamilyDetailTab.jsp","GroupID="+sGroupID+"&GroupName="+sGroupName+"&GroupType2="+sGroupType2+"&MgtOrgID="+sMgtOrgID+"&MgtUserID="+sMgtUserID+"&KeyMemberCustomerID="+sKeyMemberCustomerID+"&RightType="+sRightType,"");
		reloadSelf();	
	}  
  
    /*~[Describe=集团家谱历次已认定版本;InputParam=无;OutPutParam=无;]~*/
	function viewGroupFamilyList(){
		var sGroupID = getItemValue(0,getRow(),"GroupID");
		var sMgtOrgID=getItemValue(0,getRow(),"MgtOrgID");
		var sMgtUserID=getItemValue(0,getRow(),"MgtUserID");
		var sKeyMemberCustomerID=getItemValue(0,getRow(),"KeyMemberCustomerID");
		var sGroupName=getItemValue(0,getRow(),"GroupName");
		var sGroupType2=getItemValue(0,getRow(),"GROUPTYPE2");
      	if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
      	    alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
      	
        //查看集团是否有在途申请，如有则返回 
		var sReturn =RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkOnLineApply","GroupID="+sGroupID);  
        
		var hasRole016 = "<%= hasRole016%>";  //added by yzheng 2013/05/29
		var hasRole216 = "<%= hasRole216%>";
		
		if ( (sReturn == "ReadOnly" && hasRole016 == "true") || (sReturn == "ReadOnly" && hasRole216 == "true") ){
			sRightType=sReturn;
		}
		else  sRightType="<%=sRight %>";
		
		AsControl.PopView("/CustomerManage/GroupFamilyListDetailTab.jsp","GroupID="+sGroupID+"&GroupName="+sGroupName+"&GroupType2="+sGroupType2+"&MgtOrgID="+sMgtOrgID+"&MgtUserID="+sMgtUserID+"&KeyMemberCustomerID="+sKeyMemberCustomerID+"&RightType="+sRightType,"");
		reloadSelf();		
	} 
    
    /*~[Describe=删除集团客户;InputParam=无;OutPutParam=无;]~*/
    function deletePhyRecord(){
		var sGroupID = getItemValue(0,getRow(),"GroupID");
		var sGroupName = getItemValue(0,getRow(),"GroupName");
		var sFamilyMapStatus = getItemValue(0,getRow(),"FamilyMapStatus");    //家谱复核状态 
		var sFamilyMapStatusName = getItemValue(0,getRow(),"FamilyMapStatusName");
		var sUserID = "<%=sUserID%>";
		var sOrgID = "<%=sOrgID%>";
		
        if (typeof(sGroupID)=="undefined" || sGroupID.length==0) {
        	alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(sFamilyMapStatus != "0"){
			alert("该集团客户处于【"+sFamilyMapStatusName+"】状态,不能删除！");
			return;
		}else{
			//校验集团客户是否存在已生效版本
		    var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkGroupApproveOpinion","GroupID="+sGroupID);
			if(sReturn != "NOTEXIST" && sReturn != "ERROR"){
				alert("该集团客户存在已生效版本,不能删除！");
				return;
			}
		}
		
		//校验集团客户是否存在有效的授信额度
        var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkBeforeDeleteGroup","GroupID="+sGroupID);
		if(sReturn != "IsNotExist" && sReturn != "ERROR"){
			alert(sReturn);
			return;
		}
		
        if(confirm("是否确认删除该集团客户？")){
			// 删除集团客户
			var sReturnValue = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","deleteGroupCustomer","GroupID="+sGroupID+",UserID="+sUserID+",OrgID"+sOrgID+",GroupName="+sGroupName);
			if(sReturnValue == "true"){
				alert("删除成功！");
				reloadSelf();
			}else{
				alert("删除失败！");
			}
        }
    }
    
    /*~[Describe=加入总行管理名单;InputParam=无;OutPutParam=无;]~*/
    function changeGroupType2(){
		//1. 获取业务参数
		var sGroupID = getItemValue(0,getRow(),"GroupID"); //集团客户ID
		var sGroupType2 = getItemValue(0,getRow(),"GROUPTYPE2");
		var sInputUserID=getItemValue(0,getRow(),"InputUserID");
		var sInputOrgID=getItemValue(0,getRow(),"InputOrgID");
		var sFamilyMapStatus=getItemValue(0,getRow(),"FamilyMapStatus");
		var sFamilyMapStatusName = getItemValue(0,getRow(),"FamilyMapStatusName");

		if(sGroupType2 == "1"){
			alert("已经在总行管理名单中!");
			return;
		}
		if(sFamilyMapStatus == "1"){
			alert("该集团客户处于【"+sFamilyMapStatusName+"】状态,不能进行更改!");//家谱处于“审核中”，不允许修改。
			return;
		}
		if (typeof(sGroupID)=="undefined" || sGroupID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm("确定要加入总行管理名单吗？")){
			var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","updateGroupType2","GroupID="+sGroupID+",UserID="+sInputUserID+",OrgID="+sInputOrgID);
			if(sReturn == "Success"){
				alert("加入成功!");
			}else{
				alert("加入失败");
				return;
			}
		}
		reloadSelf();
    }
    
    /*~[Describe=查看集团家谱复核意见;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions(){
		var sGroupID = getItemValue(0,getRow(),"GroupID");
      	if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
      		alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
      	AsControl.PopView("/CustomerManage/GroupManage/GroupApproveOpinions.jsp", "GroupID="+sGroupID+"&RightType=All", "");
      	reloadSelf();	
	}  

    
    /**
     * 
     * 代码选择框，传入一个代码编号，选择相应代码
     * 如果其它地方使用到选择代码比较频繁的情况，可考虑将此函数移至common.js
     * @author syang 2009/10/14
     * @param codeNo 代码编号
     * @param Caption 弹出对话框名称
     * @param defaultValue 选择框默认值
     * @param filterExpr 对ItemNo按照这个表达式进行匹配
     * @return 选择的ItemNo
     */
    function selectCode(codeNo,Caption,defaultValue,filterExpr){
        if(typeof(filterExpr) == "undefined"){
            filterExpr = "";
        }
        var codePage = "/CustomerManage/SelectCode.jsp";
        var sPara = "CodeNo="+codeNo+"&Caption="+Caption+"&DefaultValue="+defaultValue
                   +"&ItemNoExpr="+encodeURIComponent(filterExpr)  //这里需要作编码转换，否则形如&,%,+这类字符传输会有问题
                   ;
        style = "resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no";
        sReturnValue = PopPage(codePage+"?"+sPara,"",style);
        return sReturnValue;
    }

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>