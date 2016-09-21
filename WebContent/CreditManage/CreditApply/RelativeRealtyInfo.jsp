<%@page import="com.amarsoft.are.jbo.*"%>
<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@page import="com.amarsoft.app.bizmethod.*"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String PG_TITLE = "房屋用途信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量：客户代码、暂存标志 
	String sCustomerID = "",sTempSaveFlag = "";
	//获得页面参数	
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	
	CreditObjectAction cobj=new CreditObjectAction(sObjectNo,sObjectType);
	BizObject biz=cobj.creditObject;
	if(biz!=null){
		sCustomerID = biz.getAttribute("CustomerID").getString();
	}
	
	//通过显示模版产生ASDataObject对象doTemp
	String sDisplayTemplet = "ApplyRealtyInfo";
	ASObjectModel doTemp = new ASObjectModel(sDisplayTemplet,"");
	//生成DataWindow对象	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);

	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"false","All","Button","暂存","暂时保存所有修改内容","saveRecordTemp()","","","",""}
	};
	//当暂存标志为否，即已保存，暂存按钮应隐藏
	if(sTempSaveFlag.equals("0"))
		sButtons[1][0] = "false";
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(){
		as_save("myiframe0");
	}
	
	/*~[Describe=暂存;InputParam=无;OutPutParam=无;]~*/
	function saveRecordTemp(){
		setItemValue(0,getRow(),'TempSaveFlag',"1");//暂存标志（1：是；0：否）
		as_saveTmp("myiframe0");   //暂存
	}		

	/*~[Describe=根据自定义小数位数四舍五入,参数object为传入的数值,参数decimal为保留小数位数;InputParam=基数，四舍五入位数;OutPutParam=四舍五入后的数据;]~*/
	function roundOff(number,digit){
		var sNumstr = 1;
    	for (i=0;i<digit;i++){
       		sNumstr=sNumstr*10;
        }
    	sNumstr = Math.round(parseFloat(number)*sNumstr)/sNumstr;
    	return sNumstr;
	}
	
	//检测是否是浮点数
	function isDigit(s){
		var patrn=/^(-?\d+)(\.\d+)?$/;
		if (s!="" && !patrn.exec(s)){
			alert(s+"数据格式错误！");
			return false;
		}
		return true;
	}

	function isNull(value){
		if(typeof(value)=="undefined" || value==""){
			return true;
		}
		return false;
	}
	
	function initRow(){
		if (getRowCount(0)==0){
			setItemValue(0,getRow(),'CUSTOMERID',"<%=sCustomerID%>");
		}
	}
	//根据单价，面积和首付比例获取首付金额
	function getDownPayment(){
		var unitPrice  = getItemValue(0,getRow(),"REALTYUNITPRICE");
		var realtyArea = getItemValue(0,getRow(),"REALTYAREA");
		var downPaymentRate = getItemValue(0,getRow(),"DownPaymentRate");
		if(parseInt(downPaymentRate)>100||parseInt(downPaymentRate)<0){
			alert("首付比例必须在[0,100]内！");
			setItemValue(0,getRow(),"DownPaymentRate","");
			return;
		}
		if(typeof(unitPrice)!="undefined"&& typeof(realtyArea)!="undefined"&& typeof(downPaymentRate)!="undefined" &&unitPrice.length>0&&realtyArea.length>0&&downPaymentRate.length>0){
			setItemValue(0,0,"DownPayment",toNumber(downPaymentRate)*toNumber(unitPrice)*toNumber(realtyArea)/100);
		}
	}

	//根据单价和房屋面积获取房屋总价
	function downPaymentChange(){
		var dDownPayment=getItemValue(0,getRow(),"DownPayment");
		var dBuildPrice=getItemValue(0,getRow(),"BUILDPRICE");
		var dRate=(dDownPayment/dBuildPrice)*100;
		if(parseInt(dRate)>1){
				alert("首付比例已大于100%,首付金额输入有误!");
				setItemValue(0,getRow(),"DownPaymentRate","");
				return ;
		}
		setItemValue(0,getRow(),"DownPaymentRate",dRate);
	}
	//根据单价和房屋面积获取房屋总价
	function getBuildPrice(){
		var unitPrice  = getItemValue(0,getRow(),"REALTYUNITPRICE");
		var realtyArea = getItemValue(0,getRow(),"REALTYAREA");
		if(typeof(unitPrice)!="undefined"&& typeof(realtyArea)!="undefined" &&unitPrice.length>0&&realtyArea.length>0){
			setItemValue(0,0,"BUILDPRICE",toNumber(unitPrice)*toNumber(realtyArea));
		}
	}
	
	initRow();	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>