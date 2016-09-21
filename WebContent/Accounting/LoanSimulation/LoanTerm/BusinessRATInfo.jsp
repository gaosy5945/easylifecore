<%@page contentType="text/html; charset=GBK"%>
<%@ include file="/Accounting/include_accounting.jspf"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%
	String PG_TITLE = "功能组件信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获取参数
	String objectType = CurPage.getParameter("ObjectType");//对象类型
	String objectNo = CurPage.getParameter("ObjectNo");//对象编号
	String termID = CurPage.getParameter("TermID");//组件ID
	String status = CurPage.getParameter("Status");//状态
	if(status == null)  status = "";
	
	ASObjectModel doTemp = new ASObjectModel("RATSegmentInfo");
	
	//利率选择项
	List<BusinessObject> ratList = BusinessComponentConfig.getComponents("Type='PRD0302'");
	BusinessObjectHelper.sortBusinessObject(ratList, "ID");
	String ratCodeTable="";
	for(BusinessObject rat:ratList)
	{
		if(StringX.isEmpty(ratCodeTable)) ratCodeTable+= rat.getString("ID")+","+rat.getString("Name");
		else ratCodeTable+= ","+rat.getString("ID")+","+rat.getString("Name");
	}
	doTemp.setDDDWCodeTable("TermID", ratCodeTable); 
	doTemp.setDefaultValue("TermID", termID);
	
	//利率调整方式选择
	String[] ptKeys = CashFlowConfig.getRepriceTypeConfigKeys();
	String ptCodeTable="";
	List<BusinessObject> ptList = new ArrayList<BusinessObject>();
	for(String key:ptKeys)
	{
		ptList.add(CashFlowConfig.getRepriceTypeConfig(key));
	}
	BusinessObjectHelper.sortBusinessObject(ptList, "ID");
	for(BusinessObject pt:ptList)
	{
		if(StringX.isEmpty(ptCodeTable)) ptCodeTable+= pt.getString("ID")+","+pt.getString("Name");
		else ptCodeTable+= ","+pt.getString("ID")+","+pt.getString("Name");
	}
	doTemp.setDDDWCodeTable("RepriceType", ptCodeTable);
	
	if(!StringX.isEmpty(termID))
	{
		BusinessObject ratComponent = BusinessObjectHelper.getBusinessObjectBySql(ratList, "ID='"+termID+"'");
		List<BusinessObject> parameters = ratComponent.getBusinessObjects(BusinessComponentConfig.BUSINESS_PARAMETER);
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
			}
			else if("ReadOnly".equalsIgnoreCase(apermission)){
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
					if(StringX.isEmpty(codeTable)) codeTable+=values[i]+","+valueNames[i];
					else codeTable+=","+values[i]+","+valueNames[i];
				}
				doTemp.setDDDWCodeTable(parameter.getString("PARAMETERID"), codeTable);
			}
			
			String defaultValue = parameter.getString("Value");
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
	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow(objectNo+","+objectType+","+termID);

	//依次为：
	//0.是否显示
	//1.注册目标组件号(为空则自动取当前组件)
	//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
	//3.按钮文字
	//4.说明文字
	//5.事件
	//6.资源图片路径
	String sButtons[][] = {
	};
	
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/term/rateterm.js"></script>
<script language=javascript>
	var currency = parent.getItemValue(0,0,"Currency");
	var putoutDate = parent.getItemValue(0,0,"PutOutDate");
	var maturityDate = parent.getItemValue(0,0,"MaturityDate");
	var businessDate = "<%=DateHelper.getBusinessDate()%>";
	var yearDays = parent.getItemValue(0,0,"YearDays");

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
			AsControl.OpenView("/Accounting/LoanSimulation/LoanTerm/BusinessRATInfo.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&Status=<%=status%>&TermID="+termID,"_self","");
		else
			AsControl.OpenView("/Accounting/LoanSimulation/LoanTerm/BusinessRATList.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&Status=<%=status%>&TermID="+termID,"_self","");
	}
	if("ReadOnly" != "<%=CurPage.getParameter("RightType")%>")
	{
		setBaseRateGrade();
		setRepriceInfo();	
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
</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>