<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String PG_TITLE = "�ؼ���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������	��������ˮ�š��������͡������š�ҵ�����͡��ͻ����͡��ͻ�ID
	
	String templateNo = CurPage.getParameter("TemplateNo");
	
	//����ֵת���ɿ��ַ���
	if(templateNo == null) templateNo = "";	
	

	ASObjectModel doTemp = new ASObjectModel(templateNo,"");
	
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("SingleList", "<iframe type='iframe' id=\"SingleList\" name=\"SingleList\" width=\"100%\" height=\"150\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("CLList", "<iframe type='iframe' id=\"CLList\" name=\"CLList\" width=\"100%\" height=\"150\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
	
	
	String sButtons[][] = {
		{"true","","Button","����","����","saveRecord()","","","",""},	
	};
	sButtonPosition = "south";
	
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		//as_save("myiframe0");
		if(!iV_all("myiframe0"))return;
		var SingleSerialNo = window.frames["SingleList"].getValue();
		
		var CLFlag = getItemValue(0,getRow(),"CLFlag");
		
		if(typeof(SingleSerialNo) == "undefined" || SingleSerialNo.length == 0)
		{
			alert("δѡ�񵥱�ҵ����Ϣ��");
			return;
		}
		
		var CLSerialNo = "";
		if(CLFlag == "1")
		{
			CLSerialNo = window.frames["CLList"].getValue();
			if(typeof(CLSerialNo) == "undefined" || CLSerialNo.length == 0)
			{
				alert("δѡ������Ϣ��");
				return;
			}
		}
		
		var para = "";
		para+=getItemValue(0,getRow(),"SerialNo")+",";
		para+="<%=CurPage.getParameter("ApplyType")%>,";
		para+=SingleSerialNo+",";
		para+=getItemValue(0,getRow(),"OccurType")+",";
		para+=CLSerialNo+",";
		para+=getItemValue(0,getRow(),"ProductName")+",";
		para+=getItemValue(0,getRow(),"ProductID")+",";
		para+=getItemValue(0,getRow(),"CustomerID")+",";
		para+=getItemValue(0,getRow(),"CustomerType")+",";
		para+=getItemValue(0,getRow(),"CertType")+",";
		para+=getItemValue(0,getRow(),"CertID")+",";
		para+=getItemValue(0,getRow(),"CustomerName")+",";
		para+=getItemValue(0,getRow(),"CLFlag")+",";
		para+=getItemValue(0,getRow(),"CLNoFlag")+",";
		para+=getItemValue(0,getRow(),"BusinessPriority")+",";
		para+=getItemValue(0,getRow(),"NonstdIndicator")+",";
		
		para+="<%=CurUser.getUserID()%>,";
		para+="<%=CurUser.getOrgID()%>";
		
		var customer = AsControl.RunASMethod("BusinessManage","InitApplyCvtInfo",para);
		if(typeof(customer) == "undefined" || customer.length == 0 || customer.indexOf("@") == -1)
		{
			return;
		}
		else
		{
			var flag = customer.split("@")[0];
			if(flag == "error"){
				alert(customer.split("@")[1]);
				return;
			}
			else
			{
				var serialNo = customer.split("@")[1];
				var customerID = customer.split("@")[2];
				var functionID = customer.split("@")[3];
				var flowSerialNo = customer.split("@")[4];
				var taskSerialNo = customer.split("@")[5];
				var phaseNo = customer.split("@")[6];
				var msg = customer.split("@")[7];
				setItemValue(0,getRow(),"CustomerID",customerID);
				setItemValue(0,getRow(),"SerialNo",serialNo);
				if(flag == "true")
				{
					top.returnValue = flag+"@"+taskSerialNo+"@"+flowSerialNo+"@"+phaseNo+"@"+functionID;
					top.close();
				}
			}
			
		}
	}
	
	
	//���ݿͻ���Ϣ��ʾ����ҵ����Ϣ�Ͷ����Ϣ
	function selectCustomer()
	{
		var returnValue = AsControl.PopView("/CreditManage/CreditApply/SelectCustomerInfo.jsp","","_self");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue == "false"){
			return;
		}else{
			setItemValue(0, getRow(0), "CustomerID", returnValue.split("@")[1]);
			setItemValue(0, getRow(0), "CustomerName", returnValue.split("@")[2]);
			setItemValue(0, getRow(0), "CertType", returnValue.split("@")[3]);
			setItemValue(0, getRow(0), "CertID", returnValue.split("@")[4]);
			setItemValue(0, getRow(0), "CustomerType", returnValue.split("@")[5]);
		}
		var customerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(customerID) == "undefined" || customerID.length == 0) return;
		
		AsControl.OpenPage("/CreditManage/CreditApply/CustomerCreditList.jsp","TemplateNo=SingleBusinessList&CustomerID="+customerID,"SingleList");
		selectCLInfo();
	}
	
	function selectCLInfo()
	{
		var CLFlag = getItemValue(0,getRow(),"CLFlag");
		if(CLFlag == "1")
		{
			var customerID = getItemValue(0,getRow(),"CustomerID");
			if(typeof(customerID) == "undefined" || customerID.length == 0) return;
			var obj_dw = document.getElementById('A_Group_020');
			if(typeof(obj_dw) == "undefined" || obj_dw == null) return;
			obj_dw.style.display = "";
			AsControl.OpenPage("/CreditManage/CreditApply/CustomerCreditList.jsp","TemplateNo=CLBusinessList&CustomerID="+customerID,"CLList");
			setItemRequired("myiframe0","CLNoFlag",true);
		}
		else
		{
			var obj_dw = document.getElementById('A_Group_020');
			if(typeof(obj_dw) == "undefined" || obj_dw == null) return;
			obj_dw.style.display = "none";
			setItemRequired("myiframe0","CLNoFlag",false);
		}
	}
	
	selectCLInfo();
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>