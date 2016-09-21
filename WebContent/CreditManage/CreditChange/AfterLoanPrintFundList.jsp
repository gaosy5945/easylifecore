<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: YUJIYU090 20120915
		Tester:
		Describe: 提取公积金冲还贷情况表
		Input Param:
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>

<%
	String sTitleName = "提取公积金冲还贷情况表";
	
	//更具查询输入查询
	String sDATE_OP_ID = DataConvert.toRealString(iPostChange,(String)request.getParameter("DATE_OP_ID"));
	String sDATE_1_INPUT = DataConvert.toRealString(iPostChange,(String)request.getParameter("DATE_1_INPUT"));
	String sDATE_2_INPUT = DataConvert.toRealString(iPostChange,(String)request.getParameter("DATE_2_INPUT"));
	String sORG_1_VALUE = DataConvert.toRealString(iPostChange,(String)request.getParameter("ORG_1_VALUE"));
	String sORG_1_DISPLAY = DataConvert.toRealString(iPostChange,(String)request.getParameter("ORG_1_DISPLAY"));
	String sResourcesPath = sWebRootPath+"/Frame/page/resources/images/common/";
	String sBusinessDate = "";
	if(sDATE_OP_ID==null) sDATE_OP_ID="";
	if(sDATE_1_INPUT==null) sDATE_1_INPUT=sBusinessDate;
	if(sDATE_2_INPUT==null) sDATE_2_INPUT=sBusinessDate;
	if(sORG_1_VALUE==null) sORG_1_VALUE="";
	if(sORG_1_DISPLAY==null) sORG_1_DISPLAY="";
	
	String sWhereClause = "";
	String sEqualsString = "";
	String sBetweenString = "";
	String sDate = "";
	if(sDATE_OP_ID.equals("EqualsString")){
		sEqualsString = "selected";
		if("".equals(sDATE_1_INPUT) && "".equals(sORG_1_VALUE)) sWhereClause += "and 1=2";
		if(!"".equals(sDATE_1_INPUT)) sWhereClause += " and gjj.InputDate = '"+sDATE_1_INPUT+"'";
		if(!"".equals(sORG_1_VALUE)) sWhereClause+=" and exists (select 1 from ORG_BELONG where OrgID='"+sORG_1_VALUE+"' and BelongOrgId = LB.OrgID )";
		sDate = sDATE_1_INPUT+"-"+sDATE_1_INPUT;
	}else if(sDATE_OP_ID.equals("BetweenString")){
		sBetweenString = "selected";
		if("".equals(sDATE_1_INPUT) && "".equals(sORG_1_VALUE)) sWhereClause += "and 1=2";
		if(!"".equals(sDATE_1_INPUT)) sWhereClause += " and gjj.InputDate >= '"+sDATE_1_INPUT+"' and gjj.InputDate <= '"+sDATE_2_INPUT+"'";
		if(!"".equals(sORG_1_VALUE)) sWhereClause+=" and exists (select 1 from ORG_BELONG where OrgID='"+sORG_1_VALUE+"' and BelongOrgId = LB.OrgID )";
		sDate = sDATE_1_INPUT+"-"+sDATE_2_INPUT;
	}else{
		sEqualsString = "selected";
		sWhereClause = "";
	}

	String mfOrgID = DataConvert.toString(Sqlca.getString("Select MainframeOrgID from org_info where OrgID='"+sORG_1_VALUE+"'"),sORG_1_DISPLAY);
	
	String sFilter = 
		"<TR>"+
		"<TD id=DATE_TD_1>处理日期</TD>"+
		"<TD id=DATE_TD_2>"+
		"<select id=DATE_OP_ID name=DATE_OP_ID  class=DOFilterOperatorSelect onChange=\"showHideFilterElements('DATE',document.all('DATE_OP_ID'))\">"+
		"<option value='EqualsString' "+sEqualsString+">等于</option>"+
		"<option value='BetweenString' "+sBetweenString+" >在...之间</option>"+
		"</select>"+
		"</TD>"+
		"<TD id=DATE_TD_3><input id=DATE_1_INPUT name=DATE_1_INPUT value='"+sDATE_1_INPUT+"' readonly><input id=BeginButton type=button value=... onClick=selectDate(DATE_1_INPUT)></td>"+
		"<TD id=DATE_TD_4 style='DISPLAY: none'>到</TD>"+
		"<TD id=DATE_TD_5 style='DISPLAY: none'><input id=DATE_2_INPUT name=DATE_2_INPUT value='"+sDATE_2_INPUT+"' readonly><input id=BeginButton type=button value=... onClick=selectDate(DATE_2_INPUT)></td>"+
		"<TD id=DATE_TD_6>"+
		"<TABLE>"+
		"<TBODY>"+
		"<TR>"+
		"<TD><INPUT id=DATE_INPUT type=checkbox name=DATE_3_VALUE></TD>"+
		"<TD>大小写敏感</TD></TR></TBODY></TABLE></TD></TR>"+
		"<SCRIPT>showHideFilterElements('DATE',document.all('DATE_OP_ID'));</SCRIPT>"+
		"<TR>"+
		"<TD id=ORG_TD_1>入账机构</TD>"+
		"<TD id=ORG_TD_2><SELECT class=DOFilterOperatorSelect id=ORG_OP_ID onchange=\"showHideFilterElements('1',this)'\" name=ORG_OP_ID ><OPTION value=BeginsWith selected>以...开始</OPTION></SELECT></TD>"+
		"<TD id=ORG_TD_3><INPUT id=ORG_1_DISPLAY readOnly name=ORG_1_DISPLAY value ='"+sORG_1_DISPLAY+"'><INPUT id=ORG_1_INPUT readOnly type=hidden name=ORG_1_VALUE value ='"+sORG_1_VALUE+"'><INPUT id=ORG_1_BT onclick=filterAction('ORG_1_INPUT',6,'ORG_1_DISPLAY') type=button value=...></TD>"+
		"<TD id=ORG_TD_4 style='DISPLAY: none'></TD>"+
		"<TD id=ORG_TD_5 style='DISPLAY: none'><INPUT id=ORG_2_DISPLAY readOnly name=ORG_2_DISPLAY><INPUT id=ORG_2_INPUT readOnly type=hidden name=ORG_2_VALUE><INPUT id=ORG_2_BT onclick=filterAction('ORG_2_INPUT',6,'ORG_2_DISPLAY') type=button value=...></TD>"+
		"<TD id=ORG_TD_6></TD></TR>"+
		"<SCRIPT>showHideFilterElements('ORG',document.all('ORG_OP_ID'));</SCRIPT>"+
		"<TR>";
		
	CurPage.setAttribute("FilterHTML",sFilter);
	
	double 公积金中心_提取额=0.0d,公积金中心_冲还金额=0.0d,公积金中心_冲还公积金贷款=0.0d,公积金中心_冲还本金=0.0d,公积金中心_冲还利息=0.0d,公积金中心_冲还罚息=0.0d,公积金中心_冲还商业贷款=0.0d,公积金中心_冲还差额=0.0d;
	double 住房补贴_提取额=0.0d,住房补贴_冲还金额=0.0d,住房补贴_冲还公积金贷款=0.0d,住房补贴_冲还本金=0.0d,住房补贴_冲还利息=0.0d,住房补贴_冲还罚息=0.0d,住房补贴_冲还商业贷款=0.0d,住房补贴_冲还差额=0.0d;
	double 公积金提取额=0.0d,公积金冲还金额=0.0d,冲还公积金贷款=0.0d,冲还本金=0.0d,冲还利息=0.0d,冲还罚息=0.0d,冲还商业贷款=0.0d,冲还差额=0.0d;
	
	String sSql =   " Select sum(payamt) as 公积金中心_提取额  from "
				  + "("
				  + " Select gjj.payamt From fund_ctob gjj,business_duebill lb Where gjj.LOANNO = lb.LOANACCOUNTNO "+sWhereClause
				  + ")";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		公积金中心_提取额 = rs.getDouble("公积金中心_提取额");
	}
	rs.close();
	
	sSql =    " Select sum(payamt) as 公积金中心_冲还公积金贷款,sum(paycorpus) as 公积金中心_冲还本金 ,sum(payinte) as 公积金中心_冲还利息,sum(payfineinte) as 公积金中心_冲还罚息 from "
			+ "("
			+ " Select payamt,paycorpus,gjj.payinte,payfineinte From fund_update gjj,business_duebill lb Where gjj.loanno = lb.LOANACCOUNTNO And gjj.LoanType in('01','03') "+sWhereClause
			+ ")";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		公积金中心_冲还公积金贷款 = rs.getDouble("公积金中心_冲还公积金贷款");
		公积金中心_冲还本金 = rs.getDouble("公积金中心_冲还本金");
		公积金中心_冲还利息 = rs.getDouble("公积金中心_冲还利息");
		公积金中心_冲还罚息 = rs.getDouble("公积金中心_冲还罚息");
	}
	rs.close();
	
	sSql =   " Select sum(payamt) as 公积金中心_冲还商业贷款 from "
			+"("
			+" Select payamt From fund_update gjj,business_duebill lb Where gjj.loanno = lb.LOANACCOUNTNO And gjj.LoanType in('02','04') "+sWhereClause
			+")";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		公积金中心_冲还商业贷款 = rs.getDouble("公积金中心_冲还商业贷款");
	}
	rs.close();
	
	公积金中心_冲还金额 = 公积金中心_冲还公积金贷款 + 公积金中心_冲还商业贷款;
	公积金中心_冲还差额 = 公积金中心_提取额 - 公积金中心_冲还金额;
	
	sSql =   " Select sum(payamt) as 住房补贴_提取额  from "
			+"("
			+" Select gjj.payamt From fund_ztob gjj,business_duebill lb Where gjj.loanno = lb.LOANACCOUNTNO "+sWhereClause
			+")";
	
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		住房补贴_提取额 = rs.getDouble("住房补贴_提取额");
	}
	rs.close();
	
	sSql =   " Select sum(payamt) as 住房补贴_冲还公积金贷款,sum(paycorpus) as 住房补贴_冲还本金,sum(payinte) as 住房补贴_冲还利息,sum(payfineinte) as 住房补贴_冲还罚息  from "
			+"("
			+" Select payamt,paycorpus,gjj.payinte,payfineinte From fund_return gjj,business_duebill lb Where gjj.loanno = lb.LOANACCOUNTNO And gjj.LoanType in('01','03') "+sWhereClause
			+")";
	
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		住房补贴_冲还公积金贷款 = rs.getDouble("住房补贴_冲还公积金贷款");
		住房补贴_冲还本金 = rs.getDouble("住房补贴_冲还本金");
		住房补贴_冲还利息 = rs.getDouble("住房补贴_冲还利息");
		住房补贴_冲还罚息 = rs.getDouble("住房补贴_冲还罚息");
	}
	rs.close();
	
	sSql =   " Select sum(payamt) as 住房补贴_冲还商业贷款  from "
			+"("
			+" Select payamt From fund_return gjj,business_duebill lb Where gjj.loanno = lb.LOANACCOUNTNO And gjj.LoanType in('02','04') "+sWhereClause
			+")";
	
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		住房补贴_冲还商业贷款 = rs.getDouble("住房补贴_冲还商业贷款");
	}
	rs.close();
	
	住房补贴_冲还金额 = 住房补贴_冲还公积金贷款 + 住房补贴_冲还商业贷款;
	住房补贴_冲还差额 = 住房补贴_提取额 - 住房补贴_冲还金额;
	
	公积金提取额 = 公积金中心_提取额 + 住房补贴_提取额;
	公积金冲还金额 = 公积金中心_冲还金额 + 住房补贴_冲还金额;
	冲还公积金贷款 =  公积金中心_冲还公积金贷款 + 住房补贴_冲还公积金贷款;
	冲还本金 = 公积金中心_冲还本金 + 住房补贴_冲还本金;
	冲还利息 = 公积金中心_冲还利息 + 住房补贴_冲还利息;
	冲还罚息 = 公积金中心_冲还罚息 + 住房补贴_冲还罚息;
	冲还商业贷款 = 公积金中心_冲还商业贷款 + 住房补贴_冲还商业贷款;
	冲还差额 = 公积金中心_冲还差额 + 住房补贴_冲还差额;
 %>
 
 <table width="100%" border="1" align="center"  cellspacing="0" cellpadding="5" bordercolor='#CCCCCC'>
 	<tr height=1 >
				<td id="FilterButtonTd">
				<span id="ShowFilterButton">
				<table border="0" cellspacing="0" cellpadding="0">
				<tr><td>
				<img class="FilterIcon" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="FilterIconPlus" onClick="showHideFilterArea()">
				<img class="FilterIcon2" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="FilterIconMinus" onClick="showHideFilterArea()">
				</td><td><a href="javascript:showHideFilterArea();"> &nbsp;查询条件</a></td></tr></table>
				</span>
				</td>
