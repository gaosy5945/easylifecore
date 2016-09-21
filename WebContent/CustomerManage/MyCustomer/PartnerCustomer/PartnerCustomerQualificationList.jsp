<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	String listType = CurPage.getParameter("ListType");
	if(listType == null) listType = "";
	String IsBlackList = Sqlca.getString(new SqlObject("select listType from customer_list where CUSTOMERID =:CustomerID").setParameter("CustomerID",customerID));
	
	ASObjectModel doTemp = new ASObjectModel("PCQualificationList");
	//��listTypeȡ��������������á��Ƿ���������ֶε�ȡֵΪ1������Ϊ0
	//����listType�Ĳ�ͬ�����ò�ͬ���ֶ���ʾ
	if("00".equals(listType.substring(0, 2))&&!"0001".equals(listType)&&!"0004".equals(listType)&&!"0010".equals(listType)){
		doTemp.setColumnAttribute("CERTNAME", "colheader", "��Ӫ����");
		doTemp.setColumnAttribute("VALIDDATE", "colheader", "��Ӫ������Ч����");
	}else if("0004".equals(listType)){//����������ֶδ���
		doTemp.setColumnAttribute("CERTNAME", "colheader", "��ӪƷ��");
		doTemp.setVisible("CERTTYPE", true);
		doTemp.setColumnAttribute("VALIDDATE", "colheader", "��Ӫ������Ч����");
	}else if("0010".equals(listType)){//��֤��������ֶδ���
		
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("CustomerID", customerID);
	dwTemp.genHTMLObjectWindow(customerID);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var listType = "<%=listType%>";
		AsControl.PopComp("/CustomerManage/MyCustomer/PartnerCustomer/PartnerCustomerQualificationInfo.jsp","CustomerID=<%=customerID%>"+"&InsertFlag=1"+"&ListType="+listType,"resizable=yes;dialogWidth=550px;dialogHeight=450px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var listType = "<%=listType%>";
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		AsControl.PopComp("/CustomerManage/MyCustomer/PartnerCustomer/PartnerCustomerQualificationInfo.jsp","SerialNo="+serialNo+"&ListType="+listType,"resizable=yes;dialogWidth=550px;dialogHeight=450px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	function del(){
			var serialNo = getItemValue(0,getRow(),"SerialNo");
			if (typeof(serialNo) == "undefined" || serialNo.length == 0){
			    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			    return;
			}
			if(confirm('ȷʵҪɾ����?')){
				as_delete(0);
			}
	}
	function initRow(){
		IsBlackList="<%=IsBlackList%>";
		<%if(IsBlackList.substring(0, 2).equals("70") && IsBlackList.length()>2){%>
			setItemValue(0,0,"ISBLACKLIST","1");
		<%}else{%>
        	setItemValue(0,0,"ISBLACKLIST","0");
		<%}%>
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
