<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
<br/>
<div>
	<pre>
  从SELECT_CATALOG配置中生成选择信息，是否多选根据配置的选择模式（Multi/Single）来决定：
	当要获得选择框的返回值时，才调用AsDialog.OpenSelector()打开弹出选择框，来获取返回值；
	如果是仅是通过选择框的返回值给DW的字段赋值，请在DW模型里配置
	AsDialog.OpenSelector(sSelname,sParaString,sStyle)
	sSelname：选择对话框编号
	sParaString：传入选择对话框配置需要的参数，参数形式为    参数名=参数值
	sStyle：  对话框样式
	</pre>
	<%=new Button("列表选择框","列表选择框","selectList()","","btn_icon_detail","").getHtmlText()%>
	<%=new Button("树图选择框","树图选择框","selectTree()","","btn_icon_detail","").getHtmlText()%>
</div>
<br/>
<div>
	<pre>
  从显示模板生成选择列表：
	A、打开弹出选择框，并获取返回值
	参数说明：1、显示模板编号  2、参数串：参数值1,参数值2,...  
		3、返回值串： 返回字段1@返回字段2@...
		4、预选值，为第一个返回字段的值（现只支持多选）
		5、是否多选 (true/false)
	return : 返回值按返回字段返回，如果是多选以符号“~”分隔，如：0010@节点1@...~0020@节点2@...~...
	var sReturn = AsDialog.SelectGridValue("OrgList", "", "OrgID@OrgName", sSelected, true);
	</pre>
	<div>
		<%=new Button("从显示模板生成列表选择框","列表选择框","SelectGridValue()","","btn_icon_detail","").getHtmlText()%>
	</div>

<br/>
	<pre>
	B、打开弹出选择框，获取返回值，并将返回值设置到对应字段
	参数说明：1、显示模板编号  2、参数串：参数值1,参数值2,...	
		3、返回串：接受字段1=返回字段1@接受字段2=返回字段2@...
		4、预选值
	AsDialog.SetGridValue("OrgList", "", "id=OrgID@name=OrgName", sSelected);
	</pre>
	<div><%=new Button("从显示模板生成的列表选择并设置值","列表选择框","SetGridValue()","","btn_icon_detail","").getHtmlText()%></div>
	<div>
		id 输入框：<input id="id" style="overflow:visible;" />
		name 输入框：<input id="name" style="overflow:visible;" />
	</div>
</div>
<script type="text/javascript">
	<%/*~[Describe=弹出树图选择框;InputParam=无;OutPutParam=无;]~*/%>
	function selectTree(){
		//当要获得选择框的返回值时，才调用AsDialog.OpenSelector()打开弹出选择框，来获取返回值；
		//如果是仅是通过选择框的返回值给DW的字段赋值，请在DW模型里配置
		//AsDialog.OpenSelector(sSelname,sParaString,sStyle)
		//sSelname：选择对话框编号
		//sParaString：传入选择对话框配置需要的参数，参数形式为    参数名=参数值
		//sStyle：  对话框样式
		var sReturn = AsDialog.OpenSelector("SelectAllOrg","","");
		alert("返回字符串 ："+sReturn);//注意返回字符串的返回形式
	}
	
	<%/*~[Describe=弹出列表选择框;InputParam=无;OutPutParam=无;]~*/%>
	function selectList(){
		//当要获得选择框的返回值时，才调用AsDialog.OpenSelector()打开弹出选择框，来获取返回值；
		//如果是仅是通过选择框的返回值给DW的字段赋值，请在DW模型里配置
		//AsDialog.OpenSelector(sSelname,sParaString,sStyle)
		//sSelname：选择对话框编号
		//sParaString：传入选择对话框配置需要的参数，参数形式为    参数名=参数值
		//sStyle：  对话框样式
		var sReturn  = AsDialog.OpenSelector("SelectAllUser","","");
		alert("返回字符串 ："+sReturn);//注意返回字符串的返回形式
	}
	
	<%/* DataWindow选择器选择 */%>
	function SelectGridValue(){
		var oldIds = getItemValue(0, 0, "id");
		var oldNames = getItemValue(0, 0, "name");
		var sSelected = [oldIds, oldNames];
		var sReturn = AsDialog.SelectGridValue("TestCustomerList", "", "SerialNo@CustomerName", sSelected, true);
		if(!sReturn) return;
		//alert(sReturn);
		var sIds = "";
		var sNames = "";
		if(sReturn != "_CLEAR_"){
			var aReturn = sReturn.split("~");
			//alert(aReturn.length);
			for(var i = 0; i < aReturn.length; i++){
				var aIdName = aReturn[i].split("@");
				sIds += ","+aIdName[0];
				sNames += ","+aIdName[1];
			}
			if(sIds != "") sIds = sIds.substring(1);
			if(sNames != "") sNames = sNames.substring(1);
		}
		setItemValue(0, 0, "id", sIds);
		setItemValue(0, 0, "name", sNames);
	}
	
	<%/* DataWindow选择器设置 */%>
	function SetGridValue(){
		var sSelected = getItemValue(0, 0, "id");
		AsDialog.SetGridValue("TestCustomerList", "", "id=SerialNo@name=CustomerName", sSelected);
	}
	
	<%/* 以下为模仿DataWindow方法 */%>
	function getItemValue(iDW, iRow, sField){
		return document.getElementById(sField).value;
	}
	function setItemValue(iDW, iRow, sField, sValue){
		var odom = document.getElementById(sField);
		odom.value = sValue;
		odom.style.background = "red";
		setTimeout(function(){
			odom.style.background = "";
		}, 500);
	}
	function getRow(){
		return 0;
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>