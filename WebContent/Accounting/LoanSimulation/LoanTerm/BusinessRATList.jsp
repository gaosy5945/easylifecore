<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Accounting/include_accounting.jspf"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%
	String PG_TITLE = "�б���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//��ȡ����
	String objectType = CurPage.getParameter("ObjectType");//��������
	String objectNo = CurPage.getParameter("ObjectNo");//������
	String termID = CurPage.getParameter("TermID");//���ID
	String status = CurPage.getParameter("Status");//״̬
	if(status == null)  status = "";
	
	ASObjectModel doTemp = new ASObjectModel("RATSegmentList");
	//����ѡ����
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
	
	
	StringBuffer sb = new StringBuffer();
	BusinessObject map = BusinessObject.createBusinessObject();
	if(!StringX.isEmpty(termID))
	{
		String segRPTCodeTable="";
		BusinessObject rptComponent = BusinessComponentConfig.getComponent(termID);
		List<BusinessObject> childrenComponents = rptComponent.getBusinessObjects(BusinessComponentConfig.BUSINESS_COMPONENT_CHILDRENCOMPONENT);
		for(BusinessObject childrenComponent:childrenComponents)
		{
			if(StringX.isEmpty(segRPTCodeTable)) segRPTCodeTable+= childrenComponent.getString("ID")+","+childrenComponent.getString("Name");
			else segRPTCodeTable+= ","+childrenComponent.getString("ID")+","+childrenComponent.getString("Name");
			
			sb.append(" if(!olddata[getRow()]) olddata[getRow()]={}; \r\n");
			sb.append(" var segTermID = getItemValue(0,getRow(),'SegTermID'); \r\n");
			sb.append(" if(segTermID == '"+childrenComponent.getString("ID")+"'){ \r\n");
			
			List<BusinessObject> parameters = childrenComponent.getBusinessObjects(BusinessComponentConfig.BUSINESS_PARAMETER);
			for(BusinessObject parameter:parameters)
			{
				BusinessObject parameterDefine = BusinessComponentConfig.getParameterDefinition(parameter.getString("PARAMETERID"));
				String apermission = parameter.getString("ARIGHTTYPE");
				if("Required".equalsIgnoreCase(apermission)){
					sb.append(" document.all('INPUT_myiframe0_"+parameter.getString("PARAMETERID")+"_'+getRow()+'_'+getColumnIndex('"+parameter.getString("PARAMETERID")+"')).disabled=false; \r\n");
					doTemp.setRequired(parameter.getString("PARAMETERID"), true);
					doTemp.setVisible(parameter.getString("PARAMETERID"), true);
				}
				else if("ReadOnly".equalsIgnoreCase(apermission)){
					sb.append(" document.all('INPUT_myiframe0_"+parameter.getString("PARAMETERID")+"_'+getRow()+'_'+getColumnIndex('"+parameter.getString("PARAMETERID")+"')).disabled=true; \r\n");
					sb.append(" setItemValue(0,getRow(),'"+parameter.getString("PARAMETERID")+"',''); \r\n");
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
					String str = map.getString(parameter.getString("PARAMETERID"));
					if(StringX.isEmpty(str)) str = "";
					String[] values = valueList.split(",");
					String[] valueNames = valueListName.split(",");
					String codeTable = "";
					for(int i = 0; i < values.length; i ++)
					{
						if(str.indexOf(values[i]+",") > -1) continue;//��������Ѿ�����ֱ������
						if(StringX.isEmpty(codeTable)) codeTable+=values[i]+","+valueNames[i];
						else codeTable+=","+values[i]+","+valueNames[i];
					}
					
					sb.append(" var value = getItemValue(0,getRow(),'"+parameter.getString("PARAMETERID")+"'); \r\n");
					sb.append(" if('"+valueList+"'.indexOf(value) == -1){alert('¼��ֵ������Ҫ��������¼�롣');setItemValue(0,getRow(),'"+parameter.getString("PARAMETERID")+"',''); };");
					
					if(StringX.isEmpty(str))
					{
						map.setAttributeValue(parameter.getString("PARAMETERID"),codeTable);
					}
					else if(!StringX.isEmpty(codeTable))
					{
						map.setAttributeValue(parameter.getString("PARAMETERID"),str+","+codeTable);
					}
				}
				
				String defaultValue = parameter.getString("Value");
				if(!StringX.isEmpty(defaultValue))
				{
					sb.append(" setItemValue(0,getRow(),'"+parameter.getString("PARAMETERID")+"','"+defaultValue+"'); \r\n");
					sb.append(" olddata[getRow()]['"+parameter.getString("PARAMETERID").toUpperCase()+"'] = '"+defaultValue+"';\r\n");
					doTemp.setDefaultValue(parameter.getString("PARAMETERID"), defaultValue);
				}
			}
			
			sb.append(" } \r\n");
		}
		doTemp.setDDDWCodeTable("SegTermID", segRPTCodeTable);
		
		
		for(String key:map.getAttributeIDArray())
		{
			doTemp.setDDDWCodeTable(key, map.getString(key));
		}
	}
	doTemp.setDefaultValue("ObjectType", objectType);
	doTemp.setDefaultValue("ObjectNo", objectNo);
	
	doTemp.appendJboWhere(" and O.Status in('"+status.replaceAll(",","','")+"')");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage ,doTemp,request); 
	
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
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
			{"true", "", "Button", "����", "����һ����Ϣ","newRecord()","","","",""},
			{"true", "", "Button", "ɾ��", "ɾ��һ����Ϣ","deleteRecord()","","","",""},
			{"true", "", "Button", "����", "����","back()","","","",""}
	};
	
