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
	String sButtons[][] = {
		{"true","","Button","����","����","saveRecord()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		//as_save(0);
		if(!iV_all("myiframe0"))return;
		var para = "";
		
		para+=getItemValue(0,getRow(),"SerialNo")+",";
		para+=getItemValue(0,getRow(),"PartnerSerialNo")+",";
		para+=getItemValue(0,getRow(),"ProjectName")+",";
		para+=getItemValue(0,getRow(),"ProjectType")+",";
		para+=getItemValue(0,getRow(),"PartnerName")+",";
		para+=getItemValue(0,getRow(),"CustomerID")+",";
		para+=getItemValue(0,getRow(),"AdjustType")+",";
		para+=getItemValue(0,getRow(),"AdjustType")+",";
		para+="<%=CurUser.getUserID()%>,";
		para+="<%=CurUser.getOrgID()%>";

		var customer = AsControl.RunASMethod("ProjectManage","InitProjectAlterApplyInfo",para);
		if(typeof(customer) == "undefined" || customer.length == 0 || customer.indexOf("@") == -1)
		{
			return;
		}
		else
		{
			var flag = customer.split("@")[0];
			var serialNo = customer.split("@")[1];
			var customerID = customer.split("@")[2];
			var functionID = customer.split("@")[3];
			var flowSerialNo = customer.split("@")[4];
			var taskSerialNo = customer.split("@")[5];
			var msg = customer.split("@")[6];
			setItemValue(0,getRow(),"CustomerID",customerID);
			setItemValue(0,getRow(),"SerialNo",serialNo);
			alert(msg);
			if(flag == "true")
			{
				top.returnValue = flag+"@"+taskSerialNo+"@"+flowSerialNo+"@"+functionID;
				top.close();
			}
		}
	}
	
	//ѡ��Ҫ����ĺ���ϵ��Ŀ
	function selectProject(){
		var sParaString = "UserID"+","+AsCredit.userId;	   
		setObjectValue("SelectPartnerProject",sParaString,"@ProjectSerialNo@0@ProjectType@1@CustomerID@2@ProjectName@3@PartnerName@4",0,0,"");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>