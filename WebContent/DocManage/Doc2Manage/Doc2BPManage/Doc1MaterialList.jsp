<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.are.jbo.BizObject"%>
<!-- 
    一类业务资料 权证清单打印 
 -->
<%
	//获取请求参数:押品编号、关联担保合同流水号
	String sAssetSerialNo =  DataConvert.toString(CurPage.getParameter("SerialNo"));
	String sContractSerialNo = DataConvert.toString(CurPage.getParameter("ContractSerialNo"));

	//声明变量：合同号、客户名称、业务种类编号、业务种类名称、期限
	String sBCSerialNo="",sCustomerName="",sBusinessType="",sBusinessTypeName="",sBusinessTerm="";
	String sBusinessSum = "";//发放金额
	//根据押品编号获取合同相关信息
	String sSql ="select bc.serialno,bc.customername,bc.businesstype,bc.businesssum,bc.businessterm"+
				" from business_contract bc where bc.serialno ='"+sContractSerialNo+"'";
	ASResultSet rs = Sqlca.getASResultSet2(sSql);
	
	if(rs.next()){
		sBCSerialNo = rs.getString("serialno");
		sCustomerName = rs.getString("customername");
		sBusinessType = rs.getString("businesstype");
		sBusinessSum =  DataConvert.toMoney(rs.getString("businesssum"));
		sBusinessTerm = rs.getString("businessterm"); 
	}
    rs.getStatement().close();
	String PUTOUTDATE = "";
	try{
		PUTOUTDATE = Sqlca.getString("Select PUTOUTDATE from business_putout where contractserialno = '"+sBCSerialNo+"'").toString();
	}catch(NullPointerException e){
		e.printStackTrace();
	}
	if(PUTOUTDATE == null) PUTOUTDATE = "";
		String YEAR = "";
		String MONTH = "";
		String DATE = "";
	try{
		YEAR = PUTOUTDATE.substring(0, 4);//年
		MONTH = PUTOUTDATE.substring(5, 7);//月
		DATE = PUTOUTDATE.substring(8, 10);//日
	}catch(StringIndexOutOfBoundsException e){
		e.printStackTrace();
	}
	BizObject btbiz = null;
	try{
		btbiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_TYPE").createQuery("O.TYPENO = :BUSINESSTYPEID").setParameter("BUSINESSTYPEID",sBusinessType).getSingleResult();
	}catch(NullPointerException e){
		e.printStackTrace();
	}
	String BUSINESSTYPE = "";
	try{
		sBusinessTypeName = btbiz.getAttribute("TYPENAME").toString();//业务种类 
	}catch(NullPointerException e){
		e.printStackTrace();
	}
	List<BizObject> list = null;
	try{
	   list = JBOFactory.getFactory().getManager("jbo.app.ASSET_RIGHT_CERTIFICATE").createQuery("O.ASSETSERIALNO = :ASSETSERIALNO").setParameter("ASSETSERIALNO",sAssetSerialNo).getResultList();
	}catch(NullPointerException e){
		e.printStackTrace();
	}
	int i = 0;
    String sCertType[]=new String[list.size()];//权证类型号 
	String sCertTypeName[]=new String[list.size()];//权证类型名称
    String sCertNo[]=new String[list.size()];//权证号
    for(BizObject biz: list){
		sCertType[i]=biz.getAttribute("CERTTYPE").toString(); 
		try{
			sCertTypeName[i]=Sqlca.getString("Select itemname from code_library where codeno = 'AssetCertType' and itemno='"+sCertType[i]+"'").toString();
		}catch(NullPointerException e){
			e.printStackTrace();
		}
		sCertNo[i]=biz.getAttribute("CERTNO").toString();//权证号
		i++;
	}
	

%>
<style>
.td{ border-right:none; border-bottom:none;}
.table{ border-left:none; border-top:none;} 
</style>

<body>
<table width="598" border="0" cellpadding="3" bordercolor = "black" cellspacing = "0" id="table">
  	<tr height="40">
	    <td colspan="7">
		    <div align="center">
		    <p class="STYLE1"  align=center style='text-align:center;line-height:150%; layout-grid-mode:char;font-size: 20px'>
		    <span lang=EN-US style='font-size:11.0pt;'>&nbsp;</span><b>押品所属权证入库清单</b>
		    </p>
		  	</div>
		</td>
  	</tr>
	<tr height="40">
		<td width="350" >&nbsp;</td>
		<td colspan="1">&nbsp;合同编号：</td>
		<td colspan="1">&nbsp;<%=sBCSerialNo %></td>
	</tr>
</table>


<table width="598" border="0" cellpadding="3" bordercolor = "black" cellspacing = "0" id="table">
	<tr height="40">
	    <td>&nbsp;种类：</td>
	    <td colspan="6">&nbsp;<%=sBusinessTypeName %></td>
	</tr>
	<tr height="40">
		<td width="12%">&nbsp;借款人：</td>
		<td width="12%">&nbsp;<%=sCustomerName %></td>
		<td width="22%">&nbsp;&nbsp;借款金额/期限：</td>
		<td width="30%"><%=sBusinessSum %>元&nbsp;/&nbsp;<%=sBusinessTerm%>月</td>
		<td width="15%">&nbsp;放款日期：</td>
		<td colspan="2">&nbsp;&nbsp;<%=YEAR %>&nbsp;年&nbsp;&nbsp;&nbsp;<%=MONTH %>&nbsp;月&nbsp;&nbsp;<%=DATE %>&nbsp;&nbsp;日</td>
	</tr>
	<tr><td height="20px"></td></tr>
	<tr> 
		<td align="left" colspan="6"> 
			<table border='1' cellpadding='1' cellspacing = '0' class='table' >
				<tr height='40' align="center">
					<td width='20%' class='td'>&nbsp;</td>
					<td width='30%' align='center' class='td'>权证类型</td>
					<td align= 'center' class='td'>权证号</td>
				</tr>
			
			<%for(int j=0;j<sCertNo.length;j++){ %>
			
				<tr height='40' align="center">
				<td align='center' class='td'><input type='checkbox' ></input></td>
				<td class='td'>&nbsp;<%=sCertTypeName[j]==null?"":sCertTypeName[j]%></td>
				<td class='td'>&nbsp;<%=sCertNo[j]%></td>
				</tr>
			
			<%} %>
			</table >
		</td>
	</tr>
</table>
<br><br>

<br><br>
<table width="598" border="0" cellpadding="3" bordercolor = "black" cellspacing = "0" id="table" >
	<tr height="40">
	<td >&nbsp;移交人：</td>
	<td >&nbsp;</td>
	<td >&nbsp;接交人：</td>
	<td >&nbsp;</td>
	<td >&nbsp;</td>
	<td colspan="2">&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;日</td>
	</tr>
</table>
<div id="print" onclick="printPaper()" style="width:100px;height:30px; text-align: center; line-height:30px;color:white; background-color:blue; border-radius:10px;cursor:pointer;">打印</div>
    
</body> 
<script>
   function printPaper(){
	   var print = document.getElementById("print");
	   
	   if(window.confirm("是否确定要打印？")){
		   //打印	  
		   window.print();			  
	   }
   }
   $("#print").mouseenter(function(){
	   $("#print").css("backgroundColor","red");
   }).mouseleave(function(){
	   $("#print").css("backgroundColor","blue");
   })  
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
