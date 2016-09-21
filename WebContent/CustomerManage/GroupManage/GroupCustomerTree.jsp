<%@page import="com.amarsoft.app.als.sys.widget.DWToTreeTable"%>
<%@page import="com.amarsoft.awe.dw.ASObjectWindow"%>
<%@page import="com.amarsoft.awe.dw.ASObjectModel"%>
<%@ page import="com.amarsoft.app.als.customer.group.tree.DefaultContextLoader" %>
<%@ page import="com.amarsoft.app.als.customer.group.tree.component.*" %>
<%@ page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@ page import="com.amarsoft.are.jbo.BizObject"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
/***************************************************
 * Module: GroupCustomerTree.jsp
 * Author: syang
 * Modified: 2010/09/26 16:15
 * Purpose: 家谱树组件调用页面
 * History: wmzhu 2014/05/27 简化树图生成方式，去除json方式传参
 ***************************************************/
%>
<%
    String sGroupID=CurPage.getParameter("GroupID");
    String sGroupName=CurPage.getParameter("GroupName");
    //母公司客户编号(关联关系搜索用)
    String sKeyMemberCustomerID=CurPage.getParameter("KeyMemberCustomerID");
    //正在维护的家谱版本编号
    String sRefVersionSeq=CurPage.getParameter("RefVersionSeq");
    //正在使用的家谱版本编号
    String sCurrentVersionSeq=CurPage.getParameter("CurrentVersionSeq");
    //集团家谱版本状态
    String sFamilyMapStatus = CurComp.getParameter("FamilyMapStatus");
    //集团客户类型(跨分行/地区性):用于"集团客户详情"按钮
    String sGroupType1 = CurComp.getParameter("GroupType1");
    //当前最新外部信息:用于点击”维护新的家谱“按钮后重新载入页面用
    String sExternalVersionSeq = CurComp.getParameter("ExternalVersionSeq");
    //用于控制显示模式(正常/修订),及相关按钮
    String sRightType=CurComp.getParameter("RightType");
    String sInsertTreeNode=CurComp.getParameter("InsertTreeNode");  
    String groupCustomerID=CurComp.getParameter("GroupCustomerID");
    
    //页面显示信息（因前一页面传中文过来会有乱码问题，故接收家谱状态后在本页面转换为中文）
    String treeViewDetail1 = CurComp.getParameter("TreeViewDetail1");
    String treeViewDetail2 = CurComp.getParameter("TreeViewDetail2");
    String showType = CurPage.getParameter("ShowType");//显示方式，read或空为正常模式,modify为修订模式
    
    //集团家谱版本状态中文名称
    String sFamilyMapStatusName="";
    if("0".equals(treeViewDetail1)){
		sFamilyMapStatusName="草稿";
	}else if("3".equals(treeViewDetail1)){
		sFamilyMapStatusName="审核退回";
	}else if("1".equals(treeViewDetail1)){
		sFamilyMapStatusName="审核中";
	}else if("2".equals(treeViewDetail1)){
		sFamilyMapStatusName="已认定";
	}
    
    //树图说明
    if(sGroupID==null) sGroupID=""; 
    if(sGroupName==null) sGroupName=""; 
    if(sKeyMemberCustomerID==null) sKeyMemberCustomerID=""; 
    if(sRefVersionSeq==null) sRefVersionSeq=""; 
    if(sCurrentVersionSeq==null) sCurrentVersionSeq=""; 
    if(sRightType == null) sRightType = "";
    if(sGroupType1 == null) sGroupType1 = "";
    if(sExternalVersionSeq == null) sExternalVersionSeq = "";
    if(treeViewDetail1 == null) treeViewDetail1 = "";
    if(sInsertTreeNode == null) sInsertTreeNode = "false";
    if(groupCustomerID == null) groupCustomerID = "";
    if(sFamilyMapStatus == null) sFamilyMapStatus = "";
    
    String TreeViewDetail="系统信息-家谱复核状态:["+sFamilyMapStatusName+"]-版本编号:["+treeViewDetail2+"]";//版本编号信息暂不显示
    //String TreeViewDetail="目前家谱版本状态:【"+sFamilyMapStatusName+"】";
    
    //判断当前集团是否有 已认定 的家谱版本，恢复最新已复核版本时使用
	int icount=JBOFactory.getBizObjectManager("jbo.app.GROUP_MEMBER_RELATIVE").createQuery("O.GroupID =:GroupID").setParameter("GroupID",sGroupID).getTotalCount();
	
    ASResultSet rsTemp = null;
    String sSql="";
    String sOldMemberCustomerID="";//已认定的核心企业客户编号
	sSql = "select MemberCustomerID from GROUP_MEMBER_RELATIVE where GroupID = :GroupID and ParentMemberID=:ParmentMemberID";
	rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("GroupID",sGroupID).setParameter("ParmentMemberID","None"));
	if (rsTemp.next()){
		sOldMemberCustomerID  = DataConvert.toString(rsTemp.getString("MemberCustomerID"));
		//将空值转化成空字符串
		if(sOldMemberCustomerID == null) sOldMemberCustomerID = "";
	}
    rsTemp.getStatement().close();    
	
    
    //集团管理岗维护家谱可以直接生效 
    //String EditRight="2";
  
    /*=================================权限说明==================================*/
    //家谱树权限，有以下几个取值：All,Readonly,ViewOnly,None
    //All有所有权限;
    //Readonly只能查看修订模式的数据，而不能修改修订模式的数据;
    //ViewOnly只能查看正常模式的数据，不能查看修订模式的数据;
    //None不显示任何与模式有关的按钮
    String RIGHT_TYPE=sRightType;
    //-----------------------以下两个参数为必需参数，无这两个参数，页面会报错-------------------
    String groupId = sGroupID;        //集团客户编号
    String versionSeq=sRefVersionSeq;         //版本号
    
    //-----------TreeTable显示数据项设置-------------
    String sButtons[][] = {
        {((sRightType.equals("All")&&sFamilyMapStatus.equals("2"))||((sRightType.equals("All")&&sFamilyMapStatus.equals("3")))?"true":"false"),"All","Button","维护新的版本 ","","NewVersionSeq()","","","",""},
        {"false","All","Button","完成家谱维护","","save()","","","",""},
        {(sFamilyMapStatus.equals("0")&&sRightType.equals("All")?"true":"false"),"All","Button","提交复核","","doSubmit()","","","",""},
        {((sRightType.equals("All")&&sFamilyMapStatus.equals("0")&&icount>0)?"true":"false"),"All","Button","取消家谱维护 ","","cancel()","","","",""},
    };
