<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	String sCustomerID = CurPage.getParameter("CustomerID");
	
	String sFinanceBelong = "", sIndustryType = "",sFinanceName = "";
	String sSql = "select FinanceBelong,IndustryType from ENT_INFO where CustomerID= '" + sCustomerID + "'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sFinanceBelong = DataConvert.toString(rs.getString(1));
		sIndustryType = DataConvert.toString(rs.getString(2));
	}
	rs.getStatement().close();
	if(sFinanceBelong != null && !"".equals(sFinanceBelong)){
	 	sSql = "select ItemName from CODE_LIBRARY where CodeNo = 'FinanceBelong' and ItemNo='"+sFinanceBelong+"'";
	 	rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
			sFinanceName = DataConvert.toString(rs.getString(1));
	}
	rs.getStatement().close();
%>
<script type="text/javascript">
	var availableReportCaptionList = new Array;
	var availableReportNameList = new Array;
	var selectedReportCaptionList = new Array;
	var selectedReportNameList = new Array;
	
	var availableCustomerCaptionList = new Array;
	var availableCustomerNameList = new Array;
	var selectedCustomerCaptionList = new Array;
	var selectedCustomerNameList = new Array;
<%
	int num = 0;
	//对财务报表类型进行分类,选择用户当前报表类型的财务报表进行财务分析
	sSql = "select distinct f.ReportDate || ' ' || getItemName('ReportScope',f.ReportScope) || ' ' || getItemName('ReportPeriod',f.ReportPeriod) || ' ' || getItemName('Currency',f.ReportCurrency) || ' ' || getItemName('ReportUnit',f.ReportUnit), f.ReportDate || '@' || f.ReportScope"+
			" from CUSTOMER_FSRECORD f,REPORT_RECORD r,REPORT_CATALOG c where r.ObjectNo = '" + sCustomerID + "' and r.ModelNo=c.ModelNo and c.ModelClass in (select FinanceBelong from ENT_INFO where CustomerID= '" + sCustomerID + "')"+
			" and f.ReportDate=r.ReportDate and f.ReportScope=r.ReportScope and f.CustomerID=r.ObjectNo";
	rs = Sqlca.getASResultSet(sSql);
	num = 0;
	while(rs.next()){
		out.println("availableReportCaptionList[" + num + "] = '" + rs.getString(1) + "';\r");
		out.println("availableReportNameList[" + num + "] = '" + rs.getString(2) + "';\r");
		num++;
	}
	rs.getStatement().close();
	
	num = 0;
	/*
	if(sFinanceBelong.equals("001")){
		sSql = "select distinct getIndustryName(target),target from Industry_Match order by target";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next()){
			out.println("availableCustomerCaptionList[" + num + "] = '行业：" + rs.getString(1) + "';\r");
			out.println("availableCustomerNameList[" + num + "] = 'Industry@" + rs.getString(2) + "';\r");
			num++;
		}
		rs.getStatement().close();
	}
	*/
	
	/*
	sSql = "select EnterpriseName,CustomerID from Ent_Info where SUBSTRING(IndustryType,1,1)= SUBSTRING('"+sIndustryType+"',1,1) and FinanceBelong = '"+sFinanceBelong+"' and CustomerID <> '"+sCustomerID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		out.println("availableCustomerCaptionList[" + num + "] = '客户：" + rs.getString(1) + "';\r");
		out.println("availableCustomerNameList[" + num + "] = 'Customer@" + rs.getString(2) + "';\r");
		num++;
	}
	rs.getStatement().close();
	*/
%>
</script>
<html>
<head>
	<title>选取分析条件</title>
