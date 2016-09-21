<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Accounting/include_accounting.jspf"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%
	String PG_TITLE = "列表信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获取参数
	String objectType = CurPage.getParameter("ObjectType");//对象类型
	String objectNo = CurPage.getParameter("ObjectNo");//对象编号
	String termID = CurPage.getParameter("TermID");//组件ID
	String status = CurPage.getParameter("Status");//状态
	if(status == null)  status = "";
	
	
	ASObjectModel doTemp = new ASObjectModel("RPTSegmentList");

	//还款方式选择项
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
					String str = map.getString(parameter.getString("PARAMETERID"));
					if(StringX.isEmpty(str)) str = "";
					String[] values = valueList.split(",");
					String[] valueNames = valueListName.split(",");
					String codeTable = "";
					for(int i = 0; i < values.length; i ++)
					{
						if(str.indexOf(values[i]+",") > -1) continue;//如果代码已经存在直接跳过
						if(StringX.isEmpty(codeTable)) codeTable+=values[i]+","+valueNames[i];
						else codeTable+=","+values[i]+","+valueNames[i];
					}
					
					sb.append(" var value = getItemValue(0,getRow(),'"+parameter.getString("PARAMETERID")+"'); \r\n");
					sb.append(" if('"+valueList+"'.indexOf(value) == -1){alert('录入值不符合要求，请重新录入。');setItemValue(0,getRow(),'"+parameter.getString("PARAMETERID")+"',''); };");
					
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
	
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
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
			{"true", "", "Button", "新增", "新增一条信息","newRecord()","","","",""},
			{"true", "", "Button", "删除", "删除一条信息","deleteRecord()","","","",""},
			{"true", "", "Button", "返回", "返回","back()","","","",""}
	};
	
%>
<script language=javascript>
	var olddata={};
	/*~[Describe=新增;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		var position= getRowCount(0);
		as_add("myiframe0");
		if(position == 0)
			setItemValue(0,position,'SegFromDate',parent.getItemValue(0,0,"PutOutDate"));
		else if(position > 0)
			setItemValue(0,position,'SegFromDate',getItemValue(0,position-1,"SegToDate"));
		
		//setItemValue(0,position,'SegToDate',parent.getItemValue(0,0,"MaturityDate"));
		
		document.all("INPUT_myiframe0_SegToDate_"+position+"_1").onblur=changeSegDate;
		document.all("INPUT_myiframe0_SegTermID_"+position+"_2").onblur=changeRight;
		document.all("INPUT_myiframe0_PayFrequencyType_"+position+"_3").onblur=changeRight;
	}
	
	function changeSegDate(){
		if(getRow()+1 < getRowCount(0))
			setItemValue(0,getRow()+1,'SegFromDate',getItemValue(0,getRow(),"SegToDate"));
	}
	
	function changePayFrequencyType(){
		var payFrequencyType = getItemValue(0,getRow(),"PayFrequencyType");
		if("6" == payFrequencyType) //指定还款周期
		{
			document.all("INPUT_myiframe0_PayFrequencyUnit_"+getRow()+"_4_2").disabled=false;
			document.all("INPUT_myiframe0_PayFrequencyUnit_"+getRow()+"_4_4").disabled=false;
			document.all("INPUT_myiframe0_PayFrequencyUnit_"+getRow()+"_4_6").disabled=false;
			document.all("INPUT_myiframe0_PayFrequency_"+getRow()+"_5").disabled=false;
		}
		else
		{
			document.all("INPUT_myiframe0_PayFrequencyUnit_"+getRow()+"_4_2").disabled=true;
			document.all("INPUT_myiframe0_PayFrequencyUnit_"+getRow()+"_4_4").disabled=true;
			document.all("INPUT_myiframe0_PayFrequencyUnit_"+getRow()+"_4_6").disabled=true;
			document.all("INPUT_myiframe0_PayFrequency_"+getRow()+"_5").disabled=true;
		}
	}
	
	/*~[Describe=删除;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2'))){ //您真的想删除该信息吗？
			as_delete("myiframe0");
		}
	}
	
	function back(){
		CHANGED=false;
		AsControl.OpenView("/Accounting/LoanSimulation/LoanTerm/BusinessRPTInfo.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&Status=<%=status%>&TermID=","_self","");
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
	
	//根据组件定义生成的JS脚本规则，设置对应的值和显示规则
	function changeRight()
	{
		<%=sb.toString()%>;
		changePayFrequencyType();
	}
	
	function getValues(){
		if(getRowCount(0) < 2){
			alert("必须录入两条及以上数据。");
			return false;
		}
		var values = {};
		var amt = 0.0;
		for(var row = 0; row < getRowCount(0); row ++)
		{
			values[row] = {};
			for(var i=0;i<DZ[0][1].length;i++){
				var v = getItemValue(0,row,DZ[0][1][i][15]);
				if(typeof(v) == "undefined")
					v = olddata[row][DZ[0][1][i][15].toUpperCase()];
				values[row][DZ[0][1][i][15]] = v;
			}
			values[row]["TermID"]="<%=termID%>";
			//起始日期-到期日判断
			var segFromDate = getItemValue(0,row,"SegFromDate");
			var segToDate = getItemValue(0,row,"SegToDate");
			if(row < getRowCount(0)-1 && segFromDate > segToDate){
				alert("第"+(row+1)+"行开始日期不能大于结束日期。");
				return false;
			}
			
			if(row < getRowCount(0)-1 && segFromDate < parent.getItemValue(0,0,"PutOutDate")){
				alert("第"+(row+1)+"行开始日期不能小于贷款发放日期。");
				return false;
			}
			
			if(row < getRowCount(0)-1 && segToDate > parent.getItemValue(0,0,"MaturityDate")){
				alert("第"+(row+1)+"行结束日期不能大于贷款到期日期。");
				return false;
			}
			
			if(row == getRowCount(0)-1 && segToDate)
			{
				alert("第"+(row+1)+"行结束日期不用输入。");
				return false;
			}
			
			amt += parseFloat(getItemValue(0,row,"SegRPTAmount"));
		}
		
		if(amt != parseFloat(parent.getItemValue(0,0,"BusinessSum")))
		{
			alert("指定金额总和必须和贷款金额相同。");
			return false;
		}
		if(iV_all(0)){
			return JSON.stringify(values);
		}else{
			return false;
		}
	}
	
	
	//改变父页面大小
	parent.document.all("RPTFrame").style.height = 300;
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>