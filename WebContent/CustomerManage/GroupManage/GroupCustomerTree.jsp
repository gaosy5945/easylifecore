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
 * Purpose: �������������ҳ��
 * History: wmzhu 2014/05/27 ����ͼ���ɷ�ʽ��ȥ��json��ʽ����
 ***************************************************/
%>
<%
    String sGroupID=CurPage.getParameter("GroupID");
    String sGroupName=CurPage.getParameter("GroupName");
    //ĸ��˾�ͻ����(������ϵ������)
    String sKeyMemberCustomerID=CurPage.getParameter("KeyMemberCustomerID");
    //����ά���ļ��װ汾���
    String sRefVersionSeq=CurPage.getParameter("RefVersionSeq");
    //����ʹ�õļ��װ汾���
    String sCurrentVersionSeq=CurPage.getParameter("CurrentVersionSeq");
    //���ż��װ汾״̬
    String sFamilyMapStatus = CurComp.getParameter("FamilyMapStatus");
    //���ſͻ�����(�����/������):����"���ſͻ�����"��ť
    String sGroupType1 = CurComp.getParameter("GroupType1");
    //��ǰ�����ⲿ��Ϣ:���ڵ����ά���µļ��ס���ť����������ҳ����
    String sExternalVersionSeq = CurComp.getParameter("ExternalVersionSeq");
    //���ڿ�����ʾģʽ(����/�޶�),����ذ�ť
    String sRightType=CurComp.getParameter("RightType");
    String sInsertTreeNode=CurComp.getParameter("InsertTreeNode");  
    String groupCustomerID=CurComp.getParameter("GroupCustomerID");
    
    //ҳ����ʾ��Ϣ����ǰһҳ�洫���Ĺ��������������⣬�ʽ��ռ���״̬���ڱ�ҳ��ת��Ϊ���ģ�
    String treeViewDetail1 = CurComp.getParameter("TreeViewDetail1");
    String treeViewDetail2 = CurComp.getParameter("TreeViewDetail2");
    String showType = CurPage.getParameter("ShowType");//��ʾ��ʽ��read���Ϊ����ģʽ,modifyΪ�޶�ģʽ
    
    //���ż��װ汾״̬��������
    String sFamilyMapStatusName="";
    if("0".equals(treeViewDetail1)){
		sFamilyMapStatusName="�ݸ�";
	}else if("3".equals(treeViewDetail1)){
		sFamilyMapStatusName="����˻�";
	}else if("1".equals(treeViewDetail1)){
		sFamilyMapStatusName="�����";
	}else if("2".equals(treeViewDetail1)){
		sFamilyMapStatusName="���϶�";
	}
    
    //��ͼ˵��
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
    
    String TreeViewDetail="ϵͳ��Ϣ-���׸���״̬:["+sFamilyMapStatusName+"]-�汾���:["+treeViewDetail2+"]";//�汾�����Ϣ�ݲ���ʾ
    //String TreeViewDetail="Ŀǰ���װ汾״̬:��"+sFamilyMapStatusName+"��";
    
    //�жϵ�ǰ�����Ƿ��� ���϶� �ļ��װ汾���ָ������Ѹ��˰汾ʱʹ��
	int icount=JBOFactory.getBizObjectManager("jbo.app.GROUP_MEMBER_RELATIVE").createQuery("O.GroupID =:GroupID").setParameter("GroupID",sGroupID).getTotalCount();
	
    ASResultSet rsTemp = null;
    String sSql="";
    String sOldMemberCustomerID="";//���϶��ĺ�����ҵ�ͻ����
	sSql = "select MemberCustomerID from GROUP_MEMBER_RELATIVE where GroupID = :GroupID and ParentMemberID=:ParmentMemberID";
	rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("GroupID",sGroupID).setParameter("ParmentMemberID","None"));
	if (rsTemp.next()){
		sOldMemberCustomerID  = DataConvert.toString(rsTemp.getString("MemberCustomerID"));
		//����ֵת���ɿ��ַ���
		if(sOldMemberCustomerID == null) sOldMemberCustomerID = "";
	}
    rsTemp.getStatement().close();    
	
    
    //���Ź����ά�����׿���ֱ����Ч 
    //String EditRight="2";
  
    /*=================================Ȩ��˵��==================================*/
    //������Ȩ�ޣ������¼���ȡֵ��All,Readonly,ViewOnly,None
    //All������Ȩ��;
    //Readonlyֻ�ܲ鿴�޶�ģʽ�����ݣ��������޸��޶�ģʽ������;
    //ViewOnlyֻ�ܲ鿴����ģʽ�����ݣ����ܲ鿴�޶�ģʽ������;
    //None����ʾ�κ���ģʽ�йصİ�ť
    String RIGHT_TYPE=sRightType;
    //-----------------------������������Ϊ�����������������������ҳ��ᱨ��-------------------
    String groupId = sGroupID;        //���ſͻ����
    String versionSeq=sRefVersionSeq;         //�汾��
    
    //-----------TreeTable��ʾ����������-------------
    String sButtons[][] = {
        {((sRightType.equals("All")&&sFamilyMapStatus.equals("2"))||((sRightType.equals("All")&&sFamilyMapStatus.equals("3")))?"true":"false"),"All","Button","ά���µİ汾 ","","NewVersionSeq()","","","",""},
        {"false","All","Button","��ɼ���ά��","","save()","","","",""},
        {(sFamilyMapStatus.equals("0")&&sRightType.equals("All")?"true":"false"),"All","Button","�ύ����","","doSubmit()","","","",""},
        {((sRightType.equals("All")&&sFamilyMapStatus.equals("0")&&icount>0)?"true":"false"),"All","Button","ȡ������ά�� ","","cancel()","","","",""},
    };
