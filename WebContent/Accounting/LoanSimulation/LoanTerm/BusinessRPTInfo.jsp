<%@page contentType="text/html; charset=GBK"%>
<%@ include file="/Accounting/include_accounting.jspf"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%
	String PG_TITLE = "���������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//��ȡ����
	String objectType = CurPage.getParameter("ObjectType");//��������
	String objectNo = CurPage.getParameter("ObjectNo");//������
	String termID = CurPage.getParameter("TermID");//���ID
	String status = CurPage.getParameter("Status");//״̬
	if(status == null)  status = "";
	
	ASObjectModel doTemp = new ASObjectModel("RPTSegmentInfo");
	
	//���ʽѡ����
	List<BusinessObject> rptList = BusinessComponentConfig.getComponents("Type='PRD0301'");
	BusinessObjectHelper.sortBusinessObject(rptList, "ID");
	String rptCodeTable="";
	for(BusinessObject rpt:rptList)
	{
		if(StringX.isEmpty(rptCodeTable)) rptCodeTable+= rpt.getString("ID")+","+rpt.getString("Name");
		else rptCodeTable+= ","+rpt.getString("ID")+","+rpt.getString("Name");
	}
	doTemp.setDDDWCodeTable("TermID", rptCodeTable);
	doTemp.setDefaultValue("TermID", termID);
	
	//��������ѡ��
	String[] pftKeys = CashFlowConfig.getPayFrequencyTypeConfigKeys();
	String pftCodeTable="";
	List<BusinessObject> pftList = new ArrayList<BusinessObject>();
	for(String key:pftKeys)
	{
		pftList.add(CashFlowConfig.getPayFrequencyTypeConfig(key));
	}
	BusinessObjectHelper.sortBusinessObject(pftList, "ID");
	for(BusinessObject pft:pftList)
	{
		if(StringX.isEmpty(pftCodeTable)) pftCodeTable+= pft.getString("ID")+","+pft.getString("Name");
		else pftCodeTable+= ","+pft.getString("ID")+","+pft.getString("Name");
	}
	doTemp.setDDDWCodeTable("PayFrequencyType", pftCodeTable);
	
	if(!StringX.isEmpty(termID))
	{
		BusinessObject rptComponent = BusinessObjectHelper.getBusinessObjectBySql(rptList, "ID='"+termID+"'");
		List<BusinessObject> parameters = rptComponent.getBusinessObjects(BusinessComponentConfig.BUSINESS_PARAMETER);
		for(BusinessObject parameter:parameters)
		{
			BusinessObject parameterDefine = BusinessComponentConfig.getParameterDefinition(parameter.getString("PARAMETERID"));
			if(!StringX.isEmpty(parameter.getString("DISPLAYNAME")))
			{
				doTemp.setHeader(parameter.getString("PARAMETERID"), parameter.getString("DISPLAYNAME"));
			}
			String apermission = parameter.getString("ARIGHTTYPE");
			if("Required".equalsIgnoreCase(apermission)){
				doTemp.setRequired(parameter.getString("PARAMETERID"), true);
				doTemp.setVisible(parameter.getString("PARAMETERID"), true);
			}else if("ReadOnly".equalsIgnoreCase(apermission)){
				doTemp.setReadOnly(parameter.getString("PARAMETERID"), true);
				doTemp.setVisible(parameter.getString("PARAMETERID"), true);
			}
			else if("Hide".equalsIgnoreCase(apermission)){
				doTemp.setRequired(parameter.getString("PARAMETERID"), false);
				doTemp.setVisible(parameter.getString("PARAMETERID"), false);
			}
			else{
				doTemp.setVisible(parameter.getString("PARAMETERID"), true);
			}
			
			String valueList = parameter.getString("OPTIONALVALUE");
			String valueListName = parameter.getString("OPTIONALVALUENAME");
			if(!StringX.isEmpty(valueList))
			{
				String[] values = valueList.split(",");
				String[] valueNames = valueListName.split(",");
				String codeTable = "";
				for(int i = 0; i < values.length; i ++)
				{
					if(StringX.isEmpty(codeTable)) codeTable+=values[i].trim()+","+valueNames[i].trim();
					else codeTable+=","+values[i].trim()+","+valueNames[i].trim();
				}
				doTemp.setDDDWCodeTable(parameter.getString("PARAMETERID"), codeTable);
			}
			
			String defaultValue = parameter.getString("VALUE");
			if(!StringX.isEmpty(defaultValue))
			{
				doTemp.setDefaultValue(parameter.getString("PARAMETERID"), defaultValue);
			}
		}
	}
	doTemp.setDefaultValue("ObjectType", objectType);
	doTemp.setDefaultValue("ObjectNo", objectNo);
	
	doTemp.appendJboWhere(" and O.Status in('"+status.replaceAll(",","','")+"')");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage ,doTemp,request); 
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	
	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow(objectNo+","+objectType+","+termID);

	//����Ϊ��
	//0.�Ƿ���ʾ
	//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
	//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
	//3.��ť����
	//4.˵������
	//5.�¼�
	//6.��ԴͼƬ·��
	String sButtons[][] = {
	};
	
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>


<script language=javascript>
	function saveRecord(){
		if(!iV_all("myiframe0")) return false;
		as_save("myiframe0");
		return true;
	}
	
	function changeTerm(){
		CHANGED=false;
		var termID = getItemValue(0,getRow(),"TermID");
		if(typeof(termID) == "undefined" || termID.length == 0 || "<%=termID%>" == termID) return;
		
		var view = AsControl.RunJavaMethod("com.amarsoft.app.base.config.impl.BusinessComponentConfig","getComponentAttribute","componentID="+termID+",attributeID=format");
		if("1"==view)
			AsControl.OpenView("/Accounting/LoanSimulation/LoanTerm/BusinessRPTInfo.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&Status=<%=status%>&TermID="+termID,"_self","");
		else
			AsControl.OpenView("/Accounting/LoanSimulation/LoanTerm/BusinessRPTList.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&Status=<%=status%>&TermID="+termID,"_self","");
	}
	
	
	function changePayFrequencyType(){
		var payFrequencyType = getItemValue(0,getRow(),"PayFrequencyType");
		if("6" == payFrequencyType) //ָ����������
		{
			showItem(0,"PayFrequencyUnit");
			showItem(0,"PayFrequency");
			setItemRequired(0,"PayFrequencyUnit",true);
			setItemRequired(0,"PayFrequency",true);
		}
		else
		{
			hideItem(0,"PayFrequencyUnit");
			hideItem(0,"PayFrequency");
			setItemRequired(0,"PayFrequencyUnit",false);
			setItemRequired(0,"PayFrequency",false);
		}
	}
	
	function getValues(){
		var values = {};
		values[0]={};
		for(var i=0;i<DisplayFields[0].length;i++){
			values[0][DisplayFields[0][i]] = getItemValue(0,getRow(),DisplayFields[0][i]);
		}
		if(iV_all(0)){
			return JSON.stringify(values);
		}else{
			return false;
		}
	}
	
	changePayFrequencyType();
	parent.document.all("RPTFrame").style.height = 150;
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>