</head>
<body bgcolor="#E4E4E4" >
<form name="analyseterm">
<table align="center" width="100%">
	<tr>
		<td>
			<table width='100%' border='1' cellpadding='0' cellspacing='5' bgcolor='#DDDDDD'>
				<tr>
					<td colspan="4">
						<span>当前报表类型：<%=sFinanceName%> (所选第一期报表作为基期)</span>
					</td>
				</tr>
				<tr>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>可选取的财务报表列表</span>
					</td>
					<td bordercolor='#DDDDDD'></td>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>已选取的财务报表列表</span>
					</td>
					<td></td>
				</tr>
				<tr>
					<td align='center' style="width: 48%;">
						<select name='report_available' onchange='selectionChanged(document.forms["analyseterm"].elements["report_available"],document.forms["analyseterm"].elements["report_chosen"]);' size='12' style='width:100%;' multiple> 
						</select>
					</td>
					<td width='1' align='center' valign='middle' bordercolor='#DDDDDD'>
						<img name='movefrom_report_available'
								onmousedown='pushButton("movefrom_report_available",true);'
								onmouseup='pushButton("movefrom_report_available",false);'
								onmouseout='pushButton("movefrom_report_available",false);'
								onclick='moveSelected(document.forms["analyseterm"].elements["report_available"],document.forms["analyseterm"].elements["report_chosen"]);updateHiddenChooserField(document.forms["analyseterm"].elements["report_chosen"],document.forms["analyseterm"].elements["report"]);'
								border='0'
								src='<%=CurConfig.getImagePath()%>/chooser_orange/arrowRight_disabled.gif'
								alt='Add selected items' />
						<br><br>
						<img name='movefrom_report_chosen'
								onmousedown='pushButton("movefrom_report_chosen",true);'
								onmouseup='pushButton("movefrom_report_chosen",false);'
								onmouseout='pushButton("movefrom_report_chosen",false);'
								onclick='moveSelected(document.forms["analyseterm"].elements["report_chosen"],document.forms["analyseterm"].elements["report_available"]);updateHiddenChooserField(document.forms["analyseterm"].elements["report_chosen"],document.forms["analyseterm"].elements["report"]);'
								border='0'
								src='<%=CurConfig.getImagePath()%>/chooser_orange/arrowLeft_disabled.gif'
								alt='Remove selected items' />
					</td>
					<td align='center' style="width: 48%;">
						<select name='report_chosen' onchange='selectionChanged(document.forms["analyseterm"].elements["report_chosen"],document.forms["analyseterm"].elements["report_available"]);' size='12' style='width:100%;' multiple>
						</select>
						<input type='hidden' name='report' value=''>
					</td>
					<td width='1' align='center' valign='middle' bordercolor='#DDDDDD'>
						<img name='shiftup_report_chosen'
								onmousedown='pushButton("shiftup_report_chosen",true);'
								onmouseup='pushButton("shiftup_report_chosen",false);'
								onmouseout='pushButton("shiftup_report_chosen",false);'
								onclick='shiftSelected(document.forms["analyseterm"].elements["report_chosen"],-1);updateHiddenChooserField(document.forms["analyseterm"].elements["report_chosen"],document.forms["analyseterm"].elements["report"]);'
								border='0'
								src='<%=CurConfig.getImagePath()%>/chooser_orange/arrowUp_disabled.gif'
								alt='Shift selected items down' />
						<br><br>
						<img name='shiftdown_report_chosen'
								onmousedown='pushButton("shiftdown_report_chosen",true);'
								onmouseup='pushButton("shiftdown_report_chosen",false);'
								onmouseout='pushButton("shiftdown_report_chosen",false);'
								onclick='shiftSelected(document.forms["analyseterm"].elements["report_chosen"],1);updateHiddenChooserField(document.forms["analyseterm"].elements["report_chosen"],document.forms["analyseterm"].elements["report"]);'
								border='0'
								src='<%=CurConfig.getImagePath()%>/chooser_orange/arrowDown_disabled.gif'
								alt='Shift selected items up' />
					</td>
				</tr>
	
				<tr style='display:none'>
					<td colspan="4">
						<span>选取要对比的客户</span>
					</td>
				</tr>
				<tr style='display:none'>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>可选取的客户列表</span>
					</td>
					<td bordercolor='#DDDDDD'></td>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>已选取的客户列表</span>
					</td>
					<td></td>
				</tr>
				<tr style='display:none'>
					<td align='center' style="width: 48%;">
						<select name='customer_available' onchange='selectionChanged(document.forms["analyseterm"].elements["customer_available"],document.forms["analyseterm"].elements["customer_chosen"]);' size='12' style='width:100%;' multiple> 
						</select>
					</td>
					<td width='1' align='center' valign='middle' bordercolor='#DDDDDD'>
						<img name='movefrom_customer_available'
								onmousedown='pushButton("movefrom_customer_available",true);'
								onmouseup='pushButton("movefrom_customer_available",false);'
								onmouseout='pushButton("movefrom_customer_available",false);'
								onclick='moveSelected(document.forms["analyseterm"].elements["customer_available"],document.forms["analyseterm"].elements["customer_chosen"]);updateHiddenChooserField(document.forms["analyseterm"].elements["customer_chosen"],document.forms["analyseterm"].elements["customer"]);'
								border='0'
								src='<%=CurConfig.getImagePath()%>/chooser_orange/arrowRight_disabled.gif'
								alt='Add selected items' />
						<br><br>
						<img name='movefrom_customer_chosen'
								onmousedown='pushButton("movefrom_customer_chosen",true);'
								onmouseup='pushButton("movefrom_customer_chosen",false);'
								onmouseout='pushButton("movefrom_customer_chosen",false);'
								onclick='moveSelected(document.forms["analyseterm"].elements["customer_chosen"],document.forms["analyseterm"].elements["customer_available"]);updateHiddenChooserField(document.forms["analyseterm"].elements["customer_chosen"],document.forms["analyseterm"].elements["customer"]);'
								border='0'
								src='<%=CurConfig.getImagePath()%>/chooser_orange/arrowLeft_disabled.gif'
								alt='Remove selected items' />
					</td>
					<td align='center' style="width: 48%;">
						<select name='customer_chosen' onchange='selectionChanged(document.forms["analyseterm"].elements["customer_chosen"],document.forms["analyseterm"].elements["customer_available"]);' size='12' style='width:100%;' multiple>
						</select>
						<input type='hidden' name='customer' value=''>
					</td>
					<td width='1' align='center' valign='middle' bordercolor='#DDDDDD'>
						<img name='shiftup_customer_chosen'
								onmousedown='pushButton("shiftup_customer_chosen",true);'
								onmouseup='pushButton("shiftup_customer_chosen",false);'
								onmouseout='pushButton("shiftup_customer_chosen",false);'
								onclick='shiftSelected(document.forms["analyseterm"].elements["customer_chosen"],-1);updateHiddenChooserField(document.forms["analyseterm"].elements["customer_chosen"],document.forms["analyseterm"].elements["customer"]);'
								border='0'
								src='<%=CurConfig.getImagePath()%>/chooser_orange/arrowUp_disabled.gif'
								alt='Shift selected items down' />
						<br><br>
						<img name='shiftdown_customer_chosen'
								onmousedown='pushButton("shiftdown_customer_chosen",true);'
								onmouseup='pushButton("shiftdown_customer_chosen",false);'
								onmouseout='pushButton("shiftdown_customer_chosen",false);'
								onclick='shiftSelected(document.forms["analyseterm"].elements["customer_chosen"],1);updateHiddenChooserField(document.forms["analyseterm"].elements["customer_chosen"],document.forms["analyseterm"].elements["customer"]);'
								border='0'
								src='<%=CurConfig.getImagePath()%>/chooser_orange/arrowDown_disabled.gif'
								alt='Shift selected items up' />
					</td>
				</tr>	
				<tr>
					<td colspan="4">
					<table>
					<tr>
					<td>
						<span>选取分析方式：</span>
					</td>
					<td>
						<select name="analysetype">
							<%=HTMLControls.generateDropDownSelect(Sqlca,"FinanceTrendAnalyse","")%>
						</select>
					</td>
					</tr>
					</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="4">
			<table style="width: 100%;">
				<tr>
					<td width="30%" align="right">
						<%=new Button("&nbsp;恢&nbsp;复&nbsp;","恢复","doDefault()","","").getHtmlText()%>
					</td>
					<td width="40%" align="center">
						<%=new Button("&nbsp;确&nbsp;定&nbsp;","确定","doQuery()","","").getHtmlText()%>
					</td>
					<td width="30%" align="left">
						<%=new Button("&nbsp;取&nbsp;消&nbsp;","取消","top.returnValue='_none_';top.close();","","").getHtmlText()%>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