</tr>
<tr height=1 >
				<form name="DOFilter" method='post' action="PrintGJJSheet.jsp">
				<input type=hidden name=CompClientID value="<%=CurComp.getClientID()%>">
				<input type=hidden name=PageClientID value="<%=CurComp.getClientID()%>">
				<input type=hidden name=DWCurPage value="0">
				<input type=hidden name=DWCurRow value="0">
				<td colspan=2 id="ListCriteriaTd" class="ListCriteriaTd">
				<span id="FilterArea">
				<!--查询区-->
				<%
				String sFilterHTML = (String)CurPage.getAttribute("FilterHTML");

				if(sFilterHTML!=null && !sFilterHTML.equals(""))
				{
					%>
						<table align=center border="1" bordercolorlight='#99999' bordercolordark='#FFFFFF' width="100%" height="100%" cellspacing="0" cellpadding="3">
						<tr>
						<td class="FilterHeaderTd">
						<a href="javascript:doSubmit()">[查询]</a>
						<a href="javascript:clearFilterForm('DOFilter')">[清空]</a>
						<a href="javascript:resetFilterForm('DOFilter')">[恢复]</a>
						<a href="javascript:hideFilterArea()">[取消]</a>
						&nbsp;&nbsp;&nbsp;&nbsp; <span class="DOFilterHint">请输入查询条件，并点击“查询”。</span>
						</td>
						</tr>
						<tr>
						<td>
							<table>
							<%=sFilterHTML%>
							</table>
						</td>
						</tr>
						<tr>
						<td class="FilterSubmitTd" >
						<input type=submit value="查询">
						<input type=button onclick="clearFilterForm('DOFilter')" value="清空">
						<input type=button onclick="resetFilterForm('DOFilter')" value="恢复">
						<input type=button onclick="hideFilterArea()" value="取消">
						</td>
						</tr>
						</table>
					<%
				}
				%>
				</span>
				</td>
				</form>
