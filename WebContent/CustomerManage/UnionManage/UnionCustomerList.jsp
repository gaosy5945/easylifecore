<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerType = CurPage.getParameter("CustomerType");
	ASObjectModel doTemp = new ASObjectModel("UnionCustomerList");
	doTemp.setHtmlEvent("", "ondblclick", "viewAndEditByTab");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	//dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(CurUser.getUserID()+","+customerType);
	
	String sButtons[][] = {
			{"true","","Button","����","�����ͻ�Ⱥ","newRecord()","","","","",""},
			{"true","","Button","����","�ͻ�Ⱥ����","viewAndEditByTab()","","","","",""},
			{"true","","Button","ɾ��","ɾ���ͻ�Ⱥ","deleteRecord()","","","","",""},
			{"true","","Button","��Ч","�ͻ�Ⱥ��Ч","setGroupFlag('10')","","","","",""},
			{"true","","Button","ʧЧ","�ͻ�ȺʧЧ","setGroupFlag('20')","","","","",""}
		};
%> 
<script type="text/javascript">
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		var groupID = AsControl.PopComp("/CustomerManage/UnionManage/UnionRegisterTempInfo.jsp", "CustomerType=<%=customerType%>", "resizable=yes;dialogWidth=770px;dialogHeight=700px;center:yes;status:no;statusbar:no","");
		if(typeof(groupID) != "undefined" && groupID.length != 0){
	    	AsCredit.openFunction("CustomerDetail","CustomerID="+groupID,"");
			//openObject("Customer",groupID,"001");
			reloadSelf();
		}
	}
	
	/*~[Describe=�ͻ�Ⱥ����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEditByTab(){
		var groupID = getItemValue(0,getRow(),"GroupId");//�ͻ�Ⱥ���
		if (typeof(groupID)=="undefined" || groupID.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsCredit.openFunction("CustomerDetail","CustomerID="+groupID+"&PG_CONTENT_TITLE=show","");
		//openObject("Customer",groupID,"001");
		reloadSelf();	
	}
	
	/*~[Describe=ɾ����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var groupID = getItemValue(0,getRow(),"GroupID");//�ͻ�Ⱥ���
		if (typeof(groupID)=="undefined" || groupID.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		var managerUser = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction", "getManageUser", "unionID="+groupID);
		if(managerUser != "<%=CurUser.getUserID()%>"){
			alert("�ǹܻ����޷�ɾ���ͻ�Ⱥ!");
			return;
		}
		//���ͻ��Ƿ����δ�������;ҵ������
		var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.common.action.CustomerBusinessCheck","checkBusinessApply","customerID="+groupID);
		if(sReturn == "true"){
			alert("�ÿͻ�������;��ҵ�����룬�޷��޷�ɾ����");
			return;
		}
     	//���ͻ��Ƿ��δ������ɵ�����
		sReturn = RunJavaMethod("com.amarsoft.app.als.customer.common.action.CustomerBusinessCheck","checkBusinessApprove","customerID="+groupID);
		if(sReturn == "true"){
			alert("�ÿͻ�����δ������ɵ��������޷�ɾ����");
			return;
		}
     	//���ͻ��Ƿ����δ���Ǽ���ɡ��ĺ�ͬ
		sReturn = RunJavaMethod("com.amarsoft.app.als.customer.common.action.CustomerBusinessCheck","checkBusinessContract","customerID="+groupID);
		if(sReturn == "true"){
			alert("�ÿͻ�����δ���Ǽ���ɡ��ĺ�ͬ��");
			return;
		}
		if(confirm("ȷ��Ҫ����ѡ�ͻ�Ⱥ��Ϣɾ����")){
				var sReturnValue = RunJavaMethodTrans("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","deleteUnion","unionID="+groupID);
				if(sReturnValue == "true"){
				 	alert("�ͻ�Ⱥɾ���ɹ�!");
				 	reloadSelf();
				}else{
					alert("ɾ��ʧ�ܣ�");
				}
	 	}
	}
	
	/*~[Describe=�ͻ�ȺʧЧ/��Ч;InputParam=��;OutPutParam=��;]~*/
	function setGroupFlag(flag){
		var status = getItemValue(0,getRow(),"STATUS");//�ͻ�Ⱥ״̬
		var groupID = getItemValue(0,getRow(),"GroupID");//�ͻ�Ⱥ���
		
		if (typeof(groupID)=="undefined" || groupID.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		var managerUser = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction", "getManageUser", "unionID="+groupID);
		if(managerUser != "<%=CurUser.getUserID()%>"){
			alert("�ǹܻ����޷����Ŀͻ�Ⱥ״̬!");
			return;
		}
		if(flag == '10'){//��Ч
			if(status != '30'){//30Ϊ����Ч״̬
				alert("ֻ��[����Ч]״̬�Ŀͻ�Ⱥ���ܷ�����Ч��");
				return;
			}
			//�жϸÿͻ�Ⱥ�µĳ�Ա�Ƿ������������Ч�Ŀͻ�Ⱥ�У�������ڣ����ܰѸÿͻ�Ⱥ��Ϊ����Ч��
			var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","checkMember","unionID="+groupID);
			if(sReturn == 'true'){//����
				alert("�ÿͻ�Ⱥ�µĳ�Ա������������Ч�Ŀͻ�Ⱥ�У����ܽ�����Ч������");
				return;
			}else{//������
				var result = RunJavaMethodTrans("com.amarsoft.app.als.customer.union.action.UnionCustomerAction", "setUnionStatus", "unionID="+groupID+",status=10");
				if(result == "true"){
					alert("�ÿͻ�Ⱥ�ѳɹ���Ч��");
					reloadSelf();
				}
			}
		}else if(flag == '20'){//ʧЧ
			if(status != "10"){//10Ϊ��Ч״̬
				alert("ֻ��[��Ч]״̬�Ŀͻ�Ⱥ���ܷ���ʧЧ��");
				return;
			}
			//����Ƿ������;����ҵ������
			var result = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction", "checkUnionApply", "unionID="+groupID);
			if(result == "true"){
				alert("�ÿͻ�Ⱥ�´�����;����ҵ�����룬���ܽ���ʧЧ������");
				return;
			}
			
			if(confirm("�Ƿ�ȷ��ʧЧ�ÿͻ�Ⱥ��")){
				result = RunJavaMethodTrans("com.amarsoft.app.als.customer.union.action.UnionCustomerAction", "setUnionStatus", "unionID="+groupID+",status=20");
				if(result == "true"){
					alert("�ÿͻ�Ⱥ�ѳɹ�ʧЧ��");
					reloadSelf();
				}
			}
		}
	}
</script>
<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>