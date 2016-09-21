<%
String sFilterHTML = (String)CurPage.getAttribute("FilterHTML");
if(sFilterHTML!=null && !sFilterHTML.equals("")){
%>
<link rel="stylesheet" href="<%=sWebRootPath%>/Frame/page/resources/css/filter.css">
<div id="FilterArea" onmousedown="AsLink.moveBoxOnDown(event, this)" onmouseover="AsLink.opacityBoxOnOver(this);" class="list_search list_search_nohover" style="display: none;">
	<div onclick="hideFilterArea();return false;" class="ow_righttop_close">&nbsp;</div>
	<form name="DOFilter" method=post >
		<input type=hidden name=CompClientID value="<%=CurComp.getClientID()%>">
		<input type=hidden name=DWCurPage id=DWCurPage value="0">
		<input type=hidden name=DWCurRow id=DWCurRow value="0">
		<input type=hidden name=DWInSearch value="true">
			<table align=center width="100%" cellspacing="0" cellpadding="3">
				<tr>
				<td>
				<table><%=sFilterHTML%></table>
				</td>
				</tr>
				<tr>
				<td class="FilterSubmitTd" align="center" >
				<input type="submit" value="查询" onclick="if(this.unable){return false;}else{this.unable=true;}" />
				<input type="button" value="清空" onclick="clearFilterForm('DOFilter')" />
				<input type="button" value="恢复" onclick="resetFilterForm('DOFilter')" />
				<input type="button" value="取消" onclick="hideFilterArea()" />
				<%--
				<%=new Button("查询","查询","if(!checkDOFilterForm('DOFilter')){}else{submitFilterForm('DOFilter');}","","","").getHtmlText()%>
				<%=new Button("清空","清空","clearFilterForm('DOFilter')","","","").getHtmlText()%>
				<%=new Button("恢复","恢复","resetFilterForm('DOFilter')","","","").getHtmlText()%>
				<%=new Button("取消","取消","hideFilterArea()","","","").getHtmlText()%>
				--%>
				</td>
				</tr>
			</table>
	</form>
</div>
<script type="text/javascript">
	$("#FilterArea input, #FilterArea select").mousedown(function(e){
		AsLink.stopEvent(e);
	});

	function showFilterArea(tableIndex){
		var div = $("#FilterArea");
		var doc = $(document).add(myiframe0.document).unbind(".dwfilter");
		
		if(div.is(":hidden")){
			doc.bind("keyup.dwfilter", function(e){
				if(e.keyCode!=27) return;
				div.hide();
			});
			div.css({
				"top":35,
				"left":10
			}).show();
		}else{
			div.hide();
		}
	}
	function hideFilterArea(tableIndex){
		$(document).add(myiframe0.document).unbind(".dwfilter");
		$("#FilterArea").hide();
	}
</script>
<%}else {%>
<form name="DOFilter" method=post >
       <input type=hidden name=CompClientID value="<%=CurComp.getClientID()%>">
       <input type=hidden name=DWCurPage id=DWCurPage value="0">
       <input type=hidden name=DWCurRow id=DWCurRow value="0">
       <input type=hidden name=DWInSearch value="true">
</form>
<%}%>
        