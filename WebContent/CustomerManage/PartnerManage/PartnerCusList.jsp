<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%		
	//��ȡ����
	String partnerType = CurPage.getParameter("PartnerType");

	ASObjectModel doTemp = new ASObjectModel("PartnerList");
    doTemp.setHtmlEvent("", "ondblclick", "viewAndEdit");//���˫���鿴���鹦��

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(partnerType +"," + CurUser.getUserID());
	
	String sButtons[][] = {
			 {"true","","Button","������ע��","������ע��","newRecord()","","","","btn_icon_add"},
			 {"true","","Button","�鿴����","�鿴����","viewAndEdit()","","","","btn_icon_detail"},
			 {"true","","Button","�Ƴ��������ͻ�","�Ƴ��������ͻ�","roMove()","","","","btn_icon_delete"},
			 {"false","","Button","�ͻ���Ϣ��ѯ","�ͻ���Ϣ��ѯ","selectCust()","","","","btn_icon_detail"},
		};
%> 
<script type="text/javascript">

	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){	
		var size = "resizable=yes;dialogWidth=26;dialogHeight=23;center:yes;status:no;statusbar:no";
		var returnValue = AsControl.PopComp("/CustomerManage/PartnerManage/PartnerCusInfo.jsp","PartnerType=<%=partnerType%>","dialogWidth=450px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(returnValue)=="undefined" || returnValue == "_CALCEL_"){
			return ;	
		}
		reloadSelf();
	}
	
	 /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
   	function viewAndEdit(){
   		var customerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(customerID) == "undefined" || customerID.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
    	AsCredit.openFunction("CustomerDetail","CustomerID="+customerID+"&PG_CONTENT_TITLE=show","");
   		//openObject("Customer",customerID,"001");
   		OpenPage("/CustomerManage/PartnerManage/PartnerCusList.jsp?PartnerType=<%=partnerType%>","_self");
    }

 	//�ͻ���ѯ
    function selectCust(){
    	popComp("SelectCustInfo","/CustomerManage/SelectCustInfo.jsp","","dialogWidth=40;dialogHeight=20;");
    } 
    
    /*~[Describe=�Ƴ��ͻ���Ϣ;InputParam=CustomerID,ObjectType=;OutPutParam=��;]~*/
    function roMove(){	
        var customerID = getItemValue(0,getRow(),"CustomerID");
        if (typeof(customerID) == "undefined" || customerID.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
        
        if(confirm(getHtmlMessage('2'))){ //�������ɾ������Ϣ��
	    	var returnValue = RunJavaMethod("com.amarsoft.app.als.customer.partner.action.CustomerOperate","removePartner","customerID="+customerID);
	    	if(returnValue=="1"){
				alert("�Ƴ��ͻ��ɹ�");
		    	reloadSelf();
	        }else if(returnValue =="2"){
	        	alert("�˺������ͻ�������Ŀ��Ϣ�����Ƴ�");
	        	return;
	        }
        }
     }		
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