%>
<body>
<div class="mydiv" ><%=TreeViewDetail%></div>
<% if(RIGHT_TYPE.equals("All") && sFamilyMapStatus.equals("0")){ %>
<div class="mydiv"><span class="mylabel">显示模式：</span><a href="javascript:void(0)" id="normalAction">正常</a><a href="javascript:void(0)" id="revisionAction">修订模式</a></div>
<%} %>
<div class="mydiv"><span class="mylabel">查&nbsp;&nbsp;找：</span><input type="text" id="searchText"></input></div>
<%
	ASObjectModel doTemp = new ASObjectModel("GroupFamilyTreeTest");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(groupId+","+versionSeq);
 	
	DWToTreeTable dwTree=new DWToTreeTable(dwTemp,"ParentMemberID","MemberCustomerID","None");
%>
<%@ include file="/AppMain/resources/include/treetable_include.jsp"%>
<%
	out.print(dwTree.getHTML());
%> 
</body>
</html>
<!-- ************************************************ -->
<!--                   按钮触发                                                              -->
<!-- ************************************************ -->
<script type="text/javascript"> 
	function save(){
		var sGroupID = "<%=sGroupID%>";//集团客户编号
	    if (typeof(sGroupID) == "undefined" || sGroupID.length == 0){
	        alert("维护新的家谱失败,集团客户编号为空!");
	        return;
	    }
		
    	var sRefVersionSeq = "<%=sRefVersionSeq%>";//正在维护的家谱版本编号
       if(confirm("点击确认,将建立新的家谱并对当前复核通过的家谱进行失效操作!")){
			var sReturn=RunJavaMethodTrans("com.amarsoft.app.als.customer.group.model.UpdateFamilyApproveStatus","updateFamilyApproveStatus","userID=<%=CurUser.getUserID()%>,groupID="+sGroupID+",versionSeq="+sRefVersionSeq+",effectiveStatus=2");
			if(sReturn=="SUCCEEDED"){
				alert("当前家谱已经生效！");	
				parent.parent.amarTab.refreshWidgetTab('集团家谱概况');
			}else{
				alert("当前家谱维护失败！");	
			}
		}
	}
	function doSubmit(){
    	var sGroupID = "<%=sGroupID%>";//集团客户编号
    	var sCurrentVersionSeq="<%=sCurrentVersionSeq%>";
    	var sRefVersionSeq = "<%=sRefVersionSeq%>";//正在维护的家谱版本编号
    	//对所有成员进行复核，集团家谱成员需至少2名才可建立集团提交复核
    	var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.CheckGroupMemberCount","checkGroupMemberCount","groupId="+sGroupID+",VersionSeq="+sRefVersionSeq);
    	if(sReturn == "No"){
			alert("该集团成员少于2名，不能提交复核！");
			return;
        }
    	//对所有成员进行复核，如果成员在其他集团中存在，则不允许提交复核  
		sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkAllGroupMember","GroupID="+sGroupID);
		if(sReturn!="true"){
			alert(sReturn);
			return ;
		}
		var sReturn = AsControl.PopView("/CustomerManage/GroupManage/FamilyVersionApplyOpinionInfo.jsp","GroupID="+sGroupID+"&VersionSeq="+sRefVersionSeq+"&CurrentVersionSeq="+sCurrentVersionSeq+"&EditRight=1&GroupType1=<%=sGroupType1%>","dialogWidth=40;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    	if(sReturn=="successed"){
			alert("提交复核成功");
			var sParam="TreeViewDetail1=1&TreeViewDetail2=<%=treeViewDetail2%>&RightType=<%=sRightType%>&FamilyMapStatus=1&GroupID=<%=sGroupID%>&KeyMemberCustomerID=<%=sKeyMemberCustomerID%>&RefVersionSeq=<%=sRefVersionSeq%>&CurrentVersionSeq=<%=sCurrentVersionSeq%>&GroupType1=<%=sGroupType1%>&InsertTreeNode=<%=sInsertTreeNode%>&GroupCustomerID=<%=groupCustomerID%>";
			OpenComp("GroupCustomerTree","/CustomerManage/GroupManage/GroupCustomerTree.jsp",sParam,"_self");
 	 	}
	}

	function NewVersionSeq(){
        var sGroupID = "<%=sGroupID%>";
	    if (typeof(sGroupID) == "undefined" || sGroupID.length == 0){
	        alert("维护新的家谱失败,集团客户编号为空!");// 
	        return;
	    }
		if(confirm("点击确认,将建立新的家谱并对当前复核通过的家谱进行失效操作!")){
		  	//重新初始化家谱版本表及家谱成员表,并返回新的正在维护家谱版本编号
			var sRefVersionSeq=RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.FamilyMaintain","getNewRefVersionSeq","userID=<%=CurUser.getUserID()%>,groupID="+sGroupID+",currentVersionSeq=<%=sCurrentVersionSeq%>");
		  	if(typeof(sRefVersionSeq)!="undefined" && sRefVersionSeq.length !=0 && sRefVersionSeq!="ERROR"){
				var sParam="TreeViewDetail1=0&TreeViewDetail2="+sRefVersionSeq+"&RightType=<%=sRightType%>&FamilyMapStatus=0&GroupID=<%=sGroupID%>&KeyMemberCustomerID=<%=sKeyMemberCustomerID%>&RefVersionSeq="+sRefVersionSeq+"&CurrentVersionSeq=<%=sCurrentVersionSeq%>&GroupType1=<%=sGroupType1%>&InsertTreeNode=<%=sInsertTreeNode%>&GroupCustomerID=<%=groupCustomerID%>";
				OpenComp("GroupCustomerTree","/CustomerManage/GroupManage/GroupCustomerTree.jsp",sParam,"_self");
			}
		}
	}
	
	//取消对当前家谱的维护操作，将家谱恢复到最新的已复核过的版本
	function cancel(){
		var sGroupID = "<%=sGroupID%>";
		if (typeof(sGroupID) == "undefined" || sGroupID.length == 0){
	        alert("操作失败,集团客户编号为空!");
	        return;
	    }
		var sRefVersionSeq="<%=sRefVersionSeq%>";//当前正在维护的家谱版本
		var sCurrentVersionSeq="<%=sCurrentVersionSeq%>";//最新已认定的家谱版本编号
        
		if(confirm("是否取消对家谱的维护，并将家谱恢复到最新已认定状态!")){
			var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.FamilyMaintain","deleteRefVersion","userID=<%=CurUser.getUserID()%>,groupID="+sGroupID+",refVersionSeq="+sRefVersionSeq+",currentVersionSeq="+sCurrentVersionSeq+",oldMemberCustomerID=<%=sOldMemberCustomerID%>");
		  	if(sReturn == "true"){
				alert("恢复集团家谱成功!");
				var sParam="TreeViewDetail1=2&TreeViewDetail2=<%=sCurrentVersionSeq%>&RightType=<%=sRightType%>&FamilyMapStatus=2&GroupID=<%=sGroupID%>&KeyMemberCustomerID=<%=sKeyMemberCustomerID%>&RefVersionSeq="+sCurrentVersionSeq+"&CurrentVersionSeq=<%=sCurrentVersionSeq%>&GroupType1=<%=sGroupType1%>&InsertTreeNode=<%=sInsertTreeNode%>&GroupCustomerID=<%=groupCustomerID%>";
				OpenComp("GroupCustomerTree","/CustomerManage/GroupManage/GroupCustomerTree.jsp",sParam,"_self");
			}
		}
	}
