<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.are.jbo.BizObject"%>
<!-- 二类业务资料清单打印 -->
<%
	String SERIALNO = DataConvert.toString(CurPage.getParameter("SerialNo"));//申请流水号 
	if(SERIALNO == null)       SERIALNO = "";
	
	BizObject bcbiz = null;
	try{
		bcbiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT").createQuery("O.serialno = :SERIALNO").setParameter("SERIALNO", SERIALNO).getSingleResult();
	}catch(NullPointerException e){
		e.printStackTrace();
	}
	String CONTRACTSERIALNO = "";//合同编号
	try{
		CONTRACTSERIALNO = bcbiz.getAttribute("CONTRACTARTIFICIALNO").toString();//合同编号
	}catch(NullPointerException e){
		e.printStackTrace();
	}
	if(CONTRACTSERIALNO == null)       CONTRACTSERIALNO = "";//合同编号
	
	String CUSTOMERNAME = "";
	try{
		CUSTOMERNAME = bcbiz.getAttribute("CUSTOMERNAME").toString();//借款人
	}catch(NullPointerException e){
		e.printStackTrace();
	}
	if(CUSTOMERNAME == null) CUSTOMERNAME = "";
	String BUSINESSSUM = "";
	try{
		BUSINESSSUM = DataConvert.toMoney(bcbiz.getAttribute("BUSINESSSUM").toString());//发放金额
	}catch(NullPointerException e){
		e.printStackTrace();
	}
	String BUSINESSTERM = "";
	try{
		BUSINESSTERM = bcbiz.getAttribute("BUSINESSTERM").toString();
	}catch(NullPointerException e){
		e.printStackTrace();
	}
	String BUSINESSTYPEID = "";
	try{
		BUSINESSTYPEID = bcbiz.getAttribute("BUSINESSTYPE").toString();
	}catch(NullPointerException e){
		e.printStackTrace();
	}
	String PUTOUTDATE = "";
	try{
		//PUTOUTDATE = Sqlca.getString("Select PUTOUTDATE from business_putout where contractserialno = '"+SERIALNO+"'");
		 PUTOUTDATE = bcbiz.getAttribute("FIRSTDRAWDOWNDATE").toString();
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
		btbiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_TYPE").createQuery("O.TYPENO = :BUSINESSTYPEID").setParameter("BUSINESSTYPEID",BUSINESSTYPEID).getSingleResult();
	}catch(NullPointerException e){
		e.printStackTrace();
	}
	String BUSINESSTYPE = "";
	try{
		BUSINESSTYPE = btbiz.getAttribute("TYPENAME").toString();//业务种类 
	}catch(NullPointerException e){
		e.printStackTrace();
	}
	List<BizObject> list = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_INFO").createQuery("O.OBJECTNO = :OBJECTNO and O.ObjectType = 'contract'").setParameter("OBJECTNO",CONTRACTSERIALNO).getResultList();
	int i = 0;
	String fileid[]=new String[list.size()];
	String filename[]=new String[list.size()];
	for(BizObject biz: list){
		fileid[i]=biz.getAttribute("FILEID").toString();
		try{
			filename[i]=Sqlca.getString("Select filename from doc_file_config where fileid = '"+fileid[i]+"'").toString();
		}catch(NullPointerException e){
			e.printStackTrace();
		}
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
		    <span lang=EN-US style='font-size:11.0pt;'>&nbsp;</span><b>业务资料入库清单</b>
		    </p>
		  	</div>
		</td>
  	</tr>
	<tr height="40">
		<td width="350" >&nbsp;</td>
		<td colspan="1">&nbsp;合同编号：</td>
		<td colspan="1">&nbsp;<%=CONTRACTSERIALNO %></td>
	</tr>
</table>


<table width="598" border="0" cellpadding="3" bordercolor = "black" cellspacing = "0" id="table">
	<tr height="40">
	    <td>&nbsp;种类：</td>
	    <td colspan="6">&nbsp;<%=BUSINESSTYPE %></td>
	</tr>
	<tr height="40">
		<td width="12%">&nbsp;借款人：</td>
		<td width="12%">&nbsp;<%=CUSTOMERNAME %></td>
		<td width="22%">&nbsp;&nbsp;借款金额/期限：</td>
		<td width="30%"><%=BUSINESSSUM %>元&nbsp;/&nbsp;<%=BUSINESSTERM %>月</td>
		<td width="15%">&nbsp;放款日期：</td>
		<td colspan="2">&nbsp;&nbsp;<%=YEAR %>&nbsp;年&nbsp;&nbsp;&nbsp;<%=MONTH %>&nbsp;月&nbsp;&nbsp;<%=DATE %>&nbsp;&nbsp;日</td>
	</tr>
	<tr><td height="20px"></td></tr>
	<tr> 
		<td align="left" colspan="6"> 
			<table border='1' cellpadding='1' cellspacing = '0' class='table' >
				<tr height='40' align="center">
					<td width='20%' class='td'>&nbsp;</td>
					<td width='30%' align='center' class='td'>清单编号</td>
					<td align= 'center' class='td'>清单名称</td>
				</tr>
			
			<%for(int j=0;j<filename.length;j++){ %>
			
				<tr height='40' align="center">
				<td align='center' class='td'><input type='checkbox' ></input></td>
				<td class='td'>&nbsp;<%=fileid[j]%></td>
				<td class='td'>&nbsp;<%=filename[j]%></td>
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