%>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/term/rateterm.js"></script>
<script language=javascript>
	var olddata={};
	var currency = parent.getItemValue(0,0,"Currency");
	var putoutDate = parent.getItemValue(0,0,"PutOutDate");
	var maturityDate = parent.getItemValue(0,0,"MaturityDate");
	var businessDate = "<%=DateHelper.getBusinessDate()%>";
	var yearDays = parent.getItemValue(0,0,"YearDays");

	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		var position= getRowCount(0);
		as_add("myiframe0");
		if(position == 0)
			setItemValue(0,position,'SegFromDate',parent.getItemValue(0,0,"PutOutDate"));
		else if(position > 0)
			setItemValue(0,position,'SegFromDate',getItemValue(0,position-1,"SegToDate"));
		
		//setItemValue(0,position,'SegToDate',parent.getItemValue(0,0,"MaturityDate"));
		document.all("INPUT_myiframe0_SegToDate_"+position+"_"+getColumnIndex("SegToDate")).onblur=changeSegDate;
		document.all("INPUT_myiframe0_SegTermID_"+position+"_"+getColumnIndex("SegTermID")).onblur=changeRight;
		document.all("INPUT_myiframe0_BaseRateType_"+position+"_"+getColumnIndex("BaseRateType")).onblur=setBaseRateGrade;
		document.all("INPUT_myiframe0_RateFloat_"+position+"_"+getColumnIndex("RateFloat")).onblur=setBusinessRate;
		document.all("INPUT_myiframe0_RateFloatType_"+position+"_"+getColumnIndex("RateFloatType")).onblur=setBusinessRate;
		document.all("INPUT_myiframe0_RepriceType_"+position+"_"+getColumnIndex("RepriceType")).onblur=setRepriceList;
	}
	
	function changeSegDate(){
		if(getRow()+1 < getRowCount(0))
			setItemValue(0,getRow()+1,'SegFromDate',getItemValue(0,getRow(),"SegToDate"));
	}
	
	/*~[Describe=ɾ��;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2'))){ //�������ɾ������Ϣ��
			as_delete("myiframe0");
		}
	}
	
	function getColumnIndex(sCol){
		var cnt=0;
		for(var i=0;i<DZ[0][1].length;i++){
			if(DZ[0][1][i][2]!=1) continue;
			if(typeof(sCol)=="string"){
				if(DZ[0][1][i][15].toUpperCase()==sCol.toUpperCase()) return cnt;
			}else{
				if(DZ[0][1][i][15]==sCol) return cnt;
			}
			cnt++
		}
		return -1;
	}
	
	function back(){
		CHANGED=false;
		AsControl.OpenView("/Accounting/LoanSimulation/LoanTerm/BusinessRATInfo.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&Status=<%=status%>&TermID=","_self","");
	}
	
	
	//��������������ɵ�JS�ű��������ö�Ӧ��ֵ����ʾ����
	function changeRight()
	{
		<%=sb.toString()%>;
		setBaseRateGrade();
		setRepriceList();
	}
	
	function getValues(){
		if(getRowCount(0) < 2){
			alert("����¼���������������ݡ�");
			return false;
		}
		var values = {};
		for(var row = 0; row < getRowCount(0); row ++)
		{
			values[row] = {};
			for(var i=0;i<DZ[0][1].length;i++){
				var v = getItemValue(0,row,DZ[0][1][i][15]);
				if(typeof(v) == "undefined" && !olddata[row][DZ[0][1][i][15].toUpperCase()])
					v = olddata[row][DZ[0][1][i][15].toUpperCase()];
				values[row][DZ[0][1][i][15]] = v;
			}
			
			values[row]["TermID"]="<%=termID%>";
			
			//��ʼ����-�������ж�
			var segFromDate = getItemValue(0,row,"SegFromDate");
			var segToDate = getItemValue(0,row,"SegToDate");
			var businessRate = getItemValue(0,row,"BusinessRate");
			if(row < getRowCount(0)-1 && segFromDate > segToDate){
				alert("��"+(row+1)+"�п�ʼ���ڲ��ܴ��ڽ������ڡ�");
				return false;
			}
			
			if(row < getRowCount(0)-1 && segFromDate < "<%=DateHelper.getBusinessDate()%>"){
				alert("��"+(row+1)+"�п�ʼ���ڲ���С�ڴ�������ڡ�");
				return false;
			}
			
			if(row < getRowCount(0)-1 && segToDate > parent.getItemValue(0,0,"MaturityDate")){
				alert("��"+(row+1)+"�н������ڲ��ܴ��ڴ�������ڡ�");
				return false;
			}
			
			if(row == getRowCount(0)-1 && segToDate)
			{
				alert("��"+(row+1)+"�н������ڲ������롣");
				return false;
			}
			
			if(businessRate <= 0 ){
				alert("��"+(row+1)+"������Ϊ�ջ�С���㡣");
				return false;
			}
		}
		
		return JSON.stringify(values);
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>