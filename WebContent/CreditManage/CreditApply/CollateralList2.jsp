<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "ѺƷѡ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	String flag = CurPage.getParameter("Flag");// 02 �ظ�ѺƷ  03 �����ظ�ѺƷ

	if("02".equals(flag)) PG_TITLE = "�ظ�ѺƷѡ���б�";
	else if("03".equals(flag)) PG_TITLE = "�����ظ�ѺƷѡ���б�";
	
	String sno = "";
	String serialNos = CurPage.getParameter("SerialNos");//�����ظ�ѺƷ��ţ��ԡ�,���ָ�
	if(serialNos == null) serialNos = "";
	String collNo[] = serialNos.split(",");//ѺƷϵͳѺƷ���
	for(int i = 0;i < collNo.length;i++){
		sno += "'";
		sno += collNo[i];
		sno += "',";
	}
	
	String collNames = CurPage.getParameter("CollNames");
	String collTypes = CurPage.getParameter("CollTypes");
	String collVals = CurPage.getParameter("CollVals");
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("CollateralList2", inputParameter, CurPage, request);
	
	ASDataObject doTemp = dwTemp.getDataObject();
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "1";	 //�༭ģʽ
	doTemp.setBusinessProcess("com.amarsoft.app.als.guaranty.model.CollateralProcessor");
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","All","Button","����","����","view()","","","",""},
			{"true","All","Button","����","����","updateColl()","","","",""},
			{"true","All","Button","ȡ��","ȡ��","closePage()","","","",""},
	};
	//sButtonPosition = "south";
%> 
<title><%=PG_TITLE%></title>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function view(){
		var clrID = getItemValue(0,getRow(0),"SerialNo");
		var clrTypeId = getItemValue(0,getRow(0),"CollType");
		if(typeof(clrID)=="undefined" || clrID.length == 0){
			alert("��ѡ��һ����¼��");
			return;
		}
		window.showModalDialog("<%=com.amarsoft.app.oci.OCIConfig.getProperty("GuarantyURL","")%>/ClrAssetManage/PublicService/ClrAssetRedirector.jsp?ClrID="+clrID+"&ClrTypeId="+clrTypeId,"","dialogWidth="+screen.availWidth+"px;dialogHeight="+screen.availHeight+"px;resizable=yes;maximize:yes;help:no;status:no;");
	}

	function closePage(){
		self.close();
	}
	
	function updateColl(){
		var clrSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(clrSerialNo)=="undefined" || clrSerialNo.length == 0){
			alert("��ѡ��һ����¼��");
			return;
		}
		var name = getItemValue(0,getRow(),"CollName");
		if(typeof(name)=="undefined" || name.length == 0) name = "";
		var collType = getItemValue(0,getRow(),"CollType"); 
		if(typeof(collType)=="undefined" || collType.length == 0) collType = "";
		var collValue = getItemValue(0,getRow(),"CollValue");
		if(typeof(collValue)=="undefined" || collValue.length == 0) collValue = "";
		
		parent.returnValue = (clrSerialNo+"@"+name+"@"+collType+"@"+collValue);
		self.close();
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 