</tr>
<script>
	var bFilterAreaShowStatus=false;
	<%
	if(sFilterHTML==null || sFilterHTML.equals("")){
	%>
		showHideObjects("ShowFilterButton","hide");
		showHideObjects("FilterArea","hide");
		bFilterAreaShowStatus = false;
	<%
	}else{
		%>
		hideFilterArea();
		bFilterAreaShowStatus = false;	
		<%
	}
	%>
	function showHideFilterArea(){
		if(!bFilterAreaShowStatus){
			showFilterArea();
		}else{
			hideFilterArea();
		}
	}
	function showFilterArea()
	{
		//showHideObjects("ShowFilterButton","hide");
		showHideObjects("FilterArea","show");
		bFilterAreaShowStatus = true;
		showHideObjects("FilterIconPlus","hide");
		showHideObjects("FilterIconMinus","show");
	}
	function hideFilterArea(){
		//showHideObjects("ShowFilterButton","show");
		showHideObjects("FilterArea","hide");
		bFilterAreaShowStatus = false;
		showHideObjects("FilterIconPlus","show");
		showHideObjects("FilterIconMinus","hide");
	}
</script>
    <tr>
	    <td class="buttonback" valign=top>
		    <table>
		    	<tr>	
				<td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","打印","打印","ExcelPrint()",sResourcesPath)%></td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<object classid="clsid:0002E559-0000-0000-C000-000000000046" style="display:block" id=Spreadsheet1 width="100%" height="90%" codebase="<%=sWebRootPath%>/OWC11.DLL#version=0,0,0,0" >
	<PARAM NAME="HTMLURL" VALUE="<%=sWebRootPath%>/CreditManage/HouseFund/PrintGJJ.htm">
	<PARAM NAME="DataType" VALUE="HTMLURL">
	<!--  PARAM NAME="AutoFit" VALUE="0">   -->
	<PARAM NAME="DisplayColHeaders" VALUE="-1">
	<PARAM NAME="DisplayGridlines" VALUE="1">
	<PARAM NAME="DisplayHorizontalScrollBar" VALUE="-1">
	<PARAM NAME="DisplayRowHeaders" VALUE="-1">
	<PARAM NAME="DisplayTitleBar" VALUE="-1">
	<PARAM NAME="DisplayToolbar" VALUE="-1" >
	<PARAM NAME="DisplayVerticalScrollBar" VALUE="-1">
	<PARAM NAME="EnableAutoCalculate" VALUE="-1">
	<PARAM NAME="EnableEvents" VALUE="-1">
	<PARAM NAME="MoveAfterReturn" VALUE="-1">
	<PARAM NAME="MoveAfterReturnDirection" VALUE="0">
	<!--  PARAM NAME="RightToLeft" VALUE="0">  -->
	<PARAM NAME="ViewableRange" VALUE="1:65536">
