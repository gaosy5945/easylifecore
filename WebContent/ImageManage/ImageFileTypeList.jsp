<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <script type="text/javascript" src="<%=request.getContextPath()%>/ImageTrans/jquery-1.7.2.min.js"></script>
 <%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "影像资料类型列表";
	//获得页面参数
	String sStartWithId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("StartWithId"));
	if (sStartWithId == null) sStartWithId = "";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ImageFileTypeList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//doTemp.generateFilters(Sqlca);
	//doTemp.parseFilterData(request,iPostChange);
	//CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	doTemp.multiSelectionEnabled=true;//设置可多选
	System.out.println("-----------"+doTemp.SelectClause);
	doTemp.WhereClause = "Where TypeNo Like '"+sStartWithId+"%'";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(50);//设置每页显示记录条数

	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow( "" );
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","全选","全选","SelectedAll()",sResourcesPath},
		{"true","","Button","反选","反选","SelectedBack()",sResourcesPath},
		{"true","","Button","取消全选","取消全选","SelectedCancel()",sResourcesPath}, 
		{"true","","Button","确定","打印条形码","printBarCode()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		as_add( "myiframe0" );
		var param = "StartWithId=<%=sStartWithId%>";
		var sNewExampleTypeNo = RunJavaMethodSqlca( "com.amarsoft.app.als.image.ImageUtil", "GetNewTypeNo", param );
		setItemValue( 0, getRow(), "TypeNo", sNewExampleTypeNo );
	}
	
	function saveRecord(){
		var sTypeNo = getItemValue(0,getRow(),"TypeNo");
		var sTypeName = getItemValue(0,getRow(),"TypeName");
		if( (typeof sTypeNo !="undefined") && (sTypeNo == "" || sTypeName == "") ){
			alert( "类型编号、类型名称不可以为空" );
			return;
		}else{
			as_save("myiframe0")
			parent.frames["frameleft"].reloadSelf();
		}
			
	}
	
	function deleteRecord(){
		var sTypeNo = getItemValue(0,getRow(),"TypeNo");
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			param = "imageTypeNo="+sTypeNo;
			RunJavaMethodSqlca( "com.amarsoft.app.als.image.ManagePRDImageRela", "delRelationByImageTypeNo", param );
		}
	}
	/* 打印条形码 */
	function printBarCode(){
		var sTypeNo = getItemValueArray(0,"TypeNo");
		var sTypeName = getItemValueArray(0,"TypeName");
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("请选择一条记录！");
			return;
		}

		//alert(sTypeNo);
		//alert(sTypeName);

		var typeNoString = sTypeNo.toString();
		var typeNameString = sTypeName.toString();
		
		var typeNoArray = typeNoString.split(",");//以逗号分隔,生成数组
		//alert(typeNoArray.length);
		if(typeNoArray.length > 15){//每次选择的资料不能超过15.
			alert("一次最多只能选择15项资料!");
		    return ;
		}
		//var typeNameArray = typeNameString.split(",");//以逗号分隔,生成数组
		
		//alert(typeNoArray);
		//alert(typeNameArray);
		
		var re =/,/g; //逗号
		typeNoString = typeNoString.replace(re,"@");	
		typeNameString = typeNameString.replace(re,"@");	
		//alert(typeNoString);
		//alert(typeNameString);
		//self.returnValue=typeNoArray;//返回数组
		self.returnValue=typeNoString;
		self.close();
		
		//var param = "TypeNo="+typeNoString+"&TypeName="+typeNameString;
		//popComp("PrintBarCode","/ImageManage/PrintBarCode.jsp",param,"");
	}
	
	/*~[Describe=全选ObjectViewer无;InputParam=无;OutPutParam=无;]~*/
	function SelectedAll(){//全选
		
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a != "√"){
				     setItemValue(0,iMSR,"MultiSelectionFlag","√");
			}
		}
	}
	
	/*~[Describe=反选ObjectViewer无;InputParam=无;OutPutParam=无;]~*/
	function SelectedBack(){//反选
		
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a != "√"){
				    setItemValue(0,iMSR,"MultiSelectionFlag","√");
			}else{
				setItemValue(0,iMSR,"MultiSelectionFlag","");
			}
		}
	}
	
	/*~[Describe=取消全选ObjectViewer无;InputParam=无;OutPutParam=无;]~*/
	function SelectedCancel(){//取消全选
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a != ""){
				setItemValue(0,iMSR,"MultiSelectionFlag","");
			}
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
