<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String limitType = CurPage.getParameter("LimitType");
	if(limitType==null)limitType="";
	String businesstype ="";
	if("LimitGuaranty".equals(limitType))businesstype="3040";
	if("LimitProject".equals(limitType))businesstype="3050";
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo==null)serialNo="";
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID==null)customerID="";
	
	ASObjectModel doTemp = new ASObjectModel("ProjectLimitList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo +"," + limitType);
	
	String sButtons[][] = {
			{"true","","Button","������","������","add()","","","","btn_icon_add",""},
			{"true","","Button","�������","�鿴����","openWithObjectViewer()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ�����","ɾ�����","deleteRecord()","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	/*������*/
	function add(){
		if(getRowCount(0)!="0")
		{
			alert("ֻ������һ����ȡ�");
			return;
		}
		var sParaString = "customerID"+","+"<%=customerID%>"+","+"businesstype"+"," + "<%=businesstype%>";
		var returnValue = setObjectValue("SelectLimitContract",sParaString,"",0,0,"");
		if(typeof(returnValue)=="undefined"||returnValue==""||returnValue=="_CLEAR_"){return;}
		returnValue = returnValue.split("@");
		var param = "objectNo=<%=serialNo%>,accessoryNo=" + returnValue[0] + ",accessoryType=<%=limitType%>";
		var flag = RunJavaMethod("com.amarsoft.app.als.customer.partner.action.ProjectRelativeAction","initRelative",param);
		if(flag == "true")
		{
			alert("����ɹ���");
			reloadSelf();
		}else
		{
			alert("����ʧ�ܡ�");
		}
	}
	/*ɾ����¼*/
	function deleteRecord(){
		as_delete(0);
	}
	
	/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function openWithObjectViewer()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}		
		//PopComp("CreditLineAccountInfo","/CreditManage/CreditLine/CreditLineAccountInfo.jsp","SerialNo="+sSerialNo,"","");
		openObject("BusinessContract",sSerialNo,"002");
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