</object>

</body>
<script language=javascript>
	function doSubmit(){
		DOFilter.submit();
	}

	function selectDate(obj){
		sDate=obj.value;
		sDate = PopPage("/Common/ToolsA/SelectDate.jsp?rand="+randomNumber()+"&d="+sDate,"","dialogWidth=20;dialogHeight=16;center:yes;status:no;statusbar:no");
		if(typeof(sDate)!="undefined"){
			obj.value=sDate;
		}
	}

	function filterAction(sObjectID,sFilterID,sObjectID2){
		oMyObj = document.all(sObjectID);
		oMyObj2 = document.all(sObjectID2);
		
		if(sFilterID=="6"){
			//弹出模态窗口选择框，并将返回值赋给sReturn
			sReturn = setObjectValue("SelectAllOrg","","");
			if(typeof(sReturn)=="undefined" || sReturn=="_CANCEL_"){
				return;
			}else if(sReturn=="_CLEAR_"){
				oMyObj.value="";
				oMyObj2.value="";
			}else{
				sReturns = sReturn.split("@");
				oMyObj.value=sReturns[0];
				oMyObj2.value=sReturns[1];
			}
		}
		if(sFilterID=="9"){
			//弹出模态窗口选择框，并将返回值赋给sReturn
			var sReturn = popComp("GetReturnType.jsp","/InfoManage/ReportListing/GetReturnType.jsp","","dialogWidth=300px;dialogHeight=300px;resizable=yes;status:yes;maximize:yes;help:no;");
			if(typeof(sReturn)=="undefined" || sReturn=="_CANCEL_" || sReturn.length == 0){
				return;
			}else{
				sReturn = sReturn.split("@");
				
				var sTemp = sReturn[0];
				var sTemp1 = "";
				sTemp = sTemp.split(",");
				for(var i = 0; i < sTemp.length ; i ++){
					sTemp1 += "'"+sTemp[i]+"',";
				}
				sTemp1 = sTemp1.substring(0,sTemp1.length-1);
				sTemp1 = " ("+sTemp1+") ";
		
				oMyObj.value=sTemp1;
				oMyObj2.value=sReturn[1];
			}
		}
	}
	
	
    function ExportExcel(){
       try{
            Spreadsheet1.Export();
       }catch(e){
          alert("导出发生错误!错误信息:"+e.message);
       }
    }
	
	function ExcelPrint(){
		spreadsheetPrintout(document.all('Spreadsheet1').HTMLData);
	}
	
    
