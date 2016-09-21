<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<body style="overflow: hidden; height: 100%; width: 100%;">
<table height="100%" width="100%">
<tr height="1"><td>
<pre>
前三个参数固定，后面参数和数组定义按钮的参数含义一样
new Button(String text, String tips, String action, String shortcutKey, String iconCls, String style).getHtmlText();
</pre>
</td></tr>
<tr height="100%"><td valign="top">
<input type="button" value="input" onclick="alert('input')" />
<button onclick="alert('button')">button</button>
<%=new Button("norm", "", "alert('norm')", "", "btn_icon_information", "").getHtmlText()%>
<%=new Button("sys", "", "alert('sys')", "", "btn_icon_information", "sys").getHtmlText()%>
<%=new Button("high", "", "alert('high')", "", "btn_icon_information", "high").getHtmlText()%>
<%=new Button("high2", "", "alert('high2')", "", "btn_icon_information", "high2").getHtmlText()%>
<%Button b = new Button("unable", "", "alert('不能触发到事件，除非解除禁锢')", "", "btn_icon_information", "unable");%>
<%=b.getHtmlText()%>
<hr>
<%=new Button("新增", "新增一条记录", "test()", "", "btn_icon_add").getHtmlText()%>
<%=new Button("详情","查看/修改详情","test()","", "btn_icon_detail").getHtmlText()%>
<%=new Button("保存","保存","test()","","btn_icon_save").getHtmlText()%>
<%=new Button("删除","删除所选中的记录","test()","", "btn_icon_delete").getHtmlText()%>
<%=new Button("关闭","关闭","test()","","btn_icon_close").getHtmlText()%>
<%=new Button("提交","提交","test()","","btn_icon_submit").getHtmlText()%>
<%=new Button("编辑","编辑","test()","","btn_icon_edit").getHtmlText()%>
<%=new Button("刷新","刷新","test()","","btn_icon_refresh").getHtmlText()%>
<%=new Button("信息","信息","test()","","btn_icon_information").getHtmlText()%>
<%=new Button("帮助","帮助","test()","","btn_icon_help").getHtmlText()%>
<%=new Button("退出","退出","test()","","btn_icon_exit").getHtmlText()%>
<%=new Button("搜索","搜索","test()","","btn_icon_check").getHtmlText()%>
<%=new Button("上箭头","上箭头","test()","","btn_icon_up").getHtmlText()%>
<%=new Button("下箭头","下箭头","test()","","btn_icon_down").getHtmlText()%>
<%=new Button("左箭头","左箭头","test()","","btn_icon_left").getHtmlText()%>
<%=new Button("右箭头","右箭头","test()","","btn_icon_right").getHtmlText()%>
<hr>
<%=new Button("禁锢按钮","","AsButton.unable('"+b.getButtonID()+"')").getHtmlText()%>
<span style="font-size:12px;">AsButton.unable(sBtnId);</span>
<br>
<%=new Button("解除禁锢按钮","","AsButton.able('"+b.getButtonID()+"')").getHtmlText()%>
<span style="font-size:12px;">AsButton.able(sBtnId);</span>
</td></tr>
<tr><td>
<table><tr>
<td><%=new Button("右箭头","右箭头","test()","","btn_icon_right").getHtmlText()%></td>
<td><%=new Button("右箭头","右箭头","test()","","btn_icon_right").getHtmlText()%></td>
<td><%=new Button("右箭头","右箭头","test()","","btn_icon_right").getHtmlText()%></td>
<td><%=new Button("右箭头","右箭头","test()","","btn_icon_right").getHtmlText()%></td>
</tr></table>
</td></tr>
</table>
</body>
<script type="text/javascript">
	function test(){
		alert("点击按钮");
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>