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
	String sExternDataType = CurPage.getParameter("ExternDataType") + "";
	String listTempletNo = CurPage.getParameter("DoListTemplet") + ""; //�б�ģ����
	String sSql = "";	
	String sCertId = "";
	String sViewCustomerRight = "true";
	
	if("1010".equals(sExternDataType)) sCertId = "PartyCardNum";
	else if("1020".equals(sExternDataType)) sCertId = "CardnNum";
	else if("1030".equals(sExternDataType)) sCertId = "Identity";
	else if("1040".equals(sExternDataType)) sViewCustomerRight = "false";
	else if("1050".equals(sExternDataType)) sCertId = "Merchant_Code";
	else if("1060".equals(sExternDataType)) sCertId = "Identity";
	else if("1070".equals(sExternDataType)) sViewCustomerRight = "false";
	else if("1080".equals(sExternDataType)) sCertId = "IdcardCode";
	 
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
	Vector vTemp = dwTemp.genHTMLDataWindow(sExternDataType);//������ʾģ�����
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
		   {sViewCustomerRight,"","Button","�ͻ�����","�鿴�ͻ�����","viewCustomerInfo()","","","",""}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�鿴�ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function viewCustomerInfo(){
		var sCertId = getItemValue(0,getRow(),"<%=sCertId%>");
		var customerID;
		var customerType;
		
		if(typeof(sCertId)!="undefined"&&sCertId!=null){
// 			var sColName = "CustomerId@CustomerName";
// 			var sTableName = "CUSTOMER_INFO";
// 			var sWhereClause = "String@CertID@"+sCertId+"@String@CertType@1";
			
// 			var sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.GetColValue","getColValue","colName="+sColName + ",tableName=" + sTableName + ",whereClause=" + sWhereClause);
			
			 //��ÿͻ���ż��ͻ�����
	        var sColName = "CustomerId@CustomerType";
			var sTableName = "CUSTOMER_INFO";
			var sWhereClause = "String@CertID@"+sCertId+"@String@CertType@1";
			
			var sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.GetColValue","getColValue","colName="+sColName + ",tableName=" + sTableName + ",whereClause=" + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") {
				sReturn = sReturn.split('~');
				var my_array1 = new Array();
				for(i = 0;i < sReturn.length;i++){
					my_array1[i] = sReturn[i];
				}
				
				for(j = 0;j < my_array1.length;j++){
					sReturnInfo = my_array1[j].split('@');	
					var my_array2 = new Array();
					for(m = 0;m < sReturnInfo.length;m++){
						my_array2[m] = sReturnInfo[m];
					}
					
					for(n = 0;n < my_array2.length;n++){
						//���ÿͻ����
						if(my_array2[n] == "customerid")
							customerID = sReturnInfo[n+1];
						//���ÿͻ�����
						if(my_array2[n] == "customertype")
							customerType = sReturnInfo[n+1];
					}
				}	
				if(typeof(customerID)=="undefined" || customerID.length==0){
					alert("�����޸ÿͻ���Ϣ��");
					return;
				}
				CustomerManage.viewCustomer(customerID,customerType);
				return;
			}
		}
		else{
			alert("��ѡ��һ����¼��");
		}
	}
	</script>
<%/*~END~*/%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