</script>

<!-- ************************************************ -->
<!--                   树图操作                                                              -->
<!-- ************************************************ -->
<script type="text/javascript"> 
//这里实现与实际业务逻辑高度关联的javascript逻辑
    var sKeyMemberCustomerID="<%=sKeyMemberCustomerID%>";
    var table = null;
    var normalModel = true;
    $(document).ready(function() {
    	initTreeTable("<%=dwTree.getTableId()%>");
        //搜索功能
        $("#searchText").keyup(function(){
            var text = $("#searchText").val();
            table.searchText({
                keyWord:text,             //搜索text文字
                excludeColumn:"button"   //设置不搜索的列
            });
        });
        //模式转换按钮
        $("#normalAction").click(normalModelHandler);//正常模式
        $("#revisionAction").click(revisionModelHandler);//修订模型
        if(<%="modify".equals(showType)%>){//修订模式
	        normalModelHandler();
        	revisionModelHandler();
        }else{//正常模式
	        normalModelHandler();
        }
        return;
    });
    //正常模式
    function normalModelHandler(){
        //更改显示
        $("#normalAction").addClass("actived");
        $("#revisionAction").removeClass("actived");

        $("tbody tr",table).each(function(){
            $(this).removeClass("new changed removed");
            if($(this).getValue("REVISEFLAG")=="REMOVED"){
                $(this).hide();
                $(this).attr("hidden",true);
            }
        });
        //删除操作列
        table.removeColumn({name:"button"});
        normalModel = true;
    }
    //修订模式
    function revisionModelHandler(){
        //只有拥有所有权限才可以修改 
    	  <% if(sRightType.equals("All")){%>
        //添加操作列
        var buttonClass="newbutton";
        table.addExecuteColumn({
            headerText:"操作",  //列名称
            name:"button",  //按钮列名称
            colClass:"noremoved",//按钮列使用的样式，主要用于去除删除时，增加的删除线
            buttons:[
                    {buttonClass:buttonClass,text : "新增",title:"插入一个成员",execute : insertHandler}
                    ,{buttonClass:buttonClass,text : "修改",execute : editHandler,filter : editActionFilter}
                    ,{buttonClass:buttonClass,text : "删除",title:"标记为删除",execute : deleteHandler,filter : deleteActionFilter}
                    ]
        });   
        <% }%>      
        //更改显示
        $("#normalAction").removeClass("actived");
        $("#revisionAction").addClass("actived");
        
        $("tbody tr",table).each(function(){
            $(this).show();
            $(this).attr("hidden",false);//取消隐藏
            if($(this).getValue("REVISEFLAG")=="NEW"){
                $(this).addClass("new");
            }else if($(this).getValue("REVISEFLAG")=="CHANGED"){
                $(this).addClass("changed");
            }if($(this).getValue("REVISEFLAG")=="REMOVED"){
                $(this).addClass("removed");
            }
        });
       //修订标志
        normalModel = false;
    }

    //编辑按钮过滤器 删除按钮
    function deleteActionFilter(tr){
        if(tr&&tr.attr&&(tr.attr("id")==sKeyMemberCustomerID)) return false;//根节点不出删除按钮
        else return true;
    }
    //正式成员不能修改
    function editActionFilter(tr){
        if(tr&&tr.attr&&(tr.attr("id")==sKeyMemberCustomerID|| tr.getValue("state")=="CHECKED"))return false;//根节点、正式成员 只能删除，不能编辑或者撤销
        else return true;
    }

	//编辑按钮过滤器  撤销按钮
    function undoActionFilter(tr){
        if(tr&&tr.attr&&tr.attr("id")==sKeyMemberCustomerID) return false;//根节点、正式成员不能撤销
        else return true;
    }
    
    //插入新节点，新增集团成员
	function insertHandler(){
		var currentRow = $(this).parents("tr");
		var sRefVersionSeq ="<%=sRefVersionSeq%>";
		var sGroupID="<%=sGroupID%>";
		var parentId = currentRow.getValue("MEMBERCUSTOMERID");
		var status = currentRow.getValue("REVISEFLAG");
		if(status == "REMOVED"){
			alert("删除状态下无法新增子成员");
			return;
		}
		
		var param = "GroupID="+sGroupID+"&ParentMemberID="+parentId+"&RefVersionSeq="+sRefVersionSeq;
		var dialogStyle = "dialogWidth=600px;dialogHeight=400px;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no";
		var pageURL="/CustomerManage/MemberInfoViewer.jsp";
		var oReturn= AsControl.PopView(pageURL,param,dialogStyle);
		if(typeof(oReturn)!="undefined" && oReturn.length > 0){
			AsControl.OpenPage("/CustomerManage/GroupManage/GroupCustomerTree.jsp","ShowType=modify","_self");
		}
    }

    //编辑集团成员信息
    function editHandler(){
        var currentRow = $(this).parents("tr");
        var state = currentRow.getValue("REVISEFLAG");
        if(state=="REMOVED"){
            alert("当前节点为删除状态，无法编辑");
            return;
        }
        var MemberCustomerID = currentRow.getValue("MEMBERCUSTOMERID");
        var param = "MemberCustomerID="+MemberCustomerID+"&GroupID=<%=sGroupID%>&RefVersionSeq=<%=sRefVersionSeq%>";
        var dialogStyle = "dialogWidth=600px;dialogHeight=400px;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no";
        var pageURL="/CustomerManage/MemberInfoViewer.jsp";
        var result = AsControl.PopView(pageURL,param,dialogStyle);
        if(typeof(result)!= "undefined" && result.length > 0){
			AsControl.OpenPage("/CustomerManage/GroupManage/GroupCustomerTree.jsp","ShowType=modify","_self");
		}
    }
	//删除集团成员
	function deleteHandler(){
		var currentRow = $(this).parents("tr"); 
		var sRefVersionSeq ="<%=sRefVersionSeq%>";
        var sGroupID="<%=sGroupID%>";
        var parentId = currentRow.getValue("MEMBERCUSTOMERID");
		var status = currentRow.getValue("REVISEFLAG");
		if(status == "REMOVED"){
			alert("删除状态下无法继续删除");
			return;
		}
        var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.CheckSubMemberFamilyTree","subMemberExist","GroupId="+sGroupID+",ParentMemberID="+parentId+",VersionSeq="+sRefVersionSeq);
		 if(sReturn == "EXIST"){
			alert("该成员下存在子节点，请先删除子节点再执行此操作！");
			return;
		 }
    	 if(!confirm("您确定要删除该成员吗？"))return;
    	 var result = RunJavaMethod("com.amarsoft.app.als.customer.group.action.CheckSubMemberFamilyTree","deleteGroupFamilyMember","groupId="+sGroupID+",memberID="+parentId+",versionSeq="+sRefVersionSeq);
    	 if(result == "true"){
    		 AsControl.OpenPage("/CustomerManage/GroupManage/GroupCustomerTree.jsp","ShowType=modify","_self");
    	 }else{
    		 alert("删除失败");
    	 }
    }
</script>

<%@ include file="/IncludeEnd.jsp"%>