<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	//�������
	String sCurBranchOrg=""; //��ǰ�û����ڷ���
	String sUserID =CurUser.getUserID();
	String sOrgID=CurUser.getOrgID();
	String sCurBranchSortNo = ""; //��ǰ�û����ڷ��е�SortNo
	String sTempletNo = "GroupCustomerList";//ģ��
	String sRight="ReadOnly";
	String sRoleID="";

	//����������    ���ͻ�����
	String sCustomerType = CurComp.getParameter("CustomerType");
	if(sCustomerType == null) sCustomerType = "";
    	
   	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
    doTemp.setHtmlEvent("", "ondblclick", "viewGroupInfo");//���˫���鿴���鹦��

	
    doTemp.setJboWhere("CI.CustomerType='0210' and CI.CustomerID=O.GroupID");
    //000��ϵͳ����Ա��036�����м��ż��ײ�ѯ��
    //080: ���пͻ�����,280�����пͻ�����480��֧�пͻ����� 
    //236: ���м��ż��ײ�ѯ�ڣ�436��֧�м��ż��ײ�ѯ��
   	if(CurUser.hasRole("000")|| CurUser.hasRole("036")){
   		//�鿴ȫ�м���
   	}else if(CurUser.hasRole("080")|| CurUser.hasRole("280")|| CurUser.hasRole("480")){
   		doTemp.appendJboWhere(" and O.MgtOrgID=:orgID and O.MgtUserID=:userID");//�鿴��Ͻ�ڼ���
   	}else if(CurUser.hasRole("236")|| CurUser.hasRole("436")){
   		doTemp.appendJboWhere(" and O.InputOrgID=:orgID");//�鿴�����¼���
   	}
    
    //����DataWindow
    ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
    dwTemp.setPageSize(20); //������datawindows����ʾ������
    dwTemp.Style="1"; //����DW��� 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    
    //����HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sOrgID+","+sUserID);  

    String sButtons[][] = {
	    {"true","","Button","��������","��������","viewGroupInfo()","","","",""},
    };
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script language=javascript>
    /*~[Describe=���Ÿſ�;InputParam=��;OutPutParam=��;]~*/
	function viewGroupInfo(){
      	var sGroupID = getItemValue(0,getRow(),"GroupID");
      	if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
      	    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//�򿪼�������ҳ��
		AsCredit.openFunction("CustomerDetail","CustomerID="+sGroupID+"&RightType=ReadOnly","");
	    reloadSelf();	
	}  

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>