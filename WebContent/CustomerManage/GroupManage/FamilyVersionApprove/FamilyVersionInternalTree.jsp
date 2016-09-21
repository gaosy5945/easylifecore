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
 * Purpose: �������������ҳ��
 ***************************************************/
%>
<%
    String sGroupID=CurPage.getParameter("GroupID");
    String sGroupName=CurPage.getParameter("GroupName");
    //ĸ��˾�ͻ����(������ϵ������)
    String sKeyMemberCustomerID=CurPage.getParameter("KeyMemberCustomerID");
    //����ά���ļ��װ汾���
    String sRefVersionSeq=CurPage.getParameter("VersionSeq");
    //�ɵĵļ��װ汾���
    String sCurrentVersionSeq=CurPage.getParameter("CurrentVersionSeq");

    //���ڿ�����ʾģʽ(����/�޶�),����ذ�ť
    String sRightType=CurComp.getParameter("RightType");
    String sInsertTreeNode=CurComp.getParameter("InsertTreeNode");  
    String GroupCustomerID=CurComp.getParameter("GroupCustomerID");
    //��ͼ˵��
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

    /*=================================Ȩ��˵��==================================*/
    //������Ȩ�ޣ������¼���ȡֵ��All,Readonly,ViewOnly,None
    //All������Ȩ�ޣ�Readonlyֻ�ܲ鿴�޶�ģʽ�����ݣ��������޸��޶�ģʽ������
    //ViewOnlyֻ�ܲ鿴����ģʽ�����ݣ����ܲ鿴�޶�ģʽ������,None������ʾ�κ���ģʽ�йصİ�ť
    String RIGHT_TYPE=sRightType;
    //-----------------------������������Ϊ�����������������������ҳ��ᱨ��-------------------
    String groupId = sGroupID;        //���ſͻ����
    String versionSeq=sRefVersionSeq;         //�汾��
    
    //-----------TreeTable��ʾ����������-------------
    String sButtons[][] = {
        {"true","All","Button","ȷ��","","doReturn()","","","","btn_icon_save"},
        {"true","All","Button","ȡ�� ","","goback()","","","","btn_icon_delete"},
    };
%>
<body>
<div class="mydiv" style="height:1px;padding-bottom:10px;"><%@ include file="/Frame/page/jspf/ui/widget/buttonset.jspf"%></div>
<div class="mydiv"><span class="mylabel">��&nbsp;&nbsp;����</span><input type="text" id="searchText" /></div>
<%
	ASObjectModel doTemp = new ASObjectModel("GroupFamilyTreeTest");
	doTemp.setVisible("button", false);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
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
<!--                   ��ͼ����                                                              -->
<!-- ************************************************ -->
<script type="text/javascript"> 
//����ʵ����ʵ��ҵ���߼��߶ȹ�����javascript�߼�
    var table = null;
    var normalModel = true;
    $(document).ready(function() {
    	initTreeTable("<%=dwTree.getTableId()%>");
        //��������
        $("#searchText").keyup(function(){
            var text = $("#searchText").val();
            table.searchText({
                keyWord:text,             //����text����
                excludeColumn:"editCol"   //���ò���������
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