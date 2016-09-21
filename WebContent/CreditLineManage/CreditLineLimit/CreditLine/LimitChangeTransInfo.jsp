<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.lang.DateX"%>
<%@page import="com.amarsoft.app.bizmethod.*"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>
<%

	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sSerialNo = CurPage.getParameter("SerialNo");
	String sTransSerialNo = CurPage.getParameter("TransSerialNo");
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sSerialNo == null) sSerialNo = "";
	if(sTransSerialNo == null) sTransSerialNo = "";
	
	String clSerialNo = "",childtransSerialno="",childDocumentObjectNo="";
	String selectclSerialno = "select * from cl_info where cltype not in ('0105','0106') "+
					" and objectno=? and objecttype=? ";
	PreparedStatement ps = Sqlca.getConnection().prepareStatement(selectclSerialno);
	ps.setString(1, sObjectNo);
	ps.setString(2, sObjectType);
	ResultSet rs = ps.executeQuery();
	if(rs.next())
	{
		clSerialNo = rs.getString("serialno");
	}
	rs.close();
	ps.close();
	
	String selectchildtransSerialno = "select * from acct_transaction where transactioncode='015002' "+
			" and parenttransserialno=? ";
	ps = Sqlca.getConnection().prepareStatement(selectchildtransSerialno);
	ps.setString(1, sTransSerialNo);
	rs = ps.executeQuery();
	if(rs.next())
	{
		childtransSerialno = rs.getString("serialno");
		childDocumentObjectNo = rs.getString("DocumentObjectNo");
	}
	rs.close();
	ps.close();
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", childtransSerialno);
	
	String sTempletNo = "LimitChangeTransInfo";//--ģ���--
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("RelativeObjectNo", sObjectNo);
	dwTemp.setParameter("DocumentObjectNo", childDocumentObjectNo);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","All","Button","����","����","save()","","","",""},
	};
	//sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

	//ȫ�ֱ�����JS����Ҫ
	var userId="<%=CurUser.getUserID()%>";
	var orgId="<%=CurUser.getOrgID()%>";
	
	function save(){
		var serialno = "<%=childtransSerialno%>";
		if(serialno.length>0){
			var nlineID = getItemValue(0,getRow(0),"NLineID");
			var baSerialNo = getItemValue(0,getRow(0),"DocumentObjectNo");
			var returnValue1 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.LimitInsertTransaction", "updateLimitLineID", "SerialNo="+baSerialNo+",LineID="+nlineID);
			if(returnValue1=="true")
			{
				alert("����ɹ���");
				
			}else{
				alert("����ʧ�ܣ�ʧ��ԭ��"+returnValue1);
			}
			selfRefresh();
		}else{
			if(!confirm("ȷ��Ҫ����ǰ��ȵ�ҵ���ƽ�������")){
				return;
			}
			
			var nlineID = getItemValue(0,getRow(0),"NLineID");
			if(typeof(nlineID) == "undefined" || nlineID.length == 0)
			{
				alert("����ѡ���¶�ȱ�ţ�");
				return;
			}
			var returnValue1 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.LimitInsertTransaction", "addLimitChange", "SerialNo=<%=sObjectNo%>,TransactionSerialNo=<%=sTransSerialNo%>,TransactionCode=015002,UserID="+userId+",OrgID="+orgId+",LineID="+nlineID);
			if(typeof(returnValue1) == "undefined" || returnValue1.length == 0 || returnValue1.indexOf("@") == -1){
				return;
			}else{
				if((returnValue1.split("@"))[0]=="true")
				{
					alert("���ҵ���ƽ����״����ɹ���");
					selfRefresh();
				}else{
					alert("���ҵ���ƽ����״���ʧ�ܣ�ʧ��ԭ��"+returnValue1);
				}
			}
		}
	}
	
	
	function selectNewCLInfo()
	{
		AsCredit.setGridValue('SelectCLList', "<%=CurUser.getOrgID()%>", 'NLineID=SerialNo','','',0,0);
	}


	function selfRefresh()
	{
		var para = "ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&TransSerialNo=<%=sTransSerialNo%>&SerialNo=<%=sSerialNo%>";
		AsControl.OpenPage("/CreditLineManage/CreditLineLimit/CreditLine/LimitChangeTransInfo.jsp", para, "_self", "");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
