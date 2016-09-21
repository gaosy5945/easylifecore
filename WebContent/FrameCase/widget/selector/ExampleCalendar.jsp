<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<html>
<head>
<style>
	body {
		overflow: auto;
		padding: 10px;
	}
	.test {
		border: solid #aaa;
		border-width: 1px 1px 0 1px;
	}
	.test td {
		border: 0 solid #aaa;
		border-bottom-width: 1px;
		padding: 2px;
	}
	.test b {
		padding: 0 10px;
	}
	.test input {
		cursor:pointer;
	}
</style>
</head>
<body>
<table class="test" cellspacing=0 cellpadding=0 >
	<tr>
		<td colspan="5" style="padding-left:20px;"><pre>
/**
 * 日期选择器
 * @param obj 绑定控件，一般为text输入框
 * @param strFormat 日期格式化字符串
 * @param startDate 能选日期最早值【"Today"：当前日期】【数字类型：与当前日期的天数偏移量】【字符串：与strFormat格式一致的时间】【空：不受限制】
 * @param endDate 能选日期最晚值【与startDate的解释一致】
 * @param postEvent 日期选择后续事件对象，如function(){...}
 * @param x 横向偏移量
 * @param y 纵向偏移量
 */
AsDialog.OpenCalender(obj, strFormat, startDate, endDate, postEvent, x, y);
		</pre></td>
	</tr>
	<tr>
		<td rowspan="5" style="border-right-width:1px;">日期格式</td>
		<td colspan="2">全格式</td>
		<td><input id="test11" onclick="AsDialog.OpenCalender(this, 'yyyy/MM/dd hh:mm:ss');" /><button onclick="AsDialog.OpenCalender('test11', 'yyyy/MM/dd hh:mm:ss');" >...</button></td>
		<td>AsDialog.OpenCalender(obj, 'yyyy/MM/dd hh:mm:ss');</td>
	</tr>
	<tr>
		<td colspan="2">年月日(默认)</td>
		<td><input id="test12" onclick="AsDialog.OpenCalender(this);" /><button onclick="AsDialog.OpenCalender('test12');" >...</button></td>
		<td>AsDialog.OpenCalender(obj);<b>或</b>AsDialog.OpenCalender(obj, 'yyyy/MM/dd');</td>
	</tr>
	<tr>
		<td colspan="2">年月</td>
		<td><input id="test13" onclick="AsDialog.OpenCalender(this, 'yyyy/MM');" /><button onclick="AsDialog.OpenCalender('test13', 'yyyy/MM');" >...</button></td>
		<td>AsDialog.OpenCalender(obj, 'yyyy/MM');</td>
	</tr>
	<tr>
		<td colspan="2">年</td>
		<td><input id="test14" onclick="AsDialog.OpenCalender(this, 'yyyy');" /><button onclick="AsDialog.OpenCalender('test14', 'yyyy');" >...</button></td>
		<td>AsDialog.OpenCalender(obj, 'yyyy');</td>
	</tr>
	<tr>
		<td colspan="2">中文格式</td>
		<td><input id="test15" onclick="AsDialog.OpenCalender(this, 'yyyy年MM月dd日hh时mm分ss秒');" style="overflow:visible;"/><button onclick="AsDialog.OpenCalender('test15', 'yyyy年MM月dd日hh时mm分ss秒');" >...</button></td>
		<td>AsDialog.OpenCalender(obj, 'yyyy年MM月dd日hh时mm分ss秒');</td>
	</tr>
	<tr>
		<td rowspan="7" style="border-right-width:1px;">日期区间</td>
		<td colspan="2">无区间(当年前后50年)</td>
		<td><input id="test21" onclick="AsDialog.OpenCalender(this, 'yyyy/MM/dd hh:mm:ss');" /><button onclick="AsDialog.OpenCalender('test21', 'yyyy/MM/dd hh:mm:ss');" >...</button></td>
		<td>AsDialog.OpenCalender(this, strFormat);</td>
	</tr>
	<tr>
		<td colspan="2">前区间</td>
		<td><input id="test22" onclick="AsDialog.OpenCalender(this, 'yyyy/MM/dd hh:mm:ss', '2012/10/25 12:30:00');" /><button onclick="AsDialog.OpenCalender('test22', 'yyyy/MM/dd hh:mm:ss', '2012/10/25 12:30:00');" >...</button></td>
		<td>AsDialog.OpenCalender(this, strFormat, beginDate);</td>
	</tr>
	<tr>
		<td colspan="2">后区间</td>
		<td><input id="test23" onclick="AsDialog.OpenCalender(this, 'yyyy/MM/dd hh:mm:ss', '', '2012/10/25 12:30:00');" /><button onclick="AsDialog.OpenCalender('test23', 'yyyy/MM/dd hh:mm:ss', '', '2012/10/25 12:30:00');" >...</button></td>
		<td>AsDialog.OpenCalender(this, strFormat, '', endDate);</td>
	</tr>
	<tr>
		<td colspan="2">前后区间</td>
		<td><input id="test24" onclick="AsDialog.OpenCalender(this, 'yyyy/MM/dd hh:mm:ss', '2010/10/25 00:00:00', '2012/10/25 12:30:00');" /><button onclick="AsDialog.OpenCalender('test24', 'yyyy/MM/dd hh:mm:ss', '2010/10/25 00:00:00', '2012/10/25 12:30:00');" >...</button></td>
		<td>AsDialog.OpenCalender(this, strFormat, beginDate, endDate);</td>
	</tr>
	<tr>
		<td rowspan="3" style="border-right-width:1px;">与当前时间相关</td>
		<td>当前时间后</td>
		<td><input id="test31" onclick="AsDialog.OpenCalender(this, 'yyyy/MM/dd', 'today');" /><button onclick="AsDialog.OpenCalender('test31', 'yyyy/MM/dd', 'today');" >...</button></td>
		<td>AsDialog.OpenCalender(this, strFormat, 'today');</td>
	</tr>
	<tr>
		<td>当前时间前</td>
		<td><input id="test32" onclick="AsDialog.OpenCalender(this, 'yyyy/MM/dd', '', 'today');" /><button onclick="AsDialog.OpenCalender('test32', 'yyyy/MM/dd', '', 'today');" >...</button></td>
		<td>AsDialog.OpenCalender(this, strFormat, '', 'today');</td>
	</tr>
	<tr>
		<td>当前时间前3600天后3600天</td>
		<td><input id="test33" onclick="AsDialog.OpenCalender(this, 'yyyy/MM/dd', -3600, 3600);" /><button onclick="AsDialog.OpenCalender('test33', 'yyyy/MM/dd', -3600, 3600);" >...</button></td>
		<td>AsDialog.OpenCalender(this, strFormat, -3600, 3600);</td>
	</tr>
</table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>