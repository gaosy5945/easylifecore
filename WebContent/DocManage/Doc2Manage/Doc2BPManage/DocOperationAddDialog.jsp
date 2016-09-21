<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

	String transactionCode = (String)CurPage.getParameter("TransactionCode");
	if(transactionCode == null ){
		transactionCode = "";
	}
	ASObjectModel doTemp = new ASObjectModel("DocOperationAddDialog","");
	doTemp.setDefaultValue("DOCBELONG", "1");
	doTemp.setHtmlEvent("DOCBELONG", "onClick", "docBelongChange");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存","saveRecord()","","","",""},	
	};
	sButtonPosition = "north";
	
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	function saveRecord()
	{
		as_save(0,"setReturnValue()");
	}
	
	function setReturnValue()
	{
		var serialNo = getItemValue(0,getRow(),"SerialNo"); 
		self.returnValue = serialNo;
		self.close();
	}
	
	function selectDocContract()
	{
		var docBelong = getItemValue(0,getRow(),"DOCBELONG");
		//操作方式：0010 新建入库      0015 补充如可     0040 归还入库
		var transactionCode = "<%=transactionCode%>";
		/*
		 *1、新建入库：
		 *   >>: 当业务资料归属为"额度"和"贷款"时，入库资料选择列表从业务合同表(BUSINESS_CONTRACT)中获取
		 *   >>: 当业务资料归属为"合作项目"时，入库资料选择列表从合作项目(PRJ_BASIC_INFO)表中获取
		 */    
		if(transactionCode !=""&&("0000"==transactionCode||"0010"==transactionCode)){ 
			if("1" == docBelong) //授信资料
			{
				setGridValuePretreat('SelectDocContract','<%=CurUser.getOrgID()%>,<%=transactionCode%>','OBJECTTYPE=OBJECTTYPE@OBJECTNO=SERIALNO@CONTRACTNO=CONTRACTARTIFICIALNO@PACKAGENAME=CUSTOMERNAME@MANAGEORGID=EXECUTIVEORGID@MANAGEUSERID=EXECUTIVEUSERID@CONTRACTARTIFICIALNO=CONTRACTARTIFICIALNO','');
				setItemValue(0,getRow(),"ObjectType","jbo.app.BUSINESS_CONTRACT");
			} 
			else if("2" == docBelong) //项目资料
			{
				setGridValuePretreat('SelectDocProject','<%=CurUser.getOrgID()%>,<%=transactionCode%>','OBJECTTYPE=OBJECTTYPE@OBJECTNO=SERIALNO@PRJECTNO=SERIALNO@PACKAGENAME=CUSTOMERNAME@MANAGEORGID=ORIGINATEORGID@CONTRACTARTIFICIALNO=AGREEMENTNO','');
				setItemValue(0,getRow(),"ObjectType","jbo.prj.PRJ_BASIC_INFO");
			}
		/*
		  2、补充入库和归还入库：
		      <1>、当业务资料归属为"额度"和"贷款"时，入库资料选择列表从业务资料包信息表(DOC_FILE_PACKAGE)和业务合同表(BUSINESS_CONTRACT)关联获取
		           >>:补充入库：业务资料状态为"已入库"；
		          >>:归还入库：业务资料状态为"部分资料出库"
		  	  <2>、当业务资料归属为"合作项目"时，入库资料选择列表从业务资料包信息表(DOC_FILE_PACKAGE)获取
		  	      >>:补充入库：业务资料状态为"已入库"且业务资料类型(ObjectType)为"jbo.prj.PRJ_BASIC_INFO"
          		  >>:归还入库：业务资料状态为"部分资料出库"且业务资料类型(ObjectType)为"jbo.prj.PRJ_BASIC_INFO"
		 */
		}else if(transactionCode !=""&&("0015"==transactionCode||"0040"==transactionCode)){
			//设置业务资料状态：03 已入库  05 部分资料出库
			var status = "";
			if("0015"==transactionCode){
				status = "03";
			}else if("0040"==transactionCode){
				status = "05";
			}
			if("1" == docBelong) //授信资料
			{ 
				status = "03";
				setGridValuePretreat('Doc2ManageLoanDiglogList','<%=CurUser.getOrgID()%>,<%=transactionCode%>,'+status,'OBJECTTYPE=OBJECTTYPE@OBJECTNO=OBJECTNO@CONTRACTNO=OBJECTNO@CUSTOMERNAME=CUSTOMERNAME@CONTRACTARTIFICIALNO=CONTRACTARTIFICIALNO@PACKAGENAME=CUSTOMERNAME','');
				setItemValue(0,getRow(),"ObjectType","jbo.app.BUSINESS_CONTRACT");
			} 
			else if("2" == docBelong) //项目资料
			{
				setGridValuePretreat('Doc2ManageProDiglogList','<%=CurUser.getOrgID()%>,<%=transactionCode%>,'+status,'OBJECTTYPE=OBJECTTYPE@OBJECTNO=OBJECTNO@PRJECTNO=OBJECTNO@CONTRACTARTIFICIALNO=CONTRACTARTIFICIALNO@PACKAGENAME=CUSTOMERNAME','');
				setItemValue(0,getRow(),"ObjectType","jbo.prj.PRJ_BASIC_INFO");
			}
		}  
	}
	 
	setItemValue(0,getRow(),"TransactionCode","<%=transactionCode%>");
	
	//业务资料归属要素联动事件：当业务资料归属选择"合作项目"时，不显示"关联合同编号"和"客户名称"
	function docBelongChange(){ 
		//获取业务资料归属类型
		var sDocBelong = getItemValue(0,getRow(0),"DOCBELONG");
		if("2"==sDocBelong){
			showItem(0,'PRJECTNO');
			hideItem(0,'CONTRACTNO');
			hideItem(0,'CUSTOMERNAME');
			setItemRequired("myiframe0","PRJECTNO",true);
			setItemRequired("myiframe0","CONTRACTNO",false);
		} else{
			hideItem(0,'PRJECTNO');
			showItem(0,'CONTRACTNO');
			showItem(0,'CUSTOMERNAME');  
			setItemRequired("myiframe0","CONTRACTNO",true);
			setItemRequired("myiframe0","PRJECTNO",false);
		}
	}
	docBelongChange();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>