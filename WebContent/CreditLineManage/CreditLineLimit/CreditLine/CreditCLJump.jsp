<%@page import="com.amarsoft.app.oci.bean.Field"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.amarsoft.app.oci.bean.OCITransaction"%>
<%@page import="com.amarsoft.app.oci.bean.Message"%>
<%@page import="com.amarsoft.app.oci.instance.CoreInstance"%>
<%@page import="com.amarsoft.app.als.project.QueryMarginBalance"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.BizObjectQuery"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
  
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	//从上个页面得到传入的参数
	String SerialNo = CurPage.getParameter("SerialNo");//合同编号
	if(SerialNo == null) SerialNo = "";
	String BusinessType = CurPage.getParameter("BusinessType");//基础产品
	if(BusinessType == null) BusinessType = "";
	
	String sTempletNo = "CreditCLQuery";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"false","All","Button","保存","保存所有修改","as_save(0)","","","",""},
	};
	%>
<%/*~END~*/%>
<title>消贷易/融资易额度查询</title>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%	
	StringBuffer sJSScript = new StringBuffer();
	JBOTransaction tx = null;
	try{
		tx = JBOFactory.createJBOTransaction();
		
		String TranTellerNo = "92261005";
		String BranchId = "2261";
		String BussType = "";
		if("666".equals(BusinessType)){
			BussType = "0";   //消贷易
		}else if("500".equals(BusinessType)){
			BussType = "1";   //融资易消费
		}else{
			BussType = "2";   //融资易转账
		}

		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.acct.ACCT_BUSINESS_ACCOUNT");
		tx.join(table);
		
		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType='jbo.app.BUSINESS_CONTRACT' and AccountIndicator = '01'").setParameter("ObjectNo", SerialNo);
		BizObject pr = q.getSingleResult(false);
		String CardNo = "";
		if(pr!=null){
			CardNo = pr.getAttribute("AccountNo1").getString();
		}
		try{
			BizObjectManager bmCL = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
			tx.join(bmCL);
			OCITransaction oci = CoreInstance.XDYOrRZYLoanLmtQry(TranTellerNo, BranchId, "2", CardNo, "", "", "", "", BussType, "", "", 0, tx.getConnection(bmCL));
	
			//取返回报文的ReturnCode和ReturnMsg，判断返回报文是否正确
			String ReturnCode = oci.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnCode");
			String ReturnMsg = oci.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnMsg");
			if(("000000000000").equals(ReturnCode)){
				Field[] fields = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFields();
				if(fields != null)
				{
					for(int i = 0; i < fields.length ; i ++){
						String value = fields[i].getFieldValue();
						%>
						<script type="text/javascript">
						var TagID = "<%=fields[i].getFieldTag()%>";
						var value = "<%=value%>";
						if(TagID == "LmtStatus"){
							if(value == "0"){ value = "启用";	}else if(value == "1"){ value = "暂停";}else if(value == "2"){ value = "过期";}else{ value = "关闭";}
						}
						if(TagID == "PcsMode"){
							if(value == "1"){ value = "全额转贷";}else if(value == "2"){ value = "全款扣备用金,不足还款全额转贷";}
						}
						if(TagID == "RepayMode"){
							if(value == "1"){ value = "等额";	}else if(value == "2"){ value = "等本";}else if(value == "3"){ value = "一次还本付息";}else if(value == "4"){ value = "分次付息一次还本";}else if(value == "5"){ value = "递增/递减";}
							else if(value == "6"){ value = "组合";}else if(value == "7"){ value = "无忧月供(等额)";}else{ value = "无忧月供(等本)";}
						}
						if(TagID == "IntActualPrd"){
							if(value == "0"){ value = "按月还款";	}else if(value == "1"){ value = "按季还款";}else if(value == "2"){ value = "半年还款";}else if(value == "3"){ value = "按留学半年";}else if(value == "4"){ value = "按年还款";}
							else if(value == "5"){ value = "按固定月数";}else{ value = "利随本清";}
						}
						if(TagID == "RepymtDateMode"){
							if(value == "0"){ value = "借款日为还款日";}else{ value = "指定还款日期";}
						}
						if(TagID == "IntRateAdjType"){
							if(value == "1"){ value = "固定不变";	}else if(value == "2"){ value = "满年调整";}else if(value == "3"){ value = "特定日期变动";}else if(value == "8"){ value = "按月";}else if(value == "9"){ value = "按季";}
							else{ value = "结构性固定利率";}
						}
						if(TagID =="PnyIntFlotType"){
							if(value == "0"){ value = "固定罚息率";}else{ value = "按合同利率浮动";}
						}
						if(TagID == "BussType"){
							if(value == "0"){ value = "消贷易";}else if(value == "1"){ value == "融资易消费";}else{ value == "融资易转账";}
						}
						if(TagID == "LmtExpDate" || TagID == "CtrExpDate" || TagID == "ActTranDate"){
							value = value.substring(0, 4)+"/"+value.substring(4, 6)+"/"+value.substring(6, 8);
						}
						if(TagID == "RepayDate"){
							value = "每月"+value+"日";
						}
						if(TagID == "IntRateAdjDate"){
							value = "每年"+value.substring(0, 2)+"月"+value.substring(2,4)+"日";
						}
						if(TagID == "FloatPercent"){
								value = (parseFloat(value))*100;
						}
						setItemValue(0,0,"<%=fields[i].getFieldTag()%>",value);
						</script>
						<%	
					}
				}
			}
		}catch(Exception ex){
			String msg = ex.getMessage();
			%> <script type="text/javascript"> alert("<%=msg%>");  </script><%
		}
		tx.commit();
	}catch(Exception ex){
		tx.rollback();
		throw ex;
	}

%>
<%/*~END~*/%>




<%@ include file="/Frame/resources/include/include_end.jspf"%>
