<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	String sUserID = CurPage.getParameter("UserID");
    if(sUserID == null) sUserID = "";
%>
<script type="text/javascript">
	var availableReportCaptionList = new Array;
	var availableReportNameList = new Array;
	var selectedReportCaptionList = new Array;
	var selectedReportNameList = new Array;
<%
	//实例化用户对象
	ASUser o_User = ASUser.getUser(sUserID,Sqlca);		
	//获取机构级别
	String sOrgLevel = Sqlca.getString(new SqlObject("select OrgLevel from ORG_INFO where OrgID = :OrgID").setParameter("OrgID",o_User.getOrgID()));
	if(sOrgLevel == null) sOrgLevel = "";
	
	int num = 0;
/* 	String sSql = " select RoleID || ' ' || RoleName as Allrole,RoleID" +
			" from AWE_ROLE_INFO "+ 
			" where length(RoleID)>1 "+
			" and RoleID not in (select RoleID from USER_ROLE where UserID = :UserID) ";//ORCAL */
	String sSql = " select concat(RoleID, ' ' , RoleName) as Allrole,RoleID" +
			" from AWE_ROLE_INFO "+ 
			" where length(RoleID)>1 "+
			" and RoleID not in (select RoleID from USER_ROLE where UserID = :UserID) ";//MYSQL	
			
	if(CurUser.hasRole("090")){
        if(sOrgLevel.equals("0")) //机构级别OrgLevel(0：总行；3：分行；6：支行；9：网点)
        	 sSql += " and (RoleID like '0%' "+	        		
	        		 " or RoleID like '8%') "+
	        		 " and RoleStatus = '1' ";
        if(sOrgLevel.equals("3")) //机构级别OrgLevel(0：总行；3：分行；6：支行；9：网点)
        	 sSql += " and (RoleID like '2%' "+	        		
	        		" or RoleID like '8%') "+
	        		" and RoleStatus = '1' ";
        if(sOrgLevel.equals("6")) //机构级别OrgLevel(0：总行；3：分行；6：支行；9：网点)
	        sSql += " and (RoleID like '4%' "+
	        		" or RoleID like '8%') "+
	        		" and RoleStatus = '1' ";
    }else if(CurUser.hasRole("290")){
        if(sOrgLevel.equals("3")) //机构级别OrgLevel(0：总行；3：分行；6：支行；9：网点)
        	 sSql += " and (RoleID like '2%' "+	        		
	        		" or RoleID like '8%') "+
	        		" and RoleStatus = '1' ";
        if(sOrgLevel.equals("6")) //机构级别OrgLevel(0：总行；3：分行；6：支行；9：网点)
	        sSql += " and (RoleID like '4%' "+
	        		" or RoleID like '8%') "+
	        		" and RoleStatus = '1' ";
    }else if(CurUser.hasRole("490")){
       if(sOrgLevel.equals("6")) //机构级别OrgLevel(0：总行；3：分行；6：支行；9：网点)
	        sSql += " and (RoleID like '4%' "+
	        		" or RoleID like '8%') "+
	        		" and RoleStatus = '1' ";
    }
    
    sSql += " order by RoleID ";
    ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID",sUserID));
	num = 0;
	while(rs.next()){
		out.println("availableReportCaptionList[" + num + "] = '" + rs.getString(1) + "';\r");
		System.out.print(num+"="+rs.getString(1));
		out.println("availableReportNameList[" + num + "] = '" + rs.getString(2) + "';\r");
		System.out.print(num+"="+rs.getString(2));
		num++;
	}
	rs.getStatement().close();

/* 	String sSql1 = " select ri.RoleID || ' ' || ri.RoleName as Allrole,ri.RoleID" +
			" from USER_ROLE ur,AWE_ROLE_INFO ri "+
			" where ur.RoleID = ri.RoleID "+
			" and ur.UserID = :UserID "+
			" and ur.RoleID <> '800'";//orcal */
	String sSql1 = " select concat(ri.RoleID , ' ' , ri.RoleName) as Allrole,ri.RoleID" +
			" from USER_ROLE ur,AWE_ROLE_INFO ri "+
			" where ur.RoleID = ri.RoleID "+
			" and ur.UserID = :UserID "+
			" and ur.RoleID <> '800'";//mysql
	
    ASResultSet rs1 = Sqlca.getASResultSet(new SqlObject(sSql1).setParameter("UserID",sUserID));
	num = 0;
	while(rs1.next()){
		out.println("selectedReportCaptionList[" + num + "] = '" + rs1.getString(1) + "';\r");
		System.out.print(num+"="+rs1.getString(1));
		out.println("selectedReportNameList[" + num + "] = '" + rs1.getString(2) + "';\r");
		System.out.print(num+"="+rs1.getString(2));
		num++;
	}
	rs1.getStatement().close();
%>
</script>
<html>
<head>
	<title>选取用户角色</title>
</head>
<body bgcolor="#E4E4E4">
<form name="analyseterm">
<table align="center" width="100%">
	<tr>
		<td>
			<table width='100%' border='1' cellpadding='0' cellspacing='5' bgcolor='#DDDDDD'>
				<tr>
					<td colspan="4">
						<span>选取要新增的用户角色</span>
					</td>
				</tr>
				<tr>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>可新增的用户角色列表</span>
					</td>
					<td bordercolor='#DDDDDD'></td>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>待新增的用户角色列表</span>
					</td>
					<td></td>
				</tr>
				<tr>
					<td align='center'>
						<select name='report_available' onchange='selectionChanged(document.forms["analyseterm"].elements["report_available"],document.forms["analyseterm"].elements["report_chosen"]);' size='12' style='width:100%;' multiple='true'> 
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
					<td align='center'>
						<select name='report_chosen' onchange='selectionChanged(document.forms["analyseterm"].elements["report_chosen"],document.forms["analyseterm"].elements["report_available"]);' size='12' style='width:100%;' multiple='true'>
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
			</table>
		</td>
	</tr>
	<tr height=1>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan=4>
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
	
	function moveSelected(from,to) {
		newTo = new Array();
		for(var i=0; i<to.options.length; i++){
			newTo[newTo.length] = cloneOption(to.options[i]);
			newTo[newTo.length-1].selected = false;
		}
		
		for(i=0; i<from.options.length; i++){
			if (from.options[i].selected) {
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
		if(analyseterm.report_chosen.length == 0){
			alert("请选择要新增的用户角色！");
			return;
		}
		
		var vReturn = "";
		var vReportCount = analyseterm.report_chosen.length;
		for(var i=0; i<vReportCount;i++){
			var vTemp = analyseterm.report_chosen.options[i].value;
            vReturn = vReturn+vTemp+"@";
		}
		var sReturnMessage = RunJavaMethodTrans("com.amarsoft.app.awe.config.orguser.action.AddMuchRolesAction","addMuchRoles","UserID=<%=CurUser.getUserID()%>,Action=UPDATE,UsersID=<%=sUserID%>,RolesID="+vReturn);
		alert(sReturnMessage);
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
	}
	
	doDefault();
</script>
<%@ include file="/IncludeEnd.jsp"%>