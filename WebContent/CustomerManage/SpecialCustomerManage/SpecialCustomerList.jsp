<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Describe: �ͻ���������
		Input Param:
		Output Param:
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ���������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//���������SQL���
	String specialCustomerType = CurPage.getParameter("SpecialCustomerType");
	String listTempletNo = CurPage.getParameter("DoListTemplet"); //�б�ģ����
	String infoTempletNo = CurPage.getParameter("DoInfoTemplet"); //�б�ģ����
	String importTemplet = CurPage.getParameter("ImportTemplet");
	String sSql = "";	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletFilter = "1=1"; //�й�������ע�ⲻҪ�����ݹ���������

	ASDataObject doTemp = new ASDataObject(listTempletNo);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(25);//25��һ��ҳ

	//��������¼�
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(specialCustomerType);//������ʾģ�����
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��

	String sButtons[][] = {
		   {"true","","Button","����","����","my_add()","","","",""},
		   {"true","","Button","����","�鿴����������","viewAndEdit()","","","",""},
		   {"true","","Button","�ͻ�����","�鿴�ͻ�����","viewCustomerInfo()","","","",""},
		   {"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'')","","","",""},
		   {"true","","Button","��������","��������","importData()","","","",""}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function my_add()
	{ 	 
	    	OpenPage("/CustomerManage/SpecialCustomerManage/SpecialCustInfo.jsp?DoInfoTemplet=<%=infoTempletNo%>","_self","");
		reloadSelf();
	}	                                                                                                                                                                                                                                                                                                                                                 

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
				OpenPage("/CustomerManage/SpecialCustomerManage/SpecialCustInfo.jsp?SerialNo="+sSerialNo+",DoInfoTemplet=<%=infoTempletNo%>", "_self","");
			reloadSelf();
		}
	}		
	function importData(){
		var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
		var parameter = "SpecialCustomerType=<%=specialCustomerType%>&clazz=jbo.import.excel.<%=importTemplet%>"; 
		var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
		var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
		if(typeof(sReturn) != "undefined" && sReturn != "")
		    {
		    	reloadSelf();
		    }
	}

	function viewCustomerInfo(){
		var customerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(customerID)!="undefined"&&customerID!=null){
			var re = RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.HasCustomerInfo", "hasCustOrNot", "customerID="+customerID+"");
			if(re=="SUCCEEDED"){
		    	AsCredit.openFunction("CustomerDetail","CustomerID="+customerID,"");
				//openObject("Customer",customerID,"003");
				return ;
			}
			alert("�����޸ÿͻ���Ϣ��");
		}
		else{
			alert("�����޸ÿͻ���Ϣ��");
		}
	}
	</script>
<%/*~END~*/%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
