<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		ҳ��˵��:�˵�����ҳ��
	*/
	//��ò���	
	String sMenuID =  CurPage.getParameter("MenuID");
	if(sMenuID==null) sMenuID="";

	ASObjectModel doTemp = new ASObjectModel("MenuInfo");
	//�����Ϊ����ҳ�棬�������ID�����޸�
	if(sMenuID.length() != 0 ){
		doTemp.setReadOnly("MenuID",true);
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setRightType(); //����Ȩ��
	dwTemp.genHTMLObjectWindow(sMenuID);

	String sButtons[][] = {
		{"true","All","Button","����","","saveRecord()","","","",""},
		{"true","All","Button","���ÿɼ���ɫ","","selectMenuRoles()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	function saveRecord(){
		if(bIsInsert){
			//if(!validate()) return;
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0","afterOpen()"); //ˢ��treeʹ��
	}
	
	function afterOpen(){
		parent.OpenMenuTree(getItemValue(0,0,"SortNo"));
	}
	
	<%/*~[Describe=ѡ��˵��ɼ���ɫ;InputParam=��;OutPutParam=��;]~*/%>
	function selectMenuRoles(){
		var sMenuID=getItemValue(0,0,"MenuID");
		var sMenuName=getItemValue(0,0,"MenuName");
		AsControl.PopView("/AppConfig/MenuManage/SelectMenuRoleTree.jsp","MenuID="+sMenuID+"&MenuName="+sMenuName,"dialogWidth=440px;dialogHeight=500px;center:yes;resizable:no;scrollbars:no;status:no;help:no");
	}
	
	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputOrgName","<%=CurUser.getOrgName()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurUser.getOrgName()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
    
    function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		initRow();
	});
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>