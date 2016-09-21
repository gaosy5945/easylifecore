<%@page import="com.amarsoft.app.als.sys.widget.DWToTreeTable"%>
<%@page import="com.amarsoft.awe.dw.ASObjectWindow"%>
<%@page import="com.amarsoft.awe.dw.ASObjectModel"%>
<%@ page import="com.amarsoft.app.als.customer.group.tree.DefaultContextLoader" %>
<%@ page import="com.amarsoft.app.als.customer.group.tree.component.*" %>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
/***************************************************
 * Module: GroupCustomerTree.jsp
 * Author: syang
 * Modified: 2010/09/26 16:15
 * Purpose: 家谱树组件调用页面
 ***************************************************/
%>
<%
    String sGroupID=CurPage.getParameter("GroupID");
    String sGroupName=CurPage.getParameter("GroupName");
    //母公司客户编号(关联关系搜索用)
    String sKeyMemberCustomerID=CurPage.getParameter("KeyMemberCustomerID");
    //正在维护的家谱版本编号
    String sRefVersionSeq=CurPage.getParameter("VersionSeq");
    //旧的的家谱版本编号
    String sCurrentVersionSeq=CurPage.getParameter("CurrentVersionSeq");

    //用于控制显示模式(正常/修订),及相关按钮
    String sRightType=CurComp.getParameter("RightType");
    String sInsertTreeNode=CurComp.getParameter("InsertTreeNode");  
    String GroupCustomerID=CurComp.getParameter("GroupCustomerID");
    //树图说明
    String sTreeViewDetail = CurComp.getParameter("TreeViewDetail");
    if(sGroupID==null) sGroupID=""; 
    if(sGroupName==null) sGroupName=""; 
    if(sKeyMemberCustomerID==null) sKeyMemberCustomerID=""; 
    if(sRefVersionSeq==null) sRefVersionSeq=""; 
    if(sCurrentVersionSeq==null) sCurrentVersionSeq=""; 
    if(sRightType == null) sRightType = "";
    if(sTreeViewDetail == null) sTreeViewDetail = "";
    if(sInsertTreeNode == null) sInsertTreeNode = "false";
    if(GroupCustomerID == null) GroupCustomerID = "";

    /*=================================权限说明==================================*/
    //家谱树权限，有以下几个取值：All,Readonly,ViewOnly,None
    //All有所有权限，Readonly只能查看修订模式的数据，而不能修改修订模式的数据
    //ViewOnly只能查看正常模式的数据，不能查看修订模式的数据,None，不显示任何与模式有关的按钮
    String RIGHT_TYPE=sRightType;
    //-----------------------以下两个参数为必需参数，无这两个参数，页面会报错-------------------
    String groupId = sGroupID;        //集团客户编号
    String versionSeq=sRefVersionSeq;         //版本号
    
    //-----------TreeTable显示数据项设置-------------
    String sButtons[][] = {
        {"true","All","Button","确定","","doReturn()","","","","btn_icon_save"},
        {"true","All","Button","取消 ","","goback()","","","","btn_icon_delete"},
    };
%>
<body>
<div class="mydiv" style="height:1px;padding-bottom:10px;"><%@ include file="/Frame/page/jspf/ui/widget/buttonset.jspf"%></div>
<div class="mydiv"><span class="mylabel">搜&nbsp;&nbsp;索：</span><input type="text" id="searchText" /></div>
<%
	ASObjectModel doTemp = new ASObjectModel("GroupFamilyTreeTest");
	doTemp.setVisible("button", false);
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
<!--                   树图操作                                                              -->
<!-- ************************************************ -->
<script type="text/javascript"> 
//这里实现与实际业务逻辑高度关联的javascript逻辑
    var table = null;
    var normalModel = true;
    $(document).ready(function() {
    	initTreeTable("<%=dwTree.getTableId()%>");
        //搜索功能
        $("#searchText").keyup(function(){
            var text = $("#searchText").val();
            table.searchText({
                keyWord:text,             //搜索text文字
                excludeColumn:"editCol"   //设置不搜索的列
            });
        });
        return;
    });
    
	function doReturn(){
		 var currentRow = $(".selected",table);
		 var ParentMemberID = currentRow.getValue("MEMBERCUSTOMERID");
		 var ParentMemberName =currentRow.getValue("memberName");
		 var oReturn = {};
		 oReturn["id"] =ParentMemberID;
		 oReturn["MemberName"]=ParentMemberName;
		 self.returnValue = oReturn;
		 self.close();
	}
	function goback(){
		self.close();
	}
   
</script>
<%@ include file="/IncludeEnd.jsp"%>