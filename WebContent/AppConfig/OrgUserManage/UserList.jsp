<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		ҳ��˵��: �û������б�
	 */
	String PG_TITLE = "�û������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//��ȡ�������
	String sOrgID = CurPage.getParameter("OrgID");
	if(sOrgID == null) sOrgID = "";
	String sSortNo = (new ASOrg(sOrgID, Sqlca)).getSortNo();
	if(sSortNo==null)sSortNo="";
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "UserList_1";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
    //filter��������
    doTemp.setColumnAttribute("BelongOrgName,UserName,UserID","IsFilter","1");

    ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(20);
	
	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sSortNo);
	
	String sButtons[][] = {
            {"true","","Button","����","�ڵ�ǰ������������Ա","my_add()","","","",""},			
            {"true","","Button","����","�鿴�û�����","viewAndEdit()","","","",""},
            {"false","","Button","�û���Դ","�鿴�û���Ȩ��Դ","viewResources()","","","",""},
            {"true","","Button","�û���ɫ","�鿴�����޸���Ա��ɫ","viewAndEditRole()","","","",""},
            {"true","","Button","�������½�ɫ","�������½�ɫ","my_Addrole()","","","",""},
			{"true","","Button","���û����½�ɫ","���û����½�ɫ","MuchAddrole()","","","",""},
            {"true","","Button","ת��","ת����Ա����������","UserChange()","","","",""},                       
            {"true","","Button","��ʼ����","��ʼ�����û�����","ClearPassword()","","","",""},
        };
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function my_add(){
		OpenPage("/AppConfig/OrgUserManage/UserInfo.jsp","_self","");
	}
	
	function viewAndEdit(){
		var sUserID = getItemValue(0,getRow(),"UserID");
		if (typeof(sUserID)=="undefined" || sUserID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			OpenPage("/AppConfig/OrgUserManage/UserInfo.jsp?UserID="+sUserID,"_self","");
		}
	}
	
	/*~[Describe=�鿴�û���Ȩ��Դ;InputParam=��;OutPutParam=��;]~*/
	function viewResources(){
		var sUserID = getItemValue(0,getRow(),"UserID");
		if(typeof(sUserID)=="undefined" || sUserID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			AsControl.PopView("/AppConfig/OrgUserManage/ViewUserResources.jsp","UserID="+sUserID,"");
		}
	}

	<%/*~[Describe=�鿴�����޸���Ա��ɫ;]~*/%>
	function viewAndEditRole(){
        var sUserID=getItemValue(0,getRow(),"UserID");
        if(typeof(sUserID)=="undefined" ||sUserID.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        }else{
        	var sStatus=getItemValue(0,getRow(),"Status");
        	if(sStatus!="1")
        		alert(sUserID+"�������û����޷��鿴�û���ɫ��");
        	else
            	sReturn=popComp("UserRoleList","/AppConfig/OrgUserManage/UserRoleList.jsp","UserID="+sUserID,"");
        }    
    }
    
    <%/*~[Describe=�������½�ɫ;]~*/%>    
    function my_Addrole(){
	    var sUserID=getItemValue(0,getRow(),"UserID");
 		if(typeof(sUserID)=="undefined" ||sUserID.length==0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    	}else{
        	var sStatus=getItemValue(0,getRow(),"Status");
        	if(sStatus!="1")
        		alert(sUserID+"�������û����޷��������½�ɫ��");
        	else
        		PopPage("/AppConfig/OrgUserManage/AddUserRole.jsp?UserID="+sUserID,"","dialogWidth=550px;dialogHeight=350px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
    	}
	}
	
	<%/*~[Describe=���û����½�ɫ;]~*/%>
	function MuchAddrole(){
		var sUserID=getItemValue(0,getRow(),"UserID");
 		if(typeof(sUserID)=="undefined" ||sUserID.length==0){ 
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    	}else{
    		var sStatus=getItemValue(0,getRow(),"Status");
        	if(sStatus!="1")
        		alert(sUserID+"�������û����޷����û����½�ɫ��");
        	else
        		PopPage("/AppConfig/OrgUserManage/AddMuchUserRole.jsp?UserID="+sUserID,"","dialogWidth=550px;dialogHeight=600px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
		}
	}

	<%/*~[Describe=ת����Ա����������;]~*/%>
	function UserChange(){
        var sUserID = getItemValue(0,getRow(),"UserID");
        var sFromOrgID = getItemValue(0,getRow(),"BelongOrg");
        var sFromOrgName = getItemValue(0,getRow(),"BelongOrgName");
        if(typeof(sUserID)=="undefined" ||sUserID.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        }else{
            //��ȡ��ǰ�û�
			sOrgID = "<%=CurOrg.getOrgID()%>";
			sParaStr = "OrgID,"+sOrgID;
			sOrgInfo = setObjectValue("SelectBelongOrg",sParaStr,"",0,0);	
		    if(sOrgInfo == "" || sOrgInfo == "_CANCEL_" || sOrgInfo == "_NONE_" || sOrgInfo == "_CLEAR_" || typeof(sOrgInfo) == "undefined"){
			    if( typeof(sOrgInfo) != "undefined"&&sOrgInfo != "_CLEAR_")alert(getBusinessMessage('953'));//��ѡ��ת�ƺ�Ļ�����
			    return;
		    }else{
			    sOrgInfo = sOrgInfo.split('@');
			    sToOrgID = sOrgInfo[0];
			    sToOrgName = sOrgInfo[1];
			    
			    if(sFromOrgID == sToOrgID){
					alert(getBusinessMessage('954'));//��������Աת����ͬһ�����н��У�������ѡ��ת�ƺ������
					return;
				}
				//����ҳ�����
				sReturn = AsControl.RunJsp("/AppConfig/OrgUserManage/UserShiftActionAjax.jsp","UserID="+sUserID+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&ToOrgID="+sToOrgID+"&ToOrgName="+sToOrgName); 
				if(sReturn == "TRUE"){
	                alert(getBusinessMessage("914"));//��Աת�Ƴɹ���
	                reloadSelf();           	
	            }else if(sReturn == "FALSE"){
	                alert(getBusinessMessage("915"));//��Աת��ʧ�ܣ�
	            }
			}
		}
	}
	
	<%/*~[Describe=������Ա����ǰ����;]~*/%>
	function my_import(){
       sParaString = "BelongOrg"+","+"<%=sOrgID%>";		
		sUserInfo = setObjectValue("SelectImportUser",sParaString,"",0,0,"");
		if(typeof(sUserInfo) != "undefined" && sUserInfo != "" && sUserInfo != "_NONE_" && sUserInfo != "_CANCEL_" && sUserInfo != "_CLEAR_"){
       		sInfo = sUserInfo.split("@");
	        sUserID = sInfo[0];
	        sUserName = sInfo[1];
	        if(typeof(sUserID) != "undefined" && sUserID != ""){
	        	if(confirm(getBusinessMessage("912"))){ //��ȷ������ѡ��Ա���뵽����������
        			var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.orguser.action.UserManageAction","addUser","UserID="+sUserID+",OrgID=<%=sOrgID%>");
					if(sReturn == "SUCCESS"){
		        		alert(getBusinessMessage("913"));//��Ա����ɹ���
		        		reloadSelf();
	        		}
	        	}else{
	        		alert("��Աת��ʧ��!");
	        	}
	        }
       	}
	}

	<%/*~[Describe=�ӵ�ǰ������ɾ������Ա;]~*/%>
	function my_disable(){
		var sUserID = getItemValue(0,getRow(),"UserID");
		if(typeof(sUserID) == "undefined" || sUserID.length == 0){
			alert(getMessageText('AWEW1001'));//��ѡ��һ����Ϣ��
		}else if(confirm("�������ͣ�ø��û���")){
            var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.orguser.action.UserManageAction","disableUser","UserID="+sUserID);
            if(sReturn == "SUCCESS"){
			    alert("��Ϣͣ�óɹ���");
			    reloadSelf();
			}
		}
	}

	<%/*~[Describe=�����û�;]~*/%>
	function my_enable(){
		var sUserID = getItemValue(0,getRow(),"UserID");
		if(typeof(sUserID) == "undefined" || sUserID.length == 0){
			alert(getMessageText('AWEW1001'));//��ѡ��һ����Ϣ��
		}else if(confirm("����������ø��û���")){
            var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.orguser.action.UserManageAction","enableUser","UserID="+sUserID);
            if(sReturn == "SUCCESS"){
			    alert("��Ϣ���óɹ���");
			    reloadSelf();
			}
		}
	}
	
	<%/*~[Describe=��ʼ���û�����;]~*/%>
	function ClearPassword(){
        var sUserID = getItemValue(0,getRow(),"UserID");
        var sInitPwd = "000000als";
        if (typeof(sUserID)=="undefined" || sUserID.length==0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getBusinessMessage("916"))){ //��ȷ��Ҫ��ʼ�����û���������
		    var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.orguser.action.ClearPasswordAction","initPWD","UserID="+sUserID+",InitPwd="+sInitPwd);
			if(sReturn == "SUCCESS"){
			    alert(getBusinessMessage("917"));//�û������ʼ���ɹ���
			    reloadSelf();
			}else{
				alert("�û������ʼ���ɹ���");
			}
		}
	}
	
	function queryUser()
	{
		var userID = getItemValue(0,getRow(),"UserID");
        if(typeof(userID)=="undefined" || userID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
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