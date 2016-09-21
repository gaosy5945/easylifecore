<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/strip.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/tabs.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%><%=sSkinPath%>/css/tabs.css">
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/tabstrip-1.0.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden;height:100%;width:100%;">
<div id="window1" style="vertical-align:middle;padding:0;border:0px solid #F00;height:100%;width: 100%; overflow:hidden">
</div>
</body>
<script type="text/javascript">
var tabCompent = new TabStrip("T01", "单个TabStrip组", "<%=_sView%>", "#window1");
<%String _TS = "self.name+\"", _first = null;
try{_first = CurPage.getAttribute("First");}catch(Exception e){}
String _script = "";
for(int _i = 0; _i < sTabStrip.length; _i++){
	if(!"true".equals(sTabStrip[_i][0])) continue;
	if(_first == null) _first = ""+_i;
	if(sTabStrip[_i].length < 3 || sTabStrip[_i][2].equals("")){
		_script = "";
	}else if(sTabStrip[_i].length < 4){
		_script = "AsControl.OpenComp('"+sTabStrip[_i][2]+"', '', 'TabContentFrame')";
	}else
		_script = "AsControl.OpenComp('"+sTabStrip[_i][2]+"', '"+sTabStrip[_i][3]+"', 'TabContentFrame')";
	boolean _close = sTabStrip[_i].length > 5 ? "true".equals(sTabStrip[_i][5]):false;
	out.println("tabCompent.addDataItem("+_TS+_i+"\", \""+sTabStrip[_i][1]+"\", \""+_script+"\", "
			+(sTabStrip[_i].length>6&&"false".equals(sTabStrip[_i][6])?"false":"true")+", " // 是否缓存，默认缓存
			+(sTabStrip[_i].length>5&&"true".equals(sTabStrip[_i][5])?"true":"false")+", " // 是否有关闭按钮，默认没有
			+(sTabStrip[_i].length>4&&!StringX.isSpace(sTabStrip[_i][4])?sTabStrip[_i][4]:"null")+");"); // Strip高度
}%>
<%if(_first!=null){%>tabCompent.setSelectedItem(<%=_TS+_first+"\""%>);<%}%>
tabCompent.init();
function addTabStripItem(sTitle, sUrl, sParas, bOpen){
	if(bOpen != false) bOpen = true;
	var script = !sUrl ? "" : "AsControl.OpenView('"+sUrl+"', '"+sParas+"', 'TabContentFrame')";
	tabCompent.addItem(self.name+escape(sTitle).replace(/[^A-z0-9]/g, ""), sTitle, script, true, true, bOpen);
}
</script>
</html>