<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		ҳ��˵��: ���������б�
	 */
	String PG_TITLE = "���������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//��ȡ�������
	String sOrgID = CurPage.getParameter("OrgID");
	if(sOrgID == null) sOrgID = "";
	String sSortNo = (new ASOrg(sOrgID, Sqlca)).getSortNo();
	if(sSortNo==null)sSortNo="";

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "OrgList";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
    //���ӹ�����	
	doTemp.setColumnAttribute("OrgID,OrgName","IsFilter","1");
	    
    ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(200);

	//��������¼�
	//dwTemp.setEvent("AfterDelete","!SystemManage.DeleteOrgBelong(#OrgID)");
	
	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sSortNo+"%");

	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()","","","",""},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()","","","",""},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","",""},
		{"true","","Button","��ʼ������Ȩ��","��ʼ������Ȩ��","initialOrgBelong()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
        OpenPage("/AppConfig/OrgUserManage/OrgInfo.jsp","_self","");            
	}
	
	function viewAndEdit(){
        var sOrgID = getItemValue(0,getRow(),"OrgID");
        if(typeof(sOrgID)=="undefined" || sOrgID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		OpenPage("/AppConfig/OrgUserManage/OrgInfo.jsp?CurOrgID="+sOrgID,"_self","");        
	}
    
	/*~[Describe=��ʼ������Ȩ��;InputParam=��;OutPutParam=��;]~*/
	function initialOrgBelong(){
		if(confirm("��ȷ����ʼ������Ȩ����")){
			var returnValue = PopPage("/AppConfig/OrgUserManage/InitialOrgBelongAction.jsp","","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
			if("true"==returnValue)
			{
				alert("��ʼ������Ȩ�޳ɹ���") ;
			}else{
				alert("��ʼ������Ȩ��ʧ�ܣ�") ;
			}
		}
	}
	
	function deleteRecord(){
		var sOrgID = getItemValue(0,getRow(),"OrgID");
        if(typeof(sOrgID) == "undefined" || sOrgID.length == 0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))){ //�������ɾ������Ϣ��
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			if(parent.reloadView){
				parent.reloadView();
			}
		}
	}
	
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>