%>
<body>
<div class="mydiv" ><%=TreeViewDetail%></div>
<% if(RIGHT_TYPE.equals("All") && sFamilyMapStatus.equals("0")){ %>
<div class="mydiv"><span class="mylabel">��ʾģʽ��</span><a href="javascript:void(0)" id="normalAction">����</a><a href="javascript:void(0)" id="revisionAction">�޶�ģʽ</a></div>
<%} %>
<div class="mydiv"><span class="mylabel">��&nbsp;&nbsp;�ң�</span><input type="text" id="searchText"></input></div>
<%
	ASObjectModel doTemp = new ASObjectModel("GroupFamilyTreeTest");
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
<!--                   ��ť����                                                              -->
<!-- ************************************************ -->
<script type="text/javascript"> 
	function save(){
		var sGroupID = "<%=sGroupID%>";//���ſͻ����
	    if (typeof(sGroupID) == "undefined" || sGroupID.length == 0){
	        alert("ά���µļ���ʧ��,���ſͻ����Ϊ��!");
	        return;
	    }
		
    	var sRefVersionSeq = "<%=sRefVersionSeq%>";//����ά���ļ��װ汾���
       if(confirm("���ȷ��,�������µļ��ײ��Ե�ǰ����ͨ���ļ��׽���ʧЧ����!")){
			var sReturn=RunJavaMethodTrans("com.amarsoft.app.als.customer.group.model.UpdateFamilyApproveStatus","updateFamilyApproveStatus","userID=<%=CurUser.getUserID()%>,groupID="+sGroupID+",versionSeq="+sRefVersionSeq+",effectiveStatus=2");
			if(sReturn=="SUCCEEDED"){
				alert("��ǰ�����Ѿ���Ч��");	
				parent.parent.amarTab.refreshWidgetTab('���ż��׸ſ�');
			}else{
				alert("��ǰ����ά��ʧ�ܣ�");	
			}
		}
	}
	function doSubmit(){
    	var sGroupID = "<%=sGroupID%>";//���ſͻ����
    	var sCurrentVersionSeq="<%=sCurrentVersionSeq%>";
    	var sRefVersionSeq = "<%=sRefVersionSeq%>";//����ά���ļ��װ汾���
    	//�����г�Ա���и��ˣ����ż��׳�Ա������2���ſɽ��������ύ����
    	var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.CheckGroupMemberCount","checkGroupMemberCount","groupId="+sGroupID+",VersionSeq="+sRefVersionSeq);
    	if(sReturn == "No"){
			alert("�ü��ų�Ա����2���������ύ���ˣ�");
			return;
        }
    	//�����г�Ա���и��ˣ������Ա�����������д��ڣ��������ύ����  
		sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkAllGroupMember","GroupID="+sGroupID);
		if(sReturn!="true"){
			alert(sReturn);
			return ;
		}
		var sReturn = AsControl.PopView("/CustomerManage/GroupManage/FamilyVersionApplyOpinionInfo.jsp","GroupID="+sGroupID+"&VersionSeq="+sRefVersionSeq+"&CurrentVersionSeq="+sCurrentVersionSeq+"&EditRight=1&GroupType1=<%=sGroupType1%>","dialogWidth=40;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    	if(sReturn=="successed"){
			alert("�ύ���˳ɹ�");
			var sParam="TreeViewDetail1=1&TreeViewDetail2=<%=treeViewDetail2%>&RightType=<%=sRightType%>&FamilyMapStatus=1&GroupID=<%=sGroupID%>&KeyMemberCustomerID=<%=sKeyMemberCustomerID%>&RefVersionSeq=<%=sRefVersionSeq%>&CurrentVersionSeq=<%=sCurrentVersionSeq%>&GroupType1=<%=sGroupType1%>&InsertTreeNode=<%=sInsertTreeNode%>&GroupCustomerID=<%=groupCustomerID%>";
			OpenComp("GroupCustomerTree","/CustomerManage/GroupManage/GroupCustomerTree.jsp",sParam,"_self");
 	 	}
	}

	function NewVersionSeq(){
        var sGroupID = "<%=sGroupID%>";
	    if (typeof(sGroupID) == "undefined" || sGroupID.length == 0){
	        alert("ά���µļ���ʧ��,���ſͻ����Ϊ��!");// 
	        return;
	    }
		if(confirm("���ȷ��,�������µļ��ײ��Ե�ǰ����ͨ���ļ��׽���ʧЧ����!")){
		  	//���³�ʼ�����װ汾�����׳�Ա��,�������µ�����ά�����װ汾���
			var sRefVersionSeq=RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.FamilyMaintain","getNewRefVersionSeq","userID=<%=CurUser.getUserID()%>,groupID="+sGroupID+",currentVersionSeq=<%=sCurrentVersionSeq%>");
		  	if(typeof(sRefVersionSeq)!="undefined" && sRefVersionSeq.length !=0 && sRefVersionSeq!="ERROR"){
				var sParam="TreeViewDetail1=0&TreeViewDetail2="+sRefVersionSeq+"&RightType=<%=sRightType%>&FamilyMapStatus=0&GroupID=<%=sGroupID%>&KeyMemberCustomerID=<%=sKeyMemberCustomerID%>&RefVersionSeq="+sRefVersionSeq+"&CurrentVersionSeq=<%=sCurrentVersionSeq%>&GroupType1=<%=sGroupType1%>&InsertTreeNode=<%=sInsertTreeNode%>&GroupCustomerID=<%=groupCustomerID%>";
				OpenComp("GroupCustomerTree","/CustomerManage/GroupManage/GroupCustomerTree.jsp",sParam,"_self");
			}
		}
	}
	
	//ȡ���Ե�ǰ���׵�ά�������������׻ָ������µ��Ѹ��˹��İ汾
	function cancel(){
		var sGroupID = "<%=sGroupID%>";
		if (typeof(sGroupID) == "undefined" || sGroupID.length == 0){
	        alert("����ʧ��,���ſͻ����Ϊ��!");
	        return;
	    }
		var sRefVersionSeq="<%=sRefVersionSeq%>";//��ǰ����ά���ļ��װ汾
		var sCurrentVersionSeq="<%=sCurrentVersionSeq%>";//�������϶��ļ��װ汾���
        
		if(confirm("�Ƿ�ȡ���Լ��׵�ά�����������׻ָ����������϶�״̬!")){
			var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.FamilyMaintain","deleteRefVersion","userID=<%=CurUser.getUserID()%>,groupID="+sGroupID+",refVersionSeq="+sRefVersionSeq+",currentVersionSeq="+sCurrentVersionSeq+",oldMemberCustomerID=<%=sOldMemberCustomerID%>");
		  	if(sReturn == "true"){
				alert("�ָ����ż��׳ɹ�!");
				var sParam="TreeViewDetail1=2&TreeViewDetail2=<%=sCurrentVersionSeq%>&RightType=<%=sRightType%>&FamilyMapStatus=2&GroupID=<%=sGroupID%>&KeyMemberCustomerID=<%=sKeyMemberCustomerID%>&RefVersionSeq="+sCurrentVersionSeq+"&CurrentVersionSeq=<%=sCurrentVersionSeq%>&GroupType1=<%=sGroupType1%>&InsertTreeNode=<%=sInsertTreeNode%>&GroupCustomerID=<%=groupCustomerID%>";
				OpenComp("GroupCustomerTree","/CustomerManage/GroupManage/GroupCustomerTree.jsp",sParam,"_self");
			}
		}
	}
