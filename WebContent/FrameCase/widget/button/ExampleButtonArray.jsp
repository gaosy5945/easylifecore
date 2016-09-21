<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","test()","","","",""},//btn_icon_add
		{"true","All","Button","详情","查看/修改详情","test()","","","",""},//btn_icon_detail
		{"true","","Button","保存","保存修改","test()","","","",""},//btn_icon_save
		{"true","","Button","删除","删除所选中的记录","test()","","","",""},//btn_icon_delete
		{"true","All","Button","关闭","关闭","test()","","","","btn_icon_close"},
		{"true","All","Button","提交","提交","test()","","","","btn_icon_submit"},
		{"true","All","Button","编辑","编辑","test()","","","","btn_icon_edit"},
		{"true","All","Button","刷新","刷新","test()","","","","btn_icon_refresh"},
		{"true","All","Button","信息","信息","test()","","","","btn_icon_information"},
		{"true","All","Button","帮助","帮助","test()","","","","btn_icon_help"},
		{"true","All","Button","退出","退出","test()","","","","btn_icon_exit"},
		{"true","All","Button","搜索","搜索","test()","","","","btn_icon_check"},
		{"true","All","Button","上箭头","上箭头","test()","","","","btn_icon_up"},
		{"true","All","Button","下箭头","下箭头","test()","","","","btn_icon_down"},
		{"true","All","Button","左箭头","左箭头","test()","","","","btn_icon_left"},
		{"true","All","Button","右箭头","右箭头","test()","","","","btn_icon_right"}
	};
%>
<div>
  	<pre>
  	
  	按钮数组定义，依次为:
	0.是否显示 "true"/"false"
	1.权限类型，除了新增、删除和保存三个按钮可为空外，其他均设置为'All'
	2.类型，默认为Button (可选Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
	3.按钮文字
	4.提示文字
	5.函数名
	6.shortcutKey 快捷键
	7.href 资源路径
	8.parm 资源路径参数
	9.iconCls 图标 CSS名称 (参考 button.css)
	
  	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()","","","",""},
		{"true","","Button","保存","保存","saveRecord()","","","",""},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""},
		{"true","All","Button","关闭","关闭","close()","","","","btn_icon_close"}
	}
	</pre>
</div>
<%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%>
<hr>
<%=new Button("禁锢[新增]按钮","","AsButton.unable('新增')").getHtmlText()%>
<span style="font-size:12px;">AsButton.unable('新增');</span>
<br>
<%=new Button("解除禁锢[新增]按钮","","AsButton.able('新增')").getHtmlText()%>
<span style="font-size:12px;">AsButton.able('新增');</span>
<script type="text/javascript">
	function test(){
		alert('点击按钮');
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>