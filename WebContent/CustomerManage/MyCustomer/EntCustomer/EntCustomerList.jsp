<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "��ҵ�ͻ���Ϣ�б�";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	String sInputUserId = CurUser.getUserID();
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));//�ͻ�����
	if(sCustomerType==null) sCustomerType="";
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "EntCustomerList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	doTemp.multiSelectionEnabled=true;
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and CI.InputUserId = '"+sInputUserId+"'";
	doTemp.setHTMLStyle("ondblclick", "viewCustomer");
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6����ݼ�	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","��ҵ�ͻ�����","��ҵ�ͻ�����","newCustomer()","","","","",""},
			{"true","All","Button","��ҵ�ͻ�����","��ҵ�ͻ�����","viewCustomer()","","","","",""},
			{"true","All","Button","��ҵ�ͻ�ɾ��","��ҵ�ͻ�ɾ��","delete()","","","","",""},
			{"true","All","Button","��ѯECIF��","��ѯECIF��","selectECIF()","","","","",""},
			};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	//��ҵ�ͻ�����
	function newCustomer(){
		var sCustomerType = "<%=sCustomerType%>";
	    AsControl.PopComp("/CustomerManage/MyCustomer/EntCustomer/NewCustomer.jsp","CustomerType="+sCustomerType,"resizable=yes;dialogWidth=500px;dialogHeight=400px;center:yes;status:no;statusbar:no");
	}

	//��ҵ�ͻ���Ϣ����
	function viewCustomer(){
		var sCustomerID = getItemValue(0,getRow(0),"CUSTOMERID");
		var sCustomerName = getItemValue(0,getRow(0),"CUSTOMERNAME");
		if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("��ѡ��һ����Ϣ��");
		}else{
			AsCredit.openFunction("EntCustomerTree","CustomerID="+sCustomerID+"&CustomerName="+sCustomerName);
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