</script>

<!-- ************************************************ -->
<!--                   ��ͼ����                                                              -->
<!-- ************************************************ -->
<script type="text/javascript"> 
//����ʵ����ʵ��ҵ���߼��߶ȹ�����javascript�߼�
    var sKeyMemberCustomerID="<%=sKeyMemberCustomerID%>";
    var table = null;
    var normalModel = true;
    $(document).ready(function() {
    	initTreeTable("<%=dwTree.getTableId()%>");
        //��������
        $("#searchText").keyup(function(){
            var text = $("#searchText").val();
            table.searchText({
                keyWord:text,             //����text����
                excludeColumn:"button"   //���ò���������
            });
        });
        //ģʽת����ť
        $("#normalAction").click(normalModelHandler);//����ģʽ
        $("#revisionAction").click(revisionModelHandler);//�޶�ģ��
        if(<%="modify".equals(showType)%>){//�޶�ģʽ
	        normalModelHandler();
        	revisionModelHandler();
        }else{//����ģʽ
	        normalModelHandler();
        }
        return;
    });
    //����ģʽ
    function normalModelHandler(){
        //������ʾ
        $("#normalAction").addClass("actived");
        $("#revisionAction").removeClass("actived");

        $("tbody tr",table).each(function(){
            $(this).removeClass("new changed removed");
            if($(this).getValue("REVISEFLAG")=="REMOVED"){
                $(this).hide();
                $(this).attr("hidden",true);
            }
        });
        //ɾ��������
        table.removeColumn({name:"button"});
        normalModel = true;
    }
    //�޶�ģʽ
    function revisionModelHandler(){
        //ֻ��ӵ������Ȩ�޲ſ����޸� 
    	  <% if(sRightType.equals("All")){%>
        //��Ӳ�����
        var buttonClass="newbutton";
        table.addExecuteColumn({
            headerText:"����",  //������
            name:"button",  //��ť������
            colClass:"noremoved",//��ť��ʹ�õ���ʽ����Ҫ����ȥ��ɾ��ʱ�����ӵ�ɾ����
            buttons:[
                    {buttonClass:buttonClass,text : "����",title:"����һ����Ա",execute : insertHandler}
                    ,{buttonClass:buttonClass,text : "�޸�",execute : editHandler,filter : editActionFilter}
                    ,{buttonClass:buttonClass,text : "ɾ��",title:"���Ϊɾ��",execute : deleteHandler,filter : deleteActionFilter}
                    ]
        });   
        <% }%>      
        //������ʾ
        $("#normalAction").removeClass("actived");
        $("#revisionAction").addClass("actived");
        
        $("tbody tr",table).each(function(){
            $(this).show();
            $(this).attr("hidden",false);//ȡ������
            if($(this).getValue("REVISEFLAG")=="NEW"){
                $(this).addClass("new");
            }else if($(this).getValue("REVISEFLAG")=="CHANGED"){
                $(this).addClass("changed");
            }if($(this).getValue("REVISEFLAG")=="REMOVED"){
                $(this).addClass("removed");
            }
        });
       //�޶���־
        normalModel = false;
    }

    //�༭��ť������ ɾ����ť
    function deleteActionFilter(tr){
        if(tr&&tr.attr&&(tr.attr("id")==sKeyMemberCustomerID)) return false;//���ڵ㲻��ɾ����ť
        else return true;
    }
    //��ʽ��Ա�����޸�
    function editActionFilter(tr){
        if(tr&&tr.attr&&(tr.attr("id")==sKeyMemberCustomerID|| tr.getValue("state")=="CHECKED"))return false;//���ڵ㡢��ʽ��Ա ֻ��ɾ�������ܱ༭���߳���
        else return true;
    }

	//�༭��ť������  ������ť
    function undoActionFilter(tr){
        if(tr&&tr.attr&&tr.attr("id")==sKeyMemberCustomerID) return false;//���ڵ㡢��ʽ��Ա���ܳ���
        else return true;
    }
    
    //�����½ڵ㣬�������ų�Ա
	function insertHandler(){
		var currentRow = $(this).parents("tr");
		var sRefVersionSeq ="<%=sRefVersionSeq%>";
		var sGroupID="<%=sGroupID%>";
		var parentId = currentRow.getValue("MEMBERCUSTOMERID");
		var status = currentRow.getValue("REVISEFLAG");
		if(status == "REMOVED"){
			alert("ɾ��״̬���޷������ӳ�Ա");
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

    //�༭���ų�Ա��Ϣ
    function editHandler(){
        var currentRow = $(this).parents("tr");
        var state = currentRow.getValue("REVISEFLAG");
        if(state=="REMOVED"){
            alert("��ǰ�ڵ�Ϊɾ��״̬���޷��༭");
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
	//ɾ�����ų�Ա
	function deleteHandler(){
		var currentRow = $(this).parents("tr"); 
		var sRefVersionSeq ="<%=sRefVersionSeq%>";
        var sGroupID="<%=sGroupID%>";
        var parentId = currentRow.getValue("MEMBERCUSTOMERID");
		var status = currentRow.getValue("REVISEFLAG");
		if(status == "REMOVED"){
			alert("ɾ��״̬���޷�����ɾ��");
			return;
		}
        var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.CheckSubMemberFamilyTree","subMemberExist","GroupId="+sGroupID+",ParentMemberID="+parentId+",VersionSeq="+sRefVersionSeq);
		 if(sReturn == "EXIST"){
			alert("�ó�Ա�´����ӽڵ㣬����ɾ���ӽڵ���ִ�д˲�����");
			return;
		 }
    	 if(!confirm("��ȷ��Ҫɾ���ó�Ա��"))return;
    	 var result = RunJavaMethod("com.amarsoft.app.als.customer.group.action.CheckSubMemberFamilyTree","deleteGroupFamilyMember","groupId="+sGroupID+",memberID="+parentId+",versionSeq="+sRefVersionSeq);
    	 if(result == "true"){
    		 AsControl.OpenPage("/CustomerManage/GroupManage/GroupCustomerTree.jsp","ShowType=modify","_self");
    	 }else{
    		 alert("ɾ��ʧ��");
    	 }
    }
</script>

<%@ include file="/IncludeEnd.jsp"%>