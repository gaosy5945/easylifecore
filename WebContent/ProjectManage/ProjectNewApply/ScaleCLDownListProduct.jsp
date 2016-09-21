<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String parentSerialNo = CurPage.getParameter("parentSerialNo");
	if(parentSerialNo == null) parentSerialNo = "";
	String divideType = CurPage.getParameter("divideType");
	if(divideType == null) divideType = "";
	String prjSerialNo = CurPage.getParameter("PrjSerialNo");
	if(prjSerialNo == null) prjSerialNo = "";
	String businessAppAmt = CurPage.getParameter("businessAppAmt");
	if(businessAppAmt == null) businessAppAmt = "";
	String ProductList = CurPage.getParameter("ProductList");
	if(ProductList == null) ProductList = "";
	
	ASObjectModel doTemp = new ASObjectModel("ScaleCreditLineDownListProduct");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "2";	 //只读模式

	dwTemp.setParameter("PARENTSERIALNO", parentSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","保存","保存","saveRecord()","","","","btn_icon_save",""},
			{"true","All","Button","删除","删除","del()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	var flag = true;
	function saveRecord(){
		if(!iV_all(0)){
			alert("请先填写完整信息！");
			return;
		}
		checkSum();
		var parentSerialNo = "<%=parentSerialNo%>";
		var businessAppAmt = "<%=businessAppAmt%>";
		var Rows = getRowCount(0);
		var DataGroup = '';
		var SerialNoGroup = '';
		var sum = 0.00;
		for(var i = 0;i < Rows;i++){
			var productBusinessAppAmt = getItemValue(0,i,"BUSINESSAPPAMT");
			var serialNo = getItemValue(0,i,"SERIALNO");
			var replaceData = productBusinessAppAmt.replace(/,/g, "");
			DataGroup += replaceData + "@";
			SerialNoGroup += serialNo + "@";
			var sum = parseFloat(sum)+parseFloat(replaceData);
		}
		var divideType = "10";
		var sReturn = ProjectManage.getBusinessAppAmt(parentSerialNo,divideType);
		if(sReturn == "CLParentEmpty"|| sReturn == "CLEmpty"  || sReturn == "SameNotSave"){
			alert("请先保存规模额度信息，再进行额度切分操作！");
			return;
		}else{
			if(flag){
				var temp = parseFloat(sum);
				if(temp != businessAppAmt){
					if(confirm('请注意，项目切分额度不等于实际额度总规模，是否继续切分?'))
					var sReturn = ProjectManage.updateBusinessAppAmt(SerialNoGroup,DataGroup,parentSerialNo);
					if(sReturn == "SUCCEED"){
						alert("额度切分成功！");
					}
				}else{
					var sReturn = ProjectManage.updateBusinessAppAmt(SerialNoGroup,DataGroup,parentSerialNo);
					if(sReturn == "SUCCEED"){
						alert("额度切分成功！");
					}
				}
			}else{
				flag = true;
			}
		}
	}
	function checkSum(){
		var businessAppAmt = "<%=businessAppAmt%>";
		var Rows = getRowCount(0);
		for(var i = 0;i < Rows;i++){
			var productBusinessAppAmt = getItemValue(0,i,"BUSINESSAPPAMT");
			var businessName = getItemValue(0,i,"BUSINESSTYPENAME");
			var replaceData = productBusinessAppAmt.replace(/,/g, "");
			if(parseFloat(replaceData) > parseFloat(businessAppAmt)){
				alert("【"+businessName+"】"+"的切分额度大于额度总金额，请重新输入！");
				flag = false;
				return;
			}
		}
	}
	function del(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}
		if(confirm('确实要删除吗?')){
			as_delete(0);
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