<script type="text/javascript">
	function cloneOption(option){
		var out = new Option(option.text,option.value);
		out.selected = option.selected;
		out.defaultSelected = option.defaultSelected;
		return out;
	}
	
	function shiftSelected(chosen,howFar){
		var opts = chosen.options;
		var newopts = new Array(opts.length);
		var start, end, incr;
		if(howFar > 0){
			start = 0;
			end = newopts.length;
			incr = 1; 
		}else{
			start = newopts.length - 1;
			end = -1;
			incr = -1; 
		}
		for(var sel = start; sel != end; sel += incr){
			if (opts[sel].selected) {
				setAtFirstAvailable(newopts, cloneOption(opts[sel]), sel + howFar, -incr);
			}
		}
		for(var uns = start; uns != end; uns += incr){
			if (!opts[uns].selected) {
				setAtFirstAvailable(newopts, cloneOption(opts[uns]), start, incr);
			}
		}
		opts.length = 0;
		for(var i=0; i<newopts.length; i++){
			opts[opts.length] = newopts[i]; 
		}
	}
	
	function setAtFirstAvailable(array,obj,startIndex,incr){
		if (startIndex < 0) startIndex = 0;
		if (startIndex >= array.length) startIndex = array.length -1;
		for(var xxx=startIndex; xxx>= 0 && xxx<array.length; xxx += incr){
			if (array[xxx] == null) {
				array[xxx] = obj; 
				return; 
			}
		}
	}
	
	function moveSelected(from,to){
		newTo = new Array();
		for(var i=0; i<to.options.length; i++){
			newTo[newTo.length] = cloneOption(to.options[i]);
			newTo[newTo.length-1].selected = false;
		}
		
		for(i=0; i<from.options.length; i++){
			if (from.options[i].selected){
				newTo[newTo.length] = cloneOption(from.options[i]);
				from.options[i] = null;
				i--;
			}
		}
		to.options.length = 0;
		for(i=0; i<newTo.length; i++){
			to.options[to.options.length] = newTo[i];
		}
		selectionChanged(to,from);
	}
   
	function updateHiddenChooserField(chosen,hidden){
		hidden.value='';
		var opts = chosen.options;
		for(var i=0; i<opts.length; i++){
			hidden.value = hidden.value + opts[i].value+'\n';
		}
	}
   
	function selectionChanged(selectedElement,unselectedElement){
		for(var i=0; i<unselectedElement.options.length; i++){
			unselectedElement.options[i].selected=false;
		}
		form = selectedElement.form; 
		enableButton("movefrom_"+selectedElement.name,(selectedElement.selectedIndex != -1));
		enableButton("movefrom_"+unselectedElement.name,(unselectedElement.selectedIndex != -1));
		enableButton("shiftdown_"+selectedElement.name,(selectedElement.selectedIndex != -1));
		enableButton("shiftup_"+selectedElement.name,(selectedElement.selectedIndex != -1));
		enableButton("shiftdown_"+unselectedElement.name,(unselectedElement.selectedIndex != -1));
		enableButton("shiftup_"+unselectedElement.name,(unselectedElement.selectedIndex != -1));
	}
   
   function enableButton(buttonName,enable){
		var img = document.images[buttonName]; 
		if (img == null) return; 
		var src = img.src; 
		var und = src.lastIndexOf("_disabled.gif"); 
		if (und != -1) {
			if(enable) img.src = src.substring(0,und)+".gif"; 
		}else{
			if(!enable){
				var gif = src.lastIndexOf("_clicked.gif"); 
				if (gif == -1) gif = src.lastIndexOf(".gif"); 
				img.src = src.substring(0,gif)+"_disabled.gif";
			}
		}
	}
   
   function pushButton(buttonName,push){
		var img = document.images[buttonName]; 
		if (img == null) return; 
		var src = img.src; 
		var und = src.lastIndexOf("_disabled.gif"); 
		if (und != -1) return false; 
		und = src.lastIndexOf("_clicked.gif"); 
		if (und == -1) {
			var gif = src.lastIndexOf(".gif");
			if (push) img.src = src.substring(0,gif)+"_clicked.gif"; 
		}else{
			if (!push) img.src = src.substring(0,und)+".gif"; 
		}
	}
	
	function doQuery(){
		if(analyseterm.report_chosen.length <= 1){
			alert(getMessageText('ALS70176'));//请至少选择两期报表用作趋势分析！
			return;
		}
		
		var vReturn = "";
		var vReportCount = analyseterm.report_chosen.length;
		var vCustomerCount = analyseterm.customer_chosen.length;
		
		vReturn += "@ReportCount=" + vReportCount;
		var vAccountMonth = new Array;
		var vScope = new Array;
		var vTempAccount,vTempScope;
		
		for(var i=0; i<vReportCount;i++){
			var vTemp = analyseterm.report_chosen.options[i].value.split("@");
			vAccountMonth[i] = vTemp[0];
			vScope[i] = vTemp[1];
		}
		//排序
		for(var i=0; i<vReportCount-1;i++){
			for(var j=i+1;j<vReportCount;j++){
				if(vAccountMonth[i]> vAccountMonth[j]){
					vTempAccount = vAccountMonth[i];
					vAccountMonth[i] = vAccountMonth[j];
					vAccountMonth[j] = vTempAccount;
					vTempScope = vScope[i];
					vScope[i] = vScope[j];
					vScope[j] = vTempScope;
				}
			}
		}
		
		for(var i=1; i<=vReportCount; i++){
			vReturn += "@AccountMonth" + i + "=" + vAccountMonth[i - 1] + "@Scope" + i + "=" + vScope[i - 1];
		}
		
		vReturn += "@EntityCount=" + vCustomerCount;
		for(var i=1; i<=vCustomerCount; i++){
			var vTemp = analyseterm.customer_chosen.options[i - 1].value.split("@");
			vReturn += "@EntityType" + i + "=" + vTemp[0] + "@EntityID" + i + "=" + vTemp[1];
		}
		
		vReturn += "@AnalyseType=" + analyseterm.analysetype.value;

		top.returnValue = vReturn;
		top.close();
	}
	
	function doDefault(){
		analyseterm.report_available.options.length = 0;
		analyseterm.report_chosen.length = 0;
		
		var j = 0;
		for(var i = 0; i < availableReportNameList.length; i++){
			eval("analyseterm.report_available.options[" + j + "] = new Option(availableReportCaptionList[" + i + "], availableReportNameList[" + i + "])");
			j++;
		}
		
		j = 0;
		for(var i = 0; i < selectedReportNameList.length; i++){
			eval("analyseterm.report_chosen.options[" + j + "] = new Option(selectedReportCaptionList[" + i + "], selectedReportNameList[" + i + "])");
			j++;
		}
		
		analyseterm.customer_available.options.length = 0;
		analyseterm.customer_chosen.length = 0;
		
		j = 0;
		for(var i = 0; i < availableCustomerNameList.length; i++){
			eval("analyseterm.customer_available.options[" + j + "] = new Option(availableCustomerCaptionList[" + i + "], availableCustomerNameList[" + i + "])");
			j++;
		}
		
		j = 0;
		for(var i = 0; i < selectedCustomerNameList.length; i++){
			eval("analyseterm.cusomer_chosen.options[" + j + "] = new Option(selectedCustomerCaptionList[" + i + "], selectedCustomerNameList[" + i + "])");
			j++;
		}
	}
	
	doDefault();
</script>
<%@ include file="/IncludeEnd.jsp"%>