</script>

<script language=vbscript > 
//平安
function createTemporaryFileRCPM(data) 
	Dim fso,tfolder,tfile,fileName
	Const TemporaryFolder = 2
	Set fso = CreateObject("Scripting.FileSystemObject")	
	Set tfolder = fso.GetSpecialFolder(TemporaryFolder)
	fileName = tfolder+"\"+fso.GetTempName+".xls"
	Set tfile = fso.CreateTextFile(fileName, True, True)
	tfile.write(data)
	tfile.close
	createTemporaryFileRCPM=fileName
end function


Function spreadsheetPrintout(data) 
	
	s = createTemporaryFileRCPM(data)
	
	Set xlApp = CreateObject("Excel.Application")
	Set xlBook = xlApp.Workbooks.open(s)
   
	xlBook.Sheets(1).PrintOut
	xlBook.Close 
end function
</script>

<script language=javascript>

				Spreadsheet1.Cells(2,1) = "<%="机构："+mfOrgID%>"; 
				Spreadsheet1.Cells(5,2) = "<%=DataConvert.toMoney(公积金提取额)%>";
				Spreadsheet1.Cells(5,3) = "<%=DataConvert.toMoney(公积金中心_提取额)%>";
				Spreadsheet1.Cells(5,4) = "<%=DataConvert.toMoney(住房补贴_提取额)%>";
				Spreadsheet1.Cells(6,2) = "<%=DataConvert.toMoney(公积金冲还金额)%>";
				Spreadsheet1.Cells(6,3) = "<%=DataConvert.toMoney(公积金中心_冲还金额)%>";
				Spreadsheet1.Cells(6,4) = "<%=DataConvert.toMoney(住房补贴_冲还金额)%>";
				Spreadsheet1.Cells(7,2) = "<%=DataConvert.toMoney(冲还公积金贷款)%>";
				Spreadsheet1.Cells(7,3) = "<%=DataConvert.toMoney(公积金中心_冲还公积金贷款)%>";
				Spreadsheet1.Cells(7,4) = "<%=DataConvert.toMoney(住房补贴_冲还公积金贷款)%>";
				Spreadsheet1.Cells(8,2) = "<%=DataConvert.toMoney(冲还本金)%>";
				Spreadsheet1.Cells(8,3) = "<%=DataConvert.toMoney(公积金中心_冲还本金)%>";
				Spreadsheet1.Cells(8,4) = "<%=DataConvert.toMoney(住房补贴_冲还本金)%>";
				Spreadsheet1.Cells(9,2) = "<%=DataConvert.toMoney(冲还利息)%>";
				Spreadsheet1.Cells(9,3) = "<%=DataConvert.toMoney(公积金中心_冲还利息)%>";
				Spreadsheet1.Cells(9,4) = "<%=DataConvert.toMoney(住房补贴_冲还利息)%>";
				Spreadsheet1.Cells(10,2) = "<%=DataConvert.toMoney(冲还罚息)%>";
				Spreadsheet1.Cells(10,3) = "<%=DataConvert.toMoney(公积金中心_冲还罚息)%>";
				Spreadsheet1.Cells(10,4) = "<%=DataConvert.toMoney(住房补贴_冲还罚息)%>";
				Spreadsheet1.Cells(11,2) = "<%=DataConvert.toMoney(冲还商业贷款)%>";
				Spreadsheet1.Cells(11,3) = "<%=DataConvert.toMoney(公积金中心_冲还商业贷款)%>";
				Spreadsheet1.Cells(11,4) = "<%=DataConvert.toMoney(住房补贴_冲还商业贷款)%>";
				Spreadsheet1.Cells(12,2) = "<%=DataConvert.toMoney(冲还差额)%>";
				Spreadsheet1.Cells(12,3) = "<%=DataConvert.toMoney(公积金中心_冲还差额)%>";
				Spreadsheet1.Cells(12,4) = "<%=DataConvert.toMoney(住房补贴_冲还差额)%>"; 
</script>

<script language=vbscript >
	Spreadsheet1.ActiveSheet.Protection.Enabled = True
</script>


<%@	include file="/IncludeEnd.jsp"%>