<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%><%
	String PG_TITLE = "��ɫ�б�";

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "RoleList";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);

	//���ӹ�����	
	doTemp.setColumnAttribute("RoleID,RoleName","IsFilter","1");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","������ɫ","����һ�ֽ�ɫ","newRecord()","","","",""},
		{"true","","Button","����","�鿴��ɫ���","viewAndEdit()","","","",""},
		{"true","","Button","ɾ��","ɾ���ý�ɫ","deleteRecord()","","","",""},
		{"true","","Button","��ɫ���û�","�鿴�ý�ɫ�����û�","viewUser()","","","",""},
		{"true","","Button","ϵͳȨ��","ϵͳȨ�޶���","my_AddMenu()","","","",""},
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
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
	
		sReturn=popComp("RoleInfo","/AppConfig/RoleManage/RoleInfo.jsp","RoleID="+sRoleID,"");
		//�޸����ݺ�ˢ���б�
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			reloadSelf();
		}
	}
	
	function deleteRecord(){
		var sRoleID = getItemValue(0,getRow(),"RoleID");
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getBusinessMessage("902"))){ //ɾ���ý�ɫ��ͬʱ��ɾ���ý�ɫ��Ӧ��Ȩ�ޣ�ȷ��ɾ���ý�ɫ��
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	<%/*~[Describe=����ɫ��Ȩ���˵�;]~*/%>
	function my_AddMenu(){
		var sRoleID = getItemValue(0,getRow(),"RoleID");
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		AsControl.OpenComp("/AppConfig/RoleManage/RoleRightTree.jsp","RoleID="+sRoleID,"_blank","");
	}
	
	<%/*[Describe=�鿴�ý�ɫ�����û�;]*/%>
	function viewUser(){
		var sRoleID = getItemValue(0,getRow(),"RoleID");
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0){
			alert(getMessageText('AWEW1001'));//��ѡ��һ����Ϣ��
			return;
		}
		PopPage("/AppConfig/RoleManage/ViewAllUserList.jsp?RoleID="+sRoleID,"","dialogWidth=700px;dialogHeight=540px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
	}
	
	function queryRole()
	{
		var roleID = getItemValue(0,getRow(),"RoleID");
        if(typeof(roleID)=="undefined" || roleID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
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