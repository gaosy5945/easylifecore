<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_simplelist.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.setPageSize(20);
	dwTemp.Style="0";      //设置为Grid风格
	dwTemp.ReadOnly = "1";//只读模式
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","","Button","新增","新增","add()","","","","btn_icon_add",""},
		{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
		{"true","","Button","联动菜单编辑","联动菜单编辑","editd()","","","","btn_icon_detail",""},
		{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","","btn_icon_delete",""},
	};

	Wizard wizard = new Wizard();
	wizard.setDefId("03");
	wizard.items.add(new WizardItem("01", "第一步", "01"));
	wizard.items.add(new WizardItem("02", "第二步", "02"));
	wizard.items.add(new WizardItem("03", "第三步", "03"));
	wizard.items.add(new WizardItem("04", "第四步", "04"));
	wizard.items.add(new WizardItem("05", "第五步", "05"));
	wizard.items.add(new WizardItem("06", "第六步", "06"));
	wizard.items.add(new WizardItem("07", "第七步", "07"));
	wizard.items.add(new WizardItem("08", "第八步", "08"));
	wizard.items.add(new WizardItem("09", "第九步", "09"));
	wizard.items.add(new WizardItem("10", "第十步", "10"));
	wizard.items.add(new WizardItem("11", "第十一步", "11"));
	wizard.items.add(new WizardItem("12", "第十二步", "12"));
	wizard.items.add(new WizardItem("13", "第十三步", "13"));
	wizard.items.add(new WizardItem("14", "第十四步", "14"));
	wizard.items.add(new WizardItem("15", "第十五步", "15"));
	wizard.items.add(new WizardItem("16", "第十六步", "16"));
	wizard.items.add(new WizardItem("17", "第十七步", "17"));
	wizard.items.add(new WizardItem("18", "第十八步", "18"));
	sASWizardHtml = wizard.getHtmlText();
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function WizardCellOnClick(curItem, targetItem){
		if(!curItem) return true;
		if(curItem["sort"] > targetItem["sort"])
			return confirm("从"+curItem["id"]+"回退到"+targetItem["id"]);
		
		return confirm("从"+curItem["id"]+"跳转到"+targetItem["id"]);
	}
	
	function add(){
		 var sUrl = "/FrameCase/widget/ow/DemoInfoSimple.jsp";
		 OpenPage(sUrl,'_self','');
	}
	function edit(){
		 var sUrl = "/FrameCase/widget/ow/DemoInfoSimple.jsp";
		 OpenPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo'),'_self','');
	}
	function editd(){
		 var sUrl = "/FrameCase/widget/ow/DemoInfoDMenu.jsp";
		 OpenPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo'),'_self','');
